#!/usr/bin/perl

my $inf = "input";
#my $inf = "test.input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

foreach my $l (@lines) {
  chomp($l);

  my @char = split //,$l;

  my $tot=0;
  my $loop=0;

  for (my $i=0; $i<@char; $i++) {
    my $ch = $char[$i];
    if ($ch eq '{') {
      $loop++;
    } elsif ($ch eq '<') {
      $i++;
      while ($char[$i] ne '>') {
	if ($char[$i] eq '!') {
	  $i+=2;
	} else {
	  $tot++;
	  $i++;
	}
      }
    } elsif ($ch eq '!') {
      $i++;
    } elsif ($ch eq '}') {
      $loop--;
    }
  }

  print "$l: $tot\n";
}
