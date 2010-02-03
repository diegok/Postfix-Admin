package postadmin::Form::Domain;

use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'postadmin::Form::Render::FreeKey';

has '+item_class' => ( default => 'Domain' );

has_field 'domain' => (
    type      => 'Text',
    maxlength => 255,
    required  => 1,
    apply     => [
        {
            check   => qr/^[a-z]+(?:\.[a-z]+)/,
            message => 'Must be a valid domain name'
        }
    ]
);
has_field 'description'   => ( type => 'Text', maxlength => 255, required => 1 );
has_field 'max_mailboxes' => ( type => 'PosInteger', required => 1, default => 10 );
has_field 'max_aliases'   => ( type => 'PosInteger', required => 1, default => 10 );
has_field 'maxquota'  => ( type => 'PosInteger', required => 1, default => 0 );
has_field 'active'    => ( type => 'Checkbox',   default  => 1 );
has_field 'backupmx'  => ( type => 'Checkbox' );
has_field 'transport' => ( type => 'Hidden', default => 'virtual' );    # it can be a select some day :)
has_field 'submit'    => ( widget => 'submit' );

no HTML::FormHandler::Moose;
1;
