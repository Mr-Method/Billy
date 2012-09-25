package Billy;
use Dancer ':syntax';
use Billy::Handler::Clients;
use Billy::Handler::Invoice;
use Billy::Handler::Config;

our $VERSION = '0.1';

prefix undef;

# TODO: Default to login page ( after I create one)
get '/' => sub {
    template 'index.tt';
};

true;
