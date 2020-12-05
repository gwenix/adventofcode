#!/usr/bin/perl

use strict;
use warnings;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";
my $max_row=128;
my $max_column=8;

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my $maxseat=0;

foreach my $l (@lines) {
  my @cols = split //, $l;
  my @rows=splice(@cols,0,7);

  my $row=FindPos(0,$max_row,@rows);
  my $col=FindPos(0,$max_column,@cols);
  my $seatID=FindSeatID($row,$col);

  print "$l: row $row, column $col, seat ID $seatID.\n";

  $maxseat=$seatID if ($seatID>$maxseat);
}

print "Max Seat ID: $maxseat\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub FindPos {
  my $start=shift();
  my $end=shift();
  my @pos = @_;

  my $curr=shift(@pos);
  
  my $mid=($start+$end)/2;
  my $more=@pos;

  if ($curr eq "F" || $curr eq "L") {
    if ($more) {
      $end=$mid;
    } else {
      return $start;
    }
  } elsif ($curr eq "B" || $curr eq "R") {
    if ($more) {
      $start=$mid;
    } else {
      return $mid;
    }
  } else {
    die "Invalid row marker: $curr\n";
  }

  return FindPos($start,$end,@pos);
}

sub FindSeatID {
  my $row=shift();
  my $col=shift();

  my $id=$row*8+$col;

  return $id;
}
