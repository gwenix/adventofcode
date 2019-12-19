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

my %grid;
$grid{smX}=0;
$grid{smY}=0;
$grid{lgX}=0;
$grid{lgY}=0;
my $least_dist=0;

for (my $i=0; $i<@lines; $i++) {
  my $wire = $i+1;
  print "New Wire: $wire\n";
  print "------------\n";
  my ($x, $y) = (0, 0);
  $grid{$x}{$y}="O";

  my @dir = split /,/, $lines[$i];
  for (my $j=0; $j<@dir; $j++) {
    my $d = $dir[$j];
    #print "$d -- \t";

    my @foo = split //, $d;
    my $ch = shift @foo;
    $d = join '', @foo;

    for ($a=0; $a<$d; $a++) {
      if ($ch eq "U") {
	$y++;
      } elsif ($ch eq "R") {
	$x++;
      } elsif ($ch eq "D") {
	$y--;
      } elsif ($ch eq "L") {
	$x--;
      } else {
        die "Unknown direction: $ch\n";
      }
      if ($grid{$x}{$y} && $grid{$x}{$y}!=$wire) {
	$grid{$x}{$y}="X";
	my $dist = abs($x) + abs ($y);
	$least_dist=$dist if ($dist<$least_dist || $least_dist==0);
	print "X $x, $y, dist $dist; Least: $least_dist\n";
      } else {
	$grid{$x}{$y}=$wire;
      }

      $grid{smX}=$x if ($x<$grid{smX} || $grid{smX}==0);
      $grid{smY}=$y if ($y<$grid{smY} || $grid{smY}==0);
      $grid{lgX}=$x if ($x>$grid{lgX} || $grid{lgX}==0);
      $grid{lgY}=$y if ($y>$grid{lgY} || $grid{lgY}==0);
    }
    #print "Now at $x, $y\n";
  }
}

#Print_Grid(\%grid);

#print "First crossing: $least_dist\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Print_Grid {
  my %grid = %{shift()};

  print "Dimensions: $grid{smX} - $grid{lgX}, $grid{smY} - $grid{lgY}\n";
  for (my $j=$grid{lgY}; $j>=$grid{smY}; $j--) {
    for (my $i=0-$grid{smX}; $i<=$grid{lgX}; $i++) {
      my $pt = ".";
      $pt = $grid{$i}{$j} if ($grid{$i}{$j});
      print "$pt";
    }
    print "\n";
  }
}
