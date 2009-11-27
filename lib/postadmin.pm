package postadmin;

use strict;
use warnings;

use Catalyst::Runtime 5.80;
use parent qw/Catalyst/;
use Catalyst qw/
    ConfigLoader
    Static::Simple

    Session
    Session::Store::FastMmap
    Session::State::Cookie
/;

our $VERSION = '0.01';

__PACKAGE__->config( name => 'postadmin' );

# TODO: set defaults

# Start the application
__PACKAGE__->setup();

=head1 add_feedback

Manage user feedback structure

Log to developer in debug mode!

=cut
sub add_feedback {
    my ( $c, $type, $message ) = @_;

    unless ( defined $type && defined $message ) {
        warn 'Bad usage of add_feedback()';
        return 0;
    }

    push @{ $c->stash->{feedback}{$type} }, $message;
    $c->log->debug( $type . ': ' . $message ) if $c->debug;

    return 1;
}

=head1 NAME

postadmin - Catalyst based application

=head1 SYNOPSIS

    script/postadmin_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<postadmin::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Diego Kuperman

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
