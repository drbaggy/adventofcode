package AdventSupport;
use strict;
use warnings;
use base qw(Exporter);

our @EXPORT_OK   = qw(slurp_file init);
our %EXPORT_TAGS = ('ALL'=>\@EXPORT_OK );
my $ROOT_PATH;

sub init {
  $ROOT_PATH = $_[0];
}

sub slurp_file {
  my($fn,$file) = @_;
  $file ||= 'in.txt';
  open my $fh, q(<), $ROOT_PATH.q(/).$file or die "Filename $file doesn't exist\n";
  &{$fn}( $_ ) while <$fh>;
  close $fh;
}

1;
