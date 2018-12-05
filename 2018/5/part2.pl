#!/usr/bin/perl

use strict;
use warnings;

my $input = "input";
open (F, "$input") or die "Cannot open $input: $!\n";
my @lines = <F>;
close(F);

my $polymer = $lines[0]; # only one line in the file
chomp($polymer);

my $minchain=-1;

foreach my $type ("a".."z") {
  print "Checking: $type... ";
  my $testmer = RemoveUnit($polymer, $type);
  $testmer = React($testmer);
  my $count = CountPolymer($testmer);

  print "$count:\n";
  if($minchain==-1 || $count<$minchain) {
    $minchain=$count;
  }
}

print "Minimum chain: $minchain\n";



################################################################################
# 				Subroutines				       #
################################################################################

sub CountPolymer {
  my $polymer = shift();

  my @units = split //, $polymer;

  my $count = @units;

  return $count;
}

sub RemoveUnit {
  my $polymer = shift();
  my $type = shift();

  my @units = split //, $polymer;
  my $last = @units;
  
  for(my $i=$last-1; $i>=0; $i--) {
    my $ch = lc($units[$i]);
    if ($ch eq $type) {
      splice(@units, $i, 1);
    }
  }
  $polymer = join ("", @units);

  return $polymer;
}

sub React {
  my $polymer = shift();
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
  }

  $polymer = join ("", @units);
  return $polymer;
}
