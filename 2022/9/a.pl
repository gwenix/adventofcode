#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

our @head = (0,0);
our @tail = (0,0);
our %grid;

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

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
  print "Head is at ($head[0],$head[1]).";
  print " Tail is at ($tail[0],$tail[1]).\n";
}

sub MoveHead {
  my $l = shift();

  my ($dir,$num) = split / /, $l;

  for (my $i=0; $i<$num; $i++) {
    if ($dir eq 'R') {
      $head[1]++;
    } elsif ($dir eq 'L') {
      $head[1]--;
    } elsif ($dir eq 'U') {
      $head[0]++;
    } elsif ($dir eq 'D') {
      $head[0]--;
    } else {
      die "invalid dir: $dir\n";
    } 
    MoveTail();
  }
  CurrPositions();
}

sub MoveTail {

  # diagonals first
  if (   $head[0]>$tail[0]+1 && $head[1]>$tail[1]
      || $head[0]>$tail[0] && $head[1]>$tail[1]+1
     ) {
    $tail[0]++;
    $tail[1]++;
  }
  if (   $head[0]>$tail[0]+1 && $head[1]<$tail[1]
           || $head[0]>$tail[0] && $head[1]<$tail[1]-1
	  ) {
    $tail[0]++;
    $tail[1]--;
  }
  if (   $head[0]<$tail[0]-1 && $head[1]>$tail[1]
           || $head[0]<$tail[0] && $head[1]>$tail[1]+1
	  ) {
    $tail[0]--;
    $tail[1]++;
  }
  if (  $head[0]<$tail[0]-1 && $head[1]<$tail[1]
	  || $head[0]<$tail[0] && $head[1]<$tail[1]-1
	  ) {
    $tail[0]--;
    $tail[1]--;
  }
  $tail[0]++ if ($head[0]>$tail[0]+1);
  $tail[1]++ if ($head[1]>$tail[1]+1);
  $tail[0]-- if ($head[0]<$tail[0]-1);
  $tail[1]-- if ($head[1]<$tail[1]-1);

  $grid{$tail[0]}{$tail[1]}{tvisit}=1;
}
