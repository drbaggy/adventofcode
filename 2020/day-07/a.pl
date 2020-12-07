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

is( solution('test.txt'), 4 );
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables

  my $rev_map = {};

  slurp_file( sub {
    my( $col, $pt2 ) = split m{ bags contain }, $_[0];
    $rev_map->{$_}{$col}++ foreach $pt2 =~ m{\d+ (.*?) bags?}g ;
  }, $file_name );

  my %bag_colours;
  my @queue = ( 'shiny gold' );

## OK this is very nasty abuse of perl...

  map { $bag_colours{$_} ++ || push @queue,$_ }
    keys %{$rev_map->{$_}||{}}
      while $_ = shift @queue;

  return scalar keys %bag_colours;
}

