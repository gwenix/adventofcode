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


while (!$done) {
  DrawGrid();
  print "\n";
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

  my $count=0;

  $count += SeeSeats($x,$y);

  #print "I see $count seats at $x,$y\n";


  return 1 if ($count==0);
  return 0 if ($count>4 && $GRID{$x}{$y}{seat});

  return $GRID{$x}{$y}{seat};
}

sub SeeSeats {
  my ($x, $y) = @_;
  
  my $count=0;
  $count+=CheckNorth($x,$y);
  $count+=CheckEast($x,$y);
  $count+=CheckSouth($x,$y);
  $count+=CheckWest($x,$y);

  $count+=CheckNorthEast($x,$y);
  $count+=CheckSouthWest($x,$y);
  $count+=CheckNorthWest($x,$y);
  $count+=CheckSouthEast($x,$y);

  return $count;
}

sub DebugPrintDir {
  my ($i, $j, $dir) = @_;

  #print "$dir($i,$j) ";
}

sub CheckNorthWest {
  my ($x, $y) = @_;

  my $done=0;
  my ($i,$j)=($x,$y);

  while(!$done) {
    $i--;
    $j--;

    if($i<0 || $j<0) {
      $done=1;
    } else {
      if($GRID{$i}{$j}{isSeat}) {
	my $chk = CheckSeat($i,$j);
 	DebugPrintDir($i,$j,"NW") if ($chk);
        return $chk;
      }
    }
  }

  return 0;
}

sub CheckNorthEast {
  my ($x, $y) = @_;

  my $done=0;
  my ($i,$j)=($x,$y);

  while(!$done) {
    $i--;
    $j++;

    if($i<0 || $j>=$GRID{width}) {
      $done=1;
    } else {
      if($GRID{$i}{$j}{isSeat}) {
	my $chk = CheckSeat($i,$j);
 	DebugPrintDir($i,$j,"NE") if ($chk);
        return $chk;
      }
    }
  }

  return 0;
}

sub CheckSouthWest {
  my ($x, $y) = @_;

  my $done=0;
  my ($i,$j)=($x,$y);

  while(!$done) {
    $i++;
    $j--;

    if($i>=$GRID{length} || $j<0) {
      $done=1;
    } else {
      if($GRID{$i}{$j}{isSeat}) {
	my $chk = CheckSeat($i,$j);
 	DebugPrintDir($i,$j,"SW") if ($chk);
        return $chk;
      }
    }
  }

  return 0;
}

sub CheckSouthEast {
  my ($x, $y) = @_;

  my $done=0;
  my ($i,$j)=($x,$y);

  while(!$done) {
    $i++;
    $j++;

    if($i>=$GRID{length} || $j>=$GRID{width}) {
      $done=1;
    } else {
      if($GRID{$i}{$j}{isSeat}) {
	my $chk = CheckSeat($i,$j);
 	DebugPrintDir($i,$j,"SE") if ($chk);
        return $chk;
      }
    }
  }

  return 0;
}

sub CheckSouth {
  my ($x, $y) = @_;

  for(my $i=$x+1; $i<$GRID{length}; $i++) {
    if($GRID{$i}{$y}{isSeat}) {
      my $chk = CheckSeat($i,$y);
      DebugPrintDir($i,$y,"S") if ($chk);
      return $chk;
    }
  }

  return 0;
}

sub CheckWest {
  my ($x, $y) = @_;

  for(my $j=$y-1; $j>=0; $j--) {
    if($GRID{$x}{$j}{isSeat}) {
      my $chk = CheckSeat($x,$j);
      DebugPrintDir($x,$j,"W") if ($chk);
      return $chk;
    }
  }

  return 0;
}

sub CheckNorth {
  my ($x, $y) = @_;

  for(my $i=$x-1; $i>=0; $i--) {
    if($GRID{$i}{$y}{isSeat}) {
      my $chk = CheckSeat($i,$y);
      DebugPrintDir($i,$y,"N") if ($chk);
      return $chk;
    }
  }

  return 0;
}

sub CheckEast {
  my ($x, $y) = @_;

  for(my $j=$y+1; $j<$GRID{width}; $j++) {
    if($GRID{$x}{$j}{isSeat}) {
      my $chk = CheckSeat($x,$j);
      DebugPrintDir($x,$j,"E") if ($chk);
      return $chk;
    }
  }

  return 0;
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
