package postadmin::Schema::Component::AutoLog;

use strict;
use warnings;
use base qw/DBIx::Class/;

__PACKAGE__->mk_group_accessors('simple' => qw/ log /);

# We try to log into Log resultset after any operation.
# throw_error when faling to log.

# Attribute log is added to the class that use this
# component, so is possible to pass data to the 
# Log row this component will try to create. 
# Default values are provided for all columns in Log.

#TODO: do not write to Log when there are no changes or failing to create, etc!

sub insert {
    my $self = shift;
    $self->write_log( 'create' ) if $self->next::method( @_ );
    return $self;
}

sub update {
    my $self = shift;
    $self->next::method( @_ );
    $self->write_log( 'update' ) if $self->next::method( @_ );
    return $self;
}

sub delete {
    my $self = shift;
    $self->write_log( 'delete' ) if $self->next::method( @_ );
    return $self;
}

sub write_log {
    my ( $self, $action ) = @_;

    $self->log({}) unless ref $self->log;

    my $log_rs = $self->result_source->schema->resultset('Log');
    eval {
        $log_rs->create( $self->_build_log_info( $action ) );
    };
    if ($@) {
        $self->throw_exception( "Failed to log last $action action: $@" );
    }
}

sub _build_log_info {
    my ( $self, $action ) = @_;
    my $log = $self->log;

    $log->{domain} = $self->domain;
    $log->{action} ||= sprintf( '%s %s',
        ucfirst $action,
        lc $self->result_source->source_name );
    $log->{data}     ||= $self->log_data;
    $log->{username} ||= $self->log_username;

    return $log;
}

# use log_data() to decide in each Result class the most
# significative data of the rs to store on Log->data.
sub log_data { '' }
sub log_username { 'Anonymous (localhost)' }

1;
