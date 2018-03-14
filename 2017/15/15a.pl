#!/usr/bin/perl

my $inf = "input";
#my $inf = "test.input";

my $afactor = 16807;
my $bfactor = 48271;
my $div = 2147483647;

open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my $a = $lines[0]; chomp($a);
my $b = $lines[1]; chomp($b);

my $total=0;
for (my $i=0; $i<40000000; $i++) {
  $a *= $afactor;
  $a = $a % $div;
  $b *= $bfactor;
  $b = $b % $div;

  $abin = Bin($a);
  $bbin = Bin($b);

  if ($abin == $bbin) {
    $total++;
    print "$total at $i.\n";
  }
  
}

print "Found $total matches.\n";

sub Bin {
  my $num = shift();

  my $bin = sprintf("%b", $num);
  my @foo = split //, $bin;
  my $end = @foo;
  while ($end > 16) {
    shift(@foo);
    $end = @foo;
  }
  $bin = join ("", @foo);
  return $bin;
}
