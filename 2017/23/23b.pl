#!/usr/bin/perl

#my $b=150;
#my $c=320;
my $b=106500;
my $c=17000;
$c+=$b;

my $count=0;

for (my $i=$b; $i<=$c; $i+=17) {
  print "checking $i...\n" if (($i-$b)%170==0);
  $count++ unless (Prime($i));
}

print "found: $count\n";

sub FactorsFound {
  my $num = shift();

  for (my $a=2; $a<$num; $a++) {
    for (my $b=$a; $b<$num; $b++) {
      if ($a*$b == $num) {
	print "Found $a * $b = $num\n";
	return 1;
      }
    }
  } 
  return 0;
}

sub Prime {
    my $number = shift;
    my $d = 2;
    my $sqrt = sqrt $number;
    while(1) {
        if ($number%$d == 0) {
            return 0;
        }
        if ($d < $sqrt) {
            $d++;
        } else {
            return 1;
        }
    }
}
