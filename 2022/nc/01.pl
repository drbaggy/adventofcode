my @e=(0);
open my $fh, '<', 'data/01.txt';
/\d/ ? ($e[-1]+=$_) : push @e,0 while <$fh>;
close $fh;
say for sub { $_[0], $_[0]+$_[1]+$_[2] }->(sort {$b<=>$a} @e);
