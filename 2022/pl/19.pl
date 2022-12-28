use strict;
use warnings;
use feature qw(say);
use Time::HiRes qw(time);
use Data::Dumper qw(Dumper);

my($t,$n,$c,$f,$p,@res)=(1,0,0,'t-19');
#my($t,$n,$c,$f,$p,@res)=(1,0,0,'19.txt');

my $fn=__FILE__=~s/[^\/]*$//r.'../data/'.$f;1while($fn=~s/[^\/]*\/\.\.\///);
my $time = time;

open my $fh,'<',$fn;
my @bps=map{[m{\d+.*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?(\d+).*?(\d+)}]}<$fh>;
close$fh;

for(0..9) {$c=0;
$n += P->new($_,24)->walk * ++$c for @bps;
}
#$t *= P->new($_,32)->walk        for @bps[0,1,2];

say"Time:",sprintf'%0.6f',time-$time;
say"$n\n$t";

package P;
sub ceil{ int 0.99999+$_[0] }

sub new{
  my ($class,$bp,$tm)=@_;
  bless{
    'time'=>$tm||24, 'best'=>0, 'ore'=>[@{$bp}[0,1,2,4]], 'oth'=>[0,0,@{$bp}[3,5]],
    'max' =>[(sort{$b<=>$a}@{$bp}[0,1,2,4])[0],@{$bp}[3,5],1e6]
  },$class
}

sub walk{
  my $self=shift;
  my $s=$_[0]||[[1,0,0,0],[0,0,0,0],$self->{'time'}];
  my @robots = @{$s->[0]};
  my @units  = @{$s->[1]};
  my $time   = $s->[2];
  for my $t(3,2,1,0){
    next if $robots[$t]>$self->{'max'}[$t]||
            $t&&!$robots[$t-1]||
            $units[3]+($robots[3]*$time)+$time*($time-1)/2<=$self->{'best'};
    my $steps_ore=$units[0]>$self->{'ore'}[$t]?0:($self->{'ore'}[$t]-$units[0])/$robots[0];
    my $steps_oth=$t<2?0:$units[$t-1]>$self->{'oth'}[$t]?0:($self->{'oth'}[$t]-$units[$t-1])/$robots[$t-1];
    my $steps=1+ceil($steps_ore<$steps_oth?$steps_oth:$steps_ore);
    $steps=$time if$steps>$time;
    my @units_up=map{$units[$_]+$robots[$_]*$steps}0..3;
    if($time>$steps){
      $units_up[0]-=$self->{'ore'}[$t],$units_up[$t-1]-=$self->{'oth'}[$t],
      my @robots_up=@robots;$robots_up[$t]++;
      $self->walk([\@robots_up,\@units_up,$time-$steps])
    }
    $self->{'best'}=$units_up[3] if $units_up[3]>$self->{'best'}
  }
  $self->{'best'}
}
