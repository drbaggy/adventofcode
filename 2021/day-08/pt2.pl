#!/usr/bin/perl

use strict;
use warnings;
use feature qw(say);

my $total = 0;

while( my $line = <>) {
  ## Process line to get out 14 strings into array.
  ## Extract last 4 which out the output - which we will need later.
  ## To avoid ambiguity and to make the regex solution work we
  ## sort the letters in each array into alphabetic order.

  chomp $line;
  my @in  = map { join '', sort split // } split /[\s|]+/, $line;
  my @out = splice @in,-4,4;

  ## First job create an array of arrays where the array is keyed
  ## on the length of the string and the values is an array of
  ## strings of the given length.
  ## To avoid an error in the digits line below we initialise the
  ## array for length 0...

  my @len = (['']);
  push @{$len[length $_]}, $_ for @in;

  ## Now we create an array of which string matches each digit.
  ## There are four unique length strings...
  ## 1 has length 2, 7 has length 3, 4 has length 4 and 8 has
  ## length 7.

  my @digits = map { $len[$_][0] } qw(0 2 0 0 4 0 0 3 7 0);

  ## Next we will use regular expressions to identify the other
  ## digits. We create regexs to match the numbers 1, 4, 7 as
  ## we can use these to distinguish certain numbers.

  my ($re_1,$re_4,$re_7) = map { join '.*', split //, $digits[$_] } qw(1 4 7);

  ## There are three digits with 6-character strings 0, 6 & 9.
  ## Of these the only one that "contains" the number 4 is 9...
  ## Of these the only one that doesn't "contain" the number 1 is 6...

  $digits[ m{$re_4} ? 9 : m{$re_1}     ? 0 : 6 ] = $_ for @{$len[6]};

  ## Finally we do the 5-characther strings 2,3,5.
  ## Of these the only one that "contains" the number 7 is 3...
  ## But we need another regex to distinguish between 2 + 3.
  ## We note that the top right vertical bar is only in 2 - and is
  ## the only one not in 6. So we use this to identify 2.

  my $re_not_6 = join '', '[^', $digits[6], ']';
  $digits[ m{$re_7} ? 3 : m{$re_not_6} ? 2 : 5 ] = $_ for @{$len[5]};

  ## To get the number first we flip the keys/values of the array
  ## of digits. And then use this to generate the 4 digits.
  ## We add this to the total and then we are good to go!

  my %map = map { $digits[$_] => $_ } 0..9;
  $total += join '', map { $map{$_} } @out;
}

say $total;

