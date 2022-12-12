use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

my $t = my $n = 0;

## Create an array `@k` containing the path {well the
## path for each element of the path - so:
## d1, d1/d2, d1/d2/d3....
## and a hash `%s` which contains the size in bytes of
## each of these folders

my( @k, %s );

## For every line of the file we do one of 3 things
##  * change the current path
##  * add the file size to all the directories in the
##    current path (in `@k`)
##  * nothing (`ls` & `dir something`)

## Reseting (`/`) and moving up a directory (`..`) are
## *trivial* in one is a pop of the key list, and the
## other is a reset.
## Moving into a directory is slightly more complex
## IF the path is empty - we just add it .. if not
## we push - but first prefixing the current directory

## We use nested ternaries for this

my$fn=__FILE__=~s/[^\/]*$//r.'../data/07.txt';1while($fn=~s/[^\/]*\/\.\.\///);
open my $fh, q(<), $fn;
  m{^(\d+)}       ? map { $s{$_}+=$1 } ('/', @k)
: m{\$ cd \.\.$}  ? pop @k
: m{\$ cd /$}     ? @k=()
: m{\$ cd (\S+)} && push @k, @k ? "$k[-1]/$1" : $1
  while <$fh>;
close $fh;

## Finally the calculations
## For part 1 we just need to sum the directories
## which have size <= 10^5. These are just stored in the
## values of %s

$t+=$_                   for grep { $_ <= 1e5 }               values %s;

## For part 2, we need to work out what size directory to
## remove. Well as we need 3x10^7 space left from 7x10^7. We
## need to find a folder that is greater than current use - 4e7
## Current use is the size of `/` - so
## we just need the smallest value of vlaues %s for which
## is greater than this value...

$n = $s{'/'};
($n > $_) && ( $n = $_ ) for grep { $_ >= $s{'/'} - 4e7 } values %s;

## Finally we output the results

say "Time :", sprintf '%0.6f', time-$time;
say "$t\n$n";
