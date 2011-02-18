package postadmin;

use Moose;
use namespace::autoclean;

use Catalyst qw/
    ConfigLoader
    Static::Simple

    Unicode::Encoding

    Session
    Session::Store::FastMmap
    Session::State::Cookie

    Authentication
/;
extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    name     => 'postadmin',
    encoding => 'UTF-8',

    'Plugin::Authentication' => {
        default_realm => 'mailbox',
        realms        => {
            mailbox => {
                credential => {
                    class          => 'Password',
                    password_field => 'password',
                    password_type  => 'self_check',
                },
                store => {
                    class      => 'DBIx::Class',
                    user_model => 'Postfix::Mailbox',
                    id_field   => 'username'
                }
            }
        }
    },
);

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

=head1 get_req_logdata
    
    Returns an aref with username and hostname/ip from
    the request to be used when creating log records.

=cut
sub get_req_logdata {
    my $c = shift;

    return {
        username => sprintf( "%s (%s)", 'posmaster@replace-this.com', $c->req->hostname )
    };
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
