#!/usr/bin/perl

my $portal = 361527;
#my $portal = 12;

my $step = 1;
my $currdir=0;
my $x=0;
my $y=0;

for (my $i=2; $i<=$portal; $i++) {
  $currdir=0 if ($currdir>3);

  if ($currdir == 0) {
    # east
    print "Going east $step steps. ";
    $x+=$step;
    $i+=$step-1;
    if ($i>$portal) {
      $x-=$i-$portal;
    }
  } elsif ($currdir == 1) {
    # north
    print "Going north $step steps. ";
    $y+=$step;
    $i+=$step-1;
    if ($i>$portal) {
      $y-=$i-$portal;
    }
    $step++;
  } elsif ($currdir == 2) {
    # west
    print "Going west $step steps. ";
    $x-=$step;
    $i+=$step-1;
    if ($i>$portal) {
      $x+=$i-$portal;
    }
  } else {
    # south
    print "Going south $step steps. ";
    $y-=$step;
    $i+=$step-1;
    if ($i>$portal) {
      $y+=$i-$portal;
    }
    $step++;
  }

  print "Ending at $x,$y. Current number is $i.\n";
  $currdir++;
}

my $total = abs($x) + abs($y);
print "Total steps: $total\n";
