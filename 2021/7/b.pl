#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
#my $input_file = "test.input";
my $input_file = "input";

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my @crabs = split /,/,$lines[0];

my @fuel;
my $least=0;

my $numcrabs=@crabs;
my $half = int ($numcrabs/2);
my $lee = int( $numcrabs/10);

for(my $pos=$half-$lee;$pos<$half+$lee;$pos++) {
  print "Checking position $pos ";
  my $cost=0;
  for (my $crab=0; $crab<@crabs; $crab++) {
    $cost += FuelCost($crabs[$crab],$pos);
  }
  $fuel[$pos]=$cost;
  if ($least) {
    $least=$pos if ($cost<$fuel[$least]);
  } else {
    $least=$pos;
  }
  print "cost is $cost, least is $fuel[$least]\n";
}

print "\nFuel at $least is $fuel[$least]\n";


exit; 

# ----------- #
# Subroutines #
# ----------- #

sub FuelCost {
  my $c = shift();
  my $p = shift();

  if ($c>$p) {
    my $dummy=$p;
    $p=$c;
    $c=$dummy;
  }
  
  my $cost=0;
  my $move=0;
  for (my $i=$c; $i<$p; $i++) {
    $move++;
    $cost+=$move;
  }

  return $cost;
}
