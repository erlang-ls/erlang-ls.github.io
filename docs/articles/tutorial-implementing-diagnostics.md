# How To: Diagnostics

A couple of days ago, NextRoll announced
[rebar3_hank](https://github.com/AdRoll/rebar3_hank), a _"powerful but
simple tool to detect dead code around your Erlang codebase (and kill
it with fire!)"_. In their [original
post](https://tech.nextroll.com/blog/dev/2021/01/06/erlang-rebar3-hank.html)
the authors mentioned the overlap between _rebar3\_hank_ and some of
the features provided by _Erlang LS_, such as detection of unused
included files.

Intrigued by the new tool, I decided to look deeper into it, to check
whether _rebar3\_hank_ could be integrated with the _diagnostics
framework_ in Erlang LS, to avoid duplicated efforts within the Erlang
Community.

Both _rebar3\_hank_ and _Erlang LS_ create _diagnostics_ based on
source code, but there are a few differences. For example,
_rebar3\_hank_ acts on a project's code base as a whole, while Erlang
LS operates on individual Erlang modules and their strict
dependencies. Also, _rebar3\_hank_ is intended to be used as a CLI via
a rebar3 plugin, while Erlang LS is a server which integrates with
your IDE via the LSP protocol.

It was immediately clear that an integration between both tools would
require a certain degree of refactoring. The ideas of _rebar3\_hank_
were quite interesting, though, and most of them would be easily
implementable in Erlang LS. So, I decided to port one of them,
[detection of unused
macros](https://github.com/AdRoll/rebar3_hank/blob/main/src/rules/unused_macros.erl),
and to take this opportunity to explain the process of contributing a
new diagnostics backend to Erlang LS.

> If you always wanted to contribute to Erlang LS, but you didn't know
where to start, this post is for you. Let's start.

## The goal

Given an Erlang module, we would like to be notified with a warning if
a macro is defined, but not used.

![Detecting Unused Macros in Erlang LS](../images/unused-macros.png?raw=true "Detecting Unused Macros in Erlang LS")

How can we make it happen?

## Adding a New Diagnostics Backend

The first thing we need to do is to define a new Erlang module which
implements the `els_diagnostics` behaviour. By convention, all
diagnostics modules are named `els_[BACKEND]_diagnostics.erl` where
`[BACKEND]`, in our case, will be `unused_macros`. So, the final name
of the module will be `els_unused_macros_diagnostics.erl`. Let's open
a new text file and add the following:

    -module(els_unused_macros_diagnostics).
    -behaviour(els_diagnostics).

The `els_diagnostics` behaviour requires three callback functions to
be implemented:

    -callback is_default() -> boolean().
    -callback source()     -> binary().
    -callback run(uri())   -> [diagnostic()].

So let's add the following exports to the module. We will implement
all functions in a second.

    -export([ is_default/0
            , source/0
            , run/1
            ]).

### The `is_default/0` callback

The `is_default/0` callback is used to specify if the current backend
should be enabled by default or not. In our case, we want the new
backend to be enabled by default, so we say:

    is_default() -> true.

Should the end user decide to disable this backend, she can just add
to her `erlang_ls.config` the following option:

    diagnostics:
      disabled:
        unused_macros

### The `sources/0` callback

Let's now implement our second callback function, `source/0`. This
function returns the human-friendly name for the backend, which is
rendered by the IDE (see the `UnusedMacros` text in the above
screenshot):

    source() -> <<"UnusedMacros">>.

### The `run/1` function

The last callback function we need to implement is where the
interesting stuff happens.

The `run/1` function takes a single parameter, the `Uri` of the Erlang
module for which diagnostics are run. By default, diagnostics are
calculated _OnOpen_ (when the module is firstly accessed in the IDE)
and _OnSave_ (whenever the module is saved from the IDE).

The function returns a list of _diagnostics_ for the module which will
be rendered by the IDE, in a format specified by the [LSP
protocol](https://microsoft.github.io/language-server-protocol/specifications/specification-current/). Diagnostics
can be of four types:

* Hint
* Info
* Warning
* Error

For the time being, let's return an empty list.

    run(_Uri) -> [].

### Registering the backend

There's one more thing we need to do before we can use our backend in
Erlang LS. We need to _register_ it among the available backends. We
can do this by adding an entry to the list of available diagnostics in
the `els_diagnostics` module:

    available_diagnostics() ->
      [ <<"compiler">>
      , <<"crossref">>
      , <<"dialyzer">>
      , <<"elvis">>
      , <<"unused_includes">>
      , <<"unused_macros">> %% Here is our new shiny diagnostics backend!
    ].

## Using a Test-Driven-Development (TDD) approach

At this point, we could jump in and start implementing the body of our
`run/1` function. Then, to try if things are working as expected, we
could:

* Rebuild our version of Erlang LS as an _escript_
* Open a new file in our IDE
* Restart Erlang LS
* Add an unused macro to our new file
* Save the file
* Ensure that a warning is produced _on save_
* Check Erlang LS logs to see why things don't work the way we expect
* Rinse and repeat

This approach may even work, but it would slow down our feedback loop
drastically and it would make the whole experience of contributing to
Erlang LS painful.

Luckily, there's a better way: starting with a test case. After
all, if we are planning to contribute our new backend, we will be
required to add a test case anyway.

How do we implement a test case for such a feature, though? That
sounds like a lot of work and we don't know where to
start. Here is where the _Erlang LS testing framework_ comes into play.

The first thing we need to do is to add a _minimal example_ to the
Erlang LS test application (which for historical reasons is named
_code\_navigation_ and should be renamed). You can find it
in the `priv` directory of the project.

Our minimal example could look like this:

    $ cat priv/code_navigation/src/diagnostics_unused_macros.erl
    -module(diagnostics_unused_macros).

    -export([main/0]).

    -define(USED_MACRO, used_macro).
    -define(UNUSED_MACRO, unused_macro).

    main() ->
      ?USED_MACRO.

In the above code, we define two macros and we use only one of
them. We therefore expect a warning on line 6 for the `UNUSED_MACRO`.

We also need to register our minimal example into the Erlang LS
testing framework. For that, we add a line to the list of `sources` in
the `els_test_utils` module:

    sources() ->
      [ ...
      , diagnostics_unused_macros
      , ...
      ]

Now, we can focus on the actual test case. Since it's a _diagnostics_
test, we can extend the already existing `els_diagnostics_SUITE`
module. The test suite leverages the _Common Test_ framework in
Erlang/OTP, so please refer to the [official
documentation](http://erlang.org/doc/apps/common_test/basics_chapter.html)
if you are not familiar with it.

First, we export the new testcase, which we call `unused_macros`:

    -export([ ...
            , unused_macros/1
            . ...
            ])

Then, we can implement the body of our new testcase:

    unused_macros(Config) ->
      Uri = ?config(diagnostics_unused_macros_uri, Config),
      els_mock_diagnostics:subscribe(),
      ok = els_client:did_save(Uri),
      Diagnostics = els_mock_diagnostics:wait_until_complete(),
      Expected = [ #{ message => <<"Unused macro: UNUSED_MACRO">>
                    , range =>
                        #{ 'end' => #{ character => 20
                                     , line => 5
                                     }
                         , start => #{ character => 8
                                     , line => 5
                                     }
                         }
                    , severity => ?DIAGNOSTIC_WARNING
                    , source => <<"UnusedMacros">>
                    }
                 ],
      ?assertEqual(Expected, Diagnostics),
      ok.

