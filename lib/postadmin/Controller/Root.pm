package postadmin::Controller::Root;

use Moose; BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

postadmin::Controller::Root - Root Controller for postfix admin

=head1 DESCRIPTION

This app is a drop-in replacement for php postfix admin interface

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->res->redirect( $c->uri_for( '/domain' ) );
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 auto

Actions for all requests

=cut
sub auto : Private {
    my ( $self, $c ) = @_;

    if ( my $feedback = $c->flash->{feedback} ) {
        $c->stash( feedback => $feedback );
    }

    1;
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;

    if ( my $feedback = $c->stash->{feedback} ) {
        $c->flash( feedback => $feedback );
    }
}

=head1 AUTHOR

Diego Kuperman

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
