# VSCode

## Setup

The Erlang Language Server is available in VSCode via a [dedicated
extension](https://github.com/erlang-ls/vscode).

To try it out, simply open VSCode and install the extension via the
Marketplace:

    Preferences > Extensions

Look for the `erlang-ls` extension and install it. That's it.

Remember that the Erlang Language Server requires Erlang/OTP 22 or
higher to run, so ensure that OTP 22+ is available in your `PATH`.

## Restarting the language server

You may want to quickly restart the language server for a given
workspace (e.g. after an update or in case of a server crash). To do
so:

    View -> Command Palette... -> Developer: Reload Window

On Mac OS you can use the `Cmd+Shift+P` shortcut to quickly access the
command palette.
