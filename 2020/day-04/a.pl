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

is( solution('test.txt'), 2 );
done_testing();

say solution(undef);

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my %keys;
  my $count=0;
  slurp_file( sub {
    if($_[0] =~ m{\S}) {
      $keys{$_}++ foreach grep { $_ ne 'cid' } split m{:\S+\s*}, $_[0];
    } else {
      $count++ if "@{[ sort keys %keys]}" eq 'byr ecl eyr hcl hgt iyr pid';
      %keys =();
    }
    # Code to process each line of input
  }, $file_name, 1 );
  ## Now the work horse bit
  return $count;
}

