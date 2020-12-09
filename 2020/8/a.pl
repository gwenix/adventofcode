#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

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

my $total = RunProgram(@lines);

print "End value: $total\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub RunProgram {
  my %visited;
  return Execute(0, 0, \%visited, @_);
}

sub Execute {
  my $tot = shift();
  my $pos = shift();
  my %visited = %{ shift() };
  my @inst = @_;

  return $tot if ($visited{$pos});
  $visited{$pos}=1;
  my $curr = $inst[$pos];

  my ($cmd,$val) = split / /, $curr;

  if ($cmd eq "acc") {
    $tot += $val;
    $pos++;
  } elsif ($cmd eq "jmp") {
    $pos += $val;
  } elsif ($cmd eq "nop") {
    $pos++;
  } else {
    die "Invalid command: $cmd\n";
  }

  return Execute($tot, $pos, \%visited, @inst);
}
