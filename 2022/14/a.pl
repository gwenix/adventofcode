#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

our %wall;

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

#initialize the wall
foreach my $l (@lines) {
  AddStone($l);
}

print Dumper(%wall);

$wall{done}=0;

while (!$wall{done}) {
  AddSand(500,0);
}

print "There are $wall{sand} sands\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub AddSand {
  my $x=shift();
  my $y=shift();

  if ($y>$wall{maxY}) {
    # We got to the freefall!
    $wall{done}=1;
  } elsif ($wall{$x}{$y+1}{filled}) {
    if ($wall{$x-1}{$y+1}) {
      if ($wall{$x+1}{$y+1}) {
	# well, it comes to rest then.
	$wall{$x}{$y}{filled}=1;
	$wall{sand}++;
      } else {
        # sand falls down-right
        AddSand($x+1,$y+1);
      }
    } else {
      # sand falls down-left
      AddSand($x-1,$y+1);
    }
  } else {
    # sand falls down
    AddSand($x,$y+1);
  }
}

sub AddStone {
  my $in=shift();
  my @foo = split / -> /, $in;

  for(my $i=1; $i<@foo; $i++) {
    my ($x1,$y1) = split /,/,$foo[$i-1];
    my ($x2,$y2) = split /,/,$foo[$i];
    $wall{maxY}=$y1 if ($y1>$wall{maxY});
    $wall{maxY}=$y2 if ($y2>$wall{maxY});
    if ($x1==$x2) {
      if ($y1>$y2) {
	for (my $j=$y2; $j<=$y1; $j++) {
	  $wall{$x1}{$j}{filled}=1;
	}
      } else {
	for (my $j=$y1; $j<=$y2; $j++) {
	  $wall{$x1}{$j}{filled}=1;
	}
      }
    } else {
      if ($x1>$x2) {
	for (my $j=$x2; $j<=$x1; $j++) {
	  $wall{$j}{$y1}{filled}=1;
	}
      } else {
	for (my $j=$x1; $j<=$x2; $j++) {
	  $wall{$j}{$y1}{filled}=1;
	}
      }
    }
  }
}
