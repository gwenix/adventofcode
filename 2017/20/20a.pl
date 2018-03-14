#!/usr/bin/perl

my $inf="input";
#$inf="test.input";

open(F,$inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my @part; # array of hashes, 
	  # each has {x}, {y}, {z}, and on those {pos}, {vel}, {acc}

my $numparts=@lines;

# Initializing the %part
for (my $i=0; $i<@lines; $i++) {
  my $l = $lines[$i];
  
  chomp($l);
  $l =~ s/[ pva\<]//g; # removing most of the cruft
  $l =~ s/\>\,?//g; # removing the >, or >
  $l =~ s/=//; # removing only the first =

  my @foo = split /=/,$l;

  # Gettting p values

  my @bar = split /,/,$foo[0];
  $part[$i]{x}{pos}=$bar[0];
  $part[$i]{y}{pos}=$bar[1];
  $part[$i]{z}{pos}=$bar[2];

  # Gettting v values
  @bar = split /,/,$foo[1];
  $part[$i]{x}{vel}=$bar[0];
  $part[$i]{y}{vel}=$bar[1];
  $part[$i]{z}{vel}=$bar[2];

  # Gettting a values
  @bar = split /,/,$foo[2];
  $part[$i]{x}{acc}=$bar[0];
  $part[$i]{y}{acc}=$bar[1];
  $part[$i]{z}{acc}=$bar[2];

}

#print "---- Initial Positions ----\n";
#for (my $i=0;$i<$numparts;$i++) {
  #print "$i: ";
  #PrintParticle($part[$i]);
#}

#print "---- Movement ----\n";
#for (my $iter=0; $iter<10; $iter++) {
  #print "Round $iter\n";
  #for (my $i=0; $i<$numparts; $i++) {
    #my $partstr = PrintParticle($part[$i]);
    #print "$i: $partstr\t";
    #my $dist = Distance($part[$i]);
    #print "Distance: $dist\n";
    #%part = Accelerate($part[$i]);
    #%part = Move($part[$i]);
  #}

  #print "\n";
#}

my $mini=0;
my $minacc=abs($part[0]{x}{acc}) + abs($part[0]{y}{acc}) + abs($part[0]{z}{acc});
my $mindist = Distance($part[$mini]);

for (my $i=1; $i<$numparts; $i++) {
  my $xacc = $part[$i]{x}{acc};
  my $yacc = $part[$i]{y}{acc};
  my $zacc = $part[$i]{z}{acc};

  my $result = abs($xacc) + abs($yacc) + abs($zacc);

  if ($result < $minacc) {
    $minacc = $result;
    $mini = $i;
  } elsif ($result == $minacc) {
    my $idist = Distance($part[$i]);

    if ($idist<$mindist) {
      $mini=$i;
      $minacc=$result;
      $mindist=$idist;
    }
  }

  print "Comparing $minacc with $result at $i.\n";
}

print "$mini is going the slowest.\n";


sub Move {
  my %p = %{ shift() };

  $p{x}{pos} += $p{x}{vel};
  $p{y}{pos} += $p{y}{vel};
  $p{z}{pos} += $p{z}{vel};

  return %p;
}

sub Accelerate {
  my %p = %{ shift() };

  $p{x}{vel} += $p{x}{acc};
  $p{y}{vel} += $p{y}{acc};
  $p{z}{vel} += $p{z}{acc};

  return %p;
}

sub Distance {
  my %p = %{ shift() };

  my $dist=0;

  $dist += abs($p{x}{pos});
  $dist += abs($p{y}{pos});
  $dist += abs($p{z}{pos});

  return $dist;
}

sub PrintParticle {
  my %p = %{ shift() };
  my $str;

  $str .= "Position: ($p{x}{pos},$p{y}{pos},$p{z}{pos})\t";
  $str .= "Velocity: ($p{x}{vel},$p{y}{vel},$p{z}{vel})\t";
  $str .= "Acceleration: ($p{x}{acc},$p{y}{acc},$p{z}{acc})";

  return $str;
}
