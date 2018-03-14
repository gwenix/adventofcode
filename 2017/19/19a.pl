#!/usr/bin/perl

my $inf="input";
#$inf="test.input";


open(F,$inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my %grid;

#Initialize maze grid
for (my $i=0; $i<@lines; $i++) {
  chomp($lines[$i]);
  my @foo = split //,$lines[$i];

  for (my $j=0; $j<@foo; $j++) {
    $grid{$j}{$i}=$foo[$j];
  }
}


#find the first step
my @currstep=(-1,0);
for (my $i=0; $currstep[0]<0; $i++) {
  #print "char at ($i,0): $grid{$i}{0}\n";
  $currstep[0]=$i if ($grid{$i}{0} ne " ");
}

#print "@currstep: $grid{$currstep[0]}{$currstep[1]}\n";

my $dir = 2; # 0=up, 1=right, 2=down, 3=left
my $notdone = 1;
my $str;

my $count = 0;
while ($notdone) {
   ($dir, $currstep[0], $currstep[1]) = FindNextStep($dir,@currstep,\%grid);
   if ($dir == -1) {
     $notdone=0;
   }
   my $ch = $grid{$currstep[0]}{$currstep[1]};
   if ($ch =~ m/[A-Z]/) {
     $str .= $ch;
   }
   if ($ch ne " ") {
     $count++;
   }
}

print "Final: $str at $count\n";

sub FindNextStep {
# take in current direction, current step, and grid, return array of ($dir, $x, $y) for the next step
   my $dir = shift();
   my $x = shift();
   my $y = shift();
   my %grid = %{ shift() };

   my $ch = $grid{$x}{$y};
   print "Evaluating $ch at ($x,$y) going $dir.\n";
   if ($ch eq "+") {
     if ($dir != 2 && $grid{$x}{$y-1} && $grid{$x}{$y-1} ne " ") {
       #print "Going up.\n";
       return (0, $x, $y-1);
     } elsif ($dir != 3 && $grid{$x+1}{$y} && $grid{$x+1}{$y} ne " ") {
       #print "Going right.\n";
       return (1, $x+1, $y);
     } elsif ($dir != 0 && $grid{$x}{$y+1} && $grid{$x}{$y+1} ne " ") {
       #print "Going down.\n";
       return (2, $x, $y+1);
     } elsif ($dir != 1 && $grid{$x-1}{$y} && $grid{$x-1}{$y} ne " ") {
       #print "Going left.\n";
       return (3, $x-1, $y);
     } 
   } elsif ($ch eq " ") {
     return (-1, -1, -1);
   } elsif ($dir == 0) {
     return ($dir, $x, $y-1);
   } elsif ($dir == 1) {
     return ($dir, $x+1, $y);
   } elsif ($dir == 2) {
     return ($dir, $x, $y+1);
   } elsif ($dir == 3) {
     return ($dir, $x-1, $y);
   }

  return (-1, -1, -1);
}
