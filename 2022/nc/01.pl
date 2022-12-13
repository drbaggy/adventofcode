my@e=(0);
/\d/?($e[-1]+=$_):push@e,0for<>;
say for sub{$_[0],$_[0]+$_[1]+$_[2]}->(sort{$b<=>$a}@e)
