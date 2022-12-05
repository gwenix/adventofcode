#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

my %priority = (
	a=>1, b=>2, c=>3, d=>4, e=>5, f=>6, g=>7, h=>8, i=>9, j=>10, k=>11,
	l=>12, m=>13, n=>14, o=>15, p=>16, q=>17, r=>18, s=>19, t=>20, 
	u=>21, v=>22, w=>23, x=>24, y=>25, z=>26, A=>27, B=>28, C=>29, 
	D=>30, E=>31, F=>32, G=>33, H=>34, I=>35, J=>36, K=>37, L=>38, 
	M=>39, N=>40, O=>41, P=>42, Q=>43, R=>44, S=>45, T=>46, U=>47, 
	V=>48, W=>49, X=>50, Y=>51, Z=>52, 
);

my $total=0;
# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my @elves;

for (my $i=0; $i<@lines; $i++) {
  my $o=$lines[$i];
  my $l=UniqItems($o);

  my $currElf = $i%3;
  #print "DEBUG: $currElf $o $l ";

  $elves[$currElf]=$l;
  
  if($currElf==2) {
    my $badge = FindBadge (@elves);
    $total += $priority{$badge};
  }
}

print "Total: $total\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub FindBadge {
  my %item;
  foreach my $elf (@_) {
    my @chars = split //, $elf;
    foreach my $ch (@chars) {
      $item{$ch}++;
      return $ch if ($item{$ch}==3);
    }
  }

  die "oops, shouldn't get here, badge not found.\n";
}

sub UniqItems {
  my $l = shift();

  my @chars = split //, $l;
  my %set;
  my $newstr;
  
  foreach my $ch (@chars) {
    unless ($set{$ch}) {
      $set{$ch}=1;
      $newstr .= $ch;
    }
  }

  return $newstr;
}
