package postadmin::Schema::Result::Admin;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("admin");
__PACKAGE__->add_columns(
  "username",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "password",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "created",
  {
    data_type => "DATETIME",
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
    size => 19,
  },
  "modified",
  {
    data_type => "DATETIME",
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
    size => 19,
  },
  "active",
  { data_type => "TINYINT", default_value => 1, is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("username");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-20 14:13:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AxqjP1LiXDt1HiKlNpB5VA


# You can replace this text with custom content, and it will be preserved on regeneration
1;