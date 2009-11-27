package postadmin::Controller::Domain;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

postadmin::Controller::Domain - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->detach('list');
}

=head1 list

List all domains

=cut
sub list : Private {
    my ( $self, $c ) = @_;

    $c->stash( domains  => [ $c->model('Postfix::Domain')->all() ] );
    $c->stash( template => 'domain/list.tt' );
}

=head1 element_chain

Base chain for actions related to one domain

=cut
sub element_chain : PathPart( 'domain' ) Chained( '/' ) CaptureArgs( 1 ) {
    my ( $self, $c, $domain_name ) = @_;

    unless ( $c->stash->{domain} = $c->model('Postfix::Domain')->find( $domain_name ) ) {
        $c->detach( '/error/element_not_found', [ 'domain' ] );
    }
}

=head1 edit

Edit a domain

=cut
sub edit : PathPart( 'delete' ) Chained( 'user_chained' ) Args( 0 ) {
    my ( $self, $c ) = @_;

    $c->res->body( 'Not implemented yet' );
}

=head1 delete

Delete a domain

=cut
sub delete : PathPart( 'delete' ) Chained( 'user_chained' ) Args( 0 ) {
    my ( $self, $c ) = @_;

    $c->res->body( 'Not implemented yet' );
}

=head1 togle_active

Toggle the active flag of a domain

=cut
sub toggle_active : PathPart( 'toggle' ) Chained( 'element_chain' ) Args( 0 ) {
    my ( $self, $c ) = @_;
    my $domain = $c->stash->{domain};

    if ( $domain->active ) {
        $domain->active(0);
        $c->add_feedback( info => 'Domain ' . $domain->domain . ' has been deactivated' );
    }
    else {
        $domain->active(1);
        $c->add_feedback( info => 'Domain ' . $domain->domain . ' has been activated' );
    }

    $domain->update;
    $c->res->redirect( $c->uri_for('/domain') );
}

=head1 AUTHOR

Diego Kuperman

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
