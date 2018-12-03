#!/usr/bin/perl

use strict;

my $input = "input";
open (F, "$input") or die "Cannot open $input: $!\n";
my @lines = <F>;
close(F);

my $finalchars;
my @boxes;

foreach my $boxid (@lines) {
  chomp($boxid);
  push (@boxes, $boxid);
}

my $numboxes = @boxes;

my $i=0; my $j=0;
my $stop=0;
my $matchstring;
while (!$stop) {
  $j++;
  if ($j>=$numboxes) {
    $i++;
    $j=$i+1;
    if ($j>=$numboxes) {
      die "Did not find a match?\n";
    }
  }
  $matchstring=CompareBoxes($boxes[$i], $boxes[$j]);
  $stop=1 if ($matchstring);
}

print "Match string: $matchstring\n";

exit();

#####################################################################
#			  Subroutines				    #
#####################################################################

sub CompareBoxes {
  # Compare two strings. If they are only one off, return the matching chars.
  # else return 0.
  my $box1 = shift();
  my $box2 = shift();

  print "DEBUG: comparing $box1 $box2\n";

  my @matchchars;

  my @box1chars = split //, $box1;
  my @box2chars = split //, $box2;


  # The length doesn't change for any of my input, so...
  my $length = @box1chars;
  my $i=0;
  my $stop=0;
  my $notmatch=0;

  while (!$stop) {
    print "DEBUG: comparing $box1chars[$i] $box2chars[$i] ";
    if ($box1chars[$i] ne $box2chars[$i]) {
      $notmatch++;
      #print "DEBUG did I get here? ";
    } else {
      push(@matchchars, $box1chars[$i]);
    }
    if ($notmatch<2) {
      $i++;
      if ($i>=$length) {
	$stop=1;
      } 
    } else {
      $stop=1;
    }
    print "DEBUG Not match: $notmatch\n";
  }

  my $returnval=0;

  if ($notmatch<2) {
    $returnval = join ("", @matchchars);
  } 

  return $returnval;
}
