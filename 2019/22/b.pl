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

my $deck_count=shift(@lines);
my $report_position=pop(@lines);
my @commands = @lines;

my @deck;

# create the deck;
for(my $i=0; $i<$deck_count; $i++) {
  $deck[$i]=$i;
}

for(my $i=0; $i<@commands; $i++) {
  @deck=Parse_Command(@deck, $commands[$i]);
}

Print_Deck(@deck);

for (my $i=0; $i<@deck; $i++) {
  if ($deck[$i]==$report_position) {
    $report_position=$i;
    $i=@deck;
  }
}

print "Result: $report_position\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Print_Deck {
  my @deck = @_;

  print "Current deck:\n";
  for(my $i=0; $i<@deck; $i++) {
    print $deck[$i];
    if (($i+1)%16==0) {
      print "\n";
    } else {
      print " ";
    }
  }
  print "\n";
}

sub Deal_Deck {
  my @deck=@_;
  my $increment=pop(@deck);
  my $last=@deck;
  my @newdeck;
  my $pos=0;
  
  for (my $i=0; $i<$last; $i++) {
    $newdeck[$pos]=$deck[$i];
    $pos+=$increment;
    if ($pos>=$last) {
      $pos-=$last;
    }
  }
  return @newdeck;
}

sub Restack_Deck {
  my @olddeck = @_;
  my @newdeck;

  while (@olddeck) {
    unshift(@newdeck, shift(@olddeck));
  }

  return @newdeck;
}

sub Cut_Deck {
  my @deck=@_;
  my $cut_num=pop(@deck);

  for(my $i=0;$i<abs($cut_num); $i++) {
    if ($cut_num>0) {
      my $dummy = shift(@deck);
      push(@deck, $dummy);
    } else {
      my $dummy = pop(@deck);
      unshift(@deck, $dummy);
    }
  }
  return @deck;
}

sub Parse_Command {
  my @deck = @_;
  my $cmd = pop(@deck);

  my @foo = split / /, $cmd;
  my $code = pop(@foo);
  undef @foo;

  if ($cmd =~ m/deal with increment/) {
    @deck = Deal_Deck(@deck, $code);
  } elsif ($cmd =~ m/deal into new stack/) {
    @deck = Restack_Deck(@deck);
  } elsif ($cmd =~ m/cut/) {
    @deck = Cut_Deck(@deck, $code);
  } else {
    die "Cannot understand $cmd\n";
  }
  
  return @deck;
}
