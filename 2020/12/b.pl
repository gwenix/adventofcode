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

my %curr;
my $tot;

$curr{posx}=0;
$curr{posy}=0;
$curr{wayx}=10;
$curr{wayy}=1;

for(my $i=0; $i<@lines; $i++) {
  my @ch = split //, $lines[$i];
  my $dir = shift(@ch);
  my $val = join "", @ch;
  print "$lines[$i]:  \t"; #$dir $val\t";
  my $a=$curr{wayx};
  my $b=$curr{wayy};
  my $x=$curr{posx};
  my $y=$curr{posy};
  #PrintPos(\%curr);

  if ($dir eq "N") {
    $b+=$val;
  } elsif ($dir eq "S") {
    $b-=$val;
  } elsif ($dir eq "E") {
    $a+=$val;
  } elsif ($dir eq "W") {
    $a-=$val;
  } elsif ($dir eq "L" || $dir eq "R") {
    ($a,$b) = Turn($a,$b,$val,$dir);
  } elsif ($dir eq "F") {
    ($x,$y) = Forward(\%curr,$val);
  } else {
    print "Invalid direction: $dir\n";
  }

  
  $curr{wayx}=$a;
  $curr{wayy}=$b;
  $curr{posx}=$x;
  $curr{posy}=$y;

  #print " to ";
  PrintPos(\%curr);
  print "\n";
}
$tot = Manhattan($curr{posx},$curr{posy});

print "Distance: $tot\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub PrintPos {
  my %curr = %{ shift() };


  print "S($curr{posx},$curr{posy})  \tW($curr{wayx},$curr{wayy})";
}

sub Forward {
  my %curr = %{ shift() };
  my $move=shift();

  my $a=$curr{wayx};
  my $b=$curr{wayy};
  my $x=$curr{posx};
  my $y=$curr{posy};
  
  $x += $a*$move;
  $y += $b*$move;

  return ($x,$y);
}

sub Manhattan {
  my ($x, $y) = @_;

  $x = abs($x);
  $y = abs($y);

  return $x + $y;
}

sub Turn {
  my ($a,$b,$degree,$dir) = @_;

  ($a,$b) = Swap($a,$b);
  if ($dir eq "R") {
    $b=-$b;
  } else {
    $a=-$a;
  }

  $degree-=90;
  return ($a,$b) if ($degree<=0);
  return Turn($a,$b,$degree,$dir);
}

sub Swap {
  my ($x, $y) = @_;

  return ($y,$x);
}
