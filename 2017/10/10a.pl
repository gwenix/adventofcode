#!/usr/bin/perl

my $inf = "input";
my $fin = 256;
my $test;
$test=0;

if ($test) {
  $inf = "test.input";
  $fin = 5;
}

open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my @length = split /\,/,$lines[0];

my %list;

for (my $i=0; $i<$fin; $i++) {
  $list{$i}{num} = $i;
  $list{$i}{next}=$i+1;
  $list{$i}{next}=0 if ($i==$fin-1);
}

my $curr=0;
my $skip=0;
for (my $i=0; $i<@length; $i++) {
  print "Starting at $curr place\n";
  my $l = $length[$i];
  my @set;
  my $k = $curr;
  for (my $j=0; $j<$l; $j++) {
    print "Adding $list{$k}{num} to the set.\n ";
    $set[$j]=$list{$k}{num};
    $k = $list{$k}{next};
  }
  $k=$curr;
  for (my $j=$l-1; $j>=0; $j--) {
    print "putting $set[$j] in $k place replacing $list{$k}{num}.\n ";
    $list{$k}{num}=$set[$j];
    $k = $list{$k}{next};
  }
  for (my $i=0; $i<$l+$skip; $i++) {
    $curr = $list{$curr}{next};
  }
  $skip++;
}

for (my $i=0; $i<$fin; $i++) {
  print "$list{$i}{num} ";
}
print "\n";

my $ans = $list{0}{num} * $list{1}{num};
print "Answer: $ans\n";
