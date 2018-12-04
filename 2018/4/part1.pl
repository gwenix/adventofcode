#!/usr/bin/perl

use strict;

# Note: I used Excel to initially sort the dates on the input
# in the process, I reparsed into a csv format
# So it's Date Time, Guard action
my $input = "input";
open (F, "$input") or die "Cannot open $input: $!\n";
my @lines = <F>;
close(F);

my $currguard;
my $passout;
my %guard;

for(my $i=0; $i<@lines; $i++) {
  my ($ts, $action) = split /,/, $lines[$i];

  if ($action =~ /Guard/) {
    my @data = split / /, $action;
    $currguard = $data[1];
    $currguard =~ s/\#//;
  } elsif ($action =~ /asleep/) {
    my ($garbage, $min) = split /:/, $ts;
    $passout = $min;
  } elsif ($action =~ /wakes/) {
    my ($garbage, $min) = split /:/, $ts;
    for(my $m=$passout; $m<$min; $m++) {
      $guard{$currguard}{$m}++;
      $guard{$currguard}{total}++;
    }
  }
}

my %maxg;
$maxg{total}=0;

foreach my $curr (keys %guard) {
  my %currguard = %{ $guard{$curr} };
  if ($currguard{total}>$maxg{total}) {
    %maxg = %currguard;
    $maxg{guard}=$curr;
  }
}

$maxg{maxmin}=0;

for(my $i=0; $i<60; $i++) {
  if ($maxg{$i}>$maxg{maxmin}) {
    $maxg{maxmin}=$maxg{$i};
    $maxg{bigmin}=$i;
  }
}

my $ans = $maxg{guard} * $maxg{bigmin};
print "Guard $maxg{guard} slept the most on minute $maxg{bigmin}. Answer: $ans\n";
