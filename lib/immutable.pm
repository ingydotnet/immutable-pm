use strict;
use warnings;
package immutable;

our $VERSION = '0.0.1';

use Exporter 'import';

our @EXPORT_OK = qw(
    iobj
    imap
    iseq
    ilist
    istr
    inum
    ibool
);

our %EXPORT_TAGS = ( all => [ @EXPORT_OK ] );

sub _todo {
    die "${\ (caller(1))[3]} not yet implemented";
}

sub iobj {
    my $type = ref($_[0]);
    return
        $type eq 'HASH' ? imap(%{$_[0]}) :
        $type eq 'ARRAY' ? iseq(@{$_[0]}) :
        die "Invalid arguments for iobj";
}

sub imap {
    require immutable::map;
    return immutable::map->new(@_);
}

sub iseq { _todo }
sub ilist { _todo }
sub istr { _todo }
sub inum { _todo }
sub ibool { _todo }

1;
