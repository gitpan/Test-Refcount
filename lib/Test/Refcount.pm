#  You may distribute under the terms of either the GNU General Public License
#  or the Artistic License (the same terms as Perl itself)
#
#  (C) Paul Evans, 2008 -- leonerd@leonerd.org.uk

package Test::Refcount;

use strict;
use base qw( Test::Builder::Module );

use Devel::Refcount qw( refcount );

our $VERSION = '0.01';

our @EXPORT = qw(
   is_refcount
   is_oneref
);

=head1 NAME

C<Test::Refcount> - assert reference counts on objects

=head1 SYNOPSIS

 use Test::More tests => 2;
 use Test::Refcount;

 use Some::Class;

 my $object = Some::Class->new();

 is_oneref( $object, '$object has a refcount of 1' );

 my $otherref = $object;

 is_refcount( $object, 2, '$object now has 2 references' );

=head1 DESCRIPTION

The Perl garbage collector uses simple reference counting during the normal
execution of a program. This means that cycles or unweakened references in
other parts of code can keep an object around for longer than intended. To
help avoid this problem, the reference count of a new object from its class
constructor ought to be 1. This way, the caller can know the object will be
properly DESTROYed when it drops all of its references to it.

This module provides two test functions to help ensure this property holds
for an object class, so as to be polite to its callers.

=cut

=head1 FUNCTIONS

=cut

=head2 is_refcount( $object, $count, $name )

Test that $object has $count references to it.

=cut

sub is_refcount($$;$)
{
   my ( $object, $count, $name ) = @_;

   my $tb = __PACKAGE__->builder;

   if( !ref $object ) {
      my $ok = $tb->ok( 0, $name );
      $tb->diag( "  expected a reference, was not given one" );
      return $ok;
   }

   my $REFCNT = refcount($object) - 1; # my $object takes one

   my $ok = $tb->ok( $REFCNT == $count, $name );

   unless( $ok ) {
      $tb->diag( "  expected $count references, found $REFCNT" );
   }

   return $ok;
}

=head2 is_oneref( $object, $name )

Assert that the $object has only 1 reference to it.

=cut

sub is_oneref($;$)
{
   splice( @_, 1, 0, ( 1 ) );
   goto &is_refcount;
}

# Keep perl happy; keep Britain tidy
1;

__END__

=head1 BUGS

=over 4

=item * Values not in variables

Code such as

 is_oneref( [] );

breaks on perl 5.8. Passing a variable (e.g)

 my $array = [];
 is_oneref( $array );

works fine. This limitation should not affect the behaviour of test scripts
that use this module.

=back

=head1 AUTHOR

Paul Evans E<lt>leonerd@leonerd.org.ukE<gt>
