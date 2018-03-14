#!/usr/bin/perl

my $inf = "input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

foreach my $l (@lines) {

  # parse the input into $room, $id, $chksum
  chomp($l);
  my ($room,$chksum) = split /\[/, $l;
  $chksum =~ s/\]//;
  my @foo = split /\-/,$room;
  my $id = pop(@foo);
  $room = join(" ",@foo);


  print "$id $room: ";

  my $decrypt;

  my @foo = split //, $room;
  foreach my $ch (@foo) {
    if ($ch eq " ") {
      $decrypt .= $ch;
    } else {
      for (my $i=0; $i<$id; $i++) {
	if ($ch eq 'z') {
	  $ch='a';
	} else {
	  $ch++;
	}
      }
      $decrypt .= $ch;
    }
  }

  print "$decrypt\n";
}
