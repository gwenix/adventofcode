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

foreach my $l (@lines) {
  my @chars = split //, $l;
  my $len = @chars;
  my $half = ($len-1)/2;

  my %sack;

  my $found=0;
  my $curr=0;

  while(!$found) {
    die "Something's wrong, copy not found.\n" if ($curr>$len);

    my $ch = $chars[$curr];
    #print "DEBUG: $ch";

    if ($curr<$half) {
      $sack{$ch}=1;
      #print "1";
      
    } else {
      #print "2";
      if ($sack{$ch}) {
        $found=$ch;
        $total += $priority{$ch};
        #print "found: $ch";
      }
    }
    #print "\n";

    $curr++;
  }

}

print "Total: $total\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

