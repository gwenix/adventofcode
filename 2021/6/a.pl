#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
#my $input_file = "test.input";
my $input_file = "input";

# ------ #
# Arby's #
# ------ #

my  @fish;
my $days=80;

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

@fish = split /,/,$lines[0];

for (my $day=0; $day<$days; $day++) {
  print "$day ";
  @fish = @{ BreedFish(@fish) };
  #PrintFish(@fish);
}

my $total = @fish;

print "\nThere are $total fish.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub PrintFish {
  my @fish=@_;
  my $last=pop(@fish);
  foreach my $f (@fish) {
    print "$f,";
  }
  print "$last\n";
}

sub BreedFish {
  my @arr = @_;
  my @new;

  foreach my $fish (@arr) {
    if ($fish == 0) {
      push (@new,8);
      $fish=6;
    } else {
      $fish--;
    }

    push(@new,$fish);
  }

  return \@new;
}
