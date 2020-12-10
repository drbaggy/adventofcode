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

is( solution('test.txt'), 35 );
is( solution('test2.txt'), 220 );
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my $ad = 'x';
  slurp_file( sub {
    $ad .= ' ' x ($_[0]-length $ad) if $_[0]>length $ad;
    substr $ad,$_[0],1,'x';
    # Code to process each line of input
  }, $file_name );
  $ad.='  x';
  my $threes   = @{[ $ad =~ m{(x  (?=x))}g ]};
  #my $twos     = @{[ $ad =~ m{(x (?=x))}g ]};
  my $ones     = @{[ $ad =~ m{(x(?=x))}g ]};
  return $threes * $ones;
}

