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

my %orbit;

# setting up the data
foreach my $l (@lines) {
  my ($a, $b) = split /\)/, $l;

  $orbit{$b}=$a;
}

# count the total orbits
my $total=0;
foreach my $planet (keys %orbit) {
  my $curr = $planet;
  while ($orbit{$curr}) {
    $total++;
    $curr = $orbit{$curr};
  }
}

print "Total orbits: $total\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #
