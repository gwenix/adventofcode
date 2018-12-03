#!/usr/bin/perl

use strict;
use warnings;

my $input = "input";
open (F, "$input") or die "Cannot open $input: $!\n";
my @lines = <F>;
close(F);

# Create the fabric grid array
my @fabric;
for (my $i=0; $i<1000; $i++) {
  for (my $j=0; $j<1000; $j++) {
    $fabric[$i][$j]=0;
  }
}

# storing info for a second pass on claims
my %claims;

foreach my $l (@lines) {
  chomp($l);
  my ($claim, $at, $start, $size) = split / /, $l;
  
  # translate the starting declaration into starting grid values
  $start =~ s/://;
  my ($starti, $startj) = split /,/, $start;
  $starti--; $startj--; # the grid starts at 0, not 1.

  # translate the size into ending grid values
  my ($endi, $endj) = split /x/, $size;
  $endi += $starti;
  $endj += $startj;

  # mark off the fabric inches now
  for (my $i=$starti; $i<$endi; $i++) {
    for (my $j=$startj; $j<$endj; $j++) {
      $fabric[$i][$j]++;
    }
  }

  $claims{$claim}{starti} = $starti;
  $claims{$claim}{endi} = $endi;
  $claims{$claim}{startj} = $startj;
  $claims{$claim}{endj} = $endj;
}

# Running through the claim swatches to see if they have overlapping bits
my $winclaim=0;
foreach my $claim (keys %claims) {
  unless ($winclaim) {
    my $starti = $claims{$claim}{starti};
    my $endi = $claims{$claim}{endi};
    my $startj = $claims{$claim}{startj};
    my $endj = $claims{$claim}{endj};
    my $stop=0;

    my $i=$starti;
    my $j=$startj;
    while (!$stop) {
      if ($j>$endj) {
        $i++;
        $j=$startj;
        if ($i>$endi) {
          $stop=1;
          $winclaim=$claim;
        }
      } else {
	$stop=1 if ($fabric[$i][$j]>1);
	$j++;
      }
    }
  }
}

print "Winning claim is $winclaim\n";
