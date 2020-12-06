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

is( solution('test.txt'), 11);
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my %qs;
  my $res;
  slurp_file( sub {
    if($_[0] =~ m{\w}) {
      $qs{$_}++ foreach split m{}, $_[0];
    } else {
      $res += keys %qs;
      %qs=();
    }
    # Code to process each line of input
  }, $file_name, 1 );
  ## Now the work horse bit
  return $res;
}

