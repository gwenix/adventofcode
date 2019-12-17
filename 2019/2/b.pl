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

my $base_list = $lines[0];
my $needed=19690720;
my $output=0;
my $noun=-1;
my $verb=-1;

while ($output!=$needed && $noun<1000) {
  $noun++;
  $verb=-1;
  while ($output!=$needed && $verb<1000) {
    $verb++;
    my $list=$base_list;
    $list =~ s/NOUN/$noun/; 
    $list =~ s/VERB/$verb/; 
    $list=Run_Program($list);
    if ($list) {
      my @fields = split /,/, $list;
      $output=$fields[0];
  
      print "$noun and $verb: $output\n";
    }
  }
}

print "Final output: $noun, $verb\n";

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
      return 0 if ($a>@pos || $b>@pos);
      my $result=$pos[$a]+$pos[$b];
      $pos[$c]=$result;
      $curr+=4;
    } elsif ($opcode==2) {
      my $a=$pos[$curr+1];
      my $b=$pos[$curr+2];
      my $c=$pos[$curr+3];
      return 0 if ($a>@pos || $b>@pos);
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
