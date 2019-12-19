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

my %orbit;
my ($me, $santa);

# setting up the data
foreach my $l (@lines) {
  my ($a, $b) = split /\)/, $l;

  if ($b eq "YOU") {
    $me=$a;
  } elsif ($b eq "SAN") {
    $santa=$a;
  } else {
    $orbit{$b}=$a;
  }
}

# find santa!!!
my $santa_move=0;
my $me_move;
my $found=0;
my $curr_san=$santa;
my $curr_me;
while ($orbit{$curr_san} && !$found) {
  print "Santa at: $curr_san\n";
  $curr_me=$me;
  $me_move=0;
  while ($orbit{$curr_me} && !$found) {
    print "\tI'm at $curr_me\n";
    if ($curr_me eq $curr_san) {
      $found=1;
      print "FOUND SANTA: $curr_me $curr_san\n";
    } else {
      $curr_me=$orbit{$curr_me};
      $me_move++;
    }
  }
  if (!$found) {
    $curr_san=$orbit{$curr_san};
    $santa_move++;
  }
}
if ($found ) {
  my $total = $santa_move+$me_move;
  print "Total moves: $santa_move + $me_move = $total\n";
} else {
  print "Oh no! I couldn't find Santa!\n";
}

exit; 

# ----------- #
# Subroutines #
# ----------- #
