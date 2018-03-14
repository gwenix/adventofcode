#!/usr/bin/perl

my $l = 3; 

my %spin;
$spin{0}=0;
$currpos=0;

my $lastzero=0;
for (my $i=1; $i<8; $i++) {

  for (my $j=0; $j<$l; $j++) {
    $currpos = $spin{$currpos};
  }
  unless ($currpos) {
    my $diff = $i - $lastzero;
    $lastzero=$i;
    print "Inserting after 0 at step $i, delta $diff.\n";
  }
  my $next = $spin{$currpos}; #next element
  $spin{$i} = $next;
  $spin{$currpos} = $i;
  $currpos = $i;
}

print "Element after 0 is $spin{0}\n";

sub PrintSpin {
  my %d = %{ shift() };

  my $curr = 0;

  print "0 ";

  $curr = $d{0};

  while ($curr) {
    print "$d{$curr} ";
    $curr = $d{curr};
  }
  print "\n";
}
