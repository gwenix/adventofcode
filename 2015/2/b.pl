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

my $total=0;
foreach my $l (@lines) {
  print "$l: ";

  my ($len, $wid, $hei) = split /x/, $l;
  my $ribbon=Ribbon_Length($len,$wid,$hei);

  print "$ribbon\n";

  $total+=$ribbon;
}

print "Total needed: $total\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Area {
  my $len = shift();
  my $wid = shift();

  return 2*$len*$wid;
}

sub Ribbon_Length {
  my $len = shift();
  my $wid = shift();
  my $hgt = shift();

  my ($minA, $minB) = Two_Minimums($len, $wid, $hgt);

  my $rib=2*$minA+2*$minB;

  $rib+=($len*$wid*$hgt);

  return $rib;
}

sub Two_Minimums {
  my @in = @_;
  
  my @out;

  push(@out, pop(@in));
  push(@out, pop(@in));

  if ($out[0]>$out[1]) {
    my $dummy = $out[0];
    $out[0]=$out[1];
    $out[1]=$dummy;
  }

  while (@in) {
    my $curr=pop(@in);
    if ($curr<$out[0]) {
      $out[1]=$out[0];
      $out[0]=$curr;
    } elsif ($curr<$out[1]) {
      $out[1]=$curr;
    }
  }

  return @out;
}
