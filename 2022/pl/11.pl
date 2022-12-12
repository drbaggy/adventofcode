use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
my $time = time;

my $t = my $n = 0;

my($F,$i,@a,@res) = 1;

my$fn=__FILE__=~s/[^\/]*$//r.'../data/11.txt';1while($fn=~s/[^\/]*\/\.\.\///);
open my $fh, q(<), $fn;
m{ey (\d+):}     ? ( $a[$1]      = { 'c'=>0 }, $i          = $1    ) :
m{ld (.) (\d*)}  ? ( $a[$i]{'o'} = $1,         $a[$i]{'m'} = $2||0 ) :
m{by (\d+)}      ? ( $a[$i]{'d'} = $1,         $F         *= $1    ) :
m{ue.*(\d+)}     ? ( $a[$i]{'t'} = $1                              ) :
m{se.*(\d+)}     ? ( $a[$i]{'f'} = $1                              ) :
m{ms: (\d.*)}   && ( $a[$i]{'s'} = [ split /, /, $1 ]              )
  while <$fh>;
close $fh;

for my $c ( [3,20], [1,10_000] ) {
  my( $D, $R ) = @{$c};
  $_->{'i'} = [@{$_->{'s'}}], $_->{'c'} = 0 for @a;
  for my $r ( 1 .. $R ) {
    for my $m (@a) {
      $_ = int( ($m->{'o'} eq '*' ? $_ * ($m->{'m'}||$_) : $_ + ($m->{'m'}||$_) )/$D) % $F,
        push @{$a[$m->{ $_%$m->{'d'} ? 'f' : 't' } ]{'i'}}, $_ for @{$m->{'i'}};
      $m->{'c'} += @{$m->{'i'}};
      $m->{'i'} =  [];
    }
  }
  push @res, sub { $_[0]*$_[1] }->( sort { $b <=> $a } map { $_->{'c'} } @a );
}

say "Time :", sprintf '%0.6f', time-$time;
say for @res;
