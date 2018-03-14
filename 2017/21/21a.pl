#!/usr/bin/perl

my $inf="input";
$inf="test.input";

open(F,$inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

# initial grid
my $grid;
$grid=".#./..#/###";
my $prstr = PrintGrid($grid);
Header("Initial Grid");
print "String: $grid\n";
print "$prstr\n";

# Creating the match grids
Header("Creating the Match Grids.");
my %match;
my $i=0;
foreach my $l (@lines) {
  chomp($l);
  my @foo = split / => /, $l;
  my $instr = $foo[0];
  my $outstr = $foo[1];

  my $matchstr = $instr;
  print "$matchstr = $outstr\n";
  $match{$matchstr}=$outstr;

  # Rotate it three times
  $instr = RotateGrid($instr);
  $matchstr = $instr;
  print "$matchstr = $outstr\n";
  $match{$matchstr}=$outstr;

  $instr = RotateGrid($instr);
  $matchstr = $instr;
  print "$matchstr = $outstr\n";
  $match{$matchstr}=$outstr;

  $instr = RotateGrid($instr);
  $matchstr = $instr;
  print "$matchstr = $outstr\n";
  $match{$matchstr}=$outstr;
   
  $i++;
}

my $matchref=\%match;

Header("Converting the grid.");
for(my $iter=0; $iter<5; $iter++) {
  my $currref = StrToGrid($grid);
  $grid = Convert($currref,$matchref);
  print "Current grid: $grid\n";
}

Header("Final Grid");
my $prstr = PrintGrid($grid);
print "$prstr";

# ----------- #
# Subroutines #
# ----------- #

sub Convert {
  my $gridref = shift();
  my $matchref = shift();
  my %grid = %{ $gridref };
  my $size = $grid{size};
  my $gridstr = $grid{string};
  print "Converting....$gridstr of $size\n";

  my %grid;

  if ($size % 2 == 0) {
    my $div = $size / 2;
    if ($div == 1) {
      $gridstr = Match($gridstr, $matchref);
    } else {
      my @arr;
      for(my $j=0; $j<$size; $j++) {
        for (my $i=0; $i<$size; $i++) {
	  my $arri = int($i/2) + (2 * int($j/2));
	  my $x = $i % 2;
	  my $y = $j % 2;
	  $arr[$arri]{$x}{$y}=$grid{$i}{$j};
        }
      }
      for(my $i=0; $i<@arr; $i++) {
	my %currgrid = %{ $arr[$i] };
        $currgrid{string} = GridToStr(\%currgrid);
	my $arrstr = Convert(\%currgrid,$matchref);
        %currgrid = StrToGrid($arrstr);
        my $xfac = $i % $div;
        my $yfac = int($i/$div);
        foreach my $x (keys %currgrid) {
	  if ($x eq "string") {
	    # do nothing
	  } elsif ($x eq "size") {
	    $grid{size} += $currgrid{size};
	  } else {
	    foreach my $y (keys %{ $currgrid{$x} }) {
	      my $newX = $x+$xfac;
	      my $newY = $y+$yfac;
	      $grid{$newX}{$newY}=$currgrid{$x}{$y};
	    }
	  }
	}
      }
    }
  } elsif ($size % 3 == 0) {
    my $div = $size / 3;
    if ($div == 1) {
      $gridstr = Match($gridstr, $matchref);
    } else {
      my @arr;
      $gridstr = "";
      for(my $j=0; $j<$size; $j++) {
        for (my $i=0; $i<$size; $i++) {
	  my $arri = int($i/3) + (3 * int($j/3));
	  my $x = $i % 3;
	  my $y = $j % 3;
	  $arr[$arri]{$x}{$y}=$grid{$i}{$j};
        }
      }
      for(my $i=0; $i<@arr; $i++) {
	my %currgrid = %{ $arr[$i] };
        $currgrid{string} = GridToStr(\%currgrid);
	my $arrstr = Convert(\%currgrid,$matchref);
        %currgrid = StrToGrid($arrstr);
        my $xfac = $i % $div;
        my $yfac = int($i/$div);
        foreach my $x (keys %currgrid) {
	  if ($x eq "string") {
	    # do nothing
	  } elsif ($x eq "size") {
	    $grid{size} += $currgrid{size};
	  } else {
	    foreach my $y (keys %{ $currgrid{$x} }) {
	      my $newX = $x+$xfac;
	      my $newY = $y+$yfac;
	      $grid{$newX}{$newY}=$currgrid{$x}{$y};
	    }
	  }
	}
      }
    }
  } 
  $gridstr = GridToStr(\%grid);

  return $gridstr;
}


sub RotateGrid {
  my $gridstr = shift();
  my $gridref = StrToGrid($gridstr);
  my %grid = %{ $gridref };

  my %newgrid;


  my $size = $grid{size};
  $newgrid{size} = $size;

  if ($size == 3) {
    $newgrid{2}{0} = $grid{0}{0};
    $newgrid{2}{1} = $grid{1}{0};
    $newgrid{2}{2} = $grid{2}{0};
    $newgrid{1}{2} = $grid{2}{1};
    $newgrid{0}{2} = $grid{2}{2};
    $newgrid{0}{1} = $grid{1}{2};
    $newgrid{0}{0} = $grid{0}{2};
    $newgrid{1}{0} = $grid{0}{1};
    $newgrid{1}{1} = $grid{1}{1};
  } elsif ($size ==2) {
    $newgrid{1}{0} = $grid{0}{0};
    $newgrid{1}{1} = $grid{1}{0};
    $newgrid{0}{1} = $grid{1}{1};
    $newgrid{0}{0} = $grid{0}{1};
  }

  $newstr = GridToStr(\%newgrid);
  #print "New: $newstr\n";

  return $newstr;
}

sub StrToGrid {
  my $str = shift();

  my %grid;

  my @foo = split /\//, $str;
  $grid{size}=@foo;
  $grid{string}=$str;
  #print "DEBUG: $str\n";
  for (my $y=0; $y<$grid{size}; $y++) {
    #print "DEBUG: $foo[$y]\n";
    my @bar = split //,$foo[$y];
    for (my $x=0; $x<$grid{size}; $x++) {
      #print "DEBUG ($x,$y): $bar[$x]\n";
      $grid{$x}{$y}=$bar[$x];
    }
  }

  return \%grid;
}

sub GridToStr {
  my %grid = %{ shift() };
  my $size = $grid{size};

  my $str;

  for (my $y=0; $y<$size; $y++) {
    for (my $x=0; $x<$size; $x++) {
      $str .= "$grid{$x}{$y}";
    }
    $str .= "/" if ($x != $size-1);
  }

  $str =~ s/\/$//;

  return $str;
}

sub PrintGrid {
  my $gridstr = shift();
  my $gridref = StrToGrid($gridstr);
  my %grid = %{ $gridref };

  #print "DEBUG: $gridref\n";

  my $size = $grid{size};
  my $str;

  for (my $i=0; $i<$size; $i++) {
    for (my $j=0; $j<$size; $j++) {
      #print $grid{$j}{$i};
      $str .= $grid{$j}{$i};
    }
    #print "\n";
    $str .= "\n";
  }

  return $str;
}

sub Header {
  my $str = shift();

  print "----- $str -----\n"
}

sub Match {
  my $str = shift();
  my %match = %{ shift() };

  return $match{$str} if ($match{$str});
  return $str;
}
