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
  print "Testing: $i\t";
  my @digits = split //, $i;

  # six-digit number -- don't have to test because all in range are
  # value within the range -- no test, range given by for loop

  # two adjacent digits are the same -- BUT NOT THREE+
  # a pair must exist, even if triplets or more otherwise
  my $same=0;
  my $j=0;
  while ($j<5) {
    my $curr=$digits[$j];
    my $next=$digits[$j+1];

    if ($curr==$next && !$same) {
      $same=1;
      my $adv=$j+1;
      for(my $k=$j+2; $k<6; $k++) {
	if ($digits[$k]==$curr) {
	  $adv=$k;
	  $same=0;
	}
      }
      $j=$adv;
    } 
    $j++;
  }

  # digits never decrease
  my $increase=1;

  for (my $j=1; $j<@digits; $j++) {
    my $prev=$digits[$j-1];
    my $curr=$digits[$j];
    if ($prev>$curr) {
      $increase=0;
      #print "fails increase check\t";
      $j=@digits; #end the loop
    }
  }
  print "same: $same inc: $increase\t";
  if ($same && $increase) {
    push(@valid, $i);
    print "OK\n";
  } else {
    print "FAIL\n";
  } 
  
}

my $tot=@valid;
print "There are $tot valid passwords.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #
