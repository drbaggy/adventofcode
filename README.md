# adventofcode
Advent of code

## Template....

```perl
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

my $ROOT_PATH;
BEGIN { $ROOT_PATH = dirname(dirname(dirname(abs_path($PROGRAM_NAME)))); }
use lib $ROOT_PATH;

use AdventSupport;
## END OF BOILER PLATE;

is( solution('test.txt'), 'result');
done_testing();

say solution();

sub solution {
  my $file_name = shift;
  # Initialize slurp variables
  slurp_file( sub {
    # Code to process each line of input
  }, $file_name, 0 );
  ## Now the work horse bit
  return 'result';
}
```

## Support module - AdventSupport

```perl
package AdventSupport;
use strict;
use warnings;
use base qw(Exporter);

use File::Basename qw(dirname);
use English qw(-no_match_vars $PROGRAM_NAME $PERL_VERSION);
use Cwd qw(abs_path);
use Data::Dumper;
use Test::More;
use Const::Fast;

our @EXPORT      = qw(slurp_file);
our @EXPORT_OK   = @EXPORT;
our %EXPORT_TAGS = ('ALL' => \@EXPORT );

my $PROGRAM_PATH;
BEGIN { $PROGRAM_PATH = dirname(abs_path($PROGRAM_NAME)); }

sub slurp_file {
  my($fn,$file,$flag) = @_;
  $file ||= 'in.txt';
  $flag ||= 0;
  open my $fh, q(<), $PROGRAM_PATH.q(/).$file or die "Filename $file doesn't exist\n";
  while(<$fh>) {
    chomp;
    &{$fn}( $_ );
  }
  close $fh;
  &{$fn}(q()) if $flag;
}

1;
```
