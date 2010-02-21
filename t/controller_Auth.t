use strict;
use warnings;
use Test::More tests => 6;

BEGIN { use_ok 'Catalyst::Test', 'postadmin' }
BEGIN { use_ok 'postadmin::Controller::Auth' }

ok( request('/login')->is_success, 'Login screen exists' );
content_like( '/login', qr/input[^>]+?name="username"/, 'Login screen has username field' );
content_like( '/login', qr/input[^>]+?name="password"/, 'Login screen has password field' );

ok( request('/logout')->is_redirect, 'Logout exists and is a redirect' );

