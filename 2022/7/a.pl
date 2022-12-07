#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# ------------- #
# Configuration #
# ------------- #
my $input_file = "input";

our %fs;
my $topsize=100000;

# ------ #
# Arby's #
# ------ #

open (F, $input_file) or die "Cannot open $input_file: $!\n";
my @lines = <F>;
chomp @lines;
close (F);

my $currdir;
my %dirs;

# setting up filesystem
for (my $i=0; $i<@lines; $i++) {
  my $l = $lines[$i];
  my @foo = split / /, $l;
  if ($foo[0] eq '$') { # command
    if ($foo[1] eq 'cd') {
      if ($foo[2] eq '..') {
        die "can't go up from $currdir\n" if (!$fs{$currdir}{updir});
        $currdir=$fs{$currdir}{updir};
        $dirs{$currdir}=1;
      } else {
        my $newdir="$currdir/$foo[2]";
        $newdir =~ s://:/:g;
        $fs{$newdir}{updir}=$currdir;
	$currdir=$newdir;
        $fs{$currdir}{type}='d';
      }
    } else {
      # ls -- do nothing really
    }
  } else {
    my $item="$currdir/$foo[1]";
    $item=~s://:/:g;
    #print "DEBUG: $item\n";
    $fs{$currdir}{contains}{$item}=1;
    $fs{$item}{updir}=$currdir;
    if ($foo[0] eq 'dir') {
      $fs{$item}{type}='d';
      $dirs{$item}=1;
    } else {
      $fs{$item}{type}='f';
      $fs{$item}{size}=$foo[0];
      SizeUpTree($currdir,$foo[0]);
    }
  }
}

my $total=0;

print "finding dirs with no more than $topsize sizes.\n";

foreach my $d (keys %dirs) {
  my $currsize = $fs{$d}{size};
  if ($currsize<=$topsize) {
    print "\tfound $d of size $currsize\n";
    $total+=$currsize;
  }
}

print "Total: $total\n";

exit; 

# ----------- #
# Subroutines #
# ----------- #

sub SizeUpTree {
  my $curr=shift();
  my $addsize=shift();

  my @foo = split /\//, $curr;
  while (@foo) {
    my $dir = join "/", @foo;
    $fs{$dir}{size}+=$addsize;
    pop(@foo);
  }
  $fs{"/"}{size}+=$addsize;
}

sub DirSizes { # Establish all the directory sizes
  my $currdir=shift();
  my $size=0;

  foreach my $item (keys %{ $fs{$currdir}{contains} }) {
    if ($fs{$item}{type} eq 'f') {
      $size+=$fs{$item}{size};
    } else {
      $size+=DirSizes($item);
    }
  }

  $fs{$currdir}{size}=$size;
  return $size;
}
