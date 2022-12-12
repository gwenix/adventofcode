#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

our %monkey;
# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

# initializing
while (@lines) {
  my $monkeyl = shift (@lines);
  my $startl = shift (@lines);
  my $operl = shift (@lines); 
  my $testl = shift (@lines);
  my $truel = shift (@lines);
  my $falsel = shift (@lines);
  shift(@lines) if (@lines); # throwaway line

  # which monkey are we on
  my ($dummy, $curr) = split / /, $monkeyl;
  $curr =~ s/\://;

  # what starting items
  my ($foo, $bar) = split /:/, $startl;

  my @foo = split /,/, $bar;
  foreach (@foo) {
   $_=~s/ //;
   push(@{$monkey{$curr}{items}}, $_);
  }

  # operation assignation
  ($foo, $bar) = split /:/, $operl;
  $bar =~ s/^ //;
  $monkey{$curr}{oper}=$bar;

  # test init
  @foo = split / /, $testl;
  $monkey{$curr}{divtest}=$foo[5];
  
  # where to go if true
  @foo = split / /, $truel;
  $monkey{$curr}{true}=$foo[9];

  # where to go if false
  @foo = split / /, $falsel;
  $monkey{$curr}{false}=$foo[9];
}

for(my $i=0; $i<20; $i++) {
  Round();
}

my $tot = FindTopTwo();

print "Result: $tot\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub FindTopTwo {
  my @top=(0,0);
  foreach my $mky (sort {$a <=> $b} keys %monkey) {
    my $insp = $monkey{$mky}{inspect};
    if ($insp>$top[0]) {
      $top[1]=$top[0];
      $top[0]=$insp;
    } elsif ($insp>$top[1]) {
      $top[1]=$insp;
    }
  }

  return ($top[0]*$top[1]);
}

sub PrintInspections {
  foreach my $mky (sort {$a <=> $b} keys %monkey) {
    print "Monkey $mky: ";
    my $insp = $monkey{$mky}{inspect};
    print "$insp\n";
  }
}

sub PrintItems {
  foreach my $mky (sort {$a <=> $b} keys %monkey) {
    print "Monkey $mky: ";
    foreach my $item ( @{ $monkey{$mky}{items} } ) {
      print "$item ";
    }

    print "\n";
  }
}

sub Round {
  foreach my $mky (sort {$a <=> $b} keys %monkey) {
    #print "Monkey $mky\n";
    while ( @{ $monkey{$mky}{items} } ) {
      my $item = shift( @{  $monkey{$mky}{items} } );

      #print "  Monkey inspects an item with a worry level of $item\n";
      $item=Operation($item,$monkey{$mky}{oper});
      #print "    Item becomes $item\n";
      $item = int($item/3);
      #print "    Monkey bored. Item divided by 3 to $item\n";
      my $test = DivTest($item,$monkey{$mky}{divtest});
      #print "    Item divisble by $monkey{$mky}{divtest}? $test\n";
      my $throwto=$monkey{$mky}{false};  
      $throwto=$monkey{$mky}{true} if ($test);  
      #print "    Item $item thrown to $throwto\n";
      push( @{ $monkey{$throwto}{items} }, $item);

      $monkey{$mky}{inspect}++;
    }
  }

}

sub DivTest {
   my $item=shift();
   my $div = shift();

   return 1 if ($item%$div==0);
   return 0;
}

sub Operation {
  my $old = shift();
  my $str = shift();
  my $new;

  $str =~ s/^ //;

  my @foo = split / /, $str;
  my $op = $foo[3];
  my $c = $foo[4];
  $c=$old if ($c eq 'old');

  if ($op eq '+') {
    $new = $old+$c;
  } elsif ($op eq '-') {
    $new = $old-$c;
  } elsif ($op eq '*') {
    $new = $old*$c;
  } else {
    die "Unknown operator $op \n";
  } 

  return $new;
}
