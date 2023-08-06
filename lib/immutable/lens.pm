use strict; use warnings;
package immutable::lens;

sub make {
  my ($class, $view, $set) = @_;
  bless {view => $view, set => $set}, $class;
}

sub view {
  my ($self, $obj) = @_;
  $self->{'view'}($obj);
}

sub set {
  my ($self, $obj, $value) = @_;
  $self->{'set'}($obj, $value);
}

sub modify {
  my ($self, $obj, $fn) = @_;
  $self->set($obj, $fn->($self->view($obj)));
}

sub compose {
  my ($self, $other) = @_;
  die "Can only compose lenses together" unless ref($self) eq ref($other);
  my $view = sub {
    $other->view($self->view($_[0]))
  };
  my $set = sub { 
    my ($obj, $value) = @_;
    my $current_inner = $self->view($obj);
    my $updated_inner = $other->set($current_inner, $value);
    $self->set($obj, $updated_inner);
  };
  bless {view => $view, set => $set}, ref($self);
}

1;
