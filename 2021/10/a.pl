#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";
my %scoring = ( ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 );

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);


foreach my $l (@lines) {
  my %data;
  my @ch = split //, $l;

  foreach my $c (@ch) {
    $data{$c}++;
  }

  # Checking ()
  if ($data{')'}>$data{'('} {
    
  }
  # Checking []
  # Checking {}
  # Checking <>
}

exit; 

# ----------- #
# Subroutines #
# ----------- #
