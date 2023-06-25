immutable
=========

Immutable Data Structures for Perl


# Synopsis

```
my $hash = map(k1 => 123, k2 => 456);
my $k1 = $hash->{k1};               # 123
$hash->{k3} = 789;                  # Error
my $hash2 = $hash->set(k3 => 789);  # Correct
```


# Status

This module is new and too incomplete, buggy and slow to use for any real code.

It is being developed for use in Lingy, a Perl version of Clojure, which needs
immutable data types.


# Description

The `immutable` module provides immutable versions of native Perl data
structures.

Immutable data makes programs easier to reason about, and is foundational for
functional programming and concurrency.


# Copyright and License

Copyright 2023 by Ingy döt Net

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html
