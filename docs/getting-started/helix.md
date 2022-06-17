# Helix

The [Helix] editor has a built-in LSP client that supports ErlangLS
out-of-the-box.

## Installation

First, make sure you have a recent Helix installation. ErlangLS configuration
was added in 22.05. If you're running an older build, you may configure
ErlangLS in the [language configuration file]:

```toml
[[language]]
name = "erlang"
language-server.command = "erlang_ls"
```

Install ErlangLS on your system. The `erlang_ls` executable must be in `$PATH`.

## Troubleshooting

Use `hx --health erlang` to check that Helix can find ErlangLS.

Run Helix in verbose mode with `hx -v` (up to three `v`s) and check the
[log file] to debug communication between Helix and ErlangLS.

## Tips and Tricks

LSP-driven auto-format is disabled by default. You can enable auto-format local
to a project by adding a `.helix/languages.toml`:

```toml
[[language]]
name = "erlang"
auto-format = true
```

Or globally in the [language configuration file].

[Helix]: https://helix-editor.com
[language configuration file]: https://docs.helix-editor.com/languages.html
[log file]: https://github.com/helix-editor/helix/wiki/FAQ#access-the-log-file
