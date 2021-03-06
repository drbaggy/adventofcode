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

is( solution(5,'test.txt'), 127 );
done_testing();

say solution();

sub solution {
  my ($size,$file_name) = @_;
  $size ||= 25;
  # Initialize slurp variables
  my @buffer;
  my $answer = 0;
  slurp_file( sub {
    if( @buffer < $size ) {
      push @buffer, $_[0];
      return;
    }
    foreach my $x (@buffer) {
      foreach my $y (@buffer) {
        if( $x != $y && $x + $y == $_[0] ) {
          push @buffer, $_[0];
          shift @buffer;
          return;
        }
      }
    }
    $answer = $_[0];
    die;
    # Code to process each line of input
  }, $file_name );
  ## Now the work horse bit
  return $answer;
}

