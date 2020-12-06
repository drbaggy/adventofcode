#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);

use File::Basename qw(dirname);
use English qw(-no_match_vars $PROGRAM_NAME);
use Cwd qw(abs_path);
use Data::Dumper qw(Dumper);
use Test::More;
use Const::Fast qw(const);

my $ROOT_PATH;
BEGIN { $ROOT_PATH = dirname(dirname(dirname(abs_path($PROGRAM_NAME)))); }
use lib $ROOT_PATH;

use AdventSupport;
## END OF BOILER PLATE;

is( solution('test.txt'), 6);
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my $res = 0;
  my %qs;
  my $count=0;

  ## We need to make this an "all" calculation...
  ## So we continue to "count" each answer, but also
  ## count the number of people.
  ## The number of alls is those letters for which
  ## the count of the letter equals the count of the
  ## person...

  slurp_file( sub {
    if($_[0] =~ m{\w}) {
      $qs{$_}++ foreach split m{}, $_[0];
      $count++;
    } else {
      $res += grep { $_ == $count } values %qs;
      $count=0;
      %qs=();
    }
    # Code to process each line of input
  }, $file_name, 1 ); ## 1 <- add a blank line so we process the last group..

  ## Just return the result
  return $res;
}

