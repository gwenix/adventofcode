#!/usr/bin/perl

my $inf = "input";
open (F, "$inf") or die "Cannot open $inf: $!";
my @rows = <F>;
close (F);

my $tot = 0;

foreach my $r (@rows) {
  my @nums = split /\s+/, $r;
  
  my $low = pop(@nums);
  my $high = $low;

  foreach my $i (@nums) {
    $low = $i if ($i<$low);
    $high = $i if ($i>$high);
  }
  
  $tot+= $high-$low;
}

print "Checksum: $tot\n";
