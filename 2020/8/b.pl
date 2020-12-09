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
my @orig = <F>;
chomp @orig;
close (F);

my @NopOrJmp;
my $total;

for(my $i=0; $i<@orig; $i++) {
  if ($orig[$i] =~ m/nop/ || $orig[$i] =~ m/jmp/) {
    push (@NopOrJmp, $i);
  }
}

my $notdone=1;

while ($notdone) {
  if (@NopOrJmp) {
    my $pos=shift(@NopOrJmp);

    my @fix=Toggle($pos, @orig);
    $total=RunProgram(@fix);
    $notdone=0 unless ($total eq "FAIL");
  } else {
    $notdone=0;
  }
}


print "End value: $total\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Toggle {
  my $pos = shift();
  my @inst = @_;

  my $curr = $inst[$pos];

  if ($curr =~ m/nop/) {
    $curr =~ s/nop/jmp/;
  } else {
    $curr =~ s/jmp/nop/;
  }

  $inst[$pos] = $curr;

  return @inst;
}

sub RunProgram {
  my %visited;
  return Execute(0, 0, \%visited, @_);
}

sub Execute {
  my $tot = shift();
  my $pos = shift();
  my %visited = %{ shift() };
  my @inst = @_;

  return "FAIL" if ($visited{$pos});
  $visited{$pos}=1;
  return $tot unless ($inst[$pos]);
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
