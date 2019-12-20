#!/usr/bin/perl

use strict;
use warnings;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

my $len = 25;
my $num = 6;

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my @layer;

# Really, there's just one line:
my @char = split //, $lines[0];

my $l=0;
my $s=0;

my $result;
my $least=@char;

while (@char) {
  my @curr;
  my ($zeros, $ones, $twos) = (0,0,0);
  for(my $n=0; $n<$num; $n++) {
    my $str;
    for(my $l=0; $l<$len; $l++) {
      die "How'd I run out of characters?\n" unless (@char);
      my $digit=shift(@char);
      #print "position $n, $l\n";
      $str .= $digit;
      if ($digit==0) {
	$zeros++;
      } elsif ($digit==1) {
	$ones++;
      } elsif ($digit==2) {
	$twos++;
      }
    }
    push(@curr, $str);
  }
  if ($zeros<$least) {
    $result=$ones*$twos;
    print "$zeros < $least\n";
    $least=$zeros;
    print "$zeros < $least\n";
  }
  push(@layer, \@curr);
}

Print_Layers(@layer);

print "Result: $result\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Print_Layers {
  my @lay = @_;

  for(my $layer=0; $layer<@lay; $layer++) {
    print "LAYER $layer\n";
    print "----------\n";
    my @image = @{ $lay[$layer] };
    for(my $i=0; $i<@image; $i++) {
      print "\t$image[$i]\n";
    }
  }
}
