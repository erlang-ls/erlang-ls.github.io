# Suggesting Type Specs

Erlang is a strict, dynamically typed, functional programming
language. When implementing an Erlang function, it is not required to
include any explicit information about the types of the input
parameters, nor of the return value of the function. While this can
sometimes be seen as convenient, in the sense that it allows fast
prototyping of a function, it has the heavy drawback that type errors
can occur at runtime, when it is too late. Lack of type information
can also make it harder to understand the purpose of a function, given
its signature.

In the Erlang ecosystem, a tool named
[dialyzer](http://erlang.org/doc/apps/dialyzer/dialyzer_chapter.html)
exists to help the programmer to identify software discrepancies such
as type errors via a static analysis.

While Dialyzer works by inferring type information using a technique
based on [success
typings](https://it.uu.se/research/group/hipe/papers/succ_types.pdf),
it is possible to explicitly annotate an Erlang function with type
information. Adding _type specifications_ to a function is
particularly useful for the programmer when reading and reasoning
about code, since they give an _overview_ of the function _contract_.

Given the function `sum/2` which computes the sum of two _numbers_:

```
sum(A, B) ->
  A + B.
```

We can annotate it with _type specifications_:

```
-spec sum(number(), number()) -> number().
sum(A, B) ->
  A + B.
```

For more information about _type specifications_
and their syntax, please refer to the official [reference
manual](https://erlang.org/doc/reference_manual/typespec.html).

Type specifications can often be programmatically inferred. If we look
again at the `sum/2` function above, we can see that the two input
values for the function (`A` and `B`) are passed straight away to the
`+` operator. That implies that, for the `sum/2` function not to fail,
both `A` and `B` (and the return value of the function itself!) _must_
be _numbers_. This is essentially how - well, in a very simplifyied
way - a less known tool, named
[Typer](http://erlang.org/doc/man/typer.html), works under the hood to
generate type specifications for functions which lack them.

Erlang LS today leverages both _Dialyzer_ and _Typer_ to make it
possible for the programmer to generate type specifications directly
from the text editor.

!!! warning "First Time Setup"

    To do its job, Dialyzer (and therefore Erlang LS) makes use of a _Persistent Lookup Table_
    (a.k.a. _PLT_). This table needs to be generated before you can use
    this feature in Erlang LS. Generating a _PLT_ is a simple operation
    that can be achieved via:

        dialyzer --build_plt --apps erts kernel stdlib

    Where you can of course customize the provided list of
    applications. For more information about creating a PLT and how to
    later update it, please refer to the Dialyzer [User
    Guide](https://erlang.org/doc/apps/dialyzer/dialyzer_chapter.html#the-persistent-lookup-table).

Whenever a function lacks type specifications, you will see a `Suggest
spec` code lens next to the function definition. By clicking on the
lens (or by using a keyboard shortcut), Erlang LS will attempt at
suggesting type specifications for your function. This is what the procedure
looks like in Emacs:

![Suggest Specs](https://github.com/erlang-ls/docs/raw/master/gif/16-suggest-specs.gif)

This feature is enabled by default in Erlang LS. Like for any other
_code lens_, the feature can be disabled via the `erlang_ls.config`
file, using the following configuration:

    lenses:
      enabled:
        - suggest-spec

To make this possible, we had to fork the `typer` program from
Erlang/OTP, mostly because the tool was designed as a separate
_Command Line_ utility and not to be invoked from Erlang code. This is
something that should be easy to address in Erlang/OTP itself,
avoiding the need of a fork in the future.

There are a few other things to take into account when using this
feature, most of which could be addressed in Typer itself:

* The function signatures do not include spaces after commas, making
  linters complain
* When producing records, the output is extremely verbose (containing
  types for all fields) and that should be simplified
* When user defined aliases exist for a given type, they should be
  used (this can be tricky to implement)

Finally, other tools such as
[Gradualizer](https://github.com/josefs/Gradualizer) could be
considered and eventually integrated in Erlang LS.

For now, I hope you enjoy!
