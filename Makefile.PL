use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Billy',
    AUTHOR              => q{Charlie Gonzalez <itcharlie@gmail.com>},
    VERSION_FROM        => 'lib/Billy.pm',
    ABSTRACT            => 'A Billing/Invoice web application built with Perl Dancer.',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Crypt::SaltedHash' => 0,
        'Template::Toolkit' => 0,
        'Dancer::Template::TemplateToolkit' => 0,
        'Dancer::Plugin::Databse' => 0,
        'Dancer'     => 1.3091,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Billy-*' },
);
