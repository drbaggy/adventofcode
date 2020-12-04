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

is( solution( 'test.txt'  ), 2 );
is( solution( 'test2.txt' ), 0 );
is( solution( 'test3.txt' ), 4 );
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my %keys;
  my $count=0;
  slurp_file( sub {
    if($_[0] =~ m{\S}) {
      foreach( split m{\s+}, $_[0] ) {
        my($k,$v) = split m{:};
        $keys{$k} = $v unless $k eq 'cid';
      }
    } else {
      $count++ if
           exists $keys{'byr'} && exists $keys{'ecl'} && exists $keys{'eyr'} && exists $keys{'hcl'}
        && exists $keys{'hgt'} && exists $keys{'iyr'} && exists $keys{'pid'}
        && $keys{'byr'} =~ m{^\d{4}$} && $keys{'byr'} >=1920 && $keys{'byr'}<=2002
        && $keys{'ecl'} =~ m{^(amb|blu|brn|gry|grn|hzl|oth)$}
        && $keys{'eyr'} =~ m{^\d{4}$} && $keys{'eyr'} >=2020 && $keys{'eyr'}<=2030
        && $keys{'hcl'} =~ m{^#[0-9a-f]{6}$}
        && $keys{'hgt'} =~ m{^(?:1(?:[5678]\d|9[0123])cm|(?:59|6\d|7[0-6])in)$}
        && $keys{'iyr'} =~ m{^\d{4}$} && $keys{'iyr'} >=2010 && $keys{'iyr'}<=2020
        && $keys{'pid'} =~ m{^\d{9}$}
        ;
      %keys =();
    }
    # Code to process each line of input
  }, $file_name, 1 ); ## 1 at the end forces an extra blank link to be processed so that the last entry gets processed
  ## Now the work horse bit
  return $count;
}

