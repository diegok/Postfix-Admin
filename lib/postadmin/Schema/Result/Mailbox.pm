package postadmin::Schema::Result::Mailbox;

use strict;
use warnings;

use base 'DBIx::Class';
use Crypt::PasswdMD5 qw( unix_md5_crypt );

__PACKAGE__->load_components( "+postadmin::Schema::Component::AutoLog", "TimeStamp", "Core");
__PACKAGE__->table("mailbox");
__PACKAGE__->add_columns(
  "username",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255, accessor => '_username' },
  "password",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255, accessor => '_password' },
  "name",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "maildir",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255, accessor => '_maildir' },
  "quota",
  { data_type => "INT", default_value => 0, is_nullable => 0, size => 10 },
  "domain",
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
  "created",
  {
    data_type => "DATETIME",
    set_on_create => 1,
    is_nullable => 0,
    size => 19,
  },
  "modified",
  {
    data_type => "DATETIME",
    set_on_create => 1,
    set_on_update => 1,
    is_nullable => 0,
    size => 19,
  },
  "active",
  { data_type => "TINYINT", default_value => 1, is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("username", "domain");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-11-20 14:13:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:l7CyRyfT56Q4reURodEUuw

__PACKAGE__->belongs_to( domain => 'postadmin::Schema::Result::Domain' => 'domain' );

=head2 username

Username field accessor with transparent add/remove of domain name.
Also update the field mailbox on set.

=cut
sub username {
    my($self, $value) = @_;

    return undef unless defined $self->_username or defined $value;
    return (split '@', $self->_username)[0] unless defined $value;

    my $domain = $self->get_column('domain'); 
    $self->throw_exception( 'Username should not have domain name on set' ) if $value =~ /@/;
    $self->throw_exception( 'Unable to set username  before domain' ) unless $domain;

    $value = sprintf( '%s@%s', $value, $domain );
    $self->maildir( $value . '/' );
    return $self->_username( $value );
}

=head2 email_address

Get the full email address string for this mailbox.

=cut
sub email_address {
    my $self = shift;
    $self->_username;
}

=head2 password

Password field accessor with transparent encription on set.

=cut
sub password {
    my($self, $clearpw) = @_;
    return $self->_password unless defined $clearpw;
    return $self->_password( unix_md5_crypt( $clearpw ) );
}

=head2 maildir

Accessor for maildir, create or move the directory on set.

=cut
sub maildir {
    my($self, $value) = @_;
    return $self->_maildir unless defined $value;

    #TODO: create or move the directory

    return $self->_maildir( $value );
}

1;
