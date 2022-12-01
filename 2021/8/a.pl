#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

our %digits = (
  0 => 6,
  1 => 2, 
  2 => 5,
  3 => 5,
  4 => 4,
  5 => 5,
  6 => 6,
  7 => 3,
  8 => 7,
  9 => 6
);

our %unique = (
  2 => 1,
  4 => 4,
  3 => 7,
  7 => 8
);

our %multiple = (
  6 => [0,6,9],
  5 => [2,3,5]
);

# ------ #
# Arby's #
# ------ #

my @signals;

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my $total=0;
for (my $i=0; $i<@lines; $i++) {
  my ($in,$out) = split / \| /, $lines[$i];
  $signals[$i]{in}=$in;
  $signals[$i]{out}=$out;

  $total += Count($out);
}

print "$total matches.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Count {
  my $in = shift();
  my $out=0;

  my @words = split / /, $in;
  foreach my $w (@words) {
    $out++ if (Matches($w));
  }
  
  return $out;
}

sub Matches {
  my $in = shift();
  my %data;

  my @ch = split //, $in;

  foreach my $c (@ch) {
    $data{$c}=1;
  }

  my $length = keys %data;

  return 1 if ($unique{$length});

  return 0;
}


