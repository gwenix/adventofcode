#!/usr/bin/perl

my $in=355;

my $last = 50000000;

my $value = 0;
my $currpos=0;

for (my $i=1; $i<=$last; $i++) {
  $currpos += $in+1;
  $currpos = ($currpos % ($i));

  if ($currpos == 0) {
    $value = $i;
    print "currpos at $i: $currpos\n";
  }

}

print "End value: $value\n";
