package postadmin::Controller::Error;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

postadmin::Controller::Error - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head1 not_found

Show a not found page with an optional message.

=cut
sub not_found : Private {
    my ( $self, $c, $message ) = @_;

    $c->res->status(404);
    $c->stash( error    => $message );
    $c->stash( template => 'error/not_found.tt' );
}

=head1 element_not_found

Show error message specilized on non existing objects. 

=cut
sub element_not_found : Private {
    my ( $self, $c, $object_name ) = @_;
    $object_name ||= 'object';
    
    $c->detach( not_found => [ ucfirst $object_name . ' not found' ] );
}

=head1 AUTHOR

Diego Kuperman

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
