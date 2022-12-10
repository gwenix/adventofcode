#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

our @sigs;
our $regX=1;
# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my $cycle=1;

for(my $i=0; $i<@lines; $i++) {
  my $l = $lines[$i];
  #print "checking $l... ";
  my ($inst,$val)=split / /, $l;
  
  if ($inst eq 'noop') {
    CheckSignal($cycle);
    $cycle++;
  } elsif ($inst eq 'addx') {
    CheckSignal($cycle);
    $cycle++;
    CheckSignal($cycle);
    $cycle++;
    $regX+=$val;
  } else {
    die "unknown instruction $inst\n";
  }

  #print "cycle $cycle, X: $regX\n";
}

my $score = Score();

print "Total score: $score\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Score {
  my $tot=0;
  $tot+=$sigs[0]*20;
  $tot+=$sigs[1]*60;
  $tot+=$sigs[2]*100;
  $tot+=$sigs[3]*140;
  $tot+=$sigs[4]*180;
  $tot+=$sigs[5]*220;

  return $tot;
}

sub CheckSignal {
  my $cyc = shift();

  if ($cyc==20 || $cyc==60 || $cyc==100 || $cyc==140 || $cyc==180 || $cyc==220) {
    push(@sigs, $regX);
  }
}
