#!/usr/bin/perl

my $inf = "input";
#$inf = "test.input";

open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my $outpipe = "1.out";
my $inpipe = "0.out";
my %reg;
$reg{p}=1;
my $num=0;
my @inqueue;
open (OUT, ">", $outpipe) or die "Cannot open $outpipe: $!";
close (OUT);

for(my $i=0; $i<@lines; $i++) {
  chomp($lines[$i]);

  my ($cmd, $a, $b) = split / /,$lines[$i];

  if ($cmd eq "snd") {
    $num++;
    open (OUT, ">>$outpipe") or die "Cannot open $outpipe: $!";
    print OUT "$reg{$a}\n";
    close (OUT);
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
    my $check=0;
    my $iter=0;
    while (!$check) {
      open (IN,$inpipe) or die "Cannot open $inpipe: $!";
      my @entries = <IN>;
      close (IN);
      foreach (@entries) {
        chomp($_);
      }
      push (@inqueue, @entries);
      $check = @inqueue;
      sleep(5);
      $iter++;
      print "$iter ";
      if ($iter>5) {
 	die "Nothing left in queue at $num.\n";
      }
    }
      
    $b = shift(@inqueue);
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
