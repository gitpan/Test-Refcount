use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new
  (
   module_name => 'Test::Refcount',
   requires => {
                  'Devel::FindRef' => 0,
                  'Devel::Refcount' => 0,
                  'Test::Builder' => 0,
   },
   build_requires => {
                        'Test::Builder::Tester' => 0,
                        'Test::More' => 0,
                     },
   license => 'perl',
   create_makefile_pl => 'traditional',
  );
  
$build->create_build_script;
