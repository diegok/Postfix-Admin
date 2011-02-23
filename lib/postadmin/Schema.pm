package postadmin::Schema;

use strict;
use warnings;
use base 'DBIx::Class::Schema';

our $VERSION = '0.01';

__PACKAGE__->mk_classdata( Mailbox => {} );

__PACKAGE__->load_namespaces();
__PACKAGE__->load_components( qw/Schema::Versioned/ );

# add extra attributes to all tables on the schema!
sub sqlt_deploy_hook {
my ($self, $sqlt_schema) = @_;

    for my $sqlt_table ( $sqlt_schema->get_tables ) {
        $sqlt_table->extra( mysql_charset => 'utf8' );
    }
}


1;