Lot of things are happening here, so let's go through the code
together, starting from the beginning:

    Uri = ?config(diagnostics_unused_macros_uri, Config),

Here we fetch the _Uri_ of the Erlang module containing our minimal
example from the Common Test `Config`. This feels a bit magic, since
we never populated that variable anywhere. What's going on?

Remember that we registered our new testing module in the `sources/1`
function above? That caused the Erlang LS testing framework not just
to index that file, but also to create a couple of handy variables
which can be used when writing test cases. `[MODULE_NAME]_uri` is one
of these variables. Another one is `[MODULE_NAME]_text`, which
contains the actual source code of the module. But let's continue with
our testcase for now:

    els_mock_diagnostics:subscribe(),

Since we want to test a new diagnostics backend, we subscribe to the
stream of `diagnostics`, so that we can intercept and validate
them. Again, we use a utility function which the Erlang LS testing
framework provides.

    ok = els_client:did_save(Uri),
    Diagnostics = els_mock_diagnostics:wait_until_complete(),

We then simulate an IDE saving the file and wait until the diagnostics
(which are calculated asynchronously) are completed.

    Expected = [ #{ message => <<"Unused macro: UNUSED_MACRO">>
                  , range =>
                      #{ 'end' => #{ character => 20
                                   , line => 5
                                   }
                       , start => #{ character => 8
                                   , line => 5
                                   }
                       }
                  , severity => ?DIAGNOSTIC_WARNING
                  , source => <<"UnusedMacros">>
                  }
               ],
    ?assertEqual(Expected, Diagnostics),
    ok.

Here we verify that a _warning_ message is generated by our backend
(notice the `source` attribute). The warning message is expected on
line 6, between characters 8 and 20 (which correspond to the location
of the macro _name_).

The `?DIAGNOSTIC_WARNING` macro is defined in the `erlang_ls.hrl`
header file, so let's include it below the `export` list:

    -include("erlang_ls.hrl").

Let's now execute our test case and check the result. Notice how we
need to specify a `group` for the testcase, since all Erlang LS tests
can be run for the two LSP supported _transports_ (_TCP_ and _stdio_).

    $ rebar3 ct --suite els_diagnostics_SUITE --case unused_macros --group tcp
    ===> Verifying dependencies...
    ===> Analyzing applications...
    ===> Compiling erlang_ls
    ===> Running Common Test suites...
    %%% els_diagnostics_SUITE:
    [...]
    expected: [#{message => <<"Unused macro: UNUSED_MACRO">>,
                 range =>
                   #{'end' => #{character => 20,line => 5},
                     start => #{character => 8,line => 5}},
                 severity => 2,source => <<"UnusedMacros">>}]
    got: []
    line: 582

Not surpringly, the testcase fails, since we haven't implemented our
`run/1` function yet, but we are returning an hard-coded empty
list. Let's fix that now.

## Looking for Unused Macros

We can finally jump to interesting bit of this tutorial, implementing
a detection mechanism for unused macros. As usual, let's first look at
the whole code and then explain its behaviour.

    run(Uri) ->
      {ok, [Document]} = els_dt_document:lookup(Uri),
      UnusedMacros = find_unused_macros(Document),
      [make_diagnostic(Macro) || Macro <- UnusedMacros].

First, we query the Erlang LS database by _Uri_. Then, we invoke the
`find_unused_macros/1` function - which we still need to implement -
on the returned _document_. For each identified _Macro_, we produce a
_diagnostic_, in the format expected by the LSP protocol. Again, we
still need to implement our `make_diagnostic/1` function.

Let's now focus on the `find_unused_macros/1` function. The goal of the
function is to identify unused macros within a given _document_:

    find_unused_macros(Document) ->
      Definitions = els_dt_document:pois(Document, [define]),
      Usages = els_dt_document:pois(Document, [macro]),
      UsagesIds = [Id || #{id := Id} <- Usages],
      [POI || #{id := Id} = POI <- Definitions, not lists:member(Id, UsagesIds)].

Again, lot of things happening here, so let's go through the code line by line.

First, we identify all the macro definitions, identified by the `define` key:

      Definitions = els_dt_document:pois(Document, [define]),

Then, we identify all the macro usages, identifie by the `macro` key:

      Usages = els_dt_document:pois(Document, [macro]),

You can refer to the `els_parser` module in Erlang LS for details
about _POIs_ (_Points of Interests_) and available keys.

For each macro usage, we extract the respective `id` and we return the
list of macro definitions which do not have a corresponding usage:

      UsagesIds = [Id || #{id := Id} <- Usages],
      [POI || #{id := Id} = POI <- Definitions, not lists:member(Id, UsagesIds)].

The last missing bit is the `make_diagnostic/1` function, which will
convert each _POI_ into a _diagnostic_:

    make_diagnostic(#{id := Id, range := POIRange} = _POI) ->
      Range = els_protocol:range(POIRange),
      MacroName = atom_to_binary(Id, utf8),
      Message = <<"Unused macro: ", MacroName/binary>>,
      Severity = ?DIAGNOSTIC_WARNING,
      Source = source(),
      els_diagnostics:make_diagnostic(Range, Message, Severity, Source).

This function is essentially a wrapper around around the utility
function `els_diagnostics:make_diagnostic/4`. Let's analyze it in detail.

      Range = els_protocol:range(POIRange),

Here we convert the _range_ of the _POI_ (the unused macro definition)
in the format required by the LSP protocol, using a helper function
provided by Erlang LS.

      MacroName = atom_to_binary(Id, utf8),
      Message = <<"Unused macro: ", MacroName/binary>>,

We then build the diagnostic _message_ using the _id_ (the name) of
the offending macro.

      Severity = ?DIAGNOSTIC_WARNING,

We specify _warning_ as the _severity_ of the message.

      Source = source(),

We invoke the `source/0` function to specify the _source_ of the
diagnostic (for rendering purposes in the IDE).

      els_diagnostics:make_diagnostic(Range, Message, Severity, Source).

We finally invoke the `els_diagnostics:make_diagnostic/4` function
with the constructed arguments to produce a _diagnostic_.

That should be it. Let's try to execute the testcase again:

    $ rebar3 ct --suite els_diagnostics_SUITE --case unused_macros --group tcp
    ===> Verifying dependencies...
    ===> Analyzing applications...
    ===> Compiling erlang_ls
    ===> Running Common Test suites...
    %%% els_diagnostics_SUITE:
    All 1 tests passed.

**Success!** Tests now pass and we are able to identify unused macros in Erlang LS!

## The Complete Backend

Here is the full implementation of the backend, for reference:

    -module(els_unused_macros_diagnostics).
    -behaviour(els_diagnostics).

    -export([ is_default/0
            , source/0
            , run/1
            ]).

    -include("erlang_ls.hrl").

    is_default() -> true.

    source() -> <<"UnusedMacros">>.

    run(Uri) ->
      {ok, [Document]} = els_dt_document:lookup(Uri),
      UnusedMacros = find_unused_macros(Document),
      [make_diagnostic(Macro) || Macro <- UnusedMacros].

    find_unused_macros(Document) ->
      Definitions = els_dt_document:pois(Document, [define]),
      Usages = els_dt_document:pois(Document, [macro]),
      UsagesIds = [Id || #{id := Id} <- Usages],
      [POI || #{id := Id} = POI <- Definitions, not lists:member(Id, UsagesIds)].

    make_diagnostic(#{id := Id, range := POIRange} = _POI) ->
      Range = els_protocol:range(POIRange),
      MacroName = atom_to_binary(Id, utf8),
      Message = <<"Unused macro: ", MacroName/binary>>,
      Severity = ?DIAGNOSTIC_WARNING,
      Source = source(),
      els_diagnostics:make_diagnostic(Range, Message, Severity, Source).

Of course, the implementation above is quite minimalistic and could be
improved in many ways, but at this point you should get the idea of
what it means to implement a new diagnostics backend for Erlang LS.

## Conclusion

The above backend is already integrated in Erlang LS, but as an opt-in
backend. You can see the whole contribution at:

<https://github.com/erlang-ls/erlang_ls/pull/867/files>

Contributing to an open source can be a daunting experience,
especially when you do not have an infinite amount of time available.
I hope that this little tutorial can help you in that direction and
I'm looking forward to the brilliant things that you can contribute to
Erlang LS.

Have fun!
