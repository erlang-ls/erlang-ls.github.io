# IntelliJ

## Setup

> **WARNING**: The current version of the IntelliJ LSP plugin (1.6.1)
> is quite limited, so not all of the Erlang Language Server
> capabilities are available in IntelliJ.

First of all, ensure you have the [LSP
Support](https://github.com/gtache/intellij-lsp) plugin installed. If
you don't, you can simply navigate to:

    Preferences > Plugins > Browse Repositories

Search for "LSP Support" and install the respective plugin.

Restart IntelliJ, then navigate to:

    Preferences > Languages and Frameworks > Language Server Protocol > Server Definitions

There you can instruct IntelliJ on how to start the server. Select
`Raw Command`, set `erl;hrl` as the extension, then add as the
command:

    /ABSOLUTE/PATH/TO/erlang_ls/_build/default/bin/erlang_ls --transport stdio

Ensure you use an absolute path. The plugin does not seem to
understand the `~` symbol. For the above command to work, IntelliJ
requires the `PATH` variable to be correctly configured to include
Erlang 20+. To circumvent this issues on Mac OS, the best way is to
start IntelliJ from the terminal (i.e. via the `idea` command) and not
via Spotlight.

To visualize documentation and type specs while hovering a function,
ensure the _Show quick documentation on mouse move_ option is enabled
in your IntelliJ preferences:

    Preferences > Editor > General

There, you can also set a delay in milliseconds.

For more information about how to configure the IntelliJ LSP Client,
please refer to the project [GitHub
page](https://github.com/gtache/intellij-lsp).

## Troubleshooting

In some cases, the IntelliJ LSP client may not be able to connect to
the server. In such cases, the first step is to enable logging:

    Preferences > Languages and Frameworks > Language Server Protocol

Check the _Log servers communications_ check-box there.

After restarting IntelliJ, you will notice an extra `lsp` directory
created inside your Erlang project. This directory contains the
`error` and `output` logs, which should give you a hint about what is
going on.

An alternative source of information is represented by the IntelliJ
logs:

    Help > Show Logs
