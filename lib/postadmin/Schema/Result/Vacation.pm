package postadmin::Schema::Result::Vacation;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("TimeStamp", "InflateColumn::DateTime", "Core");
__PACKAGE__->table("vacation");
__PACKAGE__->add_columns(
  "email",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "subject",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "body",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 0,
    size => 65535,
  },
  "cache",
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
  "active",
  { data_type => "TINYINT", default_value => 1, is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("email");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-20 14:13:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:F5lpyl4PT1PWxZGmcztS4g


# You can replace this text with custom content, and it will be preserved on regeneration
1;
