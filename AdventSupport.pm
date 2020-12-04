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
