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
  my $list = Run_Program($l);
  print "$l\n->\n$list\n\n";
}

exit;

# ----------- #
# Subroutines #
# ----------- #

sub Run_Program {
  my $list = shift();

  my @pos = split /,/, $list;
  my $curr=0; # current position

  while ($pos[$curr] != 99) {
    my $opcode = $pos[$curr];
    if ($opcode==1) {
      my $a=$pos[$curr+1];
      my $b=$pos[$curr+2];
      my $c=$pos[$curr+3];
      my $result=$pos[$a]+$pos[$b];
      $pos[$c]=$result;
      $curr+=4;
    } elsif ($opcode==2) {
      my $a=$pos[$curr+1];
      my $b=$pos[$curr+2];
      my $c=$pos[$curr+3];
      my $result=$pos[$a]*$pos[$b];
      $pos[$c]=$result;
      $curr+=4;
    } else {
      die "Unknown opcode: $opcode\n";
    }
    #$list = join (",", @pos);
    #print "current list: $list\n\tcurrent position: $curr\n";
  }

  $list = join (",", @pos);
  return $list;
}
