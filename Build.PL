use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'AstroSemantics',
    license             => 'lgpl',
    dist_author         => 'Brian Thomas <bthomas@noao.edu>',
    dist_abstract       => 'false',
    build_requires => {
        'Test::More' => '0.94',
        'List::MoreUtils' => '0.22',
    },
);

$builder->create_build_script();
