package AdventSupport;
use strict;
use warnings;
use base qw(Exporter);

use File::Basename qw(dirname);
use English qw(-no_match_vars $PROGRAM_NAME $PERL_VERSION);
use Cwd qw(abs_path);
use Time::HiRes qw(time);

our @EXPORT      = qw(slurp_file start_timer duration);
our @EXPORT_OK   = @EXPORT;
our %EXPORT_TAGS = ('ALL' => \@EXPORT );

my $PROGRAM_PATH;
BEGIN { $PROGRAM_PATH = dirname(abs_path($PROGRAM_NAME)); }

my $start_time;

sub start_timer {
  $start_time = time;
  return;
}

sub duration {
  return time - $start_time;
}
sub slurp_file {
  my($fn,$file,$flag) = @_;
  $file ||= 'in.txt';
  $flag ||= 0;
  open my $fh, q(<), $PROGRAM_PATH.q(/).$file or die "Filename $file doesn't exist\n";
  while(<$fh>) {
    chomp;
    eval { &{$fn}( $_ ); };
    next unless $@;
    warn sprintf "Died with message: %s\n", $@ =~ s{\s+}{ }mxsg unless $@ =~ m{^Died at };
    close $fh;
    return;
  }
  close $fh;
  &{$fn}(q()) if $flag;
}

1;
