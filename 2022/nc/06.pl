my$i=<>;
sub f {
my$x=substr my$s=$_[0],0,my$n=$_[1],'';
$x=~/(.).*\1/?($n++,$x=substr($x,1).substr$s,0,1,''):return$n while$s
}
say for map{f $i,$_}4,14
