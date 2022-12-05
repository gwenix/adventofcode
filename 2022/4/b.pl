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
  print "Looking at $l: ";
  my @group = split /,/, $l;
  my @subgrp0 = split /-/, $group[0];
  my @subgrp1 = split /-/, $group[1];

  my %sect;
  my $isdup=0;

  for(my $i=$subgrp0[0]; $i<=$subgrp0[1]; $i++) {
    $sect{$i}=1;
  }

  for(my $i=$subgrp1[0]; $i<=$subgrp1[1] && !$isdup; $i++) {
    $isdup=1 if ($sect{$i});
  }

  $dups++ if ($isdup);
  print "$isdup\n";
}

print "\nThere are $dups subsets.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #
