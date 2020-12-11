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
use Time::HiRes qw(sleep);

my $DEBUG = @ARGV;

my $ROOT_PATH;
BEGIN { $ROOT_PATH = dirname(dirname(dirname(abs_path($PROGRAM_NAME)))); }
use lib $ROOT_PATH;

use AdventSupport;
## END OF BOILER PLATE;

is( solution('test.txt'), 37);
done_testing();

say solution();

my $h;
my $w;
sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  my $grid = [];
  slurp_file( sub {
    push @{$grid},$_[0] if $_[0] =~ m{[.L]};
  }, $file_name );

  ## Get height and width of grid... helps with the loop
  $h = @{$grid}; $w = length $grid->[0];

  sub occ {
    my($g,$y,$x) = @_;
    return 0 if $y < 0 || $x < 0 || $y >= $h || $x >= $w;
    return '#' eq substr $g->[$y], $x, 1;
  }

  my $new_grid;
  while(1) {
    $new_grid = [ map {$_} @{$grid} ];
    ## The only option here is to brute force
    foreach my $y (0..($h-1)) {
      foreach my $x (0..($w-1)) {
        my $s = substr $grid->[$y], $x, 1;
        next if q(.) eq $s; ## No chair die...
        my $n = occ($grid,$y  ,$x+1)+occ($grid,$y  ,$x-1)
              + occ($grid,$y+1,$x+1)+occ($grid,$y+1,$x-1)+occ($grid,$y+1,$x)
              + occ($grid,$y-1,$x+1)+occ($grid,$y-1,$x-1)+occ($grid,$y-1,$x)
              ;
        substr $new_grid->[$y],$x,1,'L' if $s eq '#' && $n >= 4;
        substr $new_grid->[$y],$x,1,'#' if $s eq 'L' && $n == 0;
      }
    }
    if($DEBUG) {
      sleep 0.25;
      print "\033[0;0H".join("\n",@{$new_grid},'');
    }
    last if "@{$new_grid}" eq "@{$grid}";
    $grid = $new_grid;
  }
  my $count = 0; $count += tr/#/#/ foreach @{$new_grid};
  ## Now the work horse bit
  return $count;
}

