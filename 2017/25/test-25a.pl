#!/usr/bin/perl


# ------------- #
# Initial steps #
# ------------- #

# Begin in state A.
# Perform a diagnostic checksum after 12317297 steps.

# ------------ #
# Initializing #
# ------------ #

Header("Initializing");
my %tape;
$tape{cursor}=0;
#$tape{final}=12317297;
$tape{final}=6;
$tape{state}="A";
$tape{bit}{0}=0;

# ------ #
# Arby's #
# ------ #

Header("Starting to process");
my $taperef = State(\%tape);
Header("Final Tape State");
PrintTape($taperef);
print "\n";

my $chksum = CheckSum($taperef);
Header("CheckSum");
print "Checksum: $chksum\n";


# ----------- #
# Subroutines #
# ----------- #

sub Header {
  print "----- @_ -----\n";
}

sub PrintTape {
  my %tape = %{ shift() };
  my $cursor = $tape{cursor};

  #Header("Tape Reads");
  print "... ";
  foreach my $k (sort {$a <=> $b} keys %{ $tape{bit} }) {
    my $bit;
    if ($tape{bit}{$k}) {
      $bit = 1;
    } else {
      $bit = 0;
    }
    if ($k == $cursor) {
      print "[$bit] ";
    } else {
      print " $bit  ";
    }
  }
  print "... (At step $tape{step} of $tape{final} steps) ";
}

sub CheckSum {
  my %tape = %{ shift() };
  my $chksum=0;

  foreach my $k (keys %{ $tape{bit} }) {
    $chksum += $tape{bit}{$k};
  }

  return $chksum;
}

sub Move {
  my $curr = shift();
  my $dir = shift();

  if ($dir eq "right") {
    #print "Moving right: $curr\n";
    $curr++;
  } elsif ($dir eq "left") {
    #print "Moving left: $curr\n";
    $curr--;
  } else {
    die "Invalid direction: $dir\n";
  }

  return $curr;
}

sub State {
  my %tape = %{ shift() };

  for (my $step=0; $step<$tape{final}; $step++) {
    my $state = $tape{state};
    $tape{step}=$step;
    if ($tape{step} % 10000 == 1) {
      #PrintTape(\%tape);
      #print "About to start state $state.\n";
      print "About to start step $step.\n";
    }

    if ($state eq "A") {
      %tape = %{ StateA(\%tape) };
    } elsif ($state eq "B") {
      %tape = %{ StateB(\%tape) };
    } elsif ($state eq "C") {
      %tape = %{ StateC(\%tape) };
    } elsif ($state eq "D") {
      %tape = %{ StateD(\%tape) };
    } elsif ($state eq "E") {
      %tape = %{ StateE(\%tape) };
    } elsif ($state eq "F") {
      %tape = %{ StateF(\%tape) };
    } else {
      die "Invalid state: $state\n";
    }
  }

  return \%tape;
}

sub StateA {
#  In state A:
#    If the current value is 1:
#      - Write the value 0.
#      - Move one slot to the left.
#      - Continue with state D.
#    If the current value is 0:
#      - Write the value 1.
#      - Move one slot to the right.
#      - Continue with state B.


  my $taperef = shift();
  my %tape = %{ $taperef };
  $cursor = $tape{cursor};


  if ($tape{bit}{$cursor}) {
    $tape{bit}{$cursor} = 0;
    $cursor = Move($cursor, "left");
    $tape{cursor}=$cursor;
    $tape{state} = "B";
  } else {
    $tape{bit}{$cursor} = 1;
    $cursor = Move($cursor, "right");
    $tape{cursor}=$cursor;
    $tape{state} = "B";
  }

  return \%tape;
}

sub StateB {
#  In state B:
#    If the current value is 1:
#      - Write the value 0.
#      - Move one slot to the right.
#      - Continue with state F.
#    If the current value is 0:
#      - Write the value 1.
#      - Move one slot to the right.
#      - Continue with state C.


  my $taperef = shift();
  my %tape = %{ $taperef };
  $cursor = $tape{cursor};

  if ($tape{bit}{$cursor}) {
    $tape{bit}{$cursor} = 1;
    $cursor = Move($cursor, "right");
    $tape{cursor}=$cursor;
    $tape{state} = "A";
  } else {
    $tape{bit}{$cursor} = 1;
    $cursor = Move($cursor, "left");
    $tape{cursor}=$cursor;
    $tape{state} = "A";
  }

  return \%tape;
}

sub StateC {
#  In state C:
#    If the current value is 1:
#      - Write the value 1.
#      - Move one slot to the left.
#      - Continue with state A.
#    If the current value is 0:
#      - Write the value 1.
#      - Move one slot to the left.
#      - Continue with state C.


  my $taperef = shift();
  my %tape = %{ $taperef };
  $cursor = $tape{cursor};

  if ($tape{bit}{$cursor}) {
    $tape{bit}{$cursor} = 1;
    $cursor = Move($cursor, "left");
    $taperef = State("A",\%tape) if ($tape{step} < $tape{final}) ;
    $tape{state} = "A";
  } else {
    $tape{bit}{$cursor} = 0;
    $cursor = Move($cursor, "left");
    $tape{cursor}=$cursor;
    $tape{state} = "C";
  }

  return \%tape;
}

sub StateD {
#  In state D:
#    If the current value is 1:
#      - Write the value 1.
#      - Move one slot to the right.
#      - Continue with state A.
#    If the current value is 0:
#      - Write the value 0.
#      - Move one slot to the left.
#      - Continue with state E.

  my $taperef = shift();
  my %tape = %{ $taperef };
  $cursor = $tape{cursor};

  if ($tape{bit}{$cursor}) {
    $tape{bit}{$cursor} = 1;
    $cursor = Move($cursor, "right");
    $tape{cursor}=$cursor;
    $tape{state} = "A";
  } else {
    $tape{bit}{$cursor} = 0;
    $cursor = Move($cursor, "left");
    $tape{cursor}=$cursor;
    $tape{state} = "E";
  }

  return \%tape;
}

sub StateE {
#  In state E:
#    If the current value is 1:
#      - Write the value 0.
#      - Move one slot to the right.
#      - Continue with state B.
#    If the current value is 0:
#      - Write the value 1.
#      - Move one slot to the left.
#      - Continue with state A.

  my $taperef = shift();
  my %tape = %{ $taperef };
  $cursor = $tape{cursor};

  if ($tape{bit}{$cursor}) {
    $tape{bit}{$cursor} = 0;
    $cursor = Move($cursor, "right");
    $tape{cursor}=$cursor;
    $tape{state} = "B";
  } else {
    $tape{bit}{$cursor} = 1;
    $cursor = Move($cursor, "left");
    $tape{cursor}=$cursor;
    $tape{state} = "A";
  }

  return \%tape;
}

sub StateF {
#  In state F:
#    If the current value is 1:
#      - Write the value 0.
#      - Move one slot to the right.
#      - Continue with state E.
#    If the current value is 0:
#      - Write the value 0.
#      - Move one slot to the right.
#      - Continue with state C.

  my $taperef = shift();
  my %tape = %{ $taperef };
  $cursor = $tape{cursor};

  if ($tape{bit}{$cursor}) {
    $tape{bit}{$cursor} = 0;
    $cursor = Move($cursor, "right");
    $tape{cursor}=$cursor;
    $tape{state} = "E";
  } else {
    $tape{bit}{$cursor} = 0;
    $cursor = Move($cursor, "right");
    $tape{cursor}=$cursor;
    $tape{state} = "C";
  }

  return \%tape;
}
