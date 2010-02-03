package postadmin::Form::Role::AutoLog;
use Moose::Role;

requires 'update_model';
has 'log' => ( is => 'rw', isa => 'HashRef', default => sub { {} } ); 

before 'update_model' => sub {
    my $self = shift;
    $self->item->log( $self->log );
};

1;
