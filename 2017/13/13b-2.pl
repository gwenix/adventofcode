#!/usr/bin/perl

my $inf="input";
#$inf="test.input";

open(F,$inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my @layer;
my $maxlayer=0;

for (my $i=0; $i<@lines; $i++) {
  my $l = $lines[$i];
  $l =~ s/\://;
  chomp($l);
  my ($laylvl,$range) = split / /,$l;
  $layer[$laylvl] = $range;
  $maxlayer=$laylvl if ($laylvl>$maxlayer);
}

# Now to do this mathematically knowing that scans will catch on 2*init.
my $caught = 1;

my $loop=0;

while ($caught) {
  $caught=0;
  for (my $i=0; $i<=$maxlayer; $i++) {
    my $range = $layer[$i];
    if ($range>1) {
      my $currpos=Remainder(($i+$loop),($range-1)*2);
      #print "$loop,$i current position: $currpos\t";
      if ($currpos==0) {
        #print "CAUGHT!\n";
        $caught=1;
      } else {
        #print "not caught\n";
      }
    } else {
      #print "$loop,$i current position: n/a\n";
    }
  }
  if ($caught) {
    #print "Caught at $loop: $caught\n";
    $loop++;
  } 
}

print "Made it through: $loop\n";

sub Remainder {
  my ($a, $b) = @_;

    return 0 unless $a && $b;
    return (($a / $b - int($a / $b))*$b);
}
