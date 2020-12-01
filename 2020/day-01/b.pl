#!/usr/local/bin/perl

use strict;
use warnings;
use feature qw(say);

use File::Basename qw(dirname);
use English qw(-no_match_vars $PROGRAM_NAME);
use Cwd qw(abs_path);
use Data::Dumper qw(Dumper);

my $ROOT_PATH;
BEGIN {
  $ROOT_PATH = dirname(abs_path($PROGRAM_NAME));
}
use lib dirname( dirname( $ROOT_PATH ) );
use AdventSupport qw(slurp_file init);
init($ROOT_PATH);
## Open input file...
#open my $fh, q(<), $ROOT_PATH.'/in.txt';

my %seen;
slurp_file( sub { $seen{1*$_}=1; }, 'in.txt' );
#$seen{1*$_}=1 while <$fh>;
#close $fh;

foreach my $o (keys %seen) {
  next if $o < 673;
  say "@{[ $o, $_, 2020-$_-$o, $_ * $o * (2020-$_-$o) ]}" foreach grep { $o>$_ && 2020-$o-$_<$_ && exists $seen{2020-$_-$o} } keys %seen;
}
