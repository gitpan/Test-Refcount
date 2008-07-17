#!/usr/bin/perl -w

use strict;

use Test::Builder::Tester tests => 6;

use Symbol qw( gensym );

use Test::Refcount;

my %refs = (
   SCALAR => do { my $var; \$var },
   ARRAY  => [],
   HASH   => +{},
   # This magic is to ensure the code ref is new, not shared. To be a new one
   # it has to contain a unique pad.
   CODE   => do { my $var; sub { $var } },
   GLOB   => gensym(),
   Regex  => qr/foo/,
);

foreach my $type (qw( SCALAR ARRAY HASH CODE GLOB Regex )) {
   test_out( "ok 1 - anon $type ref" );
   is_refcount( $refs{$type}, 1, "anon $type ref" );
   test_test( "anon $type ref succeeds" );
}
