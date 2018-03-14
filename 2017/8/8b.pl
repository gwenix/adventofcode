#!/usr/bin/perl

my $inf = "input";
#my $inf = "sort.input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my $largest;
my %data;

foreach my $l (@lines) {
  chomp($l);
  print "$l: ";
  my ($creg, $inc, $cnum, $if, $treg, $cond, $tnum) = split / /, $l;

  die "Bad format\n" if ($if ne "if");

  if ($inc eq "inc") {
    $inc = 1;
  } else {
    $inc = 0;
  }

  if ($cond eq "<" && $data{$treg} < $tnum) {
    if ($inc) {
      $data{$creg} += $cnum;
    } else {
      $data{$creg} -= $cnum;
    }
  } elsif ($cond eq ">" && $data{$treg} > $tnum) {
    if ($inc) {
      $data{$creg} += $cnum;
    } else {
      $data{$creg} -= $cnum;
    }
  } elsif ($cond eq "<=" && $data{$treg} <= $tnum) {
    if ($inc) {
      $data{$creg} += $cnum;
    } else {
      $data{$creg} -= $cnum;
    }
  } elsif ($cond eq ">=" && $data{$treg} >= $tnum) {
    if ($inc) {
      $data{$creg} += $cnum;
    } else {
      $data{$creg} -= $cnum;
    }
  } elsif ($cond eq "==" && $data{$treg} == $tnum) {
    if ($inc) {
      $data{$creg} += $cnum;
    } else {
      $data{$creg} -= $cnum;
    }
  } elsif ($cond eq "!=" && $data{$treg} != $tnum) {
    if ($inc) {
      $data{$creg} += $cnum;
    } else {
      $data{$creg} -= $cnum;
    }
  }
  print "$creg now $data{$creg}\n";
  $largest = $data{$creg} if ($data{$creg} > $largest);
}

print "Largest value: $largest\n";

