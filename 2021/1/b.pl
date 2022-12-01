#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

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
my $curr=0;

for(my $i=2; $i<@lines; $i++) {
  my $last=$curr;
  $curr = $lines[$i] + $lines[$i-1] + $lines[$i-2];

  $total++ if ($curr>$last && $last>0);
}

print "Total increases: $total\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #
