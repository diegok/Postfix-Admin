package postadmin::Controller::Domain::Mailbox;

use Moose; BEGIN { extends 'Catalyst::Controller' }
use postadmin::Form::Mailbox;

=head1 NAME

postadmin::Controller::Domain::Mailbox - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head1 list

List all mailboxes from the given domain

=cut
sub list : PathPart( 'mailboxes' ) Chained( '/domain/element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $domain = $c->stash->{domain};

    $c->stash( mailboxes => [ $domain->mailboxes->all() ] );
    $c->stash( template  => 'domain/mailbox/list.tt' );
}

=head1 element_chain

Base chain for actions related to one mailbox

=cut
sub element_chain : PathPart( 'mailbox' ) Chained( '/domain/element_chain' ) CaptureArgs( 1 ) {
    my ( $self, $c, $username ) = @_;
    my $domain = $c->stash->{domain};

    unless ( $c->stash->{mailbox} = $domain->mailboxes({ username => $username . '@' . $domain->domain })->first ) {
        $c->detach( '/error/element_not_found', [ 'mailbox' ] );
    }
}

=head1 edit

Edit a mailbox

=cut
sub edit : PathPart( 'edit' ) Chained( 'element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $domain = $c->stash->{domain};
    my $mailbox = $c->stash->{mailbox};
    my $form = postadmin::Form::Mailbox->new( domain => $domain->domain );
    $form->field('password')->required(0);
    if ( $form->process( item => $mailbox, params => $c->req->params, log => $c->get_req_logdata ) ) {
        $c->add_feedback( info  => 'Mailbox ' . $mailbox->email_address . ' saved' );
        $c->res->redirect( $c->uri_for('/domain', $domain->domain, 'mailboxes') );
    }
    else {
        $c->stash( 
            template => 'domain/mailbox/edit.tt', 
            form     => $form
        );
    }
}

=head1 create

Create a mailbox

=cut
sub create : PathPart( 'mailbox/create' ) Chained( '/domain/element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $domain = $c->stash->{domain};
    my $form = postadmin::Form::Mailbox->new( domain => $domain->domain );
    my $mailbox = $c->model('Postfix::Mailbox')->new_result({});

    if ( $form->process( item => $mailbox, params => $c->req->params, log => $c->get_req_logdata ) ) {
        $c->add_feedback( info  => 'Mailbox ' . $mailbox->email_address . ' created' );
        $c->res->redirect( $c->uri_for('/domain', $domain->domain, 'mailboxes') );
    }
    else {
        $c->stash( 
            template => 'domain/mailbox/create.tt', 
            form     => $form
        );
    }
}

=head1 delete

Delete a mailbox

=cut
sub delete : PathPart( 'delete' ) Chained( 'element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $mailbox = $c->stash->{mailbox};
    $mailbox->log( $c->get_req_logdata );

    eval { $mailbox->delete };
    if ($@) {
        $c->add_feedback( info  => 'Mailbox ' . $mailbox->email_address . ' can\'t be deleted' );
        $c->add_feedback( error => $@ );
    }
    else {
        $c->add_feedback( info => 'Mailbox ' . $mailbox->email_address . ' has been deleted' );
    }

    $c->res->redirect( $c->uri_for( '/domain', $mailbox->domain, 'mailboxes' ) );
}

=head1 togle_active

Toggle the active flag of a domain

=cut
sub toggle_active : PathPart( 'toggle' ) Chained( 'element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $mailbox = $c->stash->{mailbox};
    $mailbox->log( $c->get_req_logdata );
    
    if ( $mailbox->active ) {
        $mailbox->deactivate;
        $c->add_feedback( info => 'Mailbox ' . $mailbox->email_address . ' has been deactivated' );
    }
    else {
        $mailbox->activate;
        $c->add_feedback( info => 'mailbox ' . $mailbox->email_address . ' has been activated' );
    }

    $c->res->redirect( $c->uri_for( '/domain', $mailbox->domain, 'mailboxes' ) );
}

=head2 multi_action_redispatch

    Try to exec allowed multi-mailbox actions on the requested action.

    When no actions catch the request, this action will try to exec
    the action mapped from allow_multi on the mailbox_username's param 
    received.

=cut
has 'allow_multi' => (
    is  => 'ro',
    isa => 'HashRef',
    default => sub {{
        toggle => 'toggle_active',
        delete => 'delete',
    }}
);

sub multi_action_redispatch : PathPart( 'mailbox' ) Chained( '/domain/element_chain' ) Args( 1 ) {
    my ( $self, $c, $action) = @_;
    my $domain = $c->stash->{domain};

    if ( exists $self->allow_multi->{$action} ) {
        for my $username ( $c->req->param('mailbox_username') ) {
            $username .= '@' . $domain->domain;
            if ( $c->stash->{mailbox} = $c->model('Postfix::Mailbox')->search( username => $username )->first ) {
                $c->forward( $self->allow_multi->{$action} );
            }
            else {
                $c->add_feedback( error => "Can't find mailbox '$username'." );
            }
        }
    }
    else {
        $c->add_feedback( error => "Action '$action' is not defined." );
    }

    $c->res->redirect( $c->uri_for( '/domain', $domain->domain, 'mailboxes' ) );
}

=head1 AUTHOR

Diego Kuperman

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
