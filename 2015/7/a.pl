#!/usr/bin/perl

use strict;
use warnings;
use integer;

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

my %wires;

foreach my $l (@lines) {
  my ($cmd, $wire) = split / -> /, $l;
  $wires{$wire}{cmd}=$cmd;
  my @foo = split / /, $cmd;

  my $len = @foo;

  my $invalidstr="Invalid cmd: $cmd\n";

  my $value;
  # error checking the input and finding the top wires
  if ($len==1) {
    die $invalidstr unless ($foo[0] =~ m/^\d*$/);
    $value = $foo[0];
  } elsif ($len==2) {
    die $invalidstr unless ($foo[0] eq "NOT"); 
    my $a = int($wires{$foo[1]}{value});
    print "$cmd: $a becomes ";
    $value = NOT($a);
    print "$value\n";
  } elsif ($len==3) {
    my ($a, $b) = ($wires{$foo[0]}{value}, $wires{$foo[2]}{value});
    if ($foo[1] eq "AND") {
      $value = $a & $b;
    } elsif ($foo[1] eq "LSHIFT") {
      $value = $a << $b;
    } elsif ($foo[1] eq "RSHIFT") {
      $value = $a >> $b;
    } elsif ($foo[1] eq "OR") {
      $value = $a | $b;
    } else {
      die $invalidstr;
    }
  } else {
    die $invalidstr;
  }

  $wires{$wire}{value}=$value;
}

PrintWires(\%wires);

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub NOT {
  my $a = BITS( shift() );
  my $b;

  my @foo = split //, $a;
  for (my $i=0; $i<@foo; $i++) {
    if ($foo[$i]) {
      $foo[$i]=0;
    } else {
      $foo[$i]=1;
    }
  }

  $b=BIT2INT( join("", @foo) );

  return $b;
}

sub BIT2INT {
  my $a = shift();
  my $b=0;
  
  my @foo = split //, $a;
  for(my $i=0; $i<@foo; $i++) {
    $b+=$foo[$i]*2;
  }
  return $b;
}

sub BITS {
  my $a = shift();
  my $b;
  my @foo;

  while ($a>0) {
    my $tmp = $a%2;
    unshift(@foo, $tmp);
    $a-- if ($tmp);
    $a = $a/2;
  }

  while (@foo < 8) {
    unshift(@foo, "0");
  }

  $b = join "", @foo;

  return $b;
}

sub PrintWires {
  my %wires = %{ shift() };

  foreach my $w (sort keys %wires) {
    print "$w: $wires{$w}{value}\n";
  }
}

