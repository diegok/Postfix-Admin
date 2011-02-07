package postadmin::Controller::Domain::Alias;

use Moose; BEGIN { extends 'Catalyst::Controller' }
use postadmin::Form::Alias;

=head1 NAME

postadmin::Controller::Domain::Alias - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head1 list

List all aliases from the given domain

=cut
sub list : PathPart( 'aliases' ) Chained( '/domain/element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $domain = $c->stash->{domain};

    $c->stash( aliases => [ $domain->aliases->all() ] );
    $c->stash( template  => 'domain/alias/list.tt' );
}

=head1 element_chain

Base chain for actions related to one alias

=cut
sub element_chain : PathPart( 'alias' ) Chained( '/domain/element_chain' ) CaptureArgs( 1 ) {
    my ( $self, $c, $username ) = @_;
    my $domain = $c->stash->{domain};
    $username = '' if $username eq 'Catch-all';
    unless ( $c->stash->{alias} = $domain->aliases({ address => $username . '@' . $domain->domain })->first ) {
        $c->detach( '/error/element_not_found', [ 'alias' ] );
    }
}

=head1 edit

Edit a alias

=cut
sub edit : PathPart( 'edit' ) Chained( 'element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $domain = $c->stash->{domain};
    my $alias = $c->stash->{alias};
    my $form = postadmin::Form::Alias->new( domain => $domain->domain );
    if ( $form->process( item => $alias, params => $c->req->params, log => $c->get_req_logdata ) ) {
        $c->add_feedback( info  => 'Alias ' . $alias->address . ' saved' );
        $c->res->redirect( $c->uri_for('/domain', $domain->domain, 'aliases') );
    }
    else {
        $c->stash( 
            template => 'domain/alias/edit.tt', 
            form     => $form
        );
    }
}

=head1 create

Create a alias

=cut
sub create : PathPart( 'alias/create' ) Chained( '/domain/element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $domain = $c->stash->{domain};
    my $form = postadmin::Form::Alias->new( domain => $domain->domain );
    my $alias = $c->model('Postfix::Alias')->new_result({});

    if ( $form->process( item => $alias, params => $c->req->params, log => $c->get_req_logdata ) ) {
        $c->add_feedback( info  => 'Alias ' . $alias->address . ' created' );
        $c->res->redirect( $c->uri_for('/domain', $domain->domain, 'aliases') );
    }
    else {
        $c->stash( 
            template => 'domain/alias/create.tt', 
            form     => $form
        );
    }
}

=head1 delete

Delete a alias

=cut
sub delete : PathPart( 'delete' ) Chained( 'element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $alias = $c->stash->{alias};
    $alias->log( $c->get_req_logdata );

    eval { $alias->delete };
    if ($@) {
        $c->add_feedback( info  => 'Alias ' . $alias->address . ' can\'t be deleted' );
        $c->add_feedback( error => $@ );
    }
    else {
        $c->add_feedback( info => 'Alias ' . $alias->address . ' has been deleted' );
    }

    $c->res->redirect( $c->uri_for( '/domain', $alias->domain, 'aliases' ) );
}

=head1 togle_active

Toggle the active flag of a domain

=cut
sub toggle_active : PathPart( 'toggle' ) Chained( 'element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $alias = $c->stash->{alias};
    $alias->log( $c->get_req_logdata );
    
    if ( $alias->active ) {
        $alias->deactivate;
        $c->add_feedback( info => 'Alias ' . $alias->address . ' has been deactivated' );
    }
    else {
        $alias->activate;
        $c->add_feedback( info => 'Alias ' . $alias->address . ' has been activated' );
    }

    $c->res->redirect( $c->uri_for( '/domain', $alias->domain, 'aliases' ) );
}

=head2 multi_action_redispatch

    Try to exec allowed multi-alias actions on the requested action.

    When no actions catch the request, this action will try to exec
    the action mapped from allow_multi on the alias_username's param 
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

sub multi_action_redispatch : PathPart( 'alias' ) Chained( '/domain/element_chain' ) Args( 1 ) {
    my ( $self, $c, $action) = @_;
    my $domain = $c->stash->{domain};

    if ( exists $self->allow_multi->{$action} ) {
        for my $username ( $c->req->param('alias_username') ) {
            $username = '' if $username eq 'Catch-all';
            $username .= '@' . $domain->domain;
            if ( $c->stash->{alias} = $c->model('Postfix::Alias')->search({ address => $username })->first ) {
                $c->forward( $self->allow_multi->{$action} );
            }
            else {
                $c->add_feedback( error => "Can't find alias '$username'." );
            }
        }
    }
    else {
        $c->add_feedback( error => "Action '$action' is not defined." );
    }

    $c->res->redirect( $c->uri_for( '/domain', $domain->domain, 'aliases' ) );
}


=head1 AUTHOR

Diego Kuperman,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
