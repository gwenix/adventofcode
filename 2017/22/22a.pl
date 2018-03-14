#!/usr/bin/perl

my $inf="input";
#$inf="test.input";

my $many=10000000;

open(F,$inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

Header("Initial Grid");

my %grid;

my $size = @lines;
$size = int($size/2);
my $x=0-$size;
for(my $i=0; $i<@lines; $i++) {
  my $l = $lines[$i];
  chomp($l);

  my @foo = split //,$l;
  my $y=0-$size;
  for(my $j=0; $j<@foo; $j++) {
    $grid{$x}{$y} = $foo[$j];;
    $grid{$x}{$y}{begin}=1 if($foo[$j] eq '#');
    $y++;
  }
  $x++;
}
undef $x;
$grid{size}=$size;

my @pos = (0, 0);

PrintGrid(\%grid, @pos);

my $numinfections=0;

Header("Movement");
my $dir=0; # 0 is north, 1 is east, 2 is south, 3 is west
for(my $iter=0; $iter<$many; $iter++) {
  # Check to see if infected
  my $state=$grid{$pos[0]}{$pos[1]};
  # Turn based on infection and Advance infection
  if ($state eq "#") {
    $dir = Turn($dir,"right");
    $grid{$pos[0]}{$pos[1]}="f";
  } elsif ($state eq "w") {
    $numinfections++ unless ($grid{$pos[0]}{$pos[1]}{begin});
    $grid{$pos[0]}{$pos[1]}="#";
  } elsif ($state eq "f") {
    $dir = Turn($dir,"reverse");
    $grid{$pos[0]}{$pos[1]}=".";
  } else {
    $dir = Turn($dir,"left");
    $grid{$pos[0]}{$pos[1]}="w";
  }
  # Move
  @pos = Move($dir,@pos);
  $grid{size}=abs($pos[0]) if (abs($pos[0])>$grid{size});
  $grid{size}=abs($pos[1]) if (abs($pos[1])>$grid{size});
  #PrintGrid(\%grid,@pos);
  print "Iteration $iter\n" if ($iter%100000==0);
}
print "\n";

Header("Final Grid");
#PrintGrid(\%grid,@pos);
print "$numinfections caused.\n";

# ----------- #
# Subroutines #
# ----------- #

sub Move {
  # remember rows are x and columns are y!
  # also it goes from - to + top to bottom
  my $dir=shift();
  my ($x, $y) = @_;

  if ($dir == 0) {
    # go north
    $x--;
  } elsif ($dir == 1) {
    # go east
    $y++;
  } elsif ($dir == 2) {
    # go south
    $x++;
  } elsif ($dir == 3) {
    # go west
    $y--;
  } else {
    die "Invalid direction: $!\n";
  }

  return ($x,$y);
}

sub Turn {
  my $currdir = shift();
  my $change = shift();

  if ($change eq "right") {
    $currdir++;
  } elsif ($change eq "left") {
    $currdir--;
  } elsif ($change eq "reverse") {
    $currdir+=2;
  } else {
    die "Invalid turn: $change\n";
  }
  $currdir = $currdir % 4;
  return $currdir;
}

sub PrintGrid {
  my %grid = %{ shift() };
  my ($currx, $curry) = @_;

  for(my $x=0-$grid{size}; $x<=$grid{size}; $x++) {
    for(my $y=0-$grid{size}; $y<=$grid{size}; $y++) {
      my $state = $grid{$x}{$y};
      $state = "." unless ($state);
      if ($currx == $x && $curry==$y) {
	if ($state eq "w") {
	  print "W";
	} elsif ($state eq "f") {
	  print "F";
	} elsif ($state eq "#") {
	  print "@";
	} else {
	  print "+";
	}
      } else {
	print $state;
      }
    }
    print "\n";
  }
  print "\n";
}


sub Header {
  my $str = shift();

  print "----- $str -----\n"
}
