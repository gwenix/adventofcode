#!/usr/bin/perl

use strict;
#use warnings;
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

my $oxy = oct("0b" . GetOxygen(0,@lines));
my $co2 = oct("0b" . GetCO2(0,@lines));

my $tot=$oxy*$co2;

print "Total: $tot\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub GetOxygen {
  my $pos = shift();
  my @arr = @_;
  my @newarr;

  my $length = @arr;
  return $arr[0] if ($length==1);

  my $maj = FindMajAtPos($pos, @arr);
  foreach my $a (@arr) {
    my @ch = split //, $a;
    die "Exceeds number of elements: $pos\n" if ($pos > @ch);
    if ($ch[$pos]==$maj) {
      push(@newarr, $a);
    }
  }

  $pos++;
  return GetOxygen($pos, @newarr);
}

sub GetCO2 {
  my $pos = shift();
  my @arr = @_;
  my @newarr;

  my $length = @arr;
  return $arr[0] if ($length==1);

  my $maj = FindMajAtPos($pos, @arr);
  foreach my $a (@arr) {
    my @ch = split //, $a;
    die "Exceeds number of elements: $pos\n" if ($pos > @ch);
    if ($ch[$pos]!=$maj) {
      push(@newarr, $a);
    }
  }

  $pos++;
  return GetCO2($pos, @newarr);
}

sub FindMajAtPos {
  my $pos = shift();
  my @arr = @_;
  my $out;

  foreach my $i (@arr) {
    my @ch = split //, $i;
    $out .= $ch[$pos];
  }

  return CheckMaj($out);
}

sub CheckMaj {
  my $in = shift();

  my @bin;
  my @arr = split //, $in;
  foreach my $i (@arr) {
    if ($i) {
      $bin[1]++;
    } else {
      $bin[0]++;
    }
  }
  return 1 if ($bin[1]>=$bin[0]);
  return 0;
}
