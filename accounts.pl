#!/bin/env perl

# Chris O'Brien
# CS-303
# 11/23/15

# program accounts.pl

# Read input record and create a file 
# containing an accounts recievable report

# data structure
# reference (hard and symbolic)
# subroutine
# hairy sort
# read from file

#use Data::Dumper;
#use Perl6::Form;

sub PrintHeader { #print headings
  $pageCount++;
  $lineCount = 0;
  print("\n======================================================================================================\n");
  printf("                           Chris' Bodacious Accounts Recievable Report                  Page %d\n\n", $pageCount);
  print("    Customer                           Previous       Current       Current          Current\n");
  print("     Number      Customer Name          Balance      Purchases     Pmts/Crdts        Balance\n");
  print("------------------------------------------------------------------------------------------------------\n");
}

sub UpdateTotals {
  $totalPrevBal += $prevBal;
  $totalPurch += $purchases;
  $totalPayCreds += $payCreds;
  $totalCurBal += $curBal;
  $lineCount++;
}

sub Commify { 
  #add commas to a number
  local $_  = shift;
  1 while s/^(-?\d+)(\d{3})/$1,$2/;

  #add zeroes at the end (if needed) for readability
  $num = $_;
  if (index($num, '.') == -1) { # detect decimal point
    $num .= ".00";
  }
  else {
    if (length($num) - index($num, '.') == 2){ # see where the decimal point is
      $num .= '0';
    }
  }
  if(index($num, '-') != -1){ # negative
    $num = reverse($num);
    chop ($num); #take off '-'
    $num = reverse ($num);

    $num .= "CR"; # add "CR"
  }
  else {
    $num .= "  ";
  }
  return $num;
}

#initialize variables
$totalPrevBal = 0;
$totalPurch = 0;
$totalPayCreds = 0;
$totalCurBal = 0;
$pageCount = 0;
$lineCount = 0;

PrintHeader();

open(INPUT, "program4.data");
while ($line = <INPUT>) { # read inpute, compute output, and then print it.
  if ($lineCount > 25) {
    print("\n\n\n");
    PrintHeader();
  }

  chomp $line;

  # inputs
  $number = substr($line, 0, 5);
  if($number == 0) { last; } # avoid printing the last entry
  $name = substr($line, 5, 18);
  $prevBal = (substr($line, 67, 8)) / 100;
  $purchases = (substr($line, 75, 8)) / 100;
  $payments = (substr($line, 83, 8)) / 100;
  $credits = (substr($line, 91, 8)) / 100;

  # calculations
  $payCreds = $payments + $credits;
  $curBal = $prevBal + $purchases - $payCreds;
  UpdateTotals();

  # output lines
  printf("     %5d      %18s   %12s   %12s   %12s   %12s\n", $number, $name, Commify($prevBal), Commify($purchases), Commify($payCreds), Commify($curBal));
} # end while

close(INPUT);

#print totals
printf("\n                        TOTALS:    %14s %14s %14s %14s\n", Commify($totalPrevBal), Commify($totalPurch), Commify($totalPayCreds), Commify($totalCurBal));

