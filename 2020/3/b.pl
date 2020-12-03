#!/usr/bin/perl

use strict;
use warnings;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";
my %map;

# ------ #
# Arby's #
# ------ #


open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my ($len,$wid);

$len=@lines;

for(my $x=0; $x<$len; $x++) {
  my $row=$lines[$x];
  my @col = split //, $row;
  print "error row $x\n" if ($x && $wid!=@col);
  $wid=@col;
  for (my $y=0; $y<$wid; $y++) {
    my $tree;
    if ($col[$y] eq '#') {
      $tree=1;
    } elsif ($col[$y] eq '.') {
      $tree=0;
    } else {
      die "Invalid char at $x,$y: $col[$y]\n";
    }
    $map{$x}{$y}=$tree;
  }
}

my $trees11=Traverse(1,1,\%map);
my $trees31=Traverse(3,1,\%map);
my $trees51=Traverse(5,1,\%map);
my $trees71=Traverse(7,1,\%map);
my $trees12=Traverse(1,2,\%map);

my $mult = $trees11*$trees31*$trees51*$trees71*$trees12;

print "$trees11 * $trees31 * $trees51 * $trees71 * $trees12 = $mult\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Traverse {
  my $right=shift();
  my $down=shift();
  my %map = %{ shift() };

  my $curr=0;
  my $trees=0;
  for(my $x=0;$x<$len;$x+=$down) {
    $trees++ if ($map{$x}{$curr});
    #print "$lines[$x]\n";
    #for (my $i=0; $i<$curr; $i++) { print " "; }
    #print "$map{$x}{$curr} $trees\n";
    $curr+=$right;
    $curr-=$wid if ($curr>=$wid);
  }

  return $trees;
}
