#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);

use File::Basename qw(dirname);
use English qw(-no_match_vars $PROGRAM_NAME);
use Cwd qw(abs_path);
use Data::Dumper qw(Dumper);
use Test::More;

my $ROOT_PATH;
BEGIN { $ROOT_PATH = dirname(abs_path($PROGRAM_NAME)); }
use lib dirname( dirname( $ROOT_PATH ) );
use AdventSupport qw(slurp_file init);
init($ROOT_PATH);
## END OF BOILER PLATE;

is( solution('test.txt'), 1 );
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  my $valid_passwords;

  slurp_file( sub {
    my( $min,$max,$letter,$pw ) = $_[0]=~m{(\d+)-(\d+)\s+(\w):\s+(\w+)}mxs;
    $valid_passwords++ if ( $letter eq substr $pw, $min-1, 1 ) ^ ( $letter eq substr $pw, $max-1, 1 );
  }, $file_name );

  return $valid_passwords;
}

