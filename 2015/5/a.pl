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

my $total=0;

foreach my $l (@lines) {
  if (isNice($l)) {
    $total++;
    print "$l is Nice\n";
  } else {
    print "$l is Naughty\n";
  }
}

print "There are $total Nice strings.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub isNice {
  my $str = shift();

  return 0 unless (hasThreeVowels($str));

  return 0 unless (hasDoubleChar($str));

  return 0 if (hasInvalidStrings($str));

  return 1;
}

sub hasInvalidStrings {
  my $str = shift();

  return 1 if ($str =~ m/ab/);
  return 1 if ($str =~ m/cd/);
  return 1 if ($str =~ m/pq/);
  return 1 if ($str =~ m/xy/);

  return 0;
}

sub hasDoubleChar {
  my $str = shift();

  my @ch=split //, $str;

  my $last=$ch[0];
  
  for (my $i=1; $i<@ch; $i++) {
    return 1 if ($ch[$i] eq $last);
    $last=$ch[$i];
  }

  return 0;
}

sub hasThreeVowels {
  my $str = shift();

  my @ch=split //, $str;

  my $vowels;

  foreach my $c (@ch) {
    $vowels++ if ($c eq "a" || $c eq "e" || $c eq "i" || $c eq "o" || $c eq "u");
  }

  return 1 if ($vowels>=3);
  return 0;
}
