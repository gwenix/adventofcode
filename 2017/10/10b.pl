#!/usr/bin/perl

my $inf = "input";
$inf = "test.input";
my $fin = 256;
my $test;

my @adds = (17, 31, 73, 47, 23);


open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

chomp($lines[0]);

my @length = split //,$lines[0];

for (my $i=0; $i<@length; $i++) {
  my $char = $length[$i];
  $length[$i] = ord($char);
}

push (@length, @adds);
print "Lengths: @length\n";

my %list;

# setting up a linked list
for (my $i=0; $i<$fin; $i++) {
  $list{$i}{num} = $i;
  $list{$i}{next}=$i+1;
  $list{$i}{next}=0 if ($i==$fin-1);
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
    for (my $i=0; $i<$l+$skip; $i++) {
      $curr = $list{$curr}{next};
    }
    $skip++;
  }
}

print "---\n";
print "End List: ";
for (my $i=0; $i<$fin; $i++) {
  print "$list{$i}{num} ";
}
print "\n";

print "---\n";
print "Sparse sets:\n";
my @dense;
my $curr=0;
while ($curr<$fin) {
  my @set;
  for (my $i=0; $i<16; $i++) {
    $set[$i] = $list{$curr+$i}{num};
  }
  print "@set\n";
  my $result = $set[0]^$set[1]^$set[2]^$set[3]^$set[4]^$set[5]^$set[6]^$set[7]^$set[8]^$set[9]^$set[10]^$set[11]^$set[12]^$set[13]^$set[14]^$set[15]^$set[16];
  push (@dense,$result);
  $curr+=16;
}
print "---\n";
print "Dense set: @dense\n";
print "---\n";

my $hexstr;

for (my $i=0; $i<@dense; $i++) {
  my $hex = sprintf("%X",$dense[$i]);
  $hex = "0$hex" if (length($hex)<2);
  #print "$dense[$i]: $hex\n";
  $hexstr .= $hex;
}
print "Hex string: $hexstr\n";
