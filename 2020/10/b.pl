#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";
my %SEEN;

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my @plugs = sort {$a <=> $b} @lines;
my $sz = @plugs;
my $INPUT = $plugs[$sz-1] + 3;
unshift(@plugs,0);
push(@plugs,$INPUT);

PrintPlugs(@plugs);
print "\n";
my $valid=CountValid(@plugs);

print "There are $valid valid arrangements.\n";
exit; 

# ----------- #
# Subroutines #
# ----------- #

sub CountValid {
  my @p = @_;
  my @sets;
  my $valid=0;

  for(my $i=0; $i<(@p-1); $i++) {
    my @set;
    my $curr = $p[$i];
    my $next = $p[$i+1];
    my $setnext=0;
    while (($next-$curr)<3 && $i<(@p-1)) {
      $setnext=1;
      #print "$curr $next\n";
      push (@set, $curr);
      $i++;
      $curr=$p[$i];
      $next=$p[$i+1];
    }
    if ($setnext) {
      push (@set, $curr);
    }
    push (@sets, \@set);
  }

  $valid = CountSets(@sets);

  return $valid;
}

sub CountSets {
  my @arr=@_;
  my $tot=1;

  foreach my $s (@arr) {
    my @sub = @{ $s };
    my $valid=1;
    PrintArr(@sub);
    $valid = Validate($valid, @sub);
    print "\t has $valid valid sets.\n";
    $tot *= $valid;
  }

  return $tot;
}

sub PrintArr {
  for(my $i=0; $i<@_; $i++) {
    print "$_[$i] ";
  }
  print "\n";
}

sub makeSeen {
  my $str = join "a", @_;

  $SEEN{$str}=1;
}

sub wasSeen {
  my $str = join "a", @_;
  return 1 if ($SEEN{$str});

  makeSeen(@_);
  return 0;
}

sub Validate {
  my $valid=shift();
  my $first=shift();
  my $last=pop();
  my @p = @_;

  my $length=@p;

  for(my $i=0; $i<@p; $i++) {
    my @tmp=@p;
    my $curr = splice(@tmp, $i, 1);
    my $isvalid += ValidArrangement($first,@tmp,$last);
    if ($isvalid) {
      $valid++;
      $valid = Validate($valid,$first,@tmp,$last);
    }
  }

  return $valid;
}

sub ValidArrangement {
  my @arr = @_;

  #PrintArr(@arr);
  my $last = shift(@arr);

  return 0 if (wasSeen(@_));

  return 0 unless (@arr);

  for(my $i=0; $i<@arr; $i++) {
    my $diff = $arr[$i]-$last;
    return 0 if ($diff>3);
    $last=$arr[$i];
  }

  return 1;
}

sub PrintPlugs {
  my @p = @_;

  print "(0), ";
  for(my $i=0; $i<@p; $i++) {
    print "$p[$i], ";
  }
  print "($INPUT)";
}
