# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

BEGIN { $| = 1; print "1..3\n"; }
END {print "not ok 1\n" unless $loaded;}
use Array::Dissect;
$loaded = 1;
print "ok 1\n";

@orig = ( 1 .. 16 );
$size = 5;
@new = Array::Dissect->dissect( $size, \@orig );
if ( scalar @new == 5 ) {
  print "ok 2\n";
} else {
  print "not ok 2\n";
}

@orig = ( 1 .. 5 );
$size = 3;
@new = Array::Dissect->dissect( $size, \@orig );
if ( $new[0][1] == 4 && $new[2][0] == 3 ) {
  print "ok 3\n";
} else {
  print "not ok 3\n";
}
