#!/usr/bin/perl

use strict;
use warnings;
use Digest::MD5 qw(md5_hex);

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


foreach my $l (@lines) {
  my $done=0;
  for (my $i=0; !$done; $i++) {
    my $curr = $l.$i;
    my $md5 = md5_hex($curr);

    $done=$i if ($md5 =~ m/^00000/);
  }
  print "$l MD5 Hash at $done\n";
}



exit; 

# ----------- #
# Subroutines #
# ----------- #
