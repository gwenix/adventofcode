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
my $least_dist=0;

for (my $i=0; $i<@lines; $i++) {
  my ($x, $y) = (0, 0);
  $grid{$x}{$y}=1;

  my @dir = split /,/, $lines[$i];
  for (my $j=0; $j<@dir; $j++) {
    my $d = $dir[$j];

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
      if ($grid{$x}{$y}) {
	my $dist = abs($x) + abs ($y);
	$least_dist=$dist if ($dist<$least_dist || $least_dist==0);
      } else {
	$grid{$x}{$y}=1;
      }

      $grid{size}=$x if ($x>$grid{size});
      $grid{size}=$y if ($y>$grid{size});
    }
  }
}

Print_Grid(\%grid);

print "First crossing: $least_dist\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Print_Grid {
  my %grid = %{shift()};

  for (my $j=$grid{size}; $j>=0-$grid{size}; $j--) {
    for (my $i=0-$grid{size}; $i<=$grid{size}; $i++) {
      my $pt = ".";
      $pt = "+" if ($grid{$i}{$j});
      print "$pt";
    }
    print "\n";
  }
}
