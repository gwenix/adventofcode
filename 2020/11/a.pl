#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";
my %GRID;

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

InitializeGrid(@lines);

my $done=0;

DrawGrid();
print "\n";

while (!$done) {
  $done=SeatPeople();
}

DrawGrid();
print "\n";

my $count=CountSeats();

print "There are $count seats filled.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub CountSeats {
  my $count=0;
  for(my $i=0; $i<$GRID{length}; $i++) {
    for (my $j=0; $j<$GRID{width}; $j++) {
      $count++ if ($GRID{$i}{$j}{seat});
    }
  }
  return $count;
}

sub SeatPeople {

  my %newgrid;

  for(my $i=0; $i<$GRID{length}; $i++) {
    for (my $j=0; $j<$GRID{width}; $j++) {
      if($GRID{$i}{$j}{isSeat}) {
	$newgrid{$i}{$j}{seat}=ToggleSeat($i,$j);
      }
    }
  }

  my $done=1;
  foreach my $i (keys %newgrid) {
    foreach my $j (keys %{ $newgrid{$i} }) {
      if ($newgrid{$i}{$j}{seat} != $GRID{$i}{$j}{seat}) {
	$done=0;
	$GRID{$i}{$j}{seat}=$newgrid{$i}{$j}{seat};
      }
    }
  }
  return $done;
}

sub ToggleSeat {
  my ($x, $y) = @_;

  my $starti=$x-1;
  $starti=0 if ($starti<0);
  my $endi=$x+2;
  $endi=$GRID{length} if ($endi>$GRID{length});
  my $startj=$y-1;
  $startj=0 if ($startj<0);
  my $endj=$y+2;
  $endj=$GRID{width} if ($endj>$GRID{width});

  my $count=0;

  for(my $i=$starti; $i<$endi; $i++) {
    for(my $j=$startj; $j<$endj; $j++) {
      $count += CheckSeat($i,$j) unless ($i==$x && $j==$y);
    }
  }
  #print "$x,$y: Count: $count\n";

  return 1 if ($count==0);
  return 0 if ($count>3 && $GRID{$x}{$y}{seat});

  return $GRID{$x}{$y}{seat};
}

sub CheckSeat {
  my ($i, $j) = @_;

  return 0 unless ($GRID{$i}{$j}{isSeat});
  return 1 if ($GRID{$i}{$j}{seat});
  return 0;
}

sub InitializeGrid {
  my @lines = @_;

  my $length=@lines;
  my $width;

  for(my $i=0; $i<@lines; $i++) {
    my @space = split //, $lines[$i];
    for (my $j=0; $j<@space; $j++) {
      if($space[$j] eq ".") {
	$GRID{$i}{$j}{isSeat}=0;
      } elsif ($space[$j] eq "L") {
	$GRID{$i}{$j}{isSeat}=1;
	$GRID{$i}{$j}{seat}=0;
      } elsif ($space[$j] eq "#") {
	$GRID{$i}{$j}{isSeat}=1;
	$GRID{$i}{$j}{seat}=1;
      } else {
	die "Invalid space: $space[$j]\n";
      }
      $width=$j+1;
    }
  }
  $GRID{length}=$length;
  $GRID{width}=$width;
}

sub DrawGrid {
  for(my $i=0; $i<$GRID{length}; $i++) {
    my @yaxis = keys %{ $GRID{$i} };;
    for(my $j=0; $j<$GRID{width}; $j++) {
      if ($GRID{$i}{$j}{isSeat}) {
	if (CheckSeat($i,$j)) {
	  print "#";
	} else {
	  print "L";
	}
      } else {
	print ".";
      }
    }
    print "\n";
  }
}
