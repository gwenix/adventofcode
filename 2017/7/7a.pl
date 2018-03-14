#!/usr/bin/perl

my $inf="input";
#my $inf="test.input";

open(F,$inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my $tot=0;

foreach my $l (@lines) {
  print "$l";
  chomp($l);
  my @chars = split //, $l;
  my $in=0;
  my @outer;
  my @inner;
  my $isIP=0;

  for (my $i=0; $i<@chars; $i++) {
    my $c = $chars[$i];
    if ($c eq '[') {
      $in=1;
      push (@outer,'|');
    } elsif ($c eq ']') {
      $in=0;
      push (@inner,'|');
    } elsif ($in) {
      push (@inner,$c);
    } else {
      push (@outer,$c);
    }
  }

  print "Outer $isIP: ";
  $isIP=1 if (Palin(\@outer));
  print "Inner $isIP: ";
  $isIP=0 if (Palin(\@inner));

  if ($isIP) {
    $tot++;
    print "This is TLS. Total: $tot\n" 
  }

}

print "TLS IPs: $tot\n";

sub Palin {
  my @ch = @{ shift() };

  print @ch;

  for (my $i=0; $i<@ch; $i++) {
      my ($a, $b, $c) = ($ch[$i-2],$ch[$i-1],$ch[$i]);

      if ($a eq $c && $a ne $b) {
        print " Matching $a$b$c.\n";
        return 1;
      }
  }

  print " No Match.\n";
  return 0;
}
