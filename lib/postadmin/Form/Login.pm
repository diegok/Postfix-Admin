package postadmin::Form::Login;

use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler';
    with 'postadmin::Form::Render::FreeKey';

use Email::Valid;

has_field 'username' => ( type => 'Text', required => 1, apply => [
    {
        check   => sub { Email::Valid->address( $_[0] ) },
        message => 'Must be your email address'
    }
]);
has_field 'password' => ( type => 'Password', required => 1 );

has_field 'submit'   => ( widget => 'submit' );

no HTML::FormHandler::Moose;
1;
