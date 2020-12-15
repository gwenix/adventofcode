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

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

while (@lines) {
  Play(shift(@lines));
}

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Play {
  my $str=shift();

  print "Checking $str\n";

  my @start = split /,/, $str;

  my %list;
  my $i=1;

  #initialize Turns
  while (@start) {
    my $num=shift(@start);
    PrintTurn($i,$num);
    $list{$num}=$i;
    $i++
  }

  my $num=0;
  my $done=0;

  while ($i<30000000) {
    PrintTurn($i,$num) if ($i%1000000 == 0);
    if ( $list{$num} ) {
      my $last=$num;
      $num = $i - $list{$last};
      $list{$last}=$i
    } else {
      $list{$num}=$i;
      $num = 0;
    }
    $i++;
  }

  PrintLine();
  print "Final number: $num\n";
  PrintLine();
  
}

sub PrintLine {
  for (my $i=0; $i<80; $i++) {
     print "#";
  }
  print "\n";
}

sub Debug {
  my ($num, $last) = @_;

  if ($last) {
    print "\t$num last seen $last\n";
  } else {
    print "\t$num not yet seen\n";
  }
}

sub PrintTurn {
  my $turn = shift();
  my $num = shift();
  

  print "Turn $turn: $num\n";
}
