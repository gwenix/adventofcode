#!/usr/bin/perl

my $inf = "input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

chomp($lines[0]);
my @banks = split /\s+/,$lines[0];
my %chk;
$chk{join("",@banks)}=1;
my $norepeat=1;
my $count=0;
my $last;

while ($norepeat) {
  my ($maxi, $maxv);
  for (my $i=0; $i<@banks; $i++) {
    if ($banks[$i]>$maxv) {
      $maxi = $i;
      $maxv = $banks[$i];
    }
  }

  $banks[$maxi]=0;
  $maxi++; #maxi now starting i
  $maxi=0 if ($maxi==@banks); #wraparound

  for (my $i=$maxi; $maxv>0; $i++) {
    $i=0 if ($i==@banks); #wraparound

    $banks[$i]++;
    $maxv--;
  }


  my $set = join(" ",@banks);
  print "$set\n";
  if ($chk{$set}) {
    $norepeat=0;
    $last = $chk{$set};
  } else {
    $chk{$set}=$count;
    $count++;
  }

}

my $fin = $count-$last;
print "$count - $last = $fin \n";
