package Array::Dissect;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

use Carp qw( croak );

require Exporter;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT_OK = qw(
	reform
);

$VERSION = '1.00';

# Preloaded methods go here.

sub dissect ($$\@) {
  my $class = shift;
  my $size = shift;
  croak "Invalid array size" if $size < 1;

  my @bigarray = @{ shift() };
  my @smallarrays;
  my $i = 0;
  my $j = 0;
  foreach (@bigarray) {
    $smallarrays[$i]->[$j] = $_;
    $i = 0, $j++ unless (++$i % $size);
  }
  return @smallarrays;
}

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

Array::Dissect - Convert an array into N-sized array of arrays

=head1 SYNOPSIS

  use Array::Dissect;

  @sample = ( 1 .. 10 );
  $rowsize = 3;

  Array::Dissect->dissect( $rowsize, \@sample );
      =>
         (
            [   1,   5,   9   ],
            [   2,   6,  10   ],
            [   3,   7   ],
            [   4,   8   ]
          );


=head1 DESCRIPTION

Like Array::Reform, this takes a big array, and converts it into an array of arrays. The key difference between the two modules is that this one takes elements from the start of the big array and pushes them onto each of the subarrays sequentially, rather than simply dividing the big array up into discrete chunks. The intended effect of this method is that, if fed a sorted array, dissect() returns an array of arrays where the first element of each subarray will be one of the highest (or lowest, depending on how the array is sorted) value items in the big array, and the last element of each will be the opposite.

=head1 AUTHOR

Alex Bowley <kilinrax@cpan.org>

=cut
