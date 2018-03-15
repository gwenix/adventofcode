#!/usr/bin/perl

my $inf="input";
$inf="test.input";

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

# initializing the layers now
for (my $i=0; $i<=$maxlayer; $i++) {
  if ($layer[$i]) {
    $layer[$i]{scan]=0;
    $layer[$i]{dir}=1;
  } else {
    $layer[$i]=0;
  }
}
PrintLayers(-1,\@layer);

my @caught;


# now to walk the layers
for (my $i=0; $i<=$maxlayer; $i++) {
  PrintLayers($i,\@layer);

  # Are we caught?
  if ($layer[$i]{scan} == 0) {
    push (@caught, $i);
  }

  # advance the registers
  for (my $j=0; $j<=$maxlayer; $j++) {
    $layer[$j]{scan}+=$layer[$j]{dir};
    if ($layer[$j]{scan} == $layer[$j]-1 
	|| $layer[$j]{scan}==0) {
      if ($layer[$j]{dir}==1) {
	$layer[$j]{dir}=-1;
      } else {
	$layer[$j]{dir}=1;
      }
    }
  }

}

print "Caught at @caught\n";

my $threat=0;

foreach my $c (@caught) {
  my $add = $c * $layer[$c];
  print "Adding $add\n";
  $threat += $add;
}

print "Threat level: $threat\n";

sub PrintLayers {
  my $pos=shift();
  my @lay = @{ shift() };

  #print "@lay\n";

  for(my $i=0; $i<@lay; $i++) {
    if ($i == $pos) {
      print "($i):";
    } else {
      print " $i :";
    }
    for (my $j=0; $j<$lay[$i]; $j++) {
      if ($j == $lay[$i]{scan}) {
        print " [S]";
      } else {
        print " [ ]";
      } 
    }
    print "\n";
  }
  print "\n";
}
