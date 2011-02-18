package postadmin::Controller::Auth;

use Moose; BEGIN { extends 'Catalyst::Controller'; }
use postadmin::Form::Login;

=head1 NAME

postadmin::Controller::Auth - Catalyst Controller for http auth

=head1 DESCRIPTION

This controller has the login and logout actions. Ths is also home for
all actions related to loged in base actions.

=head1 login

=cut
sub login : Path(/login) Args(0) {
    my ( $self, $c ) = @_;
    my $form = postadmin::Form::Login->new();

    if ( $form->process( params => $c->req->params ) ) {
        # login here!
        if ( $c->authenticate( { 
                username => $form->value->{username}, 
                password => $form->value->{password}
            } ) ) 
        {
            $c->detach('after_login_redirect');
        }
        else {
            $form->field('password')->add_error('Invalid password');
        }
    }

    $c->stash( 
        template => 'auth/login.page',
        form     => $form
    );
}

=head1 after_login_redirect

Ensure a user is redirected after a login success.

=cut
sub after_login_redirect : Private {
    my ( $self, $c ) = @_;
    my $path = delete $c->session->{after_login_path} || '/domain';
    $c->res->redirect( $c->uri_for( $path ) );
}

=head1 need_login

Base method for chains that needs a user logged in.

=cut
sub need_login : PathPart( '' ) Chained( '/' ) CaptureArgs( 0 ) {
    my ( $self, $c ) = @_;

    unless ( $c->user_exists ) {
        $c->session->{after_login_path} = '/' . $c->req->path;
        $c->res->redirect( $c->uri_for_action( $c->controller('Auth')->action_for('login') ) );
        $c->detach;
    }
}

=head1 need_admin

Base method for chains that needs a user logged in.

=cut
sub need_admin : PathPart( '' ) Chained( 'need_login' ) CaptureArgs( 0 ) {
    my ( $self, $c ) = @_;

    unless ( $c->user->obj->is_admin ) {
        $c->res->code(405);
        $c->res->body('Not allowed');
        $c->detach;
    }
}

=head1 logout

=cut
sub logout : Path(/logout) Args(0) {
    my ( $self, $c ) = @_;

    $c->logout;

    $c->res->redirect( $c->uri_for_action( $c->controller->action_for('login') ) );
}

=head1 AUTHOR

Diego Kuperman

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
