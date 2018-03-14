#!/usr/bin/perl

my $inf = "input";
#$inf = "test.input";

my $afactor = 16807;
my $bfactor = 48271;
my $div = 2147483647;

open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my $a = $lines[0]; chomp($a);
my $b = $lines[1]; chomp($b);

my $total=0;
for (my $i=0; $i<5000000; $i++) {
  $a = Generate($a, $afactor, $div, 4);
  $b = Generate($b, $bfactor, $div, 8);

  #print "$a\t$b\n";

  $abin = Bin($a);
  $bbin = Bin($b);

  if ($abin == $bbin) {
    $total++;
    print "---------------------------------------------------\n";
    print "$total at $i.\n";
    print "$a\t$b\n$abin\n$bbin\n";
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

sub Generate {
  my $num = shift();
  my $factor = shift();
  my $div = shift();
  my $match = shift();

  $num *= $factor;
  $num = $num % $div;
  my $check = $num % $match; 
  while  ($check) {
    $num *= $factor;
    $num = $num % $div;
    $check = $num % $match; 
  } 
  return $num;
}
