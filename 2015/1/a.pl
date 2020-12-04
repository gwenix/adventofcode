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


foreach my $l (@lines) {
  print "$l: ";
  my $floor=0;
  my @ch = split //, $l;
  foreach my $dir (@ch) {
    if($dir eq "\(") {
      $floor++;
    } elsif ($dir eq "\)") {
      $floor--;
    }
  }
  print "$floor\n";
}

exit; 

# ----------- #
# Subroutines #
# ----------- #
