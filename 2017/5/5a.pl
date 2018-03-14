#!/usr/bin/perl

my $inf = "input";
#my $inf = "test.input";

open (F, $inf) or die "Cannot open $inf: $!";
my @maze = <F>;
close (F);

my $steps=0;
my $i=0;
my $last = @maze;

while ($i<$last) {
  my $jump = $maze[$i];
  $maze[$i]++;
  $i += $jump;
  $steps++;
}


print "Step count: $steps\n";
