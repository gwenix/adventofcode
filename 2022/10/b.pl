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
our @pixels;
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

PrintPixels();

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub PrintPixels {
  for (my $i=0; $i<@pixels; $i++) {
    print "\n" if ($i%40==0);
    print $pixels[$i];
  }
  print "\n";
}

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
  my $pix='.';

  my $curr = ($cyc-1)%40;
  print "DEBUG: Cycle $cycle, position $curr, X at $regX\n";
  $pix='#' if ($curr >= $regX-1 && $curr <=$regX+1);
  push(@pixels, $pix);
}
