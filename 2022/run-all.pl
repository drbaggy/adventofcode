#!/usr/local/bin/perl
use feature qw(say);

my @names = (
  '-pad-',
  'Calorie counting',
  'Rock, paper, scissors',
  'Rucksack reorganization',
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
  'Proboscidea Volcanium',
  'Pyroclastic flow',
  'Boiling boulders',
  'Not enough minerals',
  'Grove Positioning System',
  'Monkey math',
  '', ## 'Monkey map',
  'Unstable diffusion',
  '', ## 'Day 24'
  '', ## 'Day 25'
);

use strict;
use Time::HiRes qw(time);
my $out;
open my $o, '>', \$out;
my $std = select $o;
my $t0 =time;
my $T = 0;
my $N = 0;
my $tot_time = 0;
for ( 1 .. $#names ){
  warn $_,' -> "',$names[$_],'"';
  next if !$names[$_];
  my $pd = sprintf 'YYYY%2d',$_;
  my $fn = sprintf '%02d',$_;
  $T += -s "nc/$fn.pl";
  $N ++;
  print "XXXX     $pd     | [`Pl`](pl/$fn.pl) [`Com`](nc/$fn.pl) [`In`](data/$fn.txt) [`Out`](out/$fn.txt) [`AOC`](https://adventofcode.com/2022/day/$_)".($_<10?' ':'').' | ',sprintf('%-40s',sprintf'[%s](%02d.md)',$names[$_],$_ ),' |    ',sprintf('%6d',-s "nc/$fn.pl")=~s{(...)$}{ $1}r,"    | ";
   do "./pl/$fn.pl";
}

select $std;
close $o;
open my $of, '>', 'of.txt'; print $of $out; close $of;
$tot_time += $_ for $out =~ m{Time\s*:\s*(\d+\.\d+)}g;

$out =~ s{\s*[\r\n]}{\t}g;
$out =~ s{\t(\S+)}{" | ".fm($1)}ge;
$out =~ s{XXXX}{ |\n| }g;
$out =~ s{[|]\s*[|]$}{|}gmxs;
$out =~ s{YYYY}{}g;
$out =~ s{Time\s*:\s*(\d+\.\d+)}{my $x=$1;(sprintf('   %10.6f',$1)=~s/(...)$/ $1/r ).sprintf'    | %8.3f%%', $x*100/$tot_time }ge;
$out =~ s{\t}{}g;
print join ( '','
| Day         | Files                                                                                                                    | Name                                     | Size          | Time              |      %age | Answer 1             | Answer 2             |
| ----------- | :----------------------------------------------------------------------------------------------------------------------- | :--------------------------------------- | ------------: | ----------------: | --------: | -------------------: | -------------------:', $out,' |
|             |                                                                                                                          |                                          |               |                   |           |                      |                      |
| **TOTAL**   |                                                                                                                          |                                          |  ~~',sprintf('%6d',$T)=~s/(...)$/ $1/r,'**  |  ~~', sprintf( '%10.6f',$tot_time    )=~s/(...)$/ $1/r, '**  |           |                      |                      |
| ***Mean***  |                                                                                                                          |                                          | ~~~',sprintf('%7.1f',$T/$N),           '*** | ~~~', sprintf( '%10.6f',$tot_time/$N )=~s/(...)$/ $1/r, '*** |           |                      |                      |

' ) =~ s{(\~\~\~?)(\s*)}{my $T=$2;$T.( ($1=~s/~/*/gr) )}ger =~ s/[|] /| <sub>/gr =~ s/ [|]/<\/sub> |/gr =~ s/(<sub>)( +)/\1/gr =~ s/( +)(<\/sub>)/\2/gr =~ s{<sub>([:-]*)</sub>}{$1}gr;

sub fm {
  my $x = $_[0];
  unless( $x=~m{\D}) {
    $x = reverse $x;
    $x =~ s{(...)}{$1 }g;
    $x = reverse $x;
  }
  sprintf '%20s',$x;
}
