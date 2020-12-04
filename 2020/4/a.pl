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

my @passport;
my $arri=0;

# Storing the passport info
for(my $i=0; $i<@lines; $i++) {
  if ($lines[$i]=~m/^\s*$/) {
    $arri++;
  } else {
    my @foo = split / /, $lines[$i];
    foreach my $pair (@foo) {
      my ($key,$val) = split /:/,$pair;
      $passport[$arri]{$key}=$val;
    }
  }
}

# Finding valid passports
my $valid=0;
foreach my $pref (@passport) {
  my %pp = %{ $pref };
  if ( $pp{byr} && $pp{iyr} && $pp{eyr} && $pp{hgt}
	&& $pp{hcl} && $pp{ecl} && $pp{pid} ) {
    $valid++;
  } 
}

print "There are $valid valid passports.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #
