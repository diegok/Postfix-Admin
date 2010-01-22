package Admin;

use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';

use DateTime;

has '+item_class' => ( default => 'Admin' );

has_field 'active' => ( type => 'Text', size => 1, required => 1, );

has_field 'modified' => (
    type  => 'Compound',
    apply => [
        {
            transform => sub { DateTime->new( $_[0] ) },
            message   => "Not a valid DateTime",
        }
    ],
);
has_field 'modified.year';
has_field 'modified.month';
has_field 'modified.day';

has_field 'created' => (
    type  => 'Compound',
    apply => [
        {
            transform => sub { DateTime->new( $_[0] ) },
            message   => "Not a valid DateTime",
        }
    ],
);
has_field 'created.year';
has_field 'created.month';
has_field 'created.day';

has_field 'password' => ( type => 'TextArea', required => 1, );
has_field 'username' => ( type => 'TextArea', required => 1, );
has_field 'submit' => ( widget => 'submit' )

1;
