package postadmin::Form::Alias;

use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with (
        'postadmin::Form::Role::AutoLog', 
        'postadmin::Form::Render::FreeKey'
    );
use Email::Valid;

use DateTime;

has '+item_class' => ( default => 'Alias' );
has 'domain'      => ( is => 'ro', required => 1 );

has_field 'address' => ( type => 'Text', required => 1, apply => [
    {
        check   => sub { Email::Valid->address( $_[0] ) },
        message => 'Must be a valid email address'
    }
]);

has_field 'goto' => ( type => 'Text', required => 1, apply => [
    {
        check   => sub { 
            for my $addr ( split /\s*[,\s]+\s*/, $_[0] ) {
                return 0 unless Email::Valid->address( $addr ); 
            }
            return 1;
        },
        message => 'Must be valid email addresses separated by commas'
    }
]);

has_field 'active'   => ( type => 'Checkbox', default => 1 );
has_field 'submit'   => ( widget => 'submit' );

before 'update_model' => sub {
    my $self = shift;
    $self->item->domain( $self->domain );
};

no HTML::FormHandler::Moose;
1;
