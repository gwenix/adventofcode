#!/usr/bin/perl

my $inf = "input";
open (F, "$inf") or die "Cannot open $inf: $!";
my @rows = <F>;
close (F);

my $tot = 0;

foreach my $r (@rows) {
  my @nums = split /\s+/, $r;
  
  my $div;

  for (my $i=0; $i<@nums-1; $i++) {
    for (my $j=$i+1; $j<@nums; $j++) {
      my ($high,$low);
      if ($nums[$i]<$nums[$j]) {
        $high = $nums[$j];
        $low = $nums[$i];
      } else {
        $high = $nums[$i];
        $low = $nums[$j];
      }

      $div = $high/$low if (!($high % $low));
    }
  }
  
  $tot+= $div;
}

print "Checksum: $tot\n";
