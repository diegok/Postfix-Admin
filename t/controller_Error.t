use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'postadmin' }
BEGIN { use_ok 'postadmin::Controller::Error' }

ok( request('/error')->is_success, 'Request should succeed' );


