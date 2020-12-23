# Sublime Text 3

## Setup

### Install the Erlang LS Language Server

To install Erlang LS:

```
git clone https://github.com/erlang-ls
cd erlang_ls
rebar3 escriptize
```

This will create an Erlang _escript_ in:

```
_build/default/bin/erlang_ls
```

Try running Erlang LS with the `--version` flag to verify everything
works as expected:

```
_build/default/bin/erlang_ls --version
```

Ensure `erlang_ls` is in your `PATH`.

### Install the LSP Client for Sublime Text 3

Using the _Command Palette_ from the _Tools_ menu, select `Package
Control: Install Package` and install the `LSP` package.

After that is done, go to:

    Preferences -> Package Settings -> LSP -> Settings

Add an Erlang client by adding the following configuration to the
`LSP.sublime-settings - User` file:

    {
      "clients":
        {
          "erlang-ls":
            {
              "command"   : [ "erlang_ls", "--transport", "stdio" ],
              "enabled"   : true,
              "languageId": "erlang",
              "scopes"    : [ "source.erlang" ],
              "syntaxes"  : ["Packages/Erlang/Erlang.sublime-syntax"]
            }
        },
      // Allow up to 30 secs to `erlang_ls` to respond to `initialize`
      // (it requires less, but just to be on the safe side)
      "initialize_timeout": 30
    }

That's it. Open a new Erlang project and enjoy Erlang LS.

## Troubleshooting

### Ensure Erlang LS is in your PATH

To be able to use Erlang LS, the `erlang_ls` escript needs to be in your path.

!!! info "Are You a macOS User?"

    If you are a _macOS_ user, you may consider using the following plugin
    to ensure your PATH is correctly used by Sublime Text 3:
    <https://github.com/int3h/SublimeFixMacPath>

### Enabling logging

In case of issues, you can enable extra logging for the `LSP` package
by adding the following configuration to your `LSP.sublime-settings -
User` file:

    {
      // Show verbose debug messages in the sublime console.
      "log_debug": true,

      // Show messages from language servers in the Language Servers output
      // panel.
     "log_server": true,

      // Show language server stderr output in the Language Servers output
      // panel.
      "log_stderr": true,

      // Show full JSON-RPC requests/responses/notifications in the Language
      // Servers output panel.
      "log_payloads": true
    }

The Sublime console can be toggled using the `` Ctrl-` `` shortcut. The
output panel can be toggled from the command palette with the command
`LSP: Toggle Panel: Language Servers`.
