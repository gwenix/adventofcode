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

my @crates;
my @moves;

for(my $i=0; $i<@lines; $i++) {
  my $l = $lines[$i];
  print "DEBUG $l...\n";
  if ($l=~/\[/) {
    my @ch = split //, $l;

    my $j=0;

    while (@ch) {
      shift (@ch);
      my $curr=shift(@ch);
      shift (@ch);
      shift (@ch);

      #print "DEBUG: curr char is $curr\n";
      $crates[$j].=$curr if ($curr ne " ");
      $j++;
    }
  } elsif ($l=~/m/) {
    push(@moves, $l)
  }
}

PrintCrates(@crates);

#print Dumper(@moves);

for(my $i=0; $i<@moves; $i++) {
  my @mch = split / /, $moves[$i];

  my $num=$mch[1];
  my $from=$mch[3]-1;
  my $to=$mch[5]-1;

  @crates = @{ MoveCrate($from,$to,$num,@crates) };
  PrintCrates(@crates);
}

my $tops = StackTops(@crates);

print "Tops: $tops\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub StackTops {
  my @cr = @_;

  my $out;

  for(my $i=0; $i<@cr; $i++) {
    my @l = split //, $cr[$i];
    $out .= shift(@l);
  }

  return $out;
}

sub MoveCrate {
  my $off=shift();
  my $on=shift();
  my $num=shift();
  my @cr=@_;

  my $offstr=$cr[$off];
  my $onstr=$cr[$on];

  my @offch=split //, $offstr;
  my @onch=split //, $onstr;

  my $move;
  for(my $i=0; $i<$num; $i++) {
    $move.=shift(@offch);
  }
  $offstr=join('',@offch);
  $cr[$off]=$offstr;

  unshift(@onch,$move);
  $onstr=join('',@onch);
  $cr[$on]=$onstr;
  
  return \@cr;
}

sub PrintCrates {
  my @cr=@_;

  print "\n";
  for (my $i=0; $i<@cr; $i++) {
    print "$i: $cr[$i]\n";
  }
  print "\n";
}
