#!/usr/bin/perl

my $input = 361527;

my %coordinates;
my $stepamount = 1;
my $stepcount = 0;
my $currdir=0;
my $x=0;
my $y=0;
my $currnum=1;
$coordinates{$x}{$y}=$currnum; #seeding

for (my $i=2; $currnum<=$input; $i++) {
  $currdir=0 if ($currdir>3);

  # Take a step
  if ($currdir == 0) {
    # east
    print "Going east. ";
    $x++;
  } elsif ($currdir == 1) {
    # north
    print "Going north. ";
    $y++;
  } elsif ($currdir == 2) {
    # west
    print "Going west. ";
    $x--;
  } else {
    # south
    print "Going south. ";
    $y--;
  }

  # Account for next step
  $stepcount++;
  if ($stepcount == $stepamount) {
    $stepcount=0;
    $stepamount++ if ($currdir%2);
    $currdir++;
  }

  # total the adjacent boxes
  $currnum=0;

  $currnum += $coordinates{$x+1}{$y}; #north
  $currnum += $coordinates{$x+1}{$y+1}; #northeast
  $currnum += $coordinates{$x}{$y+1}; #east
  $currnum += $coordinates{$x-1}{$y+1}; #southeast
  $currnum += $coordinates{$x-1}{$y}; #south
  $currnum += $coordinates{$x-1}{$y-1}; #southwest
  $currnum += $coordinates{$x}{$y-1}; #west
  $currnum += $coordinates{$x+1}{$y-1}; #northwest
  $coordinates{$x}{$y}=$currnum;

  print "Ending at $x,$y. Current number is $currnum.\n";
}

print "\nLast number is $currnum.\n";

