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

const my $TOTAL => 2020;
const my $MAX   => $TOTAL/2;

is( solution( 'test.txt' ), 514579 );
done_testing();

say solution();

sub solution {
  my $filename = shift;
  my %seen;
  slurp_file( sub { $seen{ $_[0] } = 1; }, $filename );

  foreach ( keys %seen ) {
    return $_ * ( $TOTAL - $_ ) if $_ <= $MAX && exists $seen{ $TOTAL - $_ };
  }
}
