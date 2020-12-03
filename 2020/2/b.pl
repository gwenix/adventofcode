#!/usr/bin/perl

use strict;
use warnings;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my $pw_pass=0;

foreach my $l (@lines) {
  my ($rule,$pw) = split /:/,$l;
  $pw =~ s/^ //;

  #print "Rule: $rule, Password: $pw\n";

  my ($range,$ch) = split / /, $rule;
  my ($lo,$hi) = split /-/, $range;

  my @chars = split //, $pw;

  my $check=0;
  print "Password \"$pw\" with rule $rule has ";
  for(my $i=0; $i<@chars; $i++) {
    my $humani=$i+1;
    if( ($humani==$lo || $humani==$hi) && $chars[$i] eq $ch ) {
      $check++;
    }
  }
  print "$check checks.\n";

  $pw_pass++ if ($check==1);
}

print "There are $pw_pass correct passwords.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #
