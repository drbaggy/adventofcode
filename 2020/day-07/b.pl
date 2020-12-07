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

is( solution('test.txt'), 32 );
is( solution('test2.txt'), 126 );
done_testing();

say solution();

sub count_bags_in_bag {
  my( $colour, $mapping ) = @_;
  my $sum = 1;
  $sum += $mapping->{$colour}{$_} * count_bags_in_bag( $_, $mapping )
    foreach keys %{$mapping->{$colour}};
  return $sum;
}
sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my ( $mapping, $rev_map ) = {}, {};

  slurp_file( sub {
    # Code to process each line of input
    my( $colour, $pt2 ) = split m{ bags contain }, $_[0];
    $mapping->{ $colour } = { reverse $pt2 =~ m{(\d+) (.*?) bags?}g };
  }, $file_name );

  return count_bags_in_bag( 'shiny gold', $mapping ) - 1; ## This is an inclusive number so we remove 1 for the shiny gold bag!
}

