package Vacation;

use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';

use DateTime;

has '+item_class' => ( default => 'Vacation' );

has_field 'active' => ( type => 'Text', size => 1, required => 1, );

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

has_field 'domain'  => ( type => 'TextArea', required => 1, );
has_field 'cache'   => ( type => 'TextArea', required => 1, );
has_field 'body'    => ( type => 'TextArea', required => 1, );
has_field 'subject' => ( type => 'TextArea', required => 1, );
has_field 'email'   => ( type => 'TextArea', required => 1, );
has_field 'submit' => ( widget => 'submit' )

1;
