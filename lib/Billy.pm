package Billy;
use Dancer2 ':syntax';
use Dancer2::Plugin::Database;  ## Note to self write a plugin or install a plugin for DB
use Billy::Handler::Clients;
use Billy::Handler::Invoice;
use Billy::Handler::Config;
use Billy::Handler::Login;

our $VERSION = '0.1';

prefix undef;


hook 'before' => sub {
    if (! session('user') && request->path_info !~ m{^/login}) {
        var requested_path => request->path_info;
        request->path_info('/login');
    }
};

get '/' => sub {
    template 'main_landing.tt';
};


true;
