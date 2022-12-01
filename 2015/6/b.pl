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

my $size=shift(@lines);

my @matrix = InitializeLightGrid($size); 

#print "Old:\n";
#DrawLightGrid(@matrix);

for(my $i=0;$i<@lines;$i++) {
  my $l = $lines[$i];
  my ($type,$startX,$startY,$endX,$endY) = ParseLine($l);

  #print "----$l---\n";
  @matrix = @{ ChangeLights($l, @matrix) };
  #DrawLightGrid(@matrix);
}

#print "New:\n";
#DrawLightGrid(@matrix);

my $lit = LightsOn(@matrix);

print "There are $lit lights lit.\n";

exit(); 

# ----------- #
# Subroutines #
# ----------- #

sub LightsOn {
  my @mat = @_;

  my $tot=0;

  foreach my $i (@mat) {
    foreach my $j (@{ $i }) {
      $tot+=$j;
    }
  }

  return $tot;
}

sub ChangeLights {
  my $l = shift();
  my @mat = @_;

  #print Dumper(@mat);
  my ($type,$startX,$startY,$endX,$endY) = ParseLine($l);

  #print "$l\n\t$startX - $endX ;  $startY - $endY\n";

  for(my $i=$startX; $i<=$endX; $i++) {
    #print "$i ";
    for(my $j=$startY; $j<=$endY; $j++) {
      my $curr = $mat[$i][$j];
      #print "$type $curr at $i,$j\n";
      if ($type) {
	$curr+=$type;
      } else {
	$curr-- if ($curr);
      }
      $mat[$i][$j] = $curr;
    }
  }

  return \@mat;
}

sub ParseLine {
  my $str = shift();

  my ($front, $back) = split / through /, $str;

  # Parsing the first part
  my @foo = split / /, $front;
  my $range = pop(@foo);
  my $type = join " ", @foo;
  $type = findType($type);
  
  my ($x1,$y1) = ParseRange($range);

  #parsing the second part
  my ($x2,$y2) = ParseRange($back);

  return ($type, $x1, $y1, $x2, $y2);
}

sub ParseRange {
  my $range=shift();

  my ($x,$y) = split /,/, $range;

  return ($x, $y);
}

sub findType {
  my $str = shift();

  return 0 if ($str eq "turn off");
  return 1 if ($str eq "turn on");
  return 2 if ($str eq "toggle");

  return -1;
}

sub InitializeLightGrid {
  my $size=shift();
  my @mat;

  for(my $i=0; $i<$size; $i++) {
    for(my $j=0; $j<$size; $j++) {
      $mat[$i][$j]=0;
    }
  }

  return @mat;
}

sub DrawLightGrid {
  my @mat = @_;

  for(my $i=0; $i<@mat; $i++) {
    my @y=@{ $mat[$i] };
    for(my $j=0; $j<@y; $j++) {
      if ($y[$j]) {
	print "#";
      } else {
	print ".";
      }
    }
    print "\n";
  }
}
