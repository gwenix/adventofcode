#!/usr/bin/perl

use strict;
#use warnings;

my $input = "input";
open (F, "$input") or die "Cannot open $input: $!\n";
my @program = <F>;
close(F);

# Chomp the program commands
foreach (@program) {
  chomp(@_);
}
my $proglen = @program;

# queues for the send/receive
my @queue0;
my @queue1;

# processes running the programs
my %pid0 = %{ InitializePID(0,\@program) };
my %pid1 = %{ InitializePID(1,\@program) };

my $deadlock=0;

while (!$deadlock) {
  # placeholder for counting how many rcv's couldn't run
  my $rcvheld=0;

  # first, pid0 current instruction
  print "Running 0: $pid0{inst}{cmd} $pid0{inst}{a} $pid0{inst}{b}\n";
  my $cmd0 = $pid0{inst}{cmd};
  my $runref = RunArith(\%pid0);
  if ($runref) {
    # This means that the cmd was either set, add, mul, or mod
    %pid0 = %{ $runref };
    $pid0{progline}++;
    $pid0{inst} = ParseInstruction($program[$pid0{progline}]);
  } elsif ($cmd0 eq "jgz") {
    my $a = $pid0{inst}{a};
    $a = $pid0{reg}{$a} unless (isInteger($a));
    my $b = $pid0{inst}{b};
    $b = $pid0{reg}{$b} unless (isInteger($b));
    
    if ($a>0) {
      print "Jumping $b\n";
      $pid0{progline} += $b;
      $pid0{inst} = ParseInstruction($program[$pid0{progline}]);
    } else {
      $pid0{progline}++;
      $pid0{inst} = ParseInstruction($program[$pid0{progline}]);
    }
  } elsif ($cmd0 eq "snd") {
    my $a = $pid0{inst}{a};
    print "snd $a\n";
    $a = $pid0{reg}{$a} unless (isInteger($a));
    
    push(@queue1, $a);
    print "SENT: 0 sends $a\n";
    $pid0{sent}++;
    $pid0{progline}++;
    $pid0{inst} = ParseInstruction($program[$pid0{progline}]);
  } elsif ($cmd0 eq "rcv") {
    my $qlen = @queue0;
    if ($qlen>0) {
      my $a = $pid0{inst}{a};
      $pid0{reg}{$a} = shift(@queue0);
      
      $pid0{progline}++;
      $pid0{inst} = ParseInstruction($program[$pid0{progline}]);
    } else {
      $rcvheld++;
    }
  }

  # next, pid1 current instruction
  print "Running 1: $pid1{inst}{cmd} $pid1{inst}{a} $pid1{inst}{b}\n";
  my $cmd1 = $pid1{inst}{cmd};
  $runref = RunArith(\%pid1);
  if ($runref) {
    # This means that the cmd was either set, add, mul, or mod
    %pid1 = %{ $runref };
    $pid1{progline}++;
    $pid1{inst} = ParseInstruction($program[$pid1{progline}]);
  } elsif ($cmd1 eq "jgz") {
    my $a = $pid1{inst}{a};
    $a = $pid1{reg}{$a} unless (isInteger($a));
    my $b = $pid1{inst}{b};
    $b = $pid1{reg}{$b} unless (isInteger($b));
    
    if ($a>0) {
      print "Jumping $b\n";
      $pid1{progline} += $b;
      $pid1{inst} = ParseInstruction($program[$pid1{progline}]);
    } else {
      $pid1{progline}++;
      $pid1{inst} = ParseInstruction($program[$pid1{progline}]);
    }
  } elsif ($cmd1 eq "snd") {
    my $a = $pid1{inst}{a};
    $a = $pid1{reg}{$a} unless (isInteger($a));
    
    push(@queue0, $a);
    print "SENT: 1 sends $a\n";
    $pid1{sent}++;
    $pid1{progline}++;
    $pid1{inst} = ParseInstruction($program[$pid1{progline}]);
  } elsif ($cmd1 eq "rcv") {
    my $qlen = @queue1;
    if ($qlen>0) {
      my $a = $pid1{inst}{a};
      $pid1{reg}{$a} = shift(@queue1);
      
      $pid1{progline}++;
      $pid1{inst} = ParseInstruction($program[$pid1{progline}]);
    } else {
      $rcvheld++;
    }
  }

  $deadlock=1 if ($rcvheld>1); # means both are stuck on rcv
}

print "1 sent $pid1{sent} times.\n";

exit();

#########################################################################
# 				Subroutines				#
#########################################################################

sub InitializePID {
  my $id = shift();
  my @prog = @{ shift() };
  my %pid;

  $pid{progline}=0;
  $pid{inst} = ParseInstruction($program[0]);
  $pid{sent}=0;

  foreach my $ch ("a" .. "z") {
    if ($ch eq "p") {
      $pid{reg}{$ch}=$id;
    } else {
      $pid{reg}{$ch}=0;
    }
  }

  return \%pid;
}


sub RunArith {
  my %pid = %{ shift() };

  my $cmd = $pid{inst}{cmd};
  my $a = $pid{inst}{a};
  my $b = $pid{inst}{b};
  $b=0 unless ($b);
  $b=$pid{reg}{$b} unless (isInteger($b));

  if ($cmd eq "set") {
    $pid{reg}{$a}=$b;
  } elsif ($cmd eq "add") {
    $pid{reg}{$a} += $b;
  } elsif ($cmd eq "mul") {
    $pid{reg}{$a} *= $b;
  } elsif ($cmd eq "mod") {
    $pid{reg}{$a} = $pid{reg}{$a} % $b;
  } else {
    return 0;
  }

  return \%pid;
}

sub PrintReg {
  my %pid = %{ shift() };

  foreach my $reg (sort keys %{ $pid{reg} }) {
    my $val = $pid{$reg};
    print "Reg $reg: $val\n";
  }

}

sub ParseInstruction {
  my $line = shift();
  chomp($line);

  my %data;
  my ($cmd, $a, $b) = split / /, $line;
  $data{cmd} = $cmd;
  $data{a} = $a;
  $data{b} = $b if ($b);

  return \%data;
}

sub isInteger {
  my $str = shift();

  #print "DEBUG: $str\t";

  my $isint = 0;

  $isint=1 if ($str =~ /^[\-]?[0-9]+$/);

  #print "$isint\n"; # DEBUG

  return $isint;
}
