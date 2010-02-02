package postadmin::Schema::Result::Mailbox;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "TimeStamp", "InflateColumn::DateTime", "Core");
__PACKAGE__->table("mailbox");
__PACKAGE__->add_columns(
  "username",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "password",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255, accessor => '_password' },
  "name",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "maildir",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "quota",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 10 },
  "domain",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "created",
  {
    data_type => "DATETIME",
    set_on_create => 1,
    is_nullable => 0,
    size => 19,
  },
  "modified",
  {
    data_type => "DATETIME",
    set_on_create => 1,
    set_on_update => 1,
    is_nullable => 0,
    size => 19,
  },
  "active",
  { data_type => "TINYINT", default_value => 1, is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("username");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-20 14:13:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:l7CyRyfT56Q4reURodEUuw

__PACKAGE__->belongs_to( domain => 'postadmin::Schema::Result::Domain' => 'domain' );

=head2 password

Password field accessor with transparent encription on set.

=cut
sub password {
    my($self, $clearpw) = @_;
    
    # return current password if called w/o arguments.
    return $self->_password unless defined $clearpw;

    my $cipher = Digest::SHA::sha1_hex( $clearpw );
    return $self->_password( $cipher );
}


1;
