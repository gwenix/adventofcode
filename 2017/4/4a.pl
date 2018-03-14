#!/usr/bin/perl

my $inf="input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my $tot=0;

foreach my $l (@lines) {
  my $check=0;
  my %wh;
  chomp($l);
  my @words = split / /,$l;

  foreach my $w (@words) {
    $wh{$w}++;
    $check=1 if ($wh{$w}>1);
  }

  $tot++ unless ($check);
}

print "Valid passphrases: $tot\n";
