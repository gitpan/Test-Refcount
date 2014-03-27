#!/usr/bin/perl -w

use strict;

use Test::Builder::Tester tests => 2;

use Scalar::Util qw( weaken );

use Test::Refcount;

use constant HAVE_DEVEL_FINDREF => eval { require Devel::FindRef };

my $object = bless {}, "Some::Class";

my $newref = $object;

test_out( "not ok 1 - one ref" );
test_fail( +10 );
test_err( "#   expected 1 references, found 2" );
if( HAVE_DEVEL_FINDREF ) {
   test_err( qr/^# Some::Class=HASH\(0x[0-9a-f]+\) (?:\[refcount 2\] )?is\n/ );
   test_err( qr/(?:^#.*\n){1,}/m ); # Don't be sensitive on what Devel::FindRef actually prints
}
elsif( Test::Refcount::HAVE_DEVEL_MAT_DUMPER ) {
   test_err( qr/^# SV address is 0x[0-9a-f]+\n/ );
   test_err( qr/^# Writing heap dump to \S+\n/ );
}
is_oneref( $object, 'one ref' );
test_test( "two refs to object fails to be 1" );

weaken( $newref );

test_out( "ok 1 - object with weakref" );
is_oneref( $object, 'object with weakref' );
test_test( "object with weakref succeeds" );

END {
   # Clean up Devel::MAT dumpfile
   my $pmat = $0;
   $pmat =~ s/\.t$/-1.pmat/;
   unlink $pmat if -f $pmat;
}
