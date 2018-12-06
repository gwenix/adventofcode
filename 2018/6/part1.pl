#!/usr/bin/perl

use strict;
#use warnings;

#my $input = "test.input";
my $input = "input";
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


my @dist;
for (my $i=0; $i<@points; $i++) {
  $dist[$i]=0;
}

my @grid;
# check each point in a grid; only need to check as far as the outermost points
for(my $i=$outerlimits{minX}; $i<=$outerlimits{maxX}; $i++) {
  for(my $j=$outerlimits{minY}; $j<=$outerlimits{maxY}; $j++) {
    # is one point the closest?
    my $short=0;
    my $whichpoint;
    my $thispoint=0;
    for(my $p=0; $p<@points; $p++) {
      my ($x, $y) = ($points[$p]{x}, $points[$p]{y});
      my $currdist = Distance($x, $y, $i, $j);
      if ($currdist == 0) {
	$whichpoint=$p;
        $thispoint=1;
        $p=@points; # end the loop, found it
      } elsif ($short==0 || $short>$currdist) {
	$short=$currdist;
	$whichpoint=$p;
      } elsif ($short == $currdist) {
	$whichpoint=".";
      }
    }
    
    if ($whichpoint eq ".") {
      # no op
    } elsif (OnEdge(\%outerlimits, $i, $j)) {
      $dist[$whichpoint] = "infinite";
    } elsif ($dist[$whichpoint] eq "infinite") { 
      # no op
    } else {
      $dist[$whichpoint]++;
    }
    if ($thispoint) {
      #print "Adding *\n";
      $grid[$i][$j]="*";
    } else {
      #print "Adding $whichpoint\n";
      if ($whichpoint eq ".") {
	$grid[$i][$j]=".";
      } else {
	$grid[$i][$j]=$points[$whichpoint]{sym};
      }
    }
  }
}

my $maxarea=0;
for (my $i=0; $i<@dist; $i++) {
  my $d=$dist[$i];
  print "$points[$i]{sym} Area: $d\n";
  $maxarea=$d if ($d>$maxarea && $d ne "infinite");
}

print "Max area is $maxarea\n";

#PrintGrid(\%outerlimits, @grid);


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
      print "$grid[$i][$j]";
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
