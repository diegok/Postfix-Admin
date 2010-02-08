package postadmin::Controller::Domain::Alias;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

postadmin::Controller::Domain::Alias - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched postadmin::Controller::Domain::Alias in Domain::Alias.');
}


=head1 AUTHOR

Diego Kuperman,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
