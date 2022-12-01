#!/usr/bin/perl

use strict;
#use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my @grid;
my ($maxX, $maxY) = (0,0);

foreach my $l (@lines) {
  my @pair = split / -> /, $l;
  my ($x1,$y1) = split /,/, $pair[0];
  my ($x2,$y2) = split /,/, $pair[1];

  #PrintGrid(@grid);
  print "Running $l\n";

  $maxX=$x1 if ($x1>$maxX);
  $maxY=$y1 if ($y1>$maxY);
  $maxX=$x2 if ($x2>$maxX);
  $maxY=$y2 if ($y2>$maxY);

  if ($x1==$x2) { 		# vertical line
    if ($y1>$y2) {
      my $dummy=$y1;
      $y1=$y2;
      $y2=$dummy;
    }
    for(my $j=$y1; $j<=$y2; $j++) {
      $grid[$x1][$j]++;
    }
  } elsif ($y1==$y2) { 		# horizontal line
    if ($x1>$x2) {
      my $dummy=$x1;
      $x1=$x2;
      $x2=$dummy;
    }
    for(my $i=$x1; $i<=$x2; $i++) {
      $grid[$i][$y1]++;
    }
  } else { 			# diagonal line
    if ($x1>$x2) {
      print "diagonal, x reversed\n";
      my $dummy=$x1;
      $x1=$x2;
      $x2=$dummy;
      my $dummy=$y1;
      $y1=$y2;
      $y2=$dummy;
    }
    if ($y1>$y2) {
      print "diagonal, y reversed\n";
      while($x1<$x2+1) {
        $grid[$x1][$y1]++;
        $x1++;
        $y1--;
      }
    } else {
      while($x1<$x2+1) {
        $grid[$x1][$y1]++;
        $x1++;
        $y1++;
      }
    }
  }
}

my $total=0;

for (my $i=0; $i<=$maxX; $i++) {
  for (my $j=0; $j<=$maxX; $j++) {
    $total++ if ($grid[$i][$j]>1);
  }
}

#PrintGrid(@grid);

print "total: $total\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub PrintGrid {
  my @grid=@_;

  for (my $j=0; $j<=$maxX; $j++) {
    for (my $i=0; $i<=$maxX; $i++) {
      my $curr = $grid[$i][$j];

      $curr = "." unless ($curr);
      print "$curr ";
    }
    print "\n";
  }
  print "\n";
}
