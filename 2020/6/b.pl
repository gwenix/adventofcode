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

my $grpcnt=0;
my @groups;

my $anscnt=0;

for(my $i=0; $i<@lines; $i++) {
  my $l=$lines[$i];

  if (hasNoChars($l)) {
    $grpcnt++;
  } else {
    my @ch=split //, $l;
    foreach my $c (@ch) {
      $groups[$grpcnt]{ans}{$c}++;
    }
    $groups[$grpcnt]{size}++;
  }
}

for(my $i=0; $i<@groups; $i++) {
  my %grp = %{ $groups[$i] };
  my $sz = $grp{size};

  foreach my $ans (keys %{ $grp{ans} }) {
    my $yescnt=$grp{ans}{$ans};
    $anscnt++ if ($yescnt==$sz);
  }
}

print "Total: $anscnt\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub hasNoChars {
  my $str=shift();

  return 1 if($str=~m/^\s*$/);
  
  return 0;
}
