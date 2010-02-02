package postadmin::Schema::Result::Alias;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( "TimeStamp", "InflateColumn::DateTime", "Core");
__PACKAGE__->table("alias");
__PACKAGE__->add_columns(
  "address",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "goto",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 0,
    size => 65535,
  },
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
__PACKAGE__->set_primary_key("address");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-20 14:13:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HAR9k0Gj8ySe1DQGrmFK+w

__PACKAGE__->belongs_to( domain => 'postadmin::Schema::Result::Domain' => 'domain' );

1;
