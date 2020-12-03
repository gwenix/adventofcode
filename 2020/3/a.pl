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

# Traverse
my $curr=0;
my $trees=0;
for(my $x=0;$x<$len;$x++) {
  $trees++ if ($map{$x}{$curr});
  print "$lines[$x]\n";
  for (my $i=0; $i<$curr; $i++) { print " "; }
  print "$map{$x}{$curr} $trees\n";
  $curr+=3;
  $curr-=$wid if ($curr>=$wid);
}

print "Encountered $trees trees.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #
