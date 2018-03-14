#!/usr/bin/perl

my $inf = "input";

open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my %reg;
#$reg{a}=1;

for(my $i=0; $i<@lines; $i++) {
  my $l = $lines[$i];
  chomp($l);
  print "Processing: $l\n";
  my ($cmd, $a, $b) = split / /,$l;

  if ($cmd eq "set") {
    $b = $reg{$b} unless (IsNumber($b));
    $reg{$a} = $b;
  } elsif ($cmd eq "sub") {
    $b = $reg{$b} unless (IsNumber($b));
    $reg{$a} -= $b;
  } elsif ($cmd eq "mul") {
    $b = $reg{$b} unless (IsNumber($b));
    $reg{$a} *= $b;
  } elsif ($cmd eq "jnz") {
    $a = $reg{$a} unless (IsNumber($a));
    $b = $reg{$b} unless (IsNumber($b));
    $i += $b-1 if ($a!=0);
  } else {
    die "invalid command: $cmd\n";
  }
  PrintRegs(\%reg);
}

sub IsNumber {
  my $i = shift ();

  if ($i =~ /^-?[0-9]+$/) {
    return 1;
  }
  return 0;
}

sub PrintRegs {
  my %reg = %{ shift() };

  Header("Current Reg State");
  foreach my $r (sort keys %reg) {
    print "$r: $reg{$r}\n";
  }
}

sub Header {
  my $str = shift();

  print "------ $str ------\n";
}
