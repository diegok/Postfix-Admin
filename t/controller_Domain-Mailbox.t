use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'postadmin' }
BEGIN { use_ok 'postadmin::Controller::Domain::Mailbox' }

ok( request('/domain/mailbox')->is_success, 'Request should succeed' );


