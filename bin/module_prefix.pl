#!/usr/bin/perl

use strict;
use warnings;


my $module_name = $ARGV[0];
open(my $module, ">$module_name\.pm" ) or die "unable to open $module_name\n $!\n ";



print $module <<"component_module";
package Billy::$module_name;
use Dancer ':syntax';

our \$VERSION = '0.1';

prefix '/$module_name';

get '/' => sub {

    template '';
};

true;
component_module


