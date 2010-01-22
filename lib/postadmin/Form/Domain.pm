package postadmin::Form::Domain;

use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'postadmin::Form::Render::FreeKey';

has '+item_class' => ( default => 'Domain' );

has_field 'domain' => ( type => 'Text', maxlength => 255, required => 1 );
#has_field 'domain' => ( type => 'Text', maxlength => 255, required => 1, apply => 'DomainName' );
has_field 'description' => ( type => 'Text', maxlength => 255, required => 1 );
has_field 'active' => ( type => 'Checkbox' );
has_field 'backupmx' => ( type => 'Checkbox' );
has_field 'maxquota'  => ( type => 'PosInteger', required => 1, default => 0 );
has_field 'max_mailboxes' => ( type => 'PosInteger', required => 1, defamult => 0 );
has_field 'max_aliases'   => ( type => 'PosInteger', required => 1, default => 0 );
has_field 'transport' => ( type => 'Text', maxlength => 255, default => 'virtual' );
has_field 'submit' => ( widget => 'submit' );

#subtype 'DomainName'
#    => as 'Text',
#    => where { $_ =~ /^[a-z]+(?:\.[a-z]+)/ }
#    => message { "The domain name doesn't look like a possible domain name" };

no HTML::FormHandler::Moose;
1;
