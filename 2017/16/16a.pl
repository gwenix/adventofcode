#!/usr/bin/perl

my $inf = "input";
#$inf = "test.input";
open (F, $inf) or die "Cannot open $inf: $!";
my @lines = <F>;
close (F);

my $instr = $lines[0]; chomp($instr);
my $dancestr = $lines[1]; chomp($dancestr);

my %progs;

my @in = split //,$instr;
my $fin = @in;
for (my $i=0; $i<$fin; $i++) {
  $progs{$i}{value}=$in[$i];
  if ($i == $fin-1) {
    $progs{$i}{next}=0;
  } else {
    $progs{$i}{next}=$i+1;
  }
}

  my @steps = split /\,/, $dancestr;
  for (my $i=0; $i<@steps; $i++) {
    #print "Step: $steps[$i]\n";
    my $currstr = $steps[$i]; chomp($currstr);
    my @foo = split //,$currstr;
    my $s = shift(@foo);

    if ($s eq "s") {
      #print "Spin.\n";
      my $num = join ("",@foo);
      #print "num: $num\n";
      for(my $i=0; $i<$num; $i++) {
        my $carry=$progs{0}{value};
        for(my $j=0; $j<$fin; $j++) {
	  my $next = $progs{$j}{next};
	  my $hold = $progs{$next}{value};
	  $progs{$next}{value}=$carry;
	  $carry=$hold;
        }
      }
    } elsif ($s eq "x") {
      #print "Exchange.\n";
      my $str = join ("",@foo);
      my ($a,$b) = split /\//,$str;
      my $hold = $progs{$a}{value};
      $progs{$a}{value} = $progs{$b}{value};
      $progs{$b}{value} = $hold;
    } elsif ($s eq "p") {
      #print "Partner.\n";
      my $str = join ("",@foo);
      my ($a,$b) = split /\//,$str;
      my $i = 0; while ($progs{$i}{value} ne $a) { $i++; }
      my $j = 0; while ($progs{$j}{value} ne $b) { $j++; }
      my $hold = $progs{$i}{value};
      $progs{$i}{value} = $progs{$j}{value};
      $progs{$j}{value} = $hold;
    } else {
      die "Unknown step: $s\n";
    }
  }

DancePrint($fin,\%progs);

sub DancePrint {
  my $end = shift();
  my %p = %{ shift() };

  for (my $i=0; $i<$end; $i++) {
    print "$p{$i}{value}";
  }
  print "\n";
}
