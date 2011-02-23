package postadmin::Form::Mailbox;

use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with (
        'postadmin::Form::Role::AutoLog', 
        'postadmin::Form::Render::FreeKey'
    );
use Email::Valid;

has '+item_class' => ( default => 'Mailbox' );

has_field 'name'     => ( type => 'Text', required => 1, );
has_field 'username' => ( type => 'Text', required => 1, apply => [
    {
        check   => sub { Email::Valid->address( $_[0] . '@fake.com') },
        message => 'Must be a valid for an email address'
    }
]);
has_field 'password' => ( type => 'Password',   required => 1, );
has_field 'quota'    => ( type => 'PosInteger', required => 1, default => 0 );
has_field 'active'   => ( type => 'Checkbox', default => 1 );
has_field 'is_admin'   => ( type => 'Checkbox', default => 1 );

has       'domain'   => ( is => 'ro', required => 1 );
has_field 'submit'   => ( widget => 'submit' );

before 'update_model' => sub {
    my $self = shift;
    $self->item->domain( $self->domain );
};

no HTML::FormHandler::Moose;
1;
