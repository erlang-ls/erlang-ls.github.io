# Kakoune

The [Kakoune](https://kakoune.org/) editor provides support for Erlang LS via the [Kakoune Language Server Protocol Client (kak-lsp)](https://github.com/kak-lsp/kak-lsp) Kakoune plugin.

### Step 0: Use a recent Kakoune installation

Make sure you have a recent Kakoune installation. Package managers may carry very old versions of Kakoune.

_Tips_:

* Building Kakoune from [source](https://github.com/mawww/kakoune) is easy and will give you the latest features
* If you follow the steps on this page, Erlang LS should work in Kakoune. However you will probably want to see syntax highlighting for Erlang in addition to the features that Erlang LS provides like goto definition etc. That is available only in the `Kakoune 2021.10.28` tagged release (and later) or on current git sources

### Step 1: Install Erlang LS

Install Erlang LS on your system. You may or may not decide to put the `erlang_ls` executable on your `$PATH`.

### Step 2: Install `kak-lsp`

Install or build `kak-lsp` from source by following instructions on its [repository](https://github.com/kak-lsp/kak-lsp).

### Step 3: Edit the `kak-lsp` configuration

Look for `kak-lsp.toml`. This file has language specific settings for the Kakoune kak-lsp plugin.

On Linux, configuration for `kak-lsp` should usually live at `$HOME/.config/kak-lsp/kak-lsp.toml` where `$HOME` is your home directory.

Open `kak-lsp.toml` in your favorite editor (Kakoune 😄?), look for `[language.erlang]`. It should look something like this:

```toml
[language.erlang]
filetypes = ["erlang"]
# See https://github.com/erlang-ls/erlang_ls.git for more information and
# how to configure. This default config should work in most cases though.
roots = ["rebar.config", "erlang.mk", ".git", ".hg"]
command = "erlang_ls"
```

_Tip:_ If you don't find `[language.erlang]` your probably have an older version of `kak-lsp`. Nevermind, you can add this `toml` snippet yourself to `kak-lsp.toml` without any issues

#### _If_ the `erlang_ls` executable is on your `$PATH`

Save `kak-lsp.toml` if you added the above snippet and restart Kakoune.

You're done! Erlang LS should work now on Erlang projects and sources!

#### _If_ the `erlang_ls` executable is _not_ on your `$PATH`

Change the `command` line for the `[language.erlang]` section to:

```toml
command = "/the/path/to/erlang_ls"
```

Don't forget to save the file and restart Kakoune!
