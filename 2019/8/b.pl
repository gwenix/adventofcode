#!/usr/bin/perl

use strict;
use warnings;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

my $len = 25;
my $num = 6;
#my $len = 2;
#my $num = 2;

# ------ #
# Arby's #
# ------ #

my %image;

$image{y}=$len;
$image{x}=$num;

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

# Really, there's just one line:
my @char = split //, $lines[0];

# Building the image
while (@char) {
  my @curr;
  for(my $i=0; $i<$image{x}; $i++) {
    for(my $j=0; $j<$image{y}; $j++) {
      die "How'd I run out of characters?\n" unless (@char);
      my $digit=shift(@char);
      $image{$i}{$j}{value}=$digit unless ($image{$i}{$j}{set});
      $image{$i}{$j}{set}=1 unless ($digit==2);
    }
  }
}

Print_Image(\%image);

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Print_Image {
  my %image = %{ shift() };

  for (my $i=0; $i<$image{x}; $i++) {
    for (my $j=0; $j<$image{y}; $j++) {
      my $curr = " ";
      $curr="*" if ($image{$i}{$j}{value});
      print "$curr";
    }
    print "\n";
  }
  print "\n";
}
