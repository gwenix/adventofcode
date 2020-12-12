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

my @plugs = sort {$a <=> $b} @lines;

my $last = 0;
my %diffs;

for(my $i=0; $i<@plugs; $i++) {
  my $diff = $plugs[$i]-$last;
  die "Can't plug this in: $plugs[$i] at $diff\n" if ($diff>3);

  $diffs{$diff}++;
  $last=$plugs[$i];
}

$diffs{3}++;

my $result = $diffs{1}*$diffs{3};

print "Result: $result\n";
exit; 

# ----------- #
# Subroutines #
# ----------- #
