#!/usr/bin/perl

my $instr = "dcmlhejnifpokgba";
#$instr = "baedc";

my $loop = 2000;
#$loop = 1;


my @ch = split //,$instr;
my $end = @ch;
#print "$end";
my @result;
for (my $i=0; $i<$end; $i++) {
   my $num = AtoI($ch[$i]);
   #print "$num ";

   my $diff = $num - $i;
   my $num = ($i + $diff);
   #print "$num ";
   $num = $num % $end;
   #print "$num\n---------------\n";
   for (my $iter=0; $iter<$loop-1; $iter++) {
     $num += $diff;
     #print "$num ";
     $num = $num % $end;
     #print "$num ";
     #$pr = $iter % 2000;
     #print "$iter for $i: $num\n" if ($pr==0);
   }
   push (@result,$num);
}

for(my $i=0; $i<$end; $i++) {
  my $ch = ItoA($result[$i]);
  print "$ch";
}
print "\n";


sub AtoI {
  my $ch = shift ();
  my %atoi = ( "a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7, "i" => 8, "j" => 9, "k" => 10, "l" => 11, "m" => 12, "n" => 13, "o" => 14, "p" => 15, );

  return $atoi{$ch};
}

sub ItoA {
  my $i = shift ();
  my @itoa = ("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p");

  return $itoa[$i];
}
