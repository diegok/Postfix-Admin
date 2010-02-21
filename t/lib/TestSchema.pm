package TestSchema;

use strict;
use warnings;

use DBICx::TestDatabase;
#use File::Temp qw( tempdir );

sub new {
    my $schema = DBICx::TestDatabase->new( 'postadmin::Schema' );
    #use tempdir to let the schema create mailboxes
    return $schema;
}

1;

