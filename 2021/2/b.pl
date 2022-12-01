#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "test.input";
#my $input_file = "input";

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my %position;

for (my $i=0; $i<@lines; $i++) {
  %position = %{ Parse(\%position,$lines[$i]) };
}

my $dist = $position{distance};
my $depth = $position{depth};

print "Final position: distance of $dist and depth of $depth for a total of ";
my $total = $dist*$depth;
print "$total.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Parse {
  my %pos = %{ shift() };
  my $in = shift();

  print "Parsing $in\n";
  my ($dir,$a) = split / /, $in;
  if ($dir eq "forward") {
    $pos{distance} += $a;
    $pos{depth} += $a*$pos{aim};
  } elsif ($dir eq "down") {
    $pos{aim} += $a;
  } elsif ($dir eq "up") {
    $pos{aim} -= $a;
  } else {
    die "Cannot parse $dir.\n";
  }
  
  return \%pos;
}
