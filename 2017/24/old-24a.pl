#!/usr/bin/perl

my $inf = "input";
#$inf = "test.input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my @ports;
my %connectors;

Header("Initializing the data");
for (my $i=0; $i<@lines; $i++) {
  my $l = $lines[$i];
  chomp($l);
  $ports[$i]=$l;

  my ($a,$b) == GetPorts($l);

  push(@{$connectors{$a}}, $l);
}


Header("Running the Bridge");
my $strength=Bridge(0,\%connectors,@ports);
Header("Strongest strength: $strength");


# ----------- #
# Subroutines #
# ----------- #

sub GetPorts {
  my $str = shift();

  my ($a,$b) == split /\//, $str;

  return ($a, $b);
}

sub Bridge {
  my $curr = shift();
  my %conn = %{ shift() };
  my @ports = @_;
  my $strength=0;

  for (my $i=0; $i<@ports; $i++) {
    my @newports = @ports;
    my $port = splice(@newports,$i,1);
    print "checking $port...";
    my ($a, $b) = split /\//, $port;
    if ($a == 0) {
      my $currstr = NextBridge($port,"a",@newports);
      $strength=$currstr if ($currstr>$strength);
      #Header("$port: $strength");
      print "\n";
    } elsif ($b==0) {
      my $currstr = NextBridge($port,"b",@newports);
      $strength=$currstr if ($currstr>$strength);
      #Header("$port: $strength");
      print "\n";
    } else {
      #Header("$port: n/a");
    }
  }
  
  return $strength;
}

sub NextBridge {
  my $curr = shift();
  my $zero = shift();
  my @ports = @_;
  my $strength=0;
  #print "NextBridge: $curr @ports\n";

  my ($a, $b) = split /\//, $curr;
  my $holdstr = $a+$b;
  if ($zero eq 'a') {
    $a = 'no';
  } elsif ($zero eq 'b') {
    $b = 'no';
  }

  for (my $i=0; $i<@ports; $i++) {
    my @newports = @ports;
    my $next = splice(@newports,$i,1);
    my ($nexta, $nextb) = split /\//, $next;
    if ($a eq $nexta || $a eq $nextb || $b eq $nexta || $b eq $nextb) {
      #print "Match found: $next\n";
      my $nextstr = NextBridge($next,"n/a",@newports); 
      $strength = $nextstr if ($nextstr>$strength);
    } else {
      #print "$next: No matches found.\n";
    }
  }

  $strength += $holdstr;
  #print "Going back up: $strength\n";
  return $strength;
}


sub Header {
  print "----- @_ -----\n";
}
