package postadmin::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';
use postadmin;

__PACKAGE__->config(
    CATALYST_VAR => 'c',
    TEMPLATE_EXTENSION => '.tt',
    INCLUDE_PATH => [
        postadmin->path_to( 'root', 'src' ),
        postadmin->path_to( 'root', 'wrapper' )
    ],
    WRAPPER      => 'selector',
    TIMER        => 0
);

=head1 NAME

postadmin::View::TT - TT View for postadmin

=head1 DESCRIPTION

TT View for postadmin.

=head1 SEE ALSO

L<postadmin>

=head1 AUTHOR

Diego Kuperman

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
