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
const my $INV => (1<<36)-1;

use AdventSupport;
## END OF BOILER PLATE;

is( solution('test-b.txt'),208);
done_testing();


say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my( $mask_or, $mask_and, @mask_float, %mem ) = (0,$INV);
  start_timer();
  slurp_file( sub {
    if($_[0] =~ m{mem\[(\d+)\] = (\d+)} ) {
      my $v = $1 & $mask_and | $mask_or;
      $mem{$_}    = $2 foreach addrs( $v, @mask_float );
    } elsif( $_[0] =~ m{mask = (\S+)} ) {
      @mask_float = map { ('X' eq substr $1, 35-$_, 1) ? 1<<$_ : () } 0..35;
      $mask_and   = oct( '0b'.$1 =~ tr{0X}{10}r );
      $mask_or    = oct( '0b'.$1 =~ tr{X}{0}r   );
    }
  }, $file_name );

  my $res = 0;
  $res+= $_ foreach values %mem;
  say duration();
  return $res;
}

sub addrs {
  my( $addr, $t, @bits ) = @_;
  return $t ? ( addrs( $addr, @bits ), addrs( $t | $addr, @bits ) ) : $addr;
}

