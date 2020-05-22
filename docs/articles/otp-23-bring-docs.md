# OTP 23 Brings Docs to the Shell, Erlang LS brings them to you!

You may have heard that [Erlang/OTP
23](https://github.com/erlang/otp/releases/tag/OTP-23.0) introduces a
couple of new functions that can be used for displaying documentation
for modules, functions and types in the Erlang shell:

```
1> h(lists).

   lists

  This module contains functions for list processing.

  Unless otherwise stated, all functions assume that position
  numbering starts at 1. That is, the first element of a list is at
  position 1.

  Two terms T1 and T2 compare equal if T1 == T2 evaluates to
  true. They match if T1 =:= T2 evaluates to true.

  Whenever an ordering function F is expected as argument, it is
  assumed that the following properties hold of F for all x, y,
  and z:

   • If x F y and y F x, then x = y (F is antisymmetric).

   • If x F y and y F z, then x F z (F is transitive).

   • x F y or y F x (F is total).

  An example of a typical ordering function is less than or equal
more (y/n)? (y)
```

This is an amazing improvement, but as developers we often spend a
good portion of our time in our IDE of choice, be it _VSCode_,
_Emacs_, _Vim_ or anything else. Wouldn't it be even more awesome if
those pieces of documentation were closer to us in the IDE? It turns
out this is something trivial to do.

These _pieces of documentation_ are stored as _chunks_ using the
format specified in the [EEP-48](http://erlang.org/eeps/eep-0048.html)
_Erlang Enhancement Proposal_ and now implemented in OTP 23. Erlang LS
already supports _chunks_, so the documentation for modules, functions
and types is now available on _hover_ when using OTP 23. This is how
they look in _Emacs_:

![otp-23-doc-chunks-emacs](../images/otp-23-doc-chunks-emacs.png?raw=true "OTP Docs in Erlang LS")

To get them, ensure you build your Erlang/OTP distribution with
support for _Doc Chunks_. If you are using
[kerl](https://github.com/kerl/kerl), this is as simple as:

```
KERL_BUILD_DOCS=yes KERL_DOC_TARGETS=chunks kerl build 23.0.1 23.0.1
KERL_BUILD_DOCS=yes kerl install 23.0.1 /your/favourite/path/to/23.0.1
```

Enjoy!
