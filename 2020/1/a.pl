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
  for (my $j=0; $j<$i; $j++) {
    my $a=$lines[$i];
    my $b=$lines[$j];

    if ($a+$b==2020) {
      my $mult=$a*$b;
      print "$a * $b = $mult\n";
    }
  }
}

exit; 

# ----------- #
# Subroutines #
# ----------- #
