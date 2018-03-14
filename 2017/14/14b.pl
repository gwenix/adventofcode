#!/usr/bin/perl

my $inf = "inputb";
#$inf = "test.inputb";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my %data;

for (my $x=0; $x<@lines; $x++) {
  my $l = $lines[$x];
  chomp($l);

  my @foo = split //,$l;
  for (my $y=0; $y<@foo; $y++) {
    my $ch = $foo[$y];
    if ($ch) {
      $data{$x}{$y}="X";
    } else {
      $data{$x}{$y}=".";
    }
  }
}

my $group=0;
for (my $x=0; $x<128; $x++) {
  for (my $y=0; $y<128; $y++) {
    if ($data{$x}{$y} eq "X") {
      $group++;
      %data=Scan($x,$y,$group,\%data);
    }
  }
}


PrintGrid(\%data);

print "Groups: $group\n";


sub PrintGrid {
  my %grid = { shift () };

  for (my $i=0; $i<128; $i++) {
    for (my $j=0; $j<128; $j++) {
      print "$data{$i}{$j}";
    }
    print "\n";
  }
}

sub Scan {
  my $x=shift();
  my $y=shift();
  my $grp=shift();
  my %d = %{ shift() };

  $d{$x}{$y}=$grp;
  if ($x<128 && $d{$x+1}{$y} eq "X") {
    %d = Scan ($x+1,$y,$grp,\%d);
  }
  if ($x<128 && $d{$x}{$y+1} eq "X") {
    %d = Scan ($x,$y+1,$grp,\%d);
  }
  if ($x<128 && $d{$x-1}{$y} eq "X") {
    %d = Scan ($x-1,$y,$grp,\%d);
  }
  if ($x<128 && $d{$x}{$y-1} eq "X") {
    %d = Scan ($x,$y-1,$grp,\%d);
  }
  return %d;
}
