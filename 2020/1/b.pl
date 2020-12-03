#!/usr/bin/perl

use strict;
use warnings;

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

for (my $i=0; $i<@lines; $i++) {
  my $split=$i/2;
  for (my $j=0; $j<$split; $j++) {
    for (my $k=$split; $k<$i; $k++) {
      my $a=$lines[$i];
      my $b=$lines[$j];
      my $c=$lines[$k];

      if ($a+$b+$c==2020) {
        my $mult=$a*$b*$c;
        print "$a * $b * $c = $mult\n";
      }
    }
  }
}

exit; 

# ----------- #
# Subroutines #
# ----------- #
