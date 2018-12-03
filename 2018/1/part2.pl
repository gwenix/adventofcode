#!/usr/bin/perl

use strict;

my $input = "input";
open (F, "$input") or die "Cannot open $input: $!\n";
my @lines = <F>;
close(F);

my $numlines = @lines;
my $total = 0;
my %freq; $freq{0}=1;
my $stop = 0;
my $i = 0;
my $twice;
while (!$stop) {
  my $curr = $lines[$i];
  chomp($curr);
  print "$total + $curr = ";
  $total += $curr;
  print "$total.\n";
  if ($freq{$total}) {
    $stop=1;
    $twice=$total;
  }
  $freq{$total}++;
  $i++;
  $i=0 if ($i>=$numlines);
}

print "Seen twice: $twice\n";
