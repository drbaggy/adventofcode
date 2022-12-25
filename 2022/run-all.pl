#!/usr/local/bin/perl
use feature qw(say);

my @names = (
  '-pad-',
  'Calorie counting',
  'Rock, paper, scissors',
  'Rucksack reorganization',
#); my @QQQ = (
  'Camp cleanup',
  'Supply stacks',
  'Tuning trouble',
  'No space left on device',
  'Treetop tree houses',
  'Rope bridge',
  'Cathode-ray tube',
  'Monkey in the middle',
  'Hill climbing algorithm',
  'Distress signal',
  'Regolith reservoir',
  'Beacon exclusion zone',
  '*Proboscidea Volcanium*',
  'Pyroclastic flow',
  'Boiling boulders',
  'Not enough minerals',
  'Grove Positioning System',
  'Monkey math',
  'Monkey map',
  'Unstable diffusion',
  'Blizzard basin',
  'Full of hot air',
);

use strict;
use Time::HiRes qw(time);
my $out;
my $t0 =time;
my $T = 0;
my $N = 0;
my $C = 0;
my @T;
my $OUT = '
| Day | Files | Name | Size | Time | %age | Answer 1 | Answer 2 |
| --: | :-- | :-- | --: | --: | --: | --: | --: |';

for my $dn ( 1 .. $#names ){
  my ($t,$m,$n,$tt)=1e6;
  my $fn = sprintf '%02d', $dn;
  for my $l (0..49) {
    my $out = `perl pl/$fn.pl`;
    ($tt,$m,$n) = split/ /, $out =~ s{Time\s*:}{}r =~ s{\s+}{ }gr;
    $t=$tt if $tt<$t;
  }
  my $b = -s "nc/$fn.pl";
  $T+=$t;
  $N+=$b;
  $C++;
  push @T,[ $fn, $names[$dn], $b, $t, $m, $n, $dn ];
  warn "$dn: $names[$dn] $t, $T, ",time-$t0;
}
foreach (@T) {
  $OUT .= join '',"\n| $_->[6] | [`Pl`](pl/$_->[0].pl) [`Com`](nc/$_->[0].pl) [`In`](data/$_->[0].txt) [`Out`](out/$_->[0].txt) [`AOC`](https://adventofcode.com/2022/day/$_->[6]) | [$_->[1]]($_->[0].md) | ",
    $_->[2] =~ s{(...)$}{ $1}r," | ", sprintf('%0.6f',$_->[3]) =~ s/(...)$/ $1/r, ' | ',sprintf( '%0.3f', $_->[3]/$T*100 ),'% | ',com( $_->[4]),' | ', com( $_->[5] ),' |';
}

sub com { my $x = $_[0]; unless( $x=~m{\D}) { $x = reverse $x; $x =~ s{(...)}{$1 }g; $x = reverse $x; } $x }

$OUT .= join '', '
| | | | | | | | |
| **TOTAL** | | **',sprintf('%0.3f',$N/1024),'KB** | **',sprintf('%d',$N)=~s/(...)$/ $1/r=~s/^ //r,'** | **', sprintf( '%0.6f',$T    )=~s/(...)$/ $1/r, '** | | | |
| ***Mean*** | | | ***',sprintf('%0.1f',$N/$C),'*** | ***', sprintf( '%0.6f',$T/$C )=~s/(...)$/ $1/r, '*** | | | |
';
say $OUT =~ s/\| +/| <sub>/gr =~ s/ +\|/<\/sub> |/gr =~ s/<sub>\|/|/gr =~ s/<sub>([:-]+)<\/sub>/$1/gr

