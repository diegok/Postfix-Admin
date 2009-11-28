#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'postadmin' }

ok( request('/')->is_redirect, '/ should redirect' );
ok( request('/xxx')->is_error, '/xxx is a not found error' );
