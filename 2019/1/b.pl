#!/usr/bin/perl

use strict;
use warnings;

my $input_file = "input";
#my $input_file = "test-input";

my $total_fuel=0;

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

for (my $i=0; $i<@lines; $i++) {
  my $module = $i+1;
  my $mass = $lines[$i];
  my $fuel = FuelNeeded($mass);


  print "Module $module has mass $mass and needs $fuel fuel.\n";
  $total_fuel += $fuel;
}

print "\nTotal fuel needed: $total_fuel\n";

exit;

sub FuelNeeded {
  my $start = shift();
  #print "$start ";

  my $needed = int($start/3)-2;
  return 0 if ($needed<1);
  
  return ($needed + FuelNeeded($needed));
}
