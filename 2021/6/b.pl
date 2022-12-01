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

my $days=256;

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my $total=0;
my @fish=split /,/,$lines[0];
our %data;

foreach my $fish (@fish) {
  print "Fish: $fish\t";
  if ($data{$fish}{256}) {
    $total+=$data{$fish}{256};
  } else {
    my $sub=BreedAFish ($fish,$days,1);
    $total+=$sub;
    $data{$fish}{256}=$sub;
  }
  print "Total: $total\n";
}

print "\nThere are $total fish.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub BreedAFish {
  my $curr=shift();
  my $daysleft=shift();
  my $total=shift();

  while ($daysleft) {
    if ($curr>$daysleft) {
      $daysleft=0;
    } elsif ($curr==0) {
      $curr=7;
      if ($data{$curr}{$daysleft}) {
	$total+=$data{$curr}{$daysleft};
      } else {
	my $sub = BreedAFish(9,$daysleft,1);
	$data{$curr}{$daysleft}=$sub;
	$total+=$sub;
      }
    } else {
      $daysleft-=$curr;
      $curr=0;
    }
  }
  return $total;
}
