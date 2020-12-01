#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);

use File::Basename qw(dirname);
use English qw(-no_match_vars $PROGRAM_NAME);
use Cwd qw(abs_path);
use Data::Dumper qw(Dumper);

my $ROOT_PATH;
BEGIN { $ROOT_PATH = dirname(abs_path($PROGRAM_NAME)); }
use lib dirname( dirname( $ROOT_PATH ) );
use AdventSupport qw(slurp_file init);
init($ROOT_PATH);
## END OF BOILER PLATE;

my %seen; slurp_file( sub { $seen{1*$_}=1; }, 'in.txt' );

say "@{[ $_, 2020-$_, $_ * (2020-$_) ]}" foreach grep { $_ < 1011 && exists $seen{2020-$_} } keys %seen;
