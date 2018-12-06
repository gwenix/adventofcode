#!/usr/bin/perl

use strict;
#use warnings;

#my $input = "test.input"; my $safedist = 32; # test line
my $input = "input"; my $safedist = 10000; # prod line

open (F, "$input") or die "Cannot open $input: $!\n";
my @lines = <F>;
close(F);

my @points;
my %outerlimits;
my @syms = @{ ["a".."z","A".."Z","0".."9"] };

# Initialize the coordinates
for(my $i=0; $i<@lines; $i++) {
  my $l = $lines[$i];
  chomp($l);
  my %coordinates;
  my ($x, $y) = split /,/, $l;
  ($coordinates{x}, $coordinates{y}) = ($x, $y);
  $coordinates{sym}=$syms[$i];
  
  push (@points, \%coordinates);

  $outerlimits{minX}=$x if (!$outerlimits{minX} || $x<$outerlimits{minX});
  $outerlimits{maxX}=$x if (!$outerlimits{maxX} || $x>$outerlimits{maxX});
  $outerlimits{minY}=$y if (!$outerlimits{minY} || $y<$outerlimits{minY});
  $outerlimits{maxY}=$y if (!$outerlimits{maxY} || $y>$outerlimits{maxY});
}

my @grid;
my $safearea=0;
# check each point in a grid; only need to check as far as the outermost points
for(my $i=$outerlimits{minX}; $i<=$outerlimits{maxX}; $i++) {
  for(my $j=$outerlimits{minY}; $j<=$outerlimits{maxY}; $j++) {
    my $dist = 0;
    for(my $p=0; $p<@points; $p++) {
      my $x = $points[$p]{x};
      my $y = $points[$p]{y};
      $dist += Distance($x,$y,$i,$j);
    }
    #print "($i, $j): $dist\n";
    $grid[$i][$j]=1;
    $grid[$i][$j]=0 if ($dist>=$safedist);
    $safearea++ if ($grid[$i][$j]);
  }
}


#PrintGrid(\%outerlimits, @grid);

print "Safe area: $safearea\n";

################################################################################
# 				Subroutines				       #
################################################################################

sub PrintGrid {
  my %outerlimits = %{ shift() };
  my @grid = @_;

  print "\nGrid is ($outerlimits{minX},$outerlimits{minY}), ";
  print "($outerlimits{maxX},$outerlimits{maxY})\n";
  for(my $i=$outerlimits{minX}; $i<=$outerlimits{maxX}; $i++) {
    for(my $j=$outerlimits{minY}; $j<=$outerlimits{maxY}; $j++) {
      if ($grid[$i][$j]) {
	print "S";
      } else {
	print ".";
      } 
    }
    print "\n";
  }
}

sub OnEdge {
  my %outer = %{ shift() };
  my ($x, $y) = @_;

  return 1 if ($x<=$outer{minX});
  return 1 if ($x>=$outer{maxX});
  return 1 if ($y<=$outer{minY});
  return 1 if ($y>=$outer{maxY});

  return 0;
}

sub Distance {
  my ($x1, $y1, $x2, $y2) = @_;

  my $dist = abs($x2-$x1) + abs($y2-$y1);

  return $dist;
}
