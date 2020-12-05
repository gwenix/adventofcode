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

foreach my $l (@lines) {
  my ($map1, $map2);

  my @ch = split //, $l;
  for (my $i=0; $i<@ch; $i++) {
    if ($i%2) {
      $map1 .= $ch[$i];
    } else {
      $map2 .= $ch[$i];
    }
  }
  my %path = %{ HousePath($map1) };
  my %tmp = %{ HousePath($map2) };

  #merge the hashes
  foreach my $x (keys %tmp) {
    foreach my $y (keys %{ $tmp{$x} } ) {
      $path{$x}{$y}++;
    }
  }
  undef %tmp;

  my $total = HouseCount(\%path);

  print "$total houses were visited.\n";
}


exit; 

# ----------- #
# Subroutines #
# ----------- #

sub HousePath {
  my $map = shift();
  my %house;
  my ($x, $y) = (0,0);

  #print "Map: $map\n";

  my @dirs = split //, $map;

  $house{$x}{$y}=1;
  for (my $i=0; $i<@dirs; $i++) {
    my $curr=$dirs[$i];
    if ($curr eq "^") {
      $y++;
    } elsif ($curr eq "v") {
      $y--;
    } elsif ($curr eq ">") {
      $x++;
    } elsif ($curr eq "<") {
      $x--;
    } else {
      die "Error: Invalid char: $curr\n";
    }

    $house{$x}{$y}++;
  }

  return \%house;
}

sub HouseCount {
  my %h = %{ shift() };

  my $tot=0;
  my @xes = keys %h;

  foreach my $x (@xes) {
    my @yes = keys %{ $h{$x} };
    $tot += @yes;
  }

  return $tot;
}
