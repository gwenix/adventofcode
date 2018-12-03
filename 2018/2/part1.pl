#!/usr/bin/perl

use strict;

my $input = "input";
open (F, "$input") or die "Cannot open $input: $!\n";
my @lines = <F>;
close(F);

my ($two, $three);

foreach my $boxid (@lines) {
  chomp($boxid);
  my @chars = split //, $boxid;

  # first count the number of times each char is used  
  my %ch;
  foreach my $c (@chars) {
    $ch{$c}++;
  }
  
  my ($too, $tree); # Can only count 2 and 3s once, so temp spot holder vars

  # OK, now to traverse the characters again and see how many of each
  foreach my $c (keys %ch) {
    $too++ if ($ch{$c}==2);
    $tree++ if ($ch{$c}==3);
  }

  # OK, now to add to the final tallies
  $two++ if ($too);
  $three++ if ($tree);
}

my $total = $two * $three;

print "Checksum is $total\n";
