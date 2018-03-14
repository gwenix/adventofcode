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
    $w = SortChars($w);
    $wh{$w}++;
    if ($wh{$w}>1) {
      $check=1;
    } 
    print "\n";
  } 

  $tot++ unless ($check);
}

print "Valid passphrases: $tot\n";

# ----------- #
# Subroutines #
# ----------- #

sub SortChars {
  my $w = shift();

  my @chars = split //, $w;
  my @sortedch = sort @chars;

  $w = join("", @sortedch);
  return $w;
}
