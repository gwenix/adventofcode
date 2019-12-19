#!/usr/bin/perl

use strict;
use warnings;

# ------------- #
# Configuration #
# ------------- #
#my $input_file = "input";

my $range_start=171309;
my $range_end=643603;

# ------ #
# Arby's #
# ------ #

#open (F, $input_file) or die "Cannot open $input_file: $!\n";
#my @lines = <F>;
#chomp @lines;
#close (F);

my @valid;

for (my $i=$range_start; $i<=$range_end; $i++) {
  my @digits = split //, $i;

  # six-digit number -- don't have to test because all in range are
  # value within the range -- no test, range given by for loop

  # two adjacent digits are the same
  my $same=0;
  # digits never decrease
  my $increase=1;

  for (my $j=1; $j<@digits; $j++) {
    my $prev=$digits[$j-1];
    my $curr=$digits[$j];
    $same=1 if ($prev==$curr);
    if ($prev>$curr) {
      $increase=0;
      $j=@digits; #end the loop
    }
  }
  push(@valid, $i) if ($same && $increase);
  
}

my $tot=@valid;
print "There are $tot valid passwords.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #
