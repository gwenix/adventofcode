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

my $pw_pass=0;

foreach my $l (@lines) {
  my ($rule,$pw) = split /:/,$l;
  $pw =~ s/^ //;

  #print "Rule: $rule, Password: $pw\n";

  my ($range,$ch) = split / /, $rule;
  my ($lo,$hi) = split /-/, $range;

  my %check;

  my @chars = split //, $pw;

  foreach (@chars) {
    $check{$_}++;
  }

  $pw_pass++ if ($check{$ch}>=$lo && $check{$ch}<=$hi);
}

print "There are $pw_pass correct passwords.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #
