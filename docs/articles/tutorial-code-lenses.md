# How To: Code Lenses

In our [previous tutorial](tutorial-implementing-diagnostics.md) we
learned how to implement a _diagnostics_ backend for the Erlang
Language Server. This time we will dig into the world of _Code
Lenses_.

## The Goal

Given an Erlang module containing a number of function defintions, we
want to display the number of references to each function above its
respective definition. Here is how the code lens will look like in _VS
Code_.

![code-lens-example](../images/code-lens-example.png?raw=true "A Code Lens Example")

At the end of this tutorial you will:

* Know what a code lens is
* Learn how to implement a code lens in Erlang LS
* Move a step closer to becoming an Erlang LS contributor

Without further ado, let's start.

## What is a Code Lens, anyway?

A _Code Lens_ is defined by [Wade
Anderson](https://code.visualstudio.com/blogs/2017/02/12/code-lens-roundup)
as:

> an actionable contextual information interspersed in your source code

That's a very fancy way to say that a _code lens_ is an arbitrary
piece of text which appears in the _IDE_, next to your code. The text
often provides _insights_ about a portion of the code, as in the example
we just saw above.

Code lenses can also be _actionable_. The user can activate a lens by
clicking on it or by using a keyboard shortcut, to perform an
action. The triggered action can be anything. Here is an Emacs code
lens which allows the user to execute a given _Common Test_ testcase:

![code-lens-ct](../images/code-lens-ct.png?raw=true "A Code Lens to run a CT testcase")

Code lenses are _contextual_, meaning that they are aware of the
surrounding _context_. In the above example, the _Run test_ lens is
aware of which specific testcase should be executed on click.

Now that we understand what a code lens is, let's implement one in Erlang LS.

## Implementing a New Code Lens Backend

Erlang LS provides a framework to make development of code lenses as
simple as possible. To create our new code lens, the first thing we
need to do is to decide a _name_ for it and to create a new Erlang
module implementing the `els_code_lens` behaviour. Let's call the new
code lens _function_references_.

```
-module(els_code_lens_function_references).
-behaviour(els_code_lens).
```

The `els_code_lens` behaviour requires **three** callback functions to
be implemented:

```
-callback is_default() -> boolean().
-callback pois(els_dt_document:item()) -> [poi()].
-callback command(els_dt_document:item(), poi(), state()) -> els_command:command().
```

We will see in a second what each callback function is supposed to
do. For now, let's add the following exports to our
`els_code_lens_function_references` module:

```
-export([ is_default/0
        , pois/1
        , command/3
        ]).
```

Now we can focus on each individual callback function.

### The `is_default/0` callback

The `is_default/0` callback is used to specify if the current backend
should be enabled by default or not. In our case, we want the new
backend to be enabled by default, so we say:

```
is_default() -> true.
```

Should the end user decide to disable this backend, she can just add
to her `erlang_ls.config` the following option:

```
lenses:
  disabled:
    function_references
```

### The `pois/1` callback

In Erlang LS jargon, _POI_ stands for _Point of Interest_. The term
refers to the _interesting_ bits that are part of a code base. Points
of Interest are indexed by Erlang LS and stored in an in-memory
database. A _POI_ could refer to a _function definition_, a _macro
definition_, a _record usage_, you name it. Erlang LS provides a set
of utilities that allow for easy search and manipulation of _Points Of
Interest_.

The `pois/1` function takes a single argument, the current
_document_. Its return value is the list of _POIs_ for which the lens
should be activated for. In our case, we want our lens to be visible
next to each _function definition_. Therefore, we write:

```
pois(Document) ->
  els_dt_document:pois(Document, [function]).
```

### The `command/3` callback

The last mandatory callback we need to implement is the `command/3`
one. The callback takes three arguments: the current _Document_, a
specific _POI_ and a _State_. For the sake of this tutorial, we will
ignore the `State` and focus on the first two arguments only.

#### The Command

The function needs to return a _command_. A command is an [LSP data
structure](https://microsoft.github.io/language-server-protocol/specifications/specification-current/#command)
which contains:

* A _title_ - the text which is rendered next to each
selected _POI_
* A _CommandId_ - an identifier for the command that gets executed on click
* The _CommandArgs_ - the list of arguments to pass to the command

Erlang LS provides an helper function to create such a data structure: the `els_command:make_command/3` function.
Then, our `command/3` function will look something like this:

```
command(Document, POI, _State) ->
  Title = title(Document, POI),
  CommandId = command_id(),
  CommandArgs = command_args(),
  els_command:make_command(Title, CommandId, CommandArgs).
```

We will now describe each paramater in detail and learn how to compute
them, starting from the `Title`.

#### The Title

The `Title` is the text that we want to present in the text editor,
next to our _Point of Interest_ (a.k.a. the _POI_). In our case, we want
to display the following text:

> Used [N] times

To be able to compute the number `N`, we need to know how many
references to the current function are spread across our code base. We
can therefore query the Erlang LS database via the
`els_dt_references:find_by_id/2` helper function:

```
title(Document, POI) ->

  %% Extract the module name from the current document
  #{uri := Uri} = Document,
  M = els_uri:module(Uri),

  %% Extract the function name and arity from the current POI
  #{id := {F, A}} = POI,

  %% Query the Erlang LS DB for references to the current function
  {ok, References} = els_dt_references:find_by_id(function, {M, F, A}),

  %% Calculate the number of references
  N = length(References),

  %% Format the title for the code lens
  unicode:characters_to_binary(io_lib:format("Used ~p times", [N])).
```

The `els_dt_references:find_by_id/2` function takes two arguments: the
`Kind` of references we are looking for (`function` in our case) and
the fully qualified `Id` of the current _Point of Interest_. For a
function definition, the fully qualified identifier is a `{M, F, A}`
tuple, representing the _Module_, the _Function Name_ and the _Arity_
of our function. As you can see above, we can extract the module `M`
from the `Document` and the `F` and `A` from the current `POI`.

#### CommandId and CommandArgs

The `CommandId` is an arbitrary identifier for the command we want to
run when the user clicks on our code lens. In our case, this action
will be a _no-op_, but we still need to pick a name for our
command. Let's call it `function-references`:

```
command_id() -> <<"function-references">>.
```

Since our command will be a _no-op_ (we do not want anything to happen
if the user clicks on the lens), our command will not require any
arguments:

```
command_args() -> [].
```

We are essentially done. Here is our full
`els_code_lens_function_references` module, for completeness:

```
-module(els_code_lens_function_references).

-behaviour(els_code_lens).
-export([ is_default/0
        , pois/1
        , command/3
        ]).

is_default() ->
  true.

pois(Document) ->
  els_dt_document:pois(Document, [function]).

command(Document, POI, _State) ->
  Title = title(Document, POI),
  CommandId = command_id(),
  CommandArgs = command_args(),
  els_command:make_command(Title, CommandId, CommandArgs).

title(Document, POI) ->
  #{uri := Uri} = Document,
  M = els_uri:module(Uri),
  #{id := {F, A}} = POI,
  {ok, References} = els_dt_references:find_by_id(function, {M, F, A}),
  N = length(References),
  unicode:characters_to_binary(io_lib:format("Used ~p times", [N])).

command_id() ->
  <<"function-references">>.

command_args() ->
  [].
```

## Registering the code lens

There is one more thing that we need to do before we can use our new
shiny code lens: we need to tell Erlang LS that it exists. That can be
achieved by adding our new code lens to the list of `available_lenses`
in the `els_code_lens` module:

```
available_lenses() ->
  [ ...
  , <<"function-references">>
  ].
```

That's all.

## Adding tests

Our code lens at this point should be functional, but we cannot be
sure until we write a test for it!  Erlang LS provides a testing
framework which can be used for this purpose. In this section we will
assume that you have a bit of familiarity with the Erlang LS testing
framework already. If you would like a more gentle introduction to
_testing in Erlang LS_, please refer to the previous [Diagnostics
Tutorial](tutorial-implementing-diagnostics.md).

### Creating a test module

Let's create a test module named `code_lens_function_references`
within the `code_navigation` test application:

```
$ cat apps/els_lsp/priv/code_navigation/src/code_lens_function_references.erl
-module(code_lens_function_references).

-export([ a/0 ]).

-spec a() -> ok.
a() ->
  b(),
  c().

-spec b() -> ok.
b() ->
  c().

-spec c() -> ok.
c() ->
  ok.
```


### Registering the new testing module

Simply open the `els_test_utils` module and add the new module to the
list of _sources_. This will ensure the new module is properly indexed
and some helper functions are available for it.

```
sources() ->
  [ ...
  , code_lens_function_references
  , ...
  ].
```

### Writing a testcase

Let's then open the `els_code_lens_SUITE` module and add a testcase,
where we check whether the new code lens works as expected in the new
module.

```
function_references(Config) ->
  Uri = ?config(code_lens_function_references_uri, Config),
  #{result := Result} = els_client:document_codelens(Uri),
  Expected = [ lens(5, 0) # First lens on line 5, 0 references
             , lens(10, 1) # Second lens on line 10, 1 reference
             , lens(14, 2) # Third lens on line 14, 2 references
             ],
  ?assertEqual(Expected, Result),
  ok.
```

In the above testcase, we are fetching the `Uri` of the newly added
test module by leveraging the Erlang LS testing framework. We then use
the `els_client` to invoke the `document_codelens` method for the
given `Uri` and we finally ensure that we receive the expected list of code
lenses. `lens/2` is an auxiliary function which constructs the data
structure expected by the _LSP_ protocol as follows:

```
lens(Line, Usages) ->
  Title = unicode:characters_to_binary(
            io_lib:format("Used ~p times", [Usages])),
  #{ command =>
       #{ arguments => []
        , command => els_command:with_prefix(<<"function-references">>)
        , title => Title
        }
   , data => []
   , range =>
       #{ 'end' => #{character => 1, line => Line}
        , start => #{character => 0, line => Line}
        }
   }.
```

Let's run the test and ensure it passes.

```
$ rebar3 ct --suite apps/els_lsp/test/els_code_lens_SUITE --case function_references --group tcp
[...]
===> Running Common Test suites...
%%% els_code_lens_SUITE: .
All 1 tests passed.
```

It looks like we are done here.

## Optional Callbacks

Even if they are not needed for this tutorial, it is worth mentioning
that two more _optional_ callback functions are available as part of
the `els_code_lens` behaviour:

```
-callback init(els_dt_document:item()) -> state().
-callback precondition(els_dt_document:item()) -> boolean().
```

Let's describe them for completeness.

### The `init/1` callback

The `init/1` callback allows us to perform some computation _once_ per
file and to pass around the computed values in the form a _State_ to
subsequent callback functions (remember the `State` argument which we
ignored in the `command/3` callback?). This is used, for example, in
the `suggest_spec` code lens to run `TypEr` once for each Erlang
module and to still be able to display one lens for each function.

### The `precondition/1` callback

The `precondition/1` callback allows us to only enable a given lens
for a specific type of _documents_. For example, the following
implementation enables the `ct_run_test` lens only for _Common Test_
suites, identified by the presence of an `include_lib` directive for the
`ct.hrl` file:

```
precondition(Document) ->
  Includes = els_dt_document:pois(Document, [include_lib]),
  case [POI || #{id := "common_test/include/ct.hrl"} = POI <- Includes] of
    [] ->
      false;
    _ ->
      true
  end.
```

## Conclusion

At this point you should be able to try out your new code lens. The
above code lens is already available in Erlang LS. You can see the
whole contribution at:

<https://github.com/erlang-ls/erlang_ls/pull/947>

I hope this tutorial helped you to get a better understanding about
code lenses in general and how to implement one in Erlang LS. Looking
forward to the wonderful lenses you will implement!
