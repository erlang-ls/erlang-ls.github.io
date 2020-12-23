# Snippets are here

_Snippets_ are a convenient way to insert portions of code without
having to write them from scratch or to copy them from an external
source every single time.

![Snippets](https://github.com/erlang-ls/docs/raw/master/gif/15-snippets.gif)

To start using snippets, ensure you have the latest version of Erlang
LS. Then, simply start typing _snippet_. A dropdown with all available
snippets will appear, so you can select one.

![Selecting Snippets](https://github.com/erlang-ls/docs/raw/master/png/snippets-edoc-select.png)

![Edoc Snippets](https://github.com/erlang-ls/docs/raw/master/png/snippets-edoc-function.png)

A few built-in snippets are available, ranging from a `try catch`
construct to a `receive after` statement, from a `record` attribute to
`edoc` blocks.

Snippets contain _placeholders_, which can be used for easier
navigation via the `TAB` key. They also have the concept of a
_variable_, which gets expanded automatically when the snippet is
selected. The syntax for snippets is described in detail
[here](https://microsoft.github.io/language-server-protocol/specification#snippet_syntax).

Contributing snippets is trivial and does not require coding. Built-in
snippets are stored in the Erlang LS
[priv](https://github.com/erlang-ls/erlang_ls/tree/master/priv/snippets)
directory.

It is also possible to add custom snippets by dropping them into:

```
~/.config/erlang_ls/snippets
```

This mechanism allows your organization to customize snippets, so they
match specific coding styles and conventions. A custom snippet which
has the same name as built-in one will take precedence, so the former
will override the latter in the snippets dropdown.

Enjoy!
