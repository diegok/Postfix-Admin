package postadmin::Schema::Result::Domain;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("domain");
__PACKAGE__->add_columns(
  "domain",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "description",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "aliases",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 10, accessor => 'max_aliases' },
  "mailboxes",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 10, accessor => 'max_mailboxes' },
  "maxquota",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 10 },
  "transport",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "backupmx",
  { data_type => "TINYINT", default_value => 0, is_nullable => 0, size => 1 },
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
__PACKAGE__->set_primary_key("domain");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-20 14:13:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9I4wr2hwInIfaCze3mBeDA

__PACKAGE__->has_many( mailboxes => 'postadmin::Schema::Result::Mailbox' => 'domain' );
__PACKAGE__->has_many( aliases   => 'postadmin::Schema::Result::Alias'   => 'domain' );

sub activate   { $_[0]->active(1); $_[0]->update(); };
sub deactivate { $_[0]->active(0); $_[0]->update(); };

1;
