#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";
my $prelen=shift();
die "Usage: $0 [num]\n" unless ($prelen);

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

for(my $i=$prelen; $i<@lines; $i++) {
  my $curr = $lines[$i];
  my $valid=0;
  for (my $j=$i-$prelen; $j<$i-1; $j++) {
    #print "At $curr: \n";
    for(my $k=$j+1; $k<$i; $k++) {
      my $a=$lines[$j];
      my $b=$lines[$k];
      if ($a+$b == $curr) {
	$valid=1;
	$k=$i;
        $j=$i;
      }
      #print "\t$a + $b: $valid\n";
    }
  }
  die "Found: $curr\n" unless ($valid);
}

exit; 

# ----------- #
# Subroutines #
# ----------- #
