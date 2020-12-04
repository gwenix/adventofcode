#!/usr/bin/perl

use strict;
use warnings;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my @passport;
my $arri=0;

# Storing the passport info
for(my $i=0; $i<@lines; $i++) {
  if ($lines[$i]=~m/^\s*$/) {
    $arri++;
  } else {
    my @foo = split / /, $lines[$i];
    foreach my $pair (@foo) {
      my ($key,$val) = split /:/,$pair;
      $passport[$arri]{$key}=$val;
    }
  }
}

# Finding valid passports
my $val=0;
foreach my $pref (@passport) {
    if ( ValidPP($pref) ) {
      $val++;
      print "validated...\n";
    }
    #print "Current valid count: $val\n";
}

print "There are $val valid passports.\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub ValidPP {
  my %pp = %{ shift() };
  my ($byr, $iyr, $eyr, $hgt, $hcl, $ecl, $pid) = (0,0,0,0,0,0,0);

  PrintPP(\%pp);
  print "--------------\n";

  print "byr: ";
  $byr=1 if ($pp{byr}>1919 && $pp{byr}<2003);
  print "$byr\t";

  print "iyr: ";
  $iyr=1 if ($pp{iyr}>2009 && $pp{iyr}<2021);
  print "$iyr\t";

  print "eyr: ";
  $eyr=1 if ($pp{eyr}>2019 && $pp{eyr}<2031);
  print "$eyr\n";

  print "hgt: ";
  my $h=$pp{hgt};
  if($h =~ m/in$/) {
    $h =~ s/in$//;
    $hgt=1 if ($h>58 && $h<77);
  } elsif ($h =~ m/cm$/) {
    $h =~ s/cm$//;
    $hgt=1 if ($h>149 && $h<194);
  }
  print "$hgt\t";

  print "hcl: ";
  my $hc=$pp{hcl};
  my @ch = split //, $hc;
  my $len=@ch;
  if ($len==7 && $ch[0] eq "#") {
    $hcl=1;
    for(my $i=1; $i<$len; $i++) {
      $hcl=0 unless ($ch[$i] =~ m/([0-9]|[a-f])/);
    }
  }
  print "$hcl\t";

  print "ecl: ";
  if (exists($pp{ecl})) {
    $ecl=1 if ($pp{ecl} eq "amb" || $pp{ecl} eq "blu" || $pp{ecl} eq "brn"
		|| $pp{ecl} eq "gry" || $pp{ecl} eq "grn"
		|| $pp{ecl} eq "hzl" || $pp{ecl} eq "oth");
  }
  print "$ecl\t";

  print "pid: ";
  $pid=1 if ($pp{pid} =~ m/^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$/);
  print "$pid\n";

  my $valid = ($byr && $iyr && $eyr && $hgt && $hcl && $ecl && $pid); 

  print "Valid? $valid\n";

  print "----------------------------------------------------------\n";

  return $valid;
}

sub PrintPP {
  my %pp = %{ shift() };

  my $byr=$pp{byr};
  $byr = "n/a" unless ($byr);
  my $iyr=$pp{iyr};
  $iyr = "n/a" unless ($iyr);
  my $eyr=$pp{eyr};
  $eyr = "n/a" unless ($eyr);
  my $hgt=$pp{hgt};
  $hgt = "n/a" unless ($hgt);
  my $hcl=$pp{hcl};
  $hcl = "n/a" unless ($hcl);
  my $ecl=$pp{ecl};
  $ecl = "n/a" unless ($ecl);
  my $pid=$pp{pid};
  $pid = "n/a" unless ($pid);
  my $cid=$pp{cid};
  $cid = "n/a" unless ($cid);

  print "byr: $byr iyr: $iyr eyr: $eyr hgt: $hgt\n";
  print "hcl: $hcl ecl: $ecl pid: $pid cid: $cid\n";
}
