#!/usr/bin/perl

use strict;
use warnings;
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

my $dups=0;

foreach my $l (@lines) {
  #print "Looking at $l\n";
  my @group = split /,/, $l;
  my @subgrp0 = split /-/, $group[0];
  my @subgrp1 = split /-/, $group[1];

  if ($subgrp0[0]>=$subgrp1[0] && $subgrp0[1]<=$subgrp1[1]) {
    # subgroup0 is a subset of subgroup1
    $dups++;
    #print "\t0 is a subset of 1\n";
  } elsif ($subgrp1[0]>=$subgrp0[0] && $subgrp1[1]<=$subgrp0[1]) {
    # subgroup1 is a subset of subgroup0
    $dups++;
    #print "\t1 is a subset of 0\n";
  } else {
    # Not a subset
    #print "\tnot a subset\n";
  }
}

print "There are $dups subsets.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #
