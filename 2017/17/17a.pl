#!/usr/bin/perl

my $inf = "input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

foreach $l (@lines) {
  chomp(@l);

  my %spin;
  $spin{0}=0;
  $currpos=0;

  for (my $i=1; $i<2018; $i++) {
    for (my $j=0; $j<$l; $j++) {
      $currpos = $spin{$currpos}; #advance
    }
    my $next = $spin{$currpos}; #next element
    $spin{$i} = $next;
    $spin{$currpos} = $i;
    $currpos = $i;
  }

  print "Next element is $spin{$currpos}\n";
  
}
