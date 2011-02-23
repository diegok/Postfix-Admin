#!/usr/bin/env perl
use strict;
use warnings;
use postadmin;

postadmin->setup_engine('PSGI');
my $app = sub { postadmin->run(@_) };
