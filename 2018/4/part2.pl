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
$maxg{max}=0;

for(my $i=0; $i<60; $i++) {
  my $currmax=0;
  my $currg;
  foreach my $g (keys %guard) {
    if ($guard{$g}{$i}>$currmax) {
      $currmax=$guard{$g}{$i};
      $currg = $g;
    }
  }
  if ($currmax>$maxg{max}) {
    $maxg{max}=$currmax;
    $maxg{min}=$i;
    $maxg{guard}=$currg;
  }
}

my $ans = $maxg{guard} * $maxg{min};
print "Guard $maxg{guard} slept the most on minute $maxg{min}. Answer: $ans\n";
