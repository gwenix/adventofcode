#!/usr/bin/perl

use strict;
use warnings;

my $input = "input";
open (F, "$input") or die "Cannot open $input: $!\n";
my @lines = <F>;
close(F);

my $polymer = $lines[0]; # only one line in the file
chomp($polymer);

my @units = split //, $polymer;

my $stop=0;
while (!$stop) {
  my $matchfound=0;
  my $lastunit = @units;
  for (my $i=$lastunit-1; $i>0; $i--) {
    my $a=$units[$i];
    my $b=$units[$i-1];

    my $lowerA=lc($a);
    my $lowerB=lc($b);

    if($lowerA eq $lowerB && $a ne $b) {
      $i--;
      splice(@units, $i, 2);
      $matchfound=1;
    }
  }
  $stop=1 unless($matchfound); # keep checking until no match is found.
  my $count = @units;
  print "There are $count units left.\n";
}

print "Done.\n";

