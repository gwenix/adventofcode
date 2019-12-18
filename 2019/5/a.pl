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
  my $list = Run_Intcode($l);
  #print "$l\n->\n$list\n\n";
}

exit;

# ----------- #
# Subroutines #
# ----------- #

sub Run_Intcode {
  my $list = shift();

  my @pos = split /,/, $list;
  my $curr=0; # current position

  while ($pos[$curr] != 99) {
    my $opcode = $pos[$curr];
    my $a=$pos[$curr+1];
    my $b=$pos[$curr+2];
    my $c=$pos[$curr+3];
    my @mode = (0,0,0);

    # if there are more than 2 digits to opcode, need to parse them
    if ($opcode>99) {
      my @foo = split //, $opcode;
      $opcode = pop(@foo);
      $opcode = (pop(@foo)*10)+$opcode;
      for (my $i=2; $i>=0 && @foo; $i--) {
	$mode[$i] = pop(@foo);
      }
    }
    $a=$pos[$a] unless ($mode[2] || $opcode==3 || $opcode==4);
    $b=$pos[$b] unless ($mode[1] || $opcode==3 || $opcode==4);
    #$c=$pos[$c] unless ($mode[0]); # Always output parameter

    if ($opcode==1) {
      my $result=$a+$b;
      $pos[$c]=$result;
      $curr+=4;
    } elsif ($opcode==2) {
      my $result=$a*$b;
      $pos[$c]=$result;
      $curr+=4;
    } elsif ($opcode==3) {
      print "Input: ";
      my $input=<STDIN>;
      chomp($input);
      print "\n";
      $pos[$a]=$input;
      $curr+=2;
    } elsif ($opcode==4) {
      my $output=$a;
      print "Output: $output\n";
      $curr+=2;
    } else {
      die "Unknown opcode: $opcode\n";
    }
    #$list = join (",", @pos);
    #print "current list: $list\n\tcurrent position: $curr\n";
  }

  $list = join (",", @pos);
  return $list;
}
