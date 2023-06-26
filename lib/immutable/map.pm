use strict; use warnings;
package immutable::map;



package immutable::map::tied;
use base 'Hash::Ordered';

use Carp 'croak';

# Prevent tied changes to immutable::map.
# Mutation operations must use method calls which will return a new map.

sub STORE {
    croak
        "Not valid to set a key/value on an immutable::map object.\n" .
        "Try '->set(\$key, \$val)' which returns a new immutable::map.\n";
}

sub DELETE {
    croak
        "Not valid to delete a key from an immutable::map object.\n" .
        "Try '->del(\$key)' which returns a new immutable::map.\n";
}

sub CLEAR {
    croak "Invalid CLEAR called on immutable::map object.\n";
}



package immutable::map;

use Carp 'croak';

use Scalar::Util 'refaddr';

use overload
    q{""} => sub {
        my ($self) = @_;
        "<${\ __PACKAGE__} ${\ $self->size} ${\ refaddr $self}>";
    },
    q{0+} => sub {
        $_[0]->size;
    },
    q{bool} => sub {
        !! $_[0]->size;
    },
    fallback => 1;

sub new {
    my $class = shift;
    tie my %hash, 'immutable::map::tied', @_;
    bless \%hash, $class;
}

sub get {
    tied(%{$_[0]})->get($_[1]);
}

sub set {
    my $self = shift;
    tie my %hash, 'immutable::map::tied', %$self;
    if (@_ == 2) {
        tied(%hash)->set(@_);
    }
    else {
        tied(%hash)->push(@_);
    }
    bless \%hash, ref($self);
}

sub del {
    my $self = shift;
    tie my %hash, 'immutable::map::tied', %$self;
    tied(%hash)->delete(@_);
    bless \%hash, ref($self);
}

# sub equal_to {
#     my ($self, $iobj) = @_;
#     return unless ref($self) eq ref($iobj);
#     croak "equal_to";
# }

# sub clone {
#     shift->set();
# }

sub id {
    refaddr($_[0]);
}

sub size {
    0 + @{tied(%{$_[0]})->[1]};
}

sub is_empty {
    $_[0]->size == 0;
}

sub DESTROY {
    untie(%{$_[0]});
}

# TODO should not proxy mutating methods.
our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;
    (my $method = $AUTOLOAD) =~ s/^.*:://;
    tied(%$self)->$method(@_);
}

1;
