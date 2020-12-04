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
  my $area=0;
  my $curr;
  
  $curr=Area($len,$wid);
  $area+=$curr;
  my $min = $curr;

  $curr=Area($wid,$hei);
  $area+=$curr;
  $min = $curr if ($min>$curr);

  $curr=Area($len,$hei);
  $area+=$curr;
  $min = $curr if ($min>$curr);

  $area += $min/2;

  print "$area sqft\n";

  $total+=$area;
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
