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

is( solution('test.txt'), 336);
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize the "instructions"/"data collection" objects...

  my @moves      = map { { 'jump_r'=>$_->[0], 'jump_d'=>$_->[1], 'pos'=>0, 'row'=>0, 'count'=>0 } }
                   [1,1], [3,1], [5,1], [7,1], [1,2];
  my $ROW_LENGTH = 0;

  ## Let's write this so we don't have to cache rows...
  ## We will keep track of all the "runs" at once...
  ## We cache the length of the string...

  slurp_file( sub {
    ## Get the length of the rows from the first row (and then throw it away as we know it is not a tree)
    return $ROW_LENGTH = length $_[0] unless $ROW_LENGTH;

    ## Loop through each of the rows - jumping right if it is the row to do so - and looking for a tree!
    $_->{'count'} += q(#) eq substr $_[0], ( $_->{'pos'} += $_->{'jump_r'} ) % $ROW_LENGTH, 1
      foreach grep { ! (++$_->{'row'} % $_->{'jump_d'}) } @moves;
  }, $file_name );

  ## Just get the product
  my $product = 1;
  $product *= $_->{'count'} foreach @moves;

  return $product;
}

