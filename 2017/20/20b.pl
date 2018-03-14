#!/usr/bin/perl

my $inf="input";
#$inf="test.input";

open(F,$inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my @part; # array of hashes, 
	  # each has {x}, {y}, {z}, and on those {pos}, {vel}, {acc}
	  # also {des} flag

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

  $part[$i]{des}=0;
}

print "---- Movement ----\n";
for (my $iter=0; $iter<100000; $iter++) {
  print "Round $iter\n";
  my %collide;
  for (my $i=0; $i<$numparts; $i++) {
    my $partstr = PrintParticle($part[$i]);
    print "$i: $partstr\n";
    unless ($part[$i]{des}) {
      my $x=$part[$i]{x}{pos};
      my $y=$part[$i]{y}{pos};
      my $z=$part[$i]{z}{pos};
      if ($collide{$x}{$y}{$z}) {
        $part[$i]{des}=1;
        my $former = $collide{$x}{$y}{$z}{i};
        $part[$former]{des}=1;
      } else {
        %part = Accelerate($part[$i]);
        %part = Move($part[$i]);
        $collide{$x}{$y}{$z}{i}=$i;
      }
    }
  }

  print "\n";
}

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

  $str .= "Position: ($p{x}{pos},$p{y}{pos},$p{z}{pos}) ";
  $str .= "Velocity: ($p{x}{vel},$p{y}{vel},$p{z}{vel}) ";
  $str .= "Acceleration: ($p{x}{acc},$p{y}{acc},$p{z}{acc})";

  $str = "------destroyed by collision------" if ($p{des});

  return $str;
}
