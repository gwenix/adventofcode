#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

our @rope;
our %grid;

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

#initializing
for (my $i=0; $i<10; $i++) {
  $rope[$i][0]=0;
  $rope[$i][1]=0;
}

$grid{0}{0}{tvisit}=1;

for (my $i=0; $i<@lines; $i++) {
  MoveHead($lines[$i]);
}

my $tot = CountVisited();

print "Tail has visited $tot spaces.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub CountVisited {
  my $count=0;
  foreach my $x (keys %grid) {
    foreach my $y (keys %{ $grid{$x} }) {
      $count++ if ($grid{$x}{$y}{tvisit});
    }
  }
  return $count;
}

sub CurrPositions {
  print "Head is at ($rope[0][0],$rope[0][1]).";
  print " end tail is at ($rope[9][0],$rope[9][1]).\n";
}

sub MoveHead {
  my $l = shift();

  my ($dir,$num) = split / /, $l;

  for (my $i=0; $i<$num; $i++) {
    if ($dir eq 'R') {
      $rope[0][1]++;
    } elsif ($dir eq 'L') {
      $rope[0][1]--;
    } elsif ($dir eq 'U') {
      $rope[0][0]++;
    } elsif ($dir eq 'D') {
      $rope[0][0]--;
    } else {
      die "invalid dir: $dir\n";
    } 
    for (my $j=1; $j<10; $j++) {
      my @foo=MoveTail($rope[$j-1][0],$rope[$j-1][1],$rope[$j][0],$rope[$j][1]);
      $rope[$j][0]=$foo[0];
      $rope[$j][1]=$foo[1];
      $grid{$rope[$j][0]}{$rope[$j][1]}{tvisit}=1 if ($j==9);;
    }
  }
  CurrPositions();
}

sub MoveTail {
  my @prev = ($_[0],$_[1]);
  my @next = ($_[2],$_[3]);
  
  print "Checking ($prev[0],$prev[1]) ($next[0],$next[1])..";

  # diagonals first
  if (   $prev[0]>$next[0]+1 && $prev[1]>$next[1]
      || $prev[0]>$next[0] && $prev[1]>$next[1]+1
     ) {
    $next[0]++;
    $next[1]++;
  }
  if (   $prev[0]>$next[0]+1 && $prev[1]<$next[1]
           || $prev[0]>$next[0] && $prev[1]<$next[1]-1
	  ) {
    $next[0]++;
    $next[1]--;
  }
  if (   $prev[0]<$next[0]-1 && $prev[1]>$next[1]
           || $prev[0]<$next[0] && $prev[1]>$next[1]+1
	  ) {
    $next[0]--;
    $next[1]++;
  }
  if (  $prev[0]<$next[0]-1 && $prev[1]<$next[1]
	  || $prev[0]<$next[0] && $prev[1]<$next[1]-1
	  ) {
    $next[0]--;
    $next[1]--;
  }
  $next[0]++ if ($prev[0]>$next[0]+1);
  $next[1]++ if ($prev[1]>$next[1]+1);
  $next[0]-- if ($prev[0]<$next[0]-1);
  $next[1]-- if ($prev[1]<$next[1]-1);

  print " to ($prev[0],$prev[1]) ($next[0],$next[1])\n";

  return @next;
}
