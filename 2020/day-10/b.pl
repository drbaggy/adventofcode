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

my %part_cache = qw(x 1 xx 1);

## END OF BOILER PLATE;
#printf "%5d %s\n", count_part($_), $_ foreach
#exit;

my %test_counts = (
   'x' => 1 , 'xx' => 1 , 'xxx' => 2 , 'xxxx' => 4 , 'xxxxx' => 7 , 'xxxxxx' => 13 , 'xxxxxxx' => 24 , 'xxxxxxxx' => 44,
   'x x' => 1 , 'x x x' => 1 , 'x x x x' => 1 , 'x x x x x' => 1 , 'x x x x x x' => 1 ,
   'x xx' => 2 , 'xx x' => 2 , 'xx xx' => 3 , 'x x xx' => 2 , 'x xx x' => 3 , 'x xx xx' => 5 , 'xx x x' => 2 , 'xx x xx' => 4 , 'xx xx x' => 5 , 'xx xx xx' => 8,
);

is( count_part($_), $test_counts{$_} ) foreach keys %test_counts; ## Test the count part function with a sample of test cases before testing main function.
is( solution('test.txt'), 8 );
is( solution('test2.txt'), 19208 );
done_testing();

say solution();

sub count_part {
  my $str = shift;
  return 0 if $str eq '' || ' ' eq substr $str, 0, 1;
  ## We need the sum of the counts if we jump each of the 3 possible adaptors (+1,+2,+3)
  return $part_cache{$str} ||= count_part( substr $str,1 ) + count_part( substr $str,2 ) + count_part( substr $str,3 );
}

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my $ad = 'x';
  slurp_file( sub {
    $ad .= ' ' x ($_[0]-length $ad) if $_[0]>length $ad;
    substr $ad,$_[0],1,'x';
  }, $file_name );

  ## We know that if there is a "three" gap then there is only
  ## one way to bridge this gap.
  ## We can then look for all chunks of sequence which don't contain
  ## a three gap - in our string representation this would be a
  ## string without "  " contained in it.. We then count the combinations
  ## for each block and multiply them together

  my $res = 1;
  $res *= count_part($_) foreach split m{  }, $ad;
  return $res;
}

