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

my ($gamma, $epsilon);

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my @data;
foreach my $num (@lines) {
  my @arr = split //, $num;
  if (@data) {
     for (my $i=0; $i<@arr; $i++) {
       $data[$i] .= $arr[$i];
     }
  } else {
    @data=@arr;
  }
}

for (my $i=0; $i<@data; $i++) {
  if (CheckMaj($data[$i])) { # if the majority are 1s
    $gamma .= 1;
    $epsilon .= 0;
  } else {
    $gamma .= 0;
    $epsilon .= 1;
  }
}

$gamma = oct("0b" . $gamma);
$epsilon = oct("0b" . $epsilon);

print "Gamma: $gamma Epsilon: $epsilon Total: ";
my $total = $gamma*$epsilon;
print "$total\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

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
  return 1 if ($bin[1]>$bin[0]);
  return 0;
}
