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

my $curr=$lines[0];
my $total=0;

for(my $i=1; $i<@lines; $i++) {
  my $last = $curr;
  $curr = $lines[$i];

  $total++ if ($curr>$last);
}

print "Total increases: $total\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #
