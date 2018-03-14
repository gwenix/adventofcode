#!/usr/bin/perl

my $inf = "input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my $tot=0;

foreach my $l (@lines) {
  chomp($l);
  $l =~ s/^\s+|\s+$//g; #trim

  my @nums = split /\s+/, $l;

  my ($a, $b, $c) = sort { $a <=> $b } @nums;

  print "($a,$b,$c): ";
  if ($a+$b>$c) {
    print "triangle\n";
    $tot++;
  } else {
    print "irrational\n";
  }
}

print "Total: $tot\n";

