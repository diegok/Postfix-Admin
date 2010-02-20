package postadmin::Controller::Domain;

use Moose; BEGIN { extends 'Catalyst::Controller' }
use postadmin::Form::Domain;

=head1 NAME

postadmin::Controller::Domain - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head1 list

List all domains

=cut
sub list : PathPart( 'domain' ) Chained( '/auth/need_login' ) Args( 0 ) {
    my ( $self, $c ) = @_;

    $c->stash( domains  => [ $c->model('Postfix::Domain')->all() ] );
    $c->stash( template => 'domain/list.tt' );
}

=head1 element_chain

Base chain for actions related to one domain

=cut
sub element_chain : PathPart( 'domain' ) Chained( '/auth/need_login' ) CaptureArgs( 1 ) {
    my ( $self, $c, $domain_name ) = @_;

    unless ( $c->stash->{domain} = $c->model('Postfix::Domain')->find( $domain_name ) ) {
        $c->detach( '/error/element_not_found', [ 'domain' ] );
    }
}

=head1 edit

Edit a domain

=cut
sub edit : PathPart( 'edit' ) Chained( 'element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $domain = $c->stash->{domain};
    my $form = postadmin::Form::Domain->new;

    if ( $form->process( item => $domain, params => $c->req->params, log => $c->get_req_logdata ) ) {
        $c->add_feedback( info  => 'Domain ' . $domain->domain . ' saved' );
        $c->res->redirect( $c->uri_for('/domain') );
    }
    else {
        $c->stash( 
            template => 'domain/edit.tt', 
            form     => $form
        );
    }
}

sub create : PathPart( 'domain/create' ) Chained( '/auth/need_login' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $form = postadmin::Form::Domain->new;
    my $domain = $c->model('Postfix::Domain')->new_result( {} );

    if ( $form->process( item => $domain, params => $c->req->params, log => $c->get_req_logdata ) ) {
        $c->add_feedback( info  => 'Domain ' . $domain->domain . ' created' );
        $c->res->redirect( $c->uri_for('/domain') );
    }
    else {
        $c->stash( 
            template => 'domain/create.tt', 
            form     => $form
        );
    }
}

=head1 delete

Delete a domain

=cut
sub delete : PathPart( 'delete' ) Chained( 'element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $domain = $c->stash->{domain};
    $domain->log( $c->get_req_logdata );

    eval { $domain->delete };
    if ($@) {
        $c->add_feedback( info  => 'Domain ' . $domain->domain . ' can\'t be deleted' );
        $c->add_feedback( error => $@ );
    }
    else {
        $c->add_feedback( info => 'Domain ' . $domain->domain . ' has been deleted' );
    }

    $c->res->redirect( $c->uri_for('/domain') );
}

=head1 togle_active

Toggle the active flag of a domain

=cut
sub toggle_active : PathPart( 'toggle' ) Chained( 'element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $domain = $c->stash->{domain};
    $domain->log( $c->get_req_logdata );
    
    if ( $domain->active ) {
        $domain->deactivate;
        $c->add_feedback( info => 'Domain ' . $domain->domain . ' has been deactivated' );
    }
    else {
        $domain->activate;
        $c->add_feedback( info => 'Domain ' . $domain->domain . ' has been activated' );
    }

    $c->res->redirect( $c->uri_for('/domain') );
}

=head2 multi_action_redispatch

    Try to exec allowed multi-domain actions on the requested action.

    When no actions catch the request, this action will try to exec
    the action mapped from $allow_multi on the domain_name's param 
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

sub multi_action_redispatch : PathPart( 'domain' ) Chained( '/auth/need_login' ) Args( 1 ) {
    my ( $self, $c, $action ) = @_;

    if ( exists $self->allow_multi->{$action} ) {
        for my $domain_name ( $c->req->param('domain_name') ) {
            if ( $c->stash->{domain} = $c->model('Postfix::Domain')->find( $domain_name ) ) {
                $c->forward( $self->allow_multi->{$action} );
            }
            else {
                $c->add_feedback( error => "Can't find domain '$domain_name'." );
            }
        }
    }
    else {
        $c->add_feedback( error => "Action '$action' is not defined." );
    }

    $c->res->redirect( $c->uri_for('/domain') );
}

=head1 AUTHOR

Diego Kuperman

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
