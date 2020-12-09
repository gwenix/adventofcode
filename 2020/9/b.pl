#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";
my $seed=shift();
die "Usage: $0 [num]\n" unless ($seed);

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my $result = Decrypt($seed, @lines);

print "Result: $result\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Decrypt {
  my $seed = shift();
  my @nums = @_;
  my $result = "NOT FOUND";

  while (@nums) {
    my $valid=0;
    my @set;
    my $curr=shift(@nums);
    push (@set, $curr);
    for(my $i=0; $i<@nums; $i++) {
      push (@set, $nums[$i]);
      $curr+=$nums[$i];
      if($curr == $seed) {
	$valid=1;
	$i=@nums;
      }
    }
    if ($valid) {
      my ($a, $b) = MaxMin(@set);
      $result=$a+$b;
      return $result;
    }
  }

  return $result;
}

sub MaxMin {
  my @arr = @_;

  my $mx = 0;
  my $mn = $arr[0];

  foreach my $curr (@arr) {
    $mx = $curr if ($mx<$curr);
    $mn = $curr if ($mn>$curr);
  }

  return ($mn, $mx);
}
