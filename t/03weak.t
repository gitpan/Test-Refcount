#!/usr/bin/perl -w

use strict;

use Test::Builder::Tester tests => 2;

use Scalar::Util qw( weaken );

use Test::Refcount;

my $object = bless {}, "Some::Class";

my $newref = $object;

test_out( "not ok 1 - one ref" );
test_fail( +2 );
test_err( "#   expected 1 references, found 2" );
is_oneref( $object, 'one ref' );
test_test( "two refs to object fails to be 1" );

weaken( $newref );

test_out( "ok 1 - object with weakref" );
is_oneref( $object, 'object with weakref' );
test_test( "object with weakref succeeds" );
