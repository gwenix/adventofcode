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
    $layer[$i]{scan}=0;
    $layer[$i]{dir}=1;
  } else {
    $layer[$i]=0;
  }
}
#PrintLayers(-1,\@layer);

my $delay=0;
my $caught=1;

# now to walk the layers
while ($caught) {
  $caught=0;
  #always advance the registers
  for (my $i=0; $i<$maxlayer; $i++) {

    # Are we caught?
    if ($layer[$i]{scan} == 0) {
      $caught=1;
      #PrintLayers($i,\@layer);
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
  if ($caught) {
    print "Caught at $delay.\n" ;
    $delay++;
  } 
  PrintLayers(-1,\@layer);
}

print "Go through at $delay.\n";


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
