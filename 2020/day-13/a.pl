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

is( solution( 939, '7,13,x,x,59,x,31,19' ), 295 );
done_testing();

say solution(
 '41,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,'.
 'x,x,x,x,x,37,x,x,x,x,x,557,x,29,x,x,x,x,x,x,x,x,x,x,13,x,x,x,'.
 '17,x,x,x,x,x,23,x,x,x,x,x,x,x,419,x,x,x,x,x,x,x,x,x,x,x,x,x,x'.
 ',x,x,x,x,19'
);

sub solution {
  my( $id, $next, $t0, @times ) = ( undef, 1e30, $_[0], grep { m{\d} } split m{,}, $_[1] );
  ($id,$next) = $_ - ( $t0 % $_ ) > $next ? ($id,$next) : ($_,$_ - ( $t0 % $_ )) foreach @times;
  return $next * $id;
}

