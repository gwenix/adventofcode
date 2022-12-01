#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
#my $input_file = "test.input";
my $input_file = "input";

our @grid;
our %basins;

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);
my ($maxWidth,$maxLength);
$maxLength=@lines;

# first pass to set up grid
for (my $j=0; $j<$maxLength; $j++) {
  my $l = $lines[$j];
  my @ch = split //, $l;
  $maxWidth = @ch if ($j==0); # only need to do this once
  for (my $i=0; $i<@ch; $i++) {
    $grid[$i][$j]{value}=$ch[$i];
  }
}

# Assign Basins
$basins{curr}=1;
for(my $j=0; $j<$maxLength; $j++) {
  my $l = $lines[$j];
  my @ch = split //, $l;
  for(my $i=0; $i<@ch; $i++) {
    AssignBasins($i,$j,$maxWidth,$maxLength);
  }
}

PrintGrid($maxWidth, $maxLength);
  
my $risk = TotalBasins();

print "Risk is: $risk\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub PrintGrid {
  my $maxX = shift();
  my $maxY = shift();

  for (my $j=0; $j<$maxY; $j++) {
    for (my $i=0; $i<$maxX; $i++) {
      print "$grid[$i][$j]{value} ";
    }
    print "\n";
  }
  print "\n";

  for (my $j=0; $j<$maxY; $j++) {
    for (my $i=0; $i<$maxX; $i++) {
      if ($grid[$i][$j]{value}==9) {
	print "X ";
      } elsif ($grid[$i][$j]{basin}) {
        print "$grid[$i][$j]{basin} ";
      } else {
        print "E ";
      }
    }
    print "\n";
  }
  print "\n";
}

sub TotalBasins {
  my @arr;
  foreach my $b (keys %{ $basins{bas} }) {
    my $vol = $basins{bas}{$b};
    print "Basin $b has volume $vol\n";
    push (@arr, $vol);
  }

  @arr = sort { $b <=> $a } @arr;

  my $total = $arr[0] * $arr[1] * $arr[2];

  return $total;
}

sub AssignBasins {
  my $x = shift();
  my $y = shift();
  my $maxX = shift();
  my $maxY = shift();

  my $curr = $grid[$x][$y]{value};
  my $basin = $grid[$x][$y]{basin};

  unless ($curr==9 || $basin) {
    my $basin=$basins{curr};
    $basins{curr}++;
    ABasin($x,$y,$maxX,$maxY,$basin);  
  }
}

sub ABasin {
  my $x = shift();
  my $y = shift();
  my $maxX = shift();
  my $maxY = shift();
  my $basin = shift();

  if ($x==$maxX || $y==$maxY || $x==-1 || $y==-1) {
    # do nothing
  } elsif ($grid[$x][$y]{value}==9) {
    # do nothing
  } elsif ($grid[$x][$y]{basin}) {
    # do nothing
  } else {
    $grid[$x][$y]{basin}=$basin;
    $basins{bas}{$basin}++;
    ABasin($x-1,$y,$maxX,$maxY,$basin);  
    ABasin($x+1,$y,$maxX,$maxY,$basin);  
    ABasin($x,$y-1,$maxX,$maxY,$basin);  
    ABasin($x,$y+1,$maxX,$maxY,$basin);  
  }
}
