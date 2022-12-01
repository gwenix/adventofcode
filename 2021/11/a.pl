#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "test.input";
my $steps=13;
our $size=10;

# ------ #
# Arby's #
# ------ #

our @grid;
my $flashes=0;

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

# Initializing the grid
for(my $j=0; $j<@lines; $j++) {
  my @ch = split //, $lines[$j];
  for(my $i=0; $i<@ch; $i++) {
    $grid[$i][$j]{octopus}=$ch[$i];
    $grid[$i][$j]{flashed}=0;
  }
}

for (my $s=0; $s<=$steps; $s++) {
  #if (($s%10)==0) {
    print "Step $s:\n";
    PrintGrid();
  #}

  $flashes+=FlashGrid();

  #if (($s%10)==0) {
    print "There were $flashes flashes.\n\n";
  #}
}


exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Flash {
  my $x=shift();
  my $y=shift();

  return 0 if ($x<0 || $x>$size || $y<0 || $y>$size);
  return 0 if ($grid[$x][$y]{flashed});

  $grid[$x][$y]{octopus}++;

  if ($grid[$x][$y]{octopus}>9) {
    $grid[$x][$y]{flashed}=1;
    Flash($x+1,$y);
    Flash($x+1,$y-1);
    Flash($x,$y-1);
    Flash($x-1,$y-1);
    Flash($x-1,$y);
    Flash($x-1,$y+1);
    Flash($x,$y+1);
    Flash($x+1,$y+1);
  }

  return 1;
}

sub FlashGrid {
  my $fl=0;

  for(my $j=0; $j<$size; $j++) {
    for(my $i=0; $i<$size; $i++) {
      $grid[$i][$j]{octopus}++;
      if ($grid[$i][$j]{octopus}>9) {
	Flash($i,$j);
        PrintGrid();
      }
    }
  }

  for(my $j=0; $j<$size; $j++) {
    for(my $i=0; $i<$size; $i++) {
      if ($grid[$i][$j]{flashed}) {
        $fl++;
	$grid[$i][$j]{octopus}=0;
	$grid[$i][$j]{flashed}=0;
      }
    }
  }

  return $fl;
}

sub PrintGrid {
  for(my $j=0; $j<$size; $j++) {
    for(my $i=0; $i<$size; $i++) {
      if ($grid[$i][$j]{flashed}) {
	print "F";
      } else {
        print "$grid[$i][$j]{octopus}";
      }
    }
    print "\n";
  }
  print "\n";
}
