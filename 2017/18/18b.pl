#!/usr/bin/perl

my $inf = "input";
$inf = "test.input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my (%ireg, %jreg);
$ireg{p}=0;
$jreg{p}=1;

my @iqueue;
my @jqueue;

my $notdone = 1;
my ($i, $j) = (0, 0);
my ($iwait, $jwait) = (0,0);

while ($notdone) {

  #process prog i
  my $l = $lines[$i];
  my ($cmd, $a, $b) = split / /,$l;

  if ($cmd eq "snd") {
    $a = $ireg{$a} unless (IsNumber($a));
    print "i sends $a\n";
    push (@jqueue, $a);
    $i++;
  } elsif ($cmd eq "set") {
    $b = $ireg{$b} unless (IsNumber($b));
    $ireg{$a} = $b;
    $i++;
  } elsif ($cmd eq "add") {
    $b = $ireg{$b} unless (IsNumber($b));
    $ireg{$a} += $b;
    $i++;
  } elsif ($cmd eq "mul") {
    $b = $ireg{$b} unless (IsNumber($b));
    $ireg{$a} *= $b;
    $i++;
  } elsif ($cmd eq "mod") {
    $b = $ireg{$b} unless (IsNumber($b));
    $ireg{$a} = $ireg{$a} % $b;
    $i++;
  } elsif ($cmd eq "rcv") {
    my $num = @iqueue;
    if ($num == 0) {
      $iwait=1;
    } else {
      $ireg{$a} = shift(@iqueue);
      $i++;
      $iwait=0;
    }
  } elsif ($cmd eq "jgz") {
    $a = $ireg{$a} unless (IsNumber($a));
    $b = $ireg{$b} unless (IsNumber($b));
    $i += $b if ($a>0);
  } else {
    die "invalid command: $cmd\n";
  }

  #process prog j
  my $l = $lines[$j];
  my ($cmd, $a, $b) = split / /,$l;

  if ($cmd eq "snd") {
    print "j sends $a\n";
    $a = $jreg{$a} unless (IsNumber($a));
    push (@iqueue, $a);
    $j++;
  } elsif ($cmd eq "set") {
    print "j {$a}  set to $b\n";
    $b = $jreg{$b} unless (IsNumber($b));
    $jreg{$a} = $b;
    $j++;
  } elsif ($cmd eq "add") {
    $b = $jreg{$b} unless (IsNumber($b));
    $jreg{$a} += $b;
    $j++;
  } elsif ($cmd eq "mul") {
    $b = $jreg{$b} unless (IsNumber($b));
    $jreg{$a} *= $b;
    $j++;
  } elsif ($cmd eq "mod") {
    $b = $jreg{$b} unless (IsNumber($b));
    $jreg{$a} = $jreg{$a} % $b;
    $j++;
  } elsif ($cmd eq "rcv") {
    my $num = @jqueue;
    if ($num == 0) {
      $jwait=1;
    } else {
      $jreg{$a} = shift(@iqueue);
      $j++;
      $jwait=0;
    }
  } elsif ($cmd eq "jgz") {
    $a = $jreg{$a} unless (IsNumber($a));
    $b = $jreg{$b} unless (IsNumber($b));
    $i += $b if ($a>0);
  } else {
    die "invalid command: $cmd\n";
  }
  $notdone=0 if ($iwait && $jwait);
}

sub IsNumber {
  my $i = shift ();

  if ($i =~ /^-?[0-9]+$/) {
    return 1;
  }
  return 0;
}
