#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

our %trees;
# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

our $Xlen=@lines;
our $Ylen;

for (my $x=0; $x<$Xlen; $x++) {
  my @ch = split //, $lines[$x];
  $Ylen=@ch;
  for (my $y=0; $y<$Ylen; $y++) {
    $trees{$x}{$y}{height}=$ch[$y];
    if ($x==0||$y==0||$x==$Xlen-1||$y==$Ylen-1) {
      $trees{$x}{$y}{visible}=1;
    } else {
      $trees{$x}{$y}{visible}=0;
    }
  }
}

for (my $x=1; $x<$Xlen-1; $x++) {
  for (my $y=1; $y<$Ylen-1; $y++) {
    CheckVisibility($x,$y);
  }
}

PrintTrees();

my $total=CountVisibleTrees();

print "There are $total visible trees\n";
 
exit; 

# ----------- #
# Subroutines #
# ----------- #

sub CheckVisibility {
  my $x=shift();
  my $y=shift();

  my $visible=1;

  # Checking to bottom 
  #print "Checking to bottom ($x,$y).. \n";
  for(my $i=$x+1; $i<$Xlen && $visible; $i++) {
    $visible=CheckHeights($x,$y,$i,$y);
  }

  if ($visible) {
    SetVisible($x,$y);
    return 1; # only needs to be visible from one direction
  }

  # Checking to top 
  $visible=1;
  #print "Checking to top ($x,$y).. \n";
  for(my $i=$x-1; $i>=0 && $visible; $i--) {
    $visible=CheckHeights($x,$y,$i,$y);
  }

  if ($visible) {
    SetVisible($x,$y);
    return 1; # only needs to be visible from one direction
  }

  # Checking to right
  $visible=1;
  #print "Checking to right ($x,$y).. \n";
  for(my $i=$y+1; $i<$Ylen && $visible; $i++) {
    $visible=CheckHeights($x,$y,$x,$i);
  }

  if ($visible) {
    SetVisible($x,$y);
    return 1; # only needs to be visible from one direction
  }

  # Checking to left
  $visible=1;
  #print "Checking to left ($x,$y).. \n";
  for(my $i=$y-1; $i>=0 && $visible; $i--) {
    $visible=CheckHeights($x,$y,$x,$i);
  }

  if ($visible) {
    SetVisible($x,$y);
    return 1; # only needs to be visible from one direction
  }
}

sub SetVisible {
  my $x=shift();
  my $y=shift();

  $trees{$x}{$y}{visible}=1;
}

sub CheckHeights {
  my $x1=shift();
  my $y1=shift();
  my $x2=shift();
  my $y2=shift();

  my $tree1=$trees{$x1}{$y1}{height};
  my $tree2=$trees{$x2}{$y2}{height};
  #print "DEBUG: ($x1,$y1) ($x2,$y2)  $tree1 $tree2\n";

  if ($tree2<$tree1) {
    return 1;
  }

  return 0;
}

sub CountVisibleTrees {
  my $count=0;

  for(my $x=0; $x<$Xlen; $x++) {
    for(my $y=0; $y<$Ylen; $y++) {
      $count++ if ($trees{$x}{$y}{visible});
    }
  }
  
  return $count;
}

sub PrintTrees {

  for(my $x=0; $x<$Xlen; $x++) {
    for(my $y=0; $y<$Ylen; $y++) {
      print "$trees{$x}{$y}{height}";
    }
    print "\n";
  }

  print "\n\n";

  for(my $x=0; $x<$Xlen; $x++) {
    for(my $y=0; $y<$Ylen; $y++) {
      if ($trees{$x}{$y}{visible}) {
	print "X";
      } else {
	print ".";
      }
    }
    print "\n";
  }

  print "\n\n";

}
