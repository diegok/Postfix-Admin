#!/usr/bin/env perl

BEGIN { $ENV{DBIC_NO_VERSION_CHECK}++ }

use strict;
use Getopt::Long::Descriptive;

use FindBin qw( $Bin );
use lib "$Bin/../lib";
use postadmin;

my ( $opt, $usage ) = describe_options(
    "%c %o",
    [ 'directory|d:s',  "The schema upgrade directory (default ../sql)", { default => "$Bin/../sql" } ],
    [],
    [ 'help|h',         "print usage message and exit" ],
);

if ( $opt->help ) {
    print( $usage->text ); 
    exit;
}

my $schema = postadmin->model('Postfix')->schema;
$schema->upgrade_directory( $opt->directory );

if ( !$schema->get_db_version ) {
    create_ddl($schema);
    update_ddbb($schema);
    init_data($schema);
}
elsif ( $schema->get_db_version ne $schema->schema_version ) {
    create_ddl($schema);
    update_ddbb($schema);
}
else {
    print STDERR "The schema is already on lastest version. No action needed.\n"; 
}

sub create_ddl {
    my $schema = shift;

    my $file = $schema->ddl_filename( 
        'MySQL', 
        $schema->schema_version, 
        $opt->directory,
        $schema->get_db_version 
    );

          
    if ( -f $file ) {
        print STDERR "Using file: $file\n";
    }
    else {
        print STDERR "Creating $file";
        eval {
            $schema->create_ddl_dir( 
                [ 'MySQL' ],
                $schema->schema_version, 
                $opt->directory, 
                $schema->get_db_version
            )
        };
        if ($@) { print STDERR " => error: ", $@, "\n"; die; }
        else    { print STDERR " => done.\n"; }
    }
}

sub update_ddbb {
    my $schema = shift;

    if ( !$schema->get_db_version ) {
        print STDERR 'Making initial deploy (ddbb has no version)', "\n"; 
        eval { $schema->deploy };
    }
    else {
        print STDERR 'Trying to upgrade from ', $schema->get_db_version, ' to ', $schema->schema_version, "\n"; 
        eval { $schema->upgrade };
    }

    if ($@) {
        print STDERR " => error:", $@, "\n";
    }
    else {
        print STDERR " => done.\n";
    }
}

sub init_data {
    my $schema = shift;

    my $domain = $schema->resultset('Domain')->create({
        domain      => 'example.com',
        description => 'Example domain'
    });

    my $admin  = $schema->resultset('Mailbox')->create({
        username => 'postmaster@example.com',
        password => 'admin',
        name     => 'Default admin',
        domain   => 'example.com'
    });

}

