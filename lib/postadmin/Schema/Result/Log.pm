package postadmin::Schema::Result::Log;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("TimeStamp", "InflateColumn::DateTime", "Core");
__PACKAGE__->table("log");
__PACKAGE__->add_columns(
  "timestamp",
  {
    data_type => "DATETIME",
    set_on_create => 1,
    set_on_update => 1,
    is_nullable => 0,
    size => 19,
  },
  "username",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "domain",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "action",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "data",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-20 14:13:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CCiFdYmeDiLVEJepswN7EQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
