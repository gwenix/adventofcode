#!/usr/bin/perl

use strict;
use warnings;

my $input = "input";
open (F, "$input") or die "Cannot open $input: $!\n";
my @lines = <F>;
close(F);

my $numlines = @lines;
my $total = 0;
for (my $i=0; $i<$numlines; $i++) {
  my $curr = $lines[$i];
  chomp($curr);
  print "$total + $curr = ";
  $total += $curr;
  print "$total.\n";
}

print "Total: $total\n";
