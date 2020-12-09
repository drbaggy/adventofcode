package AOC2001;

use strict;
use warnings;
use Data::Dumper qw(Dumper);

sub new {
  my $class = shift;
  my $self = {
    'ptr' => 0,
    'mem' => [],
    'acc' => 0,
  };
  bless $self, $class;
  return $self;
}

sub add {
  my( $self, $line ) = @_;
  my( $opp, $value ) = split m{\s+}, $line;
  push @{$self->{'mem'}}, { 'action' => $opp, 'value' => $value, 'exec' => 0,
    'initial' => { 'action' => $opp, 'value' => $value, 'exec' => 0 } };
}

sub acc {
  my $self = shift;
  return $self->{'acc'};
}

sub current_action {
  my $self = shift;
  return $self->{'mem'}[$self->{'ptr'}]{'action'};
}

sub current_value {
  my $self = shift;
  return $self->{'mem'}[$self->{'ptr'}]{'value'};
}

sub executed {
  my $self = shift;
  return $self->{'mem'}[$self->{'ptr'}]{'exec'};
}

sub step {
  my $self = shift;
  my $action = 'step_'.$self->current_action;
  if( $self->can($action) ) {
    $self->{'mem'}[$self->{'ptr'}]{'exec'} = 1;
    $self->$action();
  } else {
    die 'Illegal opp '.$self->current_action.' at '.$self->{'ptr'};
  }
  return;
}

sub next {
  my $self = shift;
  $self->{'ptr'}++;
  return;
}

sub finished {
  my $self = shift;
  return $self->{'ptr'} >= @{ $self->{'mem'} };
}

sub step_nop {
  my $self = shift;
  $self->next;
  return;
}

sub step_acc {
  my $self = shift;
  $self->{'acc'}+=$self->current_value;
  $self->next;
  return;
}

sub step_jmp {
  my $self = shift;
  $self->{'ptr'}+=$self->current_value;
  return;
}

sub reset {
  my $self = shift;
  $self->{'ptr'} =0;
  $self->{'acc'} =0;
  ( $_->{'action' }, $_->{'value'},  $_->{'exec'} )=
    ( $_->{'initial'}{'action'},
       $_->{'initial'}{'value'},
       $_->{'initial'}{'exec'} ) foreach @{$self->{'mem'}};
  return;
}

sub clear {
  my $self = shift;
  $self->{'ptr'} =0;
  $self->{'acc'} =0;
  $slef->{'mem'} = [];
  return;
}


sub op {
  my($self,$op_no) = @_;
  return $self->{'mem'}[$op_no]{'action'};
}

sub set_op {
  my($self,$op_no,$action) = @_;
  $self->{'mem'}[$op_no]{'action'} = $action;
  return;
}

sub no_steps {
  my $self = shift;
  return @{$self->{'mem'}};
}

1;
