package postadmin::Controller::Log;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

postadmin::Controller::Log - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 list

=cut

sub list : PathPart( 'log' ) Chained( '/auth/need_login' ) Args( 0 ) {
    my ( $self, $c ) = @_;

    my $logs = $c->model('Postfix::Log')->search( {}, {
        page => $c->req->params->{page} || 1,
        rows => 15,
        order_by => 'timestamp DESC'
    }); 

    $c->stash( logs  => [ $logs->all ] );
    $c->stash( pager => $logs->pager );

    $c->stash( template => 'log/list.tt' );
}


=head1 AUTHOR

Diego Kuperman

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
