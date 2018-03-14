#!/usr/bin/perl

my $inf = "input";
$inf = "test.input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my @ports;
my %connectors;

Header("Initializing the data");
for (my $i=0; $i<@lines; $i++) {
  my $l = $lines[$i];
  chomp($l);
  $ports[$i]=$l;

  my ($a,$b) = GetPorts($l);
  print "Setting $l: $a $b\n";

  if ($connectors{$a}) {
    my $ref = $connectors{$a};
    my @foo = @{ $ref };
    push(@foo, $i);
    $connectors{$a} = \@foo;
  } else {
    my @foo;
    $foo[0]=$i;
    $connectors{$a} = \@foo;
  }

  if ($connectors{$b}) {
    my $ref = $connectors{$b};
    my @foo = @{ $ref };
    push(@foo, $i);
    $connectors{$b} = \@foo;
  } else {
    my @foo;
    $foo[0]=$i;
    $connectors{$b} = \@foo;
  }

}

#PrintConnectors(\%connectors);

Header("Running the Bridge");
my ($strength, @bridge) =Bridge(0,\%connectors,@ports);
Header("Strongest strength: $strength");


# ----------- #
# Subroutines #
# ----------- #

sub PrintConnectors {
  my %c = %{ shift() };

  foreach my $k (sort keys %c) {
    my @foo = @{ $c{$k} };
    print "$k: @foo\n";
  }

}

sub GetPorts {
  my $str = shift();

  my ($a,$b) = split /\//, $str;

  return ($a, $b);
}

sub Bridge {
  my $p = shift();
  my %conn = %{ shift() };
  my @ports = @_;
  my $strength=0;

  my @bridge;

  print "Checking $p...\n";
  #PrintConnectors(\%conn);
  my $length = @{ $conn{$p} };
  if ($length) {
    for(my $i=0; $i<$length; $i++) {
      my @subset1 = @{ $conn{$p} };
      my @subset2;
      my $q;
 
      my $iport = splice(@subset1, $i, 1);
      $conn{$p} = \@subset1;

      my $curr = $ports[$iport];
      my ($a, $b) = GetPorts($curr);
      #print "\n";

      if ($a == $p) {
	@subset2 = @{ conn{$b} };
        @subset2 = RemovePort($curr, $conn{$b}, @ports);
        $conn{$b} = \@subset2;
	$q=$b;
      } else {
	@subset2 = @{ conn{$a} };
        @subset2 = RemovePort($curr, $conn{$a}, @ports);
        $conn{$a} = \@subset2;
	$q=$b;
      }
      PrintConnectors(\%conn);

      my $substrength;

      ($substrength, @bridge) = Bridge($q,\%conn,@ports);


      if (($substrength+$a+$b)>$strength) {
        $substrength += $a + $b;
        $strength = $substrength;
	unshift (@bridge, $curr);
      }
    }
  } else {
    print "No connections found.\n";
  }
  
  print "Returning $strength and @bridge.\n";
  return ($strength, @bridge);
}

sub RemovePort {
  my $curr = shift();
  my $aref = shift();
  my @ports = @_;
  
  my @indexes = @{ $aref };
  print "Ports being looked at to compare to $curr: ";
  foreach my $j (@indexes) {
    print "$ports[$indexes[$j]] ";
  }
  print "\n";

  for (my $i=0; $i<@indexes; $i++) {
    #print "Comparing $ports[$indexes[$i]] and $curr\n";
    if ($ports[$indexes[$i]] eq $curr) {
      my $out = splice (@indexes, $i, 1);
    }
  }

  return @indexes;
}

sub Header {
  print "----- @_ -----\n";
}
