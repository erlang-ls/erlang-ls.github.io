# Features

## Breadcrumbs

Breadcrumbs display a list of links to the current element and its
ancestors in the top part of the page.

![Breadcrumbs](images/lsp-ui-breadcrumbs.png)

=== "VS Code"

    Breadcrumbs can be enabled or disabled via:

    > Settings > Workbench > Breadcrumbs

    The settings section contains a number of additional preferences to
    tweak what to display exactly (e.g. icons, symbols, complete path to
    the file, etc).

=== "Emacs"

    Breadcrumbs are provided by the
    [lsp-mode](https://emacs-lsp.github.io/lsp-mode) package.
    To enable breadcrumbs:

    ```elisp
    (setq lsp-headerline-breadcrumb-mode t)
    ```

    You can also customize what to display in the breadcrumbs by
    customizing the `lsp-headerline-breadcrumb-segments` variable. For
    more information please refer to the official [lsp-mode
    documentation](https://emacs-lsp.github.io/lsp-mode/page/main-features/#breadcrumb-on-headerline).

## Code Completion

Get context-aware code completions for function names, macros,
records, variable names and more.

![Code Completion](https://github.com/erlang-ls/docs/raw/master/png/01-code-completion.png)

## Go To Definition

Navigate to the definition of a function, macro, record or type.

![Go To Definition](https://github.com/erlang-ls/docs/raw/master/gif/02-go-to-definition.gif)

## Go To Implementation for OTP Behaviours

Hovering a `gen_server:start_link` call? Jump to the respective `init`
function with a single keystroke.

![Go To Implementation](https://github.com/erlang-ls/docs/raw/master/gif/03-go-to-implementation.gif)

## Signature Suggestions

Never remember the order of the `lists:keytake/3` arguments? You are
not alone. We got you covered.

![Signature Suggestions](https://github.com/erlang-ls/docs/raw/master/gif/04-signature-suggestions.gif)

## Compiler Diagnostics

Display warnings and errors from the compiler. Inline.

![Compiler Diagnostics](https://github.com/erlang-ls/docs/raw/master/png/05-compiler-diagnostics.png)

## Dialyzer Diagnostics

It has never been so easy to make Dialyzer happy.

![Dialyzer Diagnostics](https://github.com/erlang-ls/docs/raw/master/png/06-dialyzer-diagnostics.png)

## Elvis Diagnostics

Display [Elvis](https://github.com/inaka/elvis) style suggestions
inline. No more nit-picking comments from colleagues!

![Elvis Diagnostics](https://github.com/erlang-ls/docs/raw/master/png/07-elvis-diagnostics.png)

## Edoc

Hover a local or remote function to see its `edoc`. You will miss this
feature so much when edocs are not available that you will start
writing them!

![Edoc](https://github.com/erlang-ls/docs/raw/master/gif/08-edoc.gif)

## Navigation for Included Files

Navigate to included files with a single click.

![Included Files](https://github.com/erlang-ls/docs/raw/master/gif/09-included-files.gif)

## Find/Peek References

Who is calling this function? Figure it out without leaving the
current context.

![Peek References](https://github.com/erlang-ls/docs/raw/master/png/11-peek-references.png)

## Outline

Get a nice outline of your module on the side and jump between
functions.

![Outline](https://github.com/erlang-ls/docs/raw/master/png/12-outline.png)

## Workspace Symbols

Jump to the module you're looking for, in no time.

![Workspace Symbols](https://github.com/erlang-ls/docs/raw/master/png/13-workspace-symbols.png)

## Folding

Focus on what's important, fold the rest.

![Folding](https://github.com/erlang-ls/docs/raw/master/png/14-folding.png)

## Snippets

Quickly insert parametrized, reusable pieces of code.

![Snippets](https://github.com/erlang-ls/docs/raw/master/gif/15-snippets.gif)

## Suggest Type Specs

Annotate your Erlang programs with type information.

![Suggest Specs](https://github.com/erlang-ls/docs/raw/master/gif/16-suggest-specs.gif)

## Call Hierarchy

The _Call Hierarchy_ feature lets you explore callers of a given
function (known as _incoming calls_), as well as show which functions
are called by a given function (known as _outgoing calls_).

For an overview of what Call Hierarchy may look like, have a look to
this [video](https://www.youtube.com/watch?v=r5LA7ivUb2c).

=== "VS Code"

    ![Call Hierarchy in VS Code](images/lsp-vscode-call-hierarchy.png)

    To display the _Call Hierarchy_ panel, right-click on the name of a
    function and select _Show Call Hierarchy_. You can use the newly
    opened panel to navigate through the hierarchy of calls.

    To switch between _incoming calls_ and _outgoing calls_ simply use the
    _phone_ icon on the top-right corner of the panel.

=== "Emacs"

    ![Call Hierarchy in Emacs](images/lsp-emacs-call-hierarchy.png)

    The feature is provided by the
    [lsp-treemacs](https://github.com/emacs-lsp/lsp-treemacs) package.

    To show the _incoming calls_ hierarchy:

        M-x lsp-treemacs-call-hierarchy

    To show the outgoing calls hierarchy:

        C-u M-x lsp-treemacs-call-hierarchy

    For more information please refer to the official [lsp-treemacs
    documentation](https://github.com/emacs-lsp/lsp-treemacs#lsp-treemacs-call-hierarchy).

## Code Actions

Code Actions are a mechanism providing the user with possible
corrective actions right next to an error or warning. If actions are
available, a light bulb or similar icon appears next to the error or
warning. When the user clicks the light bulb (or hits a shortcut), a
list of available code actions is presented.

Currently Erlang LS support code actions for:

* Exporting unused functions
* Prepending an underscore (`_`) to an unused variable
* Correct a mistyped name for an unbound variable
* Fix a module name to match the corresponding filename
