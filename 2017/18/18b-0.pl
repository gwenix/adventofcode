#!/usr/bin/perl

my $inf = "input";
#$inf = "test.input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my %reg;
$reg{p}=0;
my $num=0;

for(my $i=0; $i<@lines; $i++) {
  chomp($lines[$i]);

  my ($cmd, $a, $b) = split / /,$lines[$i];

  if ($cmd eq "snd") {
    $num++;
    print "$num: Sending $reg{$a}\n";
  } elsif ($cmd eq "set") {
    $b = $reg{$b} unless (IsNumber($b));
    $reg{$a} = $b;
  } elsif ($cmd eq "add") {
    $b = $reg{$b} unless (IsNumber($b));
    $reg{$a} += $b;
  } elsif ($cmd eq "mul") {
    $b = $reg{$b} unless (IsNumber($b));
    $reg{$a} *= $b;
  } elsif ($cmd eq "mod") {
    $b = $reg{$b} unless (IsNumber($b));
    $reg{$a} = $reg{$a} % $b;
  } elsif ($cmd eq "rcv") {
    print "Waiting to receive: ";
    $b = <STDIN>; 
    chomp($b);
    while (IsNumber($b) == 0) {
      print "Receiving numbers only: ";
      $b = <STDIN>; 
      chomp($b);
    }
    $reg{$a} = $b;
  } elsif ($cmd eq "jgz") {
    $a = $reg{$a} unless (IsNumber($a));
    $b = $reg{$b} unless (IsNumber($b));
    $i += $b-1 if ($a>0);
  } else {
    die "invalid command: $cmd\n";
  }
}

sub IsNumber {
  my $i = shift ();

  if ($i =~ /^-?[0-9]+$/) {
    return 1;
  }
  return 0;
}
