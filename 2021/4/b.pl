#!/usr/bin/perl

use strict;
#use warnings;
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

my @numbers = split /,/, shift(@lines);;
our %BINGO = %{ CreateBingoCards(@lines) };

my $win=0;
my $round=0;

while (!$win && @numbers) {
  my $drawn_num = shift(@numbers);
  my $cards=$BINGO{quantity};

  $round++;
  for (my $c=0; $c<$cards && !$win; $c++) {
    $win=CheckNumber($c,$drawn_num);
    if ($win) {
      $BINGO{winner} = WinTotal($c,$drawn_num);
    }
  }
}

PrintCards();

print "Winning total: $BINGO{winner}\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub WinTotal {
  my $card = shift();
  my $num = shift();

  my $cardtotal = CardTotal($card);
  return ($cardtotal*$num);
}

sub CardTotal {
  my $c = shift();
  my $tot=0;

  for (my $i=0; $i<5; $i++) {
    for (my $j=0; $j<5; $j++) {
      my $curr=0;
      $curr=$BINGO{$c}{$i}{$j}{num} unless ($BINGO{$c}{$i}{$j}{hit});
      $tot+=$curr;
    }
  }
  return $tot;
}

sub PrintCards {
  for (my $card=0; $card<$BINGO{quantity}; $card++) {
    for (my $j=0; $j<5; $j++) {
      for (my $i=0; $i<5; $i++) {
        if ($BINGO{$card}{$i}{$j}{hit}) {
	  print " X ";
	} else {
	  my $num = $BINGO{$card}{$i}{$j}{num};
	  if (length($num)<2) {
	    print " $num ";
	  } else {
	    print "$num ";
	  }
	}
      }
      print "\n";
    }
    print "\n";
  }
}

sub CheckNumber {
  my $card = shift();
  my $num = shift();
  my $win=0;

  return 0 if ($BINGO{$card}{won});

  for (my $i=0; $i<5; $i++) {
    for (my $j=0; $j<5; $j++) {
      my $check = $BINGO{$card}{$i}{$j}{num};
      if ($check==$num) {
	$win=NumberHit($card,$num,$i,$j);
	if ($win) {
	  $BINGO{$card}{won}=1;
	  $BINGO{won}++;
	  return 1 if ($BINGO{won} == $BINGO{quantity});
	}
      }
    }
  }
  return 0;
}

sub NumberHit {
  my $card = shift();
  my $num = shift();
  my $x = shift();
  my $y = shift();
  my $win=0;

  $BINGO{$card}{$x}{$y}{hit}=1;

  $win=CheckRow($card,$x);
  return 1 if ($win);

  $win=CheckCol($card,$y);
  return $win;
}

sub CheckRow {
  my $card=shift();
  my $row=shift();

  for(my $i=0; $i<5; $i++) {
    return 0 unless ($BINGO{$card}{$row}{$i}{hit});
  }

  return 1;
}

sub CheckCol {
  my $card=shift();
  my $col=shift();

  for(my $i=0; $i<5; $i++) {
    return 0 unless ($BINGO{$card}{$i}{$col}{hit});
  }

  return 1;
}

sub CreateBingoCards {
  my @lines = @_;
  my %card;

  my $count=-1;
  my $y=0;
  for (my $i=0; $i<@lines; $i++) {
    my $curr = $lines[$i];
  
    if ($curr eq "") {
      $count++;
      $y=0;
    } else {
      $curr =~ s/  / /g;
      $curr =~ s/^ //g;
      my @num = split / /,$curr;
      my $x=0;
      for(my $j=0; $j<@num; $j++) {
        $card{$count}{$x}{$y}{num}=$num[$j];
        $card{$count}{$x}{$y}{hit}=0;
        $x++;
      }
      $y++;
    }
  }
  $card{quantity}=$count+1;
  return \%card;
}
