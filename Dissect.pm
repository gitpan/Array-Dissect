package Array::Dissect;

use 5.006;
use warnings;
use strict;
use Carp;

require Exporter;

our @ISA = qw(Exporter DynaLoader);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Array::Dissect ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
                                   reform
                                   dissect
                                  ) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw();

our $VERSION = '1.03';

# Preloaded methods go here.
sub reform {
  my ($size, $r_list) = &_validate_params;

  my @list = @{$r_list};
  my @lol;

  push @lol, [splice @list, 0, $size] while @list;

  return wantarray ? @lol : \@lol;
}

sub dissect {
  my ($size, $r_list) = &_validate_params;

  my @lol;
  my ($i, $j) = (0, 0);

  foreach (@$r_list) {
    $lol[$i]->[$j] = $_;
    $i = 0, $j++ unless (++$i % $size);
  }

  return wantarray ? @lol : \@lol;
}


# Internal parameter validation function
sub _validate_params {
  # Check we have at been called with at least 2 arguments
  Carp::croak( "Called with insufficient arguments" ) if( $#_ < 1 );

  # First argument is size. check it is a valid positive integer.
  my $size = shift;
  if( $size !~ /^\+?\d+$/ ) {
    Carp::croak( "Size '$size' is not a valid positive integer" );
  } elsif( $size == 0 ) {
    Carp::croak( "'$size' is an invalid array size" );
  }

  # If only one argument remains, check to see if it is an arrayref, otherwise, create a reference to all remaining args
  my $r_list;
  if( ($#_ == 0) &&
      (ref($_[0]) eq 'ARRAY') ) {
    $r_list = $_[0];
  } else {
    $r_list = \@_;
  }

  return $size, $r_list;
}

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

Array::Dissect - Convert an array into N-sized array of arrays.

=head1 SYNOPSIS

  use Array::Dissect qw( :all );

  @sample = ( 1 .. 10 );
  $rowsize = 3;

  reform( $rowsize, @sample );
      =>
         (
            [   1,   2,   3   ],
            [   4,   5,   6   ],
            [   7,   8,   9   ],
            [   10   ]
          );

  dissect( $rowsize, @sample );
      =>
         (
            [   1,   5,   9   ],
            [   2,   6,  10   ],
            [   3,   7   ],
            [   4,   8   ]
          );


=head1 DESCRIPTION

This is intended as a much-improved replacement for Array::Reform.
Given the current maintainer's apparent lack of interest in keeping
this module up to date, it unfortunately, for now, exists separately.

The module is designed to reformat a list into a list of lists. It is
often used for formatting data into HTML tables, amongst other things.

Two methods are available for this purpose, C<reform()> and
C<dissect()>. The key difference between the two methods is that
C<dissect()> takes elements from the start of the list provided and
pushes them onto each of the sub-arrays sequentially, rather than
simply dividing the list into discrete chunks.
As a result C<dissect()> returns a list of lists where the first
element of each sublist will be one of the first elements of the
source list, and the last element will be one of the last.
This behavior is much more useful when the input list is sorted.

With both methods the array to be reformed can be passed as an array
or an array reference, and the list or lists will be returned as a
reference in a scalar context.

=head1 AUTHOR

Alex Bowley <kilinrax@cpan.org>, implementing improvements to
Array::Reform suggested by Dave Cross <dave@dave.org.uk>.

=head1 SEE ALSO

Array::Reform.

=cut
