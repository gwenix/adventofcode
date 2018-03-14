#!/usr/bin/perl

my $inf = "input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my $tot=0;

foreach my $l (@lines) {

  # parse the input into $room, $id, $chksum
  chomp($l);
  my ($room,$chksum) = split /\[/, $l;
  $chksum =~ s/\]//;
  my @foo = split /\-/,$room;
  my $id = pop(@foo);
  $room = join("",@foo);

  # count the letters
  my @chars = split //, $room;
  my %ch;
  foreach my $c (@chars) {
    $ch{$c}++;
  }

  print "$room: ";
  # find the top 5
  my $a=0; my $b=0; my $c=0; my $d=0; my $e=0;
  foreach my $i (sort keys %ch) {
    my $curr = $ch{$i};
    #print "$i-$curr ";
    if ($curr > $ch{$a}) {
      $e = $d;
      $d = $c;
      $c = $b;
      $b = $a;

      $a = $i;
    } elsif ($curr > $ch{$b}) {
      $e = $d;
      $d = $c;
      $c = $b;

      $b = $i;
    } elsif ($curr > $ch{$c}) {
      $e = $d;
      $d = $c;

      $c = $i;
    } elsif ($curr > $ch{$d}) {
      $e = $d;

      $d = $i;
    } elsif ($curr > $ch{$e}) {
      $e = $i;
    }
  }
  my $chker = $a.$b.$c.$d.$e;

  print "$chksum vs $chker: ";
  if ($chksum eq $chker) {
    $tot+=$id;
    print "OK\n";
  } else {
    print "BAD\n";
  }
}

print "Total: $tot\n";
