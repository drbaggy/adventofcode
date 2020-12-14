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
no warnings qw(portable);

my $ROOT_PATH;
BEGIN { $ROOT_PATH = dirname(dirname(dirname(abs_path($PROGRAM_NAME)))); }
use lib $ROOT_PATH;

use AdventSupport;
## END OF BOILER PLATE;

is( solution('test.txt'),165);
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my( $mask_and, $mask_or, %mem ) = ((1<<36)-1,0);
  slurp_file( sub {
    if($_[0] =~ m{mem\[(\d+)\] = (\d+)} ) {
      $mem{$1} = ($2 & $mask_and) | $mask_or;
    } elsif( $_[0] =~ m{mask = (\S+)} ) {
      $mask_and = oct( '0b'.$1 =~ tr{X}{1}r );
      $mask_or  = oct( '0b'.$1 =~ tr{X}{0}r );
    }
    # Code to process each line of input
  }, $file_name );
  ## Now the work horse bit
  my $res = 0;
  $res+= $_ foreach values %mem;
  return $res;
}

