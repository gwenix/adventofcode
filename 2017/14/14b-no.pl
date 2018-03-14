#!/usr/bin/perl

my $inf = "input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

foreach my $l (@lines) {
  print "-----------------------------------\n";
  print "\t$l";
  print "-----------------------------------\n";
  chomp($l);
  my %grid;

  for (my $i=0; $i<128; $i++) {
    my $str = "$l-$i";
    my $hex = KnotHash($str);
    #print "Hex: $hex\n";
    my @foo = split //, $hex;
    my $data;
    for (my $j=0; $j<@foo; $j++) {
      my $bin = HtoB($foo[$j]);
      $data .= $bin;
    }
    my @bits = split //, $data;
    for (my $j=0; $j<@bits; $j++) {
      my $b = $bits[$j];
      #print "Adding [$i,$j]:";
      $grid{$i}{$j} = $b;
      $grid{$i}{$j}{group}=0;
      #print "$grid{$i}{$j} ";
    }
  }

  my $group=0;
  for (my $x=0; $x<128; $x++) {
    for (my $y=0; $y<128; $y++) {
      print "Checking ($x,$y): $grid{$x}{$y} $grid{$x}{$y}{group}\n";
      if ($grid{$x}{$y} && $grid{$x}{$y}{group}==0) {
	$group++;
        %grid = Scan($x,$y,$group,\%grid);
      }
    }
    #print "\n";
  }

  print "$group groups.\n";
  
}

sub KnotHash {
  my $string = shift();

  my @adds = (17, 31, 73, 47, 23);

  my @length = split //,$string;

  for (my $i=0; $i<@length; $i++) {
    my $char = $length[$i];
    $length[$i] = ord($char);
  }

  push (@length, @adds);
  #print "Lengths: @length\n";

  my %list;

  # setting up a linked list
  for (my $i=0; $i<256; $i++) {
    $list{$i}{num} = $i;
    $list{$i}{next}=$i+1;
    $list{$i}{next}=0 if ($i==255);
  }

  my $curr=0;
  my $skip=0;
  for (my $outer=0;$outer<64;$outer++) {
    #print "Current position $curr\tCurrent skip: $skip\n";
    for (my $i=0; $i<@length; $i++) {
      #print "Starting at $curr place\n";
      my $l = $length[$i];
      #print "$l $curr $skip\n";
      my @set;
      my $k = $curr;
      for (my $j=0; $j<$l; $j++) {
        #print "Adding $list{$k}{num} to the set.\n ";
        $set[$j]=$list{$k}{num};
        $k = $list{$k}{next};
      }
      $k=$curr;
      for (my $j=$l-1; $j>=0; $j--) {
        #print "putting $set[$j] in $k place replacing $list{$k}{num}.\n ";
        $list{$k}{num}=$set[$j];
        $k = $list{$k}{next};
      }
      for (my $j=0; $j<$l+$skip; $j++) {
        #print "at $curr and next is $list{$curr}{next}\n";
        $curr = $list{$curr}{next};
      }
      $skip++;
    }
  }

  #print "---\n";
  #print "End List: ";
  #for (my $i=0; $i<256; $i++) {
    #print "$list{$i}{num} ";
  #}
  #print "\n";

  #print "---\n";
  #print "Sparse sets:\n";
  my @dense;
  my $curr=0;
  while ($curr<256) {
    my @set;
    for (my $i=0; $i<16; $i++) {
      $set[$i] = $list{$curr+$i}{num};
    }
    #print "@set\n";
    my $result = $set[0]^$set[1]^$set[2]^$set[3]^$set[4]^$set[5]^$set[6]^$set[7]^$set[8]^$set[9]^$set[10]^$set[11]^$set[12]^$set[13]^$set[14]^$set[15]^$set[16];
    push (@dense,$result);
    $curr+=16;
  }
  #print "---\n";
  #print "Dense set: @dense\n";
  #print "---\n";

  my $hexstr;

  for (my $i=0; $i<@dense; $i++) {
    my $hex = sprintf("%X",$dense[$i]);
    $hex = "0$hex" if (length($hex)<2);
    #print "$dense[$i]: $hex\n";
    $hexstr .= $hex;
  }
  #print "Hex string: $hexstr\n";

  return $hexstr;
}

sub HtoB {
  my $ch = shift();
  my $bin;

  if ($ch eq "0") {
    $bin = "0000";
  } elsif ($ch eq "1") {
    $bin = "0001";
  } elsif ($ch eq "2") {
    $bin = "0010";
  } elsif ($ch eq "3") {
    $bin = "0011";
  } elsif ($ch eq "4") {
    $bin = "0100";
  } elsif ($ch eq "5") {
    $bin = "0101";
  } elsif ($ch eq "6") {
    $bin = "0110";
  } elsif ($ch eq "7") {
    $bin = "0111";
  } elsif ($ch eq "8") {
    $bin = "1000";
  } elsif ($ch eq "9") {
    $bin = "1001";
  } elsif ($ch eq "A") {
    $bin = "1010";
  } elsif ($ch eq "B") {
    $bin = "1011";
  } elsif ($ch eq "C") {
    $bin = "1100";
  } elsif ($ch eq "D") {
    $bin = "1101";
  } elsif ($ch eq "E") {
    $bin = "1110";
  } elsif ($ch eq "F") {
    $bin = "1111";
  }

  return $bin;
}

sub Scan {
  my $x = shift();
  my $y = shift();
  my $grp = shift();
  my %grid = %{ shift() };

  print "Checking ($x,$y) for group $grp.\n";
  $grid{$x}{$y}{group} = $grp;
  print "($x+1,$y) : $grid{$x+1}{$y} $grid{$x+1}{$y}{group}\n";
  if ($x<255 && $grid{$x+1}{$y}==1 && $grid{$x+1}{$y}{group}==0) {
    print "I got to x+1.\n";
    %grid = Scan($x+1,$y,$grp,\%grid);
  }
  if ($y<255 && $grid{$x}{$y+1}==1 && $grid{$x}{$y+1}{group}==0) {
    print "I got to y+1.\n";
    %grid = Scan($x,$y+1,$grp,\%grid);
  }
  if ($x>1 && $grid{$x-1}{$y}==1 && $grid{$x-1}{$y}{group}==0) {
    print "I got to x-1.\n";
    %grid = Scan($x-1,$y,$grp,\%grid);
  }
  if ($y>1 && $grid{$x}{$y-1}==1 && $grid{$x}{$y-1}{group}==0) {
    print "I got to y-1.\n";
    %grid = Scan($x,$y-1,$grp,\%grid);
  }
  return %grid;
}
