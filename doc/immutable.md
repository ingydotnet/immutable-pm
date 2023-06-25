immutable
=========

Immutable Data Structures for Perl


# Synopsis

```
use immutable ':all';

$hash1 = imap(k1 => 123, k2 => 456);
$k1 = $hash->{k1};                      # 123

$hash1->{k3} = 789;                     # Error
$hash2 = $hash1->set(k3 => 789);        # Correct
$hash2->get('k3');                      # 789

delete $hash2->{k3};                    # Error
$hash3 = $hash2->del('k3');             # Correct

$string = "$hash3";                     # <immutable::map 2 94394857332096>
$id = $hash3->id;                       # 94394857332096
$num = $hash3->size;                    # 2
$hash3->is_empty;                       # false
```


# Description

The `immutable` module provides immutable versions of native Perl data
structures.

Immutable data makes programs easier to reason about, and is foundational for
functional programming and concurrency.

Immutable objects support both a tied interface (for use with Perl object
access syntax) and an OO interface.

Mutating operation like `$h->{x} = 1` and `delete $h->{x}` will throw errors.
You need to use the OO methods like `$h->set(x => 1)` and `$h->del('x')` which
will return a new `immutable::map` immutable hash object.
By throwing errors on these operations, it will make things obvious when you
pass them to existing code that tries to do a mutating operation.


# Exports

The `immutable` module exports a number of sugar functions for creating new
immutable objects.

* `iobj`

  Create an immutable object from a plain scalar object.

  `$ihash = iobj $hash;`

* `imap`

  Create an immutable hash (`immutable::map`) object.
  Takes an even number (0 to n) of key and value arguments.

  * `$ihash = imap;`      # Empty hash
  * `$ihash = imap x => 1, y => 2;

* `iseq`

  Immutable array. Not implemented yet.

* `ilist`

  Immutable lazy list. Not implemented yet.

* `istr`

  Immutable string. Not implemented yet.

* `inum`

  Immutable number. Not implemented yet.

* `ibool`

  Immutable boolean. Not implemented yet.


# Object Operations and Methods

Each types of immutable object has a class with various methods.
The immutable objects are also tied so they respond to Perl syntax and keyword
functions appropriately.


## `immutable::map`

* `new`

  Takes a list of zero or more key/value scalars.
  Returns a new `immutable::map` hashref object that is also tied.

* `$imap->{key}`

  Get the hash/map value associated with the key.

* `$imap->get('key')`

  Same as above using method call.

* `$imap->{key} = $val`

  Not allowed. Throws an error.

* `$imap->set(key => $value, ...)`

  Clones the map and adds the key value pairs to it.

  Calling this with no args creates an equivalent clone of the caller.

* `delete $imap->{key}`

  Not allowed. Throws an error.

* `$imap->del('key')`

  Clones the map and deletes the key pair from it.

* `$imap->id`

  Returns an integer id number for the map.

* `$imap->size`

  Returns the number of key value pairs in the map.

* `$imap->is_empty`

  Returns true if the map is empty.


# Status

This module is new and too incomplete, buggy and slow to use for any real code.

It is being developed for use in Lingy, a Perl implementation of Clojure, which
needs immutable data types.

Only immutable maps are support in this early version.

Very little effort is currently placed on performance and memory usage.
The intent is to use performant and memory efficient XS based algorithms once
the API stabilizes.


# Copyright and License

Copyright 2023 by Ingy döt Net

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html
