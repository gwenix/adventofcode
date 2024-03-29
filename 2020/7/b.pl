#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";
my $mybag = shift();

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my %bags;

foreach my $l (@lines) {
  my @foo = split / contain /, $l;
  my $container = $foo[0];
  $container =~ s/ bags$//;
  $bags{$container}{exists}=1;

  my $contained = $foo[1];

  @foo = split /, /, $contained;

  foreach my $b (@foo) {
    my @bar = split / /, $b;
    my $num = shift (@bar);
    pop(@bar); # removing "bag(s)(.)"
    my $bag = join " ", @bar;

    if ($bag eq "other") {
      $bags{$container}{empty}=1;
    } else {
      $bags{$bag}{exists}=1;
      $bags{$container}{contains}{$bag}=$num;
      $bags{$bag}{containedby}{$container}=1;
    }
  }
}

#print Dumper(\%bags);

my $total=totalBags($mybag,\%bags);

print "$mybag needs $total bags.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub totalBags {
  my $bag = shift();
  my %bags = %{ shift() };

  my $total=0;

  return 0 if ($bags{$bag}{empty});
  foreach my $next (keys %{ $bags{$bag}{contains}} ) {
    $total += $bags{$bag}{contains}{$next}*bagNeeds($next,\%bags);
  }
  return $total;
}

sub bagNeeds {
  my $bag = shift();
  my %bags = %{ shift() };
  my $total=1;

  return 1 if ($bags{$bag}{empty});
  foreach my $next (keys %{ $bags{$bag}{contains}} ) {
    $total += $bags{$bag}{contains}{$next}*bagNeeds($next,\%bags);
  }
  return $total;
}

sub TraverseUp {
  my $b = shift();
  my %bags = %{ shift() };
  my %found = %{ shift() };

  my @containers = keys %{ $bags{$b}{containedby} };

  return \%found unless (@containers);

  foreach my $c (@containers) {
    $found{$c}=1;
    %found = %{ Traverse($c, \%bags, \%found) };
  }

  return \%found;
}

sub ContainedIn {
  my $b = shift();
  my %bags = %{ shift() };

  my %contents;
  %contents = %{ Traverse($b, \%bags, \%contents) };

  my @found = keys %contents;

  my $num = @found;

  return $num;
}

sub findTopBags {
  my %bags = %{ shift() };
  my @out;

  foreach my $bag (keys %bags) {
    push (@out, $bag) unless ($bags{$bag}{containedby});
  }

  return @out;
}

