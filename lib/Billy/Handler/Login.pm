package Billy::Handler::Login;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::Ajax;


use Data::Dumper;

our $VERSION = '0.1';

prefix '/login';


any '/' => sub {
    debug "Login route done";
    if ( params->{user} && params->{password} ){
         
        my $user = database->quick_select('users',
            { username => params->{user} }
        );
        if (!$user) {
            debug "Authentication failure for user " . params->{user};
            template 'index.tt', { auth_fail => 1, user => params->{user} };
        } else {
            if (Crypt::SaltedHash->validate($user->{password}, params->{pass}))
            {
                session user => $user;
                redirect '/main_landing.tt';
            } else {
                debug "Auth_failed";
                template 'index.tt', { auth_fail => 1, user => params->{user} };
            }
        }
    
    } elsif ( params->{user} || params->{password} ) {   
        template 'index.tt', { auth_fail => 1, user => params->{user} };   
    } else {
        template 'index.tt';
    }
};



true;
