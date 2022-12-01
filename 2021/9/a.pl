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
    $grid[$i][$j]=$ch[$i];
  }
}

my $risk=0;
# check grid for low points
for(my $j=0; $j<$maxLength; $j++) {
  my $l = $lines[$j];
  my @ch = split //, $l;
  for(my $i=0; $i<@ch; $i++) {
    $risk+=1+$grid[$i][$j] if (CheckForLow($i,$j,$maxWidth,$maxLength));
  }
}

print "Risk is: $risk\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub CheckForLow {
  my $x = shift();
  my $y = shift();
  my $maxX = shift();
  my $maxY = shift();

  #print "Checking ($x, $y) ($maxX, $maxY): $grid[$x][$y]...\n";

  my $curr = $grid[$x][$y];
  my $isLowest=1;

  if ($x!=0) { 
    my $check=$grid[$x-1][$y];
    #print "\t against $check\n";
    $isLowest=0 if ($check<=$curr);
  }

  if ($y!=0 && $isLowest) { 
    my $check=$grid[$x][$y-1];
    #print "\t against $check\n";
    $isLowest=0 if ($check<=$curr);
  }

  if ($x!=$maxX-1 && $isLowest) { 
    my $check=$grid[$x+1][$y];
    #print "\t against $check\n";
    $isLowest=0 if ($check<=$curr);
  }

  if ($y!=$maxY-1 && $isLowest) { 
    my $check=$grid[$x][$y+1];
    #print "\t against $check\n";
    $isLowest=0 if ($check<=$curr);
  }

  return $isLowest;
}
