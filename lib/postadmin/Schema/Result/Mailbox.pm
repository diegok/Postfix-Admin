package postadmin::Schema::Result::Mailbox;

use strict;
use warnings;

use base 'DBIx::Class';
use Crypt::PasswdMD5 qw( unix_md5_crypt );
use Path::Class::Dir;
use File::Copy;

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
  { data_type => "VARCHAR", default_value => "", is_nullable => 0, size => 255 },
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

__PACKAGE__->belongs_to( domain => 'postadmin::Schema::Result::Domain' => 'domain' );

=head2 delete

Remove maildir on mailbox delete.

=cut
sub delete {
    my $self = shift;

    my $maildir = $self->root_dir->subdir( $self->maildir );

    my $ret = $self->next::method(@_);
    eval { 
        $maildir->rmtree();
        $maildir = $maildir->parent while $maildir->parent->remove(); # is parent empty?, then remove!. 
    };
    return $ret;
}

=head2 insert

Wrapper to auto create an alias if configured to do so.

WARNING: In the case an alias with the same address as this mailbox
already exists pointing wherever, it will be changed to point here!.

=cut
sub insert {
    my $self = shift;

    $self->next::method(@_);

    # If auto_alias I'll ensure the alias exists and point to this mailbox!
    if ( $self->result_source->schema->Mailbox->{auto_alias} ) {
        my $alias_rs = $self->result_source->schema->resultset('Alias');
        if ( my $alias = $alias_rs->find($self->email_address) ) {
            $alias->goto( $self->email_address );
            $alias->active( 1 );
            $alias->update;
        }
        else {
            $alias_rs->create({
                address => $self->email_address,
                goto    => $self->email_address,
                domain  => $self->domain
            });
        }
    }

    return $self;
}

=head2 update

Wrapper to auto update an alias if configured to do so.
When changing address, a new alias will be created but the
old one will remain modified to point to the updated mailbox.

=cut
sub update {
    my ( $self, $args ) = ( shift, shift );
    #TODO: check $self->get_dirty_columns and mantain aliases if username is changed!        
    $self->next::method($args, @_);
}

=head2 store_column

Create or move the maildir when setting 'username' column.

=cut
sub store_column {
    my ( $self, $column, $value ) = ( shift, shift, shift );

    my $ret = $self->next::method($column, $value, @_);

    if ( $column eq 'username' ) {
        my $old_maildir = $self->maildir;
        my $new_maildir = $self->maildir( $self->maildir_relative_path );

        if ( $old_maildir && ( $old_maildir ne $new_maildir ) ) { #move
            my $root_dir    = $self->root_dir;
            $old_maildir = $root_dir->subdir( $old_maildir );
            $new_maildir = $root_dir->subdir( $new_maildir );

            $new_maildir->mkpath( 0, 0700 )
                || $self->throw_exception( 'Unable to create new mailbox directory: ' . $! );

            move( $old_maildir, $new_maildir ) 
                || $self->throw_exception( 'Unable to rename mailbox directory: ' . $! );

            # cleanup old dir tree: delete empty parents.
            $old_maildir = $old_maildir->parent while $old_maildir->parent->remove();
        }
        elsif ( ! $old_maildir ) { #create
            $new_maildir = $self->root_dir->subdir( $new_maildir );
            if ( $new_maildir->mkpath( 0, 0700 ) ) {
                for my $dir ( qw/ new cur tmp / ) {
                    $new_maildir->subdir($dir)->mkpath( 0, 0700 );
                }
            }
            else {
                $self->throw_exception( 'Unable to create mailbox directory: ' . $! );
            }
        }
    }

    return $ret;
}

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
    $self->throw_exception( 'Unable to set username before domain' ) unless $domain;

    $self->_username( sprintf( '%s@%s', $value, $domain ) );
    return $value;
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

=head2 check_password

Check if a password match with the crypted one.

=cut
sub check_password {
    my ( $self, $clearpw ) = @_;
    my $crypt = unix_md5_crypt( $clearpw, $self->password );
    return $crypt eq $self->password;
}

sub is_admin {
    my ($self, $val) = @_;

    my $admins = $self->result_source->schema->resultset('Admin');

    if ( defined $val ) {
        my $adm = $admins->find($self->_username);
        if ( $adm && $val == 0 ) {
            $adm->delete();
        }
        elsif ( ! $adm ) {
            $val = $admins->create({
                username => $self->_username,
                password => $self->_password,
            });
       }
       else {
            $val = $adm;
       }
    }
    else {
        $val = $admins->find($self->_username);
    }

    return defined $val ? 1 : 0;
}

sub activate   { $_[0]->active(1); $_[0]->log->{action}='Activate mailbox'; $_[0]->update(); };
sub deactivate { $_[0]->active(0); $_[0]->log->{action}='Deactivate mailbox'; $_[0]->update(); };

sub log_data { $_[0]->email_address }

=head2 root_dir

Returns a Path::Class::Dir object representing the root directory of all mailboxes.

=cut
sub root_dir {
    my $self = shift;
    my $dir = Path::Class::Dir->new($self->result_source->schema->Mailbox->{root});
    return $dir;
}

=head2 maildir_relative_path

Returns a string representing the relative directory genrated using Mailbox->{pattern}
config option. By default it is "[domain]/[user]/Maildir"

=cut
sub maildir_relative_path {
    my $self = shift;

    my $pattern  = $self->result_source->schema->Mailbox->{pattern} 
                || '[domain]/[user]/Maildir';

    my $username = $self->username;
    my $domain   = $self->get_column('domain'); 

    $pattern =~ s/\[domain\]/$domain/g;
    $pattern =~ s/\[user\]/$username/g;

    return $pattern;
}
1;
