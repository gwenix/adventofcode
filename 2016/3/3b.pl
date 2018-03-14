#!/usr/bin/perl

my $inf = "input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my (@c1,@c2,@c3);

for (my $i=0; $i<@lines; $i++) {
  $l = $lines[$i];
  chomp($l);
  $l =~ s/^\s+|\s+$//g; #trim

  ($c1[$i], $c2[$i], $c3[$i]) = split /\s+/, $l;
}

my $tot=Tries(\@c1);
print "Col1: $tot\n";
$tot += Tries(\@c2);
print "Col2: $tot\n";
$tot += Tries(\@c3);
print "Col3: $tot\n";

print "Total: $tot\n";

sub Tries {
  my $colref = shift();
  my @col = @{ $colref };

  my $t=0;

  for (my $i=2; $i<@col; $i+=3) {
    print "($col[$i-2],$col[$i-1],$col[$i]) -> ";
    my ($a, $b, $c)  = sort { $a <=> $b } ($col[$i-2],$col[$i-1],$col[$i]);
    print "($a,$b,$c)\n";
    $t++ if ($a+$b>$c);
  }

  return $t;
}
