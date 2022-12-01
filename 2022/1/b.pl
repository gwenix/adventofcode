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

my @elves;

my $elf=0;
my $item=0;

while (@lines) {
  my $curr=shift(@lines);
  if ($curr eq '') {
    $elf++;
    $item=0;
  } else {
    $elves[$elf]{item}[$item]=$curr;
    $elves[$elf]{total}+=$curr;
  }
}

my @totals;

foreach my $i (@elves) {
  my $curr = $i->{total};
  push(@totals,$curr);
}

my @maxes = sort {$b <=> $a} @totals;

my $max = $maxes[0] + $maxes[1] + $maxes[2];

print "Max: $max\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

