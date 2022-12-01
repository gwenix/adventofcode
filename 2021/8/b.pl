#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "test.input";

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my $total=0;
foreach my $l (@lines) {
  $total+=Parse($l);
}

print "Total: $total\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub Parse {
  my $in = shift();
  my $out=0;

  my @input;
  my @output;
  my @all;

  my $inside=1;
  my @foo = split / /, $in;

  for (my $i=0; $i<@foo; $i++) {
    my $curr = SortedStr($foo[$i]);

    if ($curr =~ m/\|/) {
      $inside=0;
    } elsif ($inside) {
      push (@input, $curr);
      push (@all, $curr);
    } else { # outside
      push (@output, $curr);
      push (@all, $curr);
    }
  }

  my %cipher = %{ FindCipher(@all) };
  for (my $i=0; $i<@output; $i++) {
    $out = ($out*10) + $cipher{$output[$i]};
  }
  return $out;
}

sub SortedStr {
  my $in=shift();

  return join '', sort { $a cmp $b } split(//, $in);
}

sub StrLength {
  my $in = shift();

  my @ch = split //, $in;
  my $len = @ch;

  return $len;
}

sub FindCipher {
  my @words = @_;

  my %data;
  my %cipher;
  my @fivers;

  # first pass to put words into data for finding
  foreach my $w (@words) {
    my $len = StrLength($w);
    if ($len==2) {
      # 1
      $cipher{1}=$w;
    } elsif ($len==4) {
      # 4
      $cipher{4}=$w;
    } elsif ($len==3) {
      # 7
      $cipher{7}=$w;
    } elsif ($len==7) {
      # 8
      $cipher{8}=$w;
    } elsif ($len==5) {
      # 2,3,5
      push(@fivers,$w);
    } elsif ($len==6) {
      # 0,6,9
    } else {
      die "Something went terribly wrong, length of $len\n";
    }
  }

  my %ElRem = ( a => 1, b => 1, c => 1, d => 1, e => 1, f => 1, g => 1 );
  # compare 7 and 1 top with tr to find top element
  my @foo = ElementsMissing($cipher{7},$cipher{1});
  $data{top}=$foo[0];
  $ElRem{$foo[0]}=0;
  @foo = ElementsSame($cipher{7},$cipher{1});
  foreach (@foo) { $ElRem{$_}=0; }
  $data{tr}=\@foo;
  $data{br}=\@foo;

  # compare 4 and 1 tl/mid with tr to find those elements
  @foo = ElementsMissing($cipher{4},$cipher{1});
  foreach (@foo) { $ElRem{$_}=0; }
  $data{tl}=\@foo;
  $data{mid}=\@foo;

  # find 3 by finding which of the 5 units has both 1 elements 
	# -- this sets bot and bl, tl and mid
  @foo = ElementsRemaining(\%ElRem);
  foreach (@foo) { $ElRem{$_}=0; }
  $data{bl}=\@foo;
  $data{bot}=\@foo;

  my $three = FindThree(\@fivers, $data{tr});
  my @threearr = split //, $three;
  foreach my $ch (@threearr) {
    if ($ch eq $data{top}) {
    #ignore this
    } elsif (my $test=inArr($ch,$data{tl})) {
      $data{tl}=$test;
      $data{mid}=Other($test,$data{bl});
    } elsif (inArr($ch,$data{tr})) {
      #ignore this
    } else {
      my $test = inArr($ch, $data{bl});
      die "Should not die here, in find three area\n" unless ($test);
      $data{bot}=$test;
      $data{bl}=Other($test,$data{bot});
    }
  }
  
  # find 2 by which has bl element -- sets tr and br
  my $two = FindTwo($data{bl},@fivers);
  my @twoarr = split //, $two;
  foreach my $ch (@twoarr) {
    my $test=inArr($ch, $data{tr});
    if ($test) {
      $data{tr}=$ch;
      $data{br}=Other($ch, $data{br});
    }
  }

  $cipher{0}=SortedStr( $data{top}.$data{tr}.$data{br}.$data{bot}.$data{bl}.$data{tl} );
  $cipher{2}=SortedStr( $data{top}.$data{tr}.$data{mid}.$data{bl}.$data{bot} );
  $cipher{3}=SortedStr( $data{top}.$data{tr}.$data{mid}.$data{br}.$data{bot} );
  $cipher{5}=SortedStr( $data{top}.$data{tl}.$data{mid}.$data{br}.$data{bot} );
  $cipher{6}=SortedStr( $data{top}.$data{mid}.$data{br}.$data{bot}.$data{bl}.$data{tl} );
  $cipher{9}=SortedStr( $data{top}.$data{tr}.$data{br}.$data{bot}.$data{mid}.$data{tl} );

  return \%cipher;
}

sub ElementsRemaining {
  my %er = %{ shift() };
  my @arr;

  print Dumper(%er);

  foreach my $e (keys %er) {
    push(@arr, $e) if ($er{$e});
  }

  return @arr;
}

sub FindTwo {
  my $bl = shift();
  my @fivers = @_;

  foreach my $f (@fivers) {
    my @ch = split //, $f;

    foreach my $c (@ch) {
      return $f if ($c eq $bl);
    }
  }

  die "I should not get here, end of FindTwo\n";
}

sub inArr {
  my $in = shift();
  my @arr = @{ shift() };

  foreach my $ch (@arr) {
    return $ch if ($ch eq $in);
  }
  return 0;
}

sub Other {
  my $in = shift();
  my @arr = @{ shift() };

  my $out=$arr[0];
  $out=$arr[1] if ($in ne $out);

  return $out;
}

sub FindThree {
  my @fivers = @{ shift() };
  my @arr = @{ shift() };

  my %data;

  foreach (@arr) {
    $data{$_}=1;
  }

  foreach my $f (@fivers) {
    my @arr=split //, $f;
    my $test=0;

    foreach my $a (@arr) {
      $test++ if ($data{$a});
    }
    return $f if ($test==2);
  }

  die "I should not get here -- end of FindThree\n";
}

sub ElementsSame {
  my $in1=shift();
  my $in2=shift();

  my %hash;

  my @arr = split //, $in1;

  push (@arr, split('', $in2));

  foreach (@arr) {
    $hash{$_}++;
  }

  my @out;

  foreach my $ele (keys %hash) {
    push (@out, $ele) if ($hash{$ele}>1);
  }

  return @out;
}

sub ElementsMissing {
  my $in1=shift();
  my $in2=shift();

  my %hash;

  my @arr = split //, $in1;

  push (@arr, split('', $in2));

  foreach (@arr) {
    $hash{$_}++;
  }

  my @out;

  foreach my $ele (keys %hash) {
    push (@out, $ele) if ($hash{$ele}==1);
  }

  return @out;
}

sub ArrStr {
  my $in=shift();
  my @arr = split //, $in;

  return @arr;
}
