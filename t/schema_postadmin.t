use strict;
use warnings;
use Test::More 'no_plan';

use lib 't/lib';
BEGIN { use_ok 'TestSchema' }

ok ( my $schema = TestSchema->new(), 'Create a schema object' );
isa_ok ( $schema, 'postadmin::Schema');

ok ( my $domain_rs = $schema->resultset('Domain'), 'Schema has Domain RS' );
ok( $domain_rs->create(
        {   domain      => 'test.com',
            description => 'A domain for testing',
            aliases     => 10,
            mailboxes   => 10,
            maxquota    => 0,
            transport   => 'virtual',
            backupmx    => 0,
            active      => 1,
        }
    ),
    'Create a new domain'
);
ok ( my $mailbox_rs = $schema->resultset('Mailbox'), 'Schema has Mailbox RS' );
ok ( my $alias_rs = $schema->resultset('Alias'), 'Schema has Alias RS' );
