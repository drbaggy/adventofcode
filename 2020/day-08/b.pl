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
use AOC2001;

## END OF BOILER PLATE;

is( solution('test.txt'), 8 );
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my $comp = AOC2001->new();
  slurp_file( sub {
    $comp->add( $_ );
    # Code to process each line of input
  }, $file_name );
  ## Now the work horse bit
  foreach my $op_no ( 0 .. $comp->no_steps -1 ) {
    $comp->reset;
    if( $comp->op( $op_no ) eq 'nop' ) {
      $comp->set_op( $op_no, 'jmp' );
      $comp->step until $comp->finished || $comp->executed;
      $comp->set_op( $op_no, 'nop' );
    } elsif( $comp->op( $op_no ) eq 'jmp' ) {
      $comp->set_op( $op_no, 'nop' );
      $comp->step until $comp->finished || $comp->executed;
      return $comp->acc if $comp->finished;
    }
  }
  return 'Nothing finished';
}

