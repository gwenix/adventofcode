#!/usr/bin/perl

use strict;
#use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

my $packet;
my $start;
# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

foreach my $l (@lines) {
  print "Looking at $l\n";
  ($packet,$start) = FindStartPacket($l);
  print "Packet $packet found at $start position.\n";
}

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub FindStartPacket {
  my $stream = shift();

  my $packet;

  my @charr = split //, $stream;
  my $found=0;

  #print Dumper(@charr);

  for(my $i=13; $i<@charr && !$found; $i++) {
    my $dupfound=0;
    my %dup;
    my $currp;
    for(my $j=$i-13; $j<=$i; $j++) {
      $dupfound=1 if ($dup{$charr[$j]});
      $dup{$charr[$j]}=1;
      $currp.=$charr[$j];
    }
    
    #print "DEBUG: checking $currp at $i\n";
    $found=$i unless ($dupfound);
    $packet=$currp;
  }

  return ($packet,$found+1);
}
