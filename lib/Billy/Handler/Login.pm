package Billy::Handler::Login;
use Dancer2 ':syntax';
use Dancer2::Plugin::Database;
use Dancer2::Plugin::Ajax;
use Crypt::SaltedHash;

use Data::Dumper;

our $VERSION = '0.1';

prefix '/login';

get '/' =>sub {
    template 'index.tt';
};

post '/' => sub {
    debug "Login route done";
    if ( params->{username} && params->{password} ){
         
        my $user = database->quick_select('users',
            { username => params->{username} }
        );
        if (!$user) {
            debug "Authentication failure user doesn't exist: " . params->{username};
            template 'index.tt', { auth_fail => 1, user => params->{username} };
        } else {
	    debug "User "  . Dumper $user->{password};
            if (Crypt::SaltedHash->validate($user->{password}, params->{password}))
            {
                session user => $user;
                redirect '/';
            } else {
                debug "Authentication failure for user " . params->{username};
                template 'index.tt', { auth_fail => 1, user => params->{username} };
            }
        }
    
    } elsif ( params->{username} || params->{password} ) {   
        template 'index.tt', { auth_fail => 1, user => params->{username} };   
    } else {
        template 'index.tt';
    }
};



true;
