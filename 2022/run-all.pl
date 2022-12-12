#!/usr/local/bin/perl

use strict;
use Time::HiRes qw(time);
my $out;
open my $o, '>', \$out;
my $std = select $o;
my $t0 =time;
my $T = 0;
for ( 1..12 ){
  my $pd = sprintf 'YYYY%2d',$_;
  my $fn = sprintf '%02d',$_;
  $T += -s "nc/$fn.pl";
  print "XXXX  $pd  | ",sprintf('%6d',-s "nc/$fn.pl")," | ";
   do "./pl/$fn.pl";
}
select $std;
close $o;
$out =~ s{[\r\n]}{\t}g;
$out =~ s{XXXX}{ |\n| }g;
$out =~ s{YYYY}{}g;
$out =~ s{Time :}{}g;
$out =~ s{\t(\S+)}{" | ".sprintf('%12s',$1)}ge;
$out =~ s{\t}{}g;
print "
| Day   | Size   | Time     | Part 1       | Part 2       |
| ----- | -----: | -------: | -----------: | -----------:$out |
|       |        |          |              |              |
| TOTAL | ".sprintf('%6d',$T)." | ".sprintf( '%0.6f',time-$t0 ),
' |              |              |

';
