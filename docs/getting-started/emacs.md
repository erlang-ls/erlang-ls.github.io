# Emacs

## Setup

The official `lsp-mode` package includes a client for the Erlang
Language Server.

[Here](https://github.com/erlang-ls/erlang_ls/blob/master/misc/dotemacs)
you can find a sample Emacs configuration file which installs and
configures all packages required to get all of the Erlang LS features
working. Use this configuration file as a starting point for your
Erlang LS Emacs configuration.

Whenever opening a project for the first time, you will be prompted by
`emacs-lsp` to select the correct project root. In that occasion, you
also have the opportunity to _blacklist_ projects. Information about
projects is stored in a file pointed by the `lsp-session-file`
variable. Its default location is `~/.emacs.d/.lsp-session-v1`. You
may need to prune or amend this file if you change your mind about
blacklisting a project or if you erroneously select a project
root. For more information about the `lsp-session-file` and
`emacs-lsp` in general, please refer to the [official
documentation](https://emacs-lsp.github.io/lsp-mode/).

Remember that the Erlang Language Server requires Erlang/OTP 21 or
higher to run, so ensure that OTP 21+ is available in your `PATH`.
This can be achieved, for example, by using the
[exec-path-from-shell](https://github.com/purcell/exec-path-from-shell)
Emacs package.

## Restarting the language server

You may want to quickly restart the language server for a given
workspace (e.g. after an update or in case of a server crash). To do
so:

    M-x lsp-workspace-restart

## Troubleshooting

If things do not work as expected, we advise you to start Emacs with
only the configuration from the provided sample file, using the
following command:

    emacs -q -l [PATH-TO-ERLANG-LS]/misc/dotemacs

This will remove from the equation potential incompatibilities with
other packages or configurations that you may have on your workstation
and that could conflict with Erlang LS.

To be sure that you don't have outdated or incompatible packages
installed, you may also want to rename your `~/.emacs.d` directory
while you are troubleshooting your Erlang LS Emacs setup.

Also, ensure that Erlang (i.e. `erl`, `escript` and friends) and the
`erlang_ls` executable are all available in your `PATH`. If they are
not, you can try the following:

```elisp
;; Ensure your Emacs environment looks like your user's shell one
(package-require 'exec-path-from-shell)
(exec-path-from-shell-initialize)
```

Finally, to enable logging on the client-side, just:

```elisp
(setq lsp-log-io t)
```

You can then follow the client logs for the current workspace by doing:

    M-x lsp-workspace-show-log

## Tips and Tricks

### Shortcuts for code lenses and quick actions

You can run `M-x lsp-avy-lens` to show _letters_ next to code
lenses. You can then press those letters to trigger the respective
action.

If your `sideline` is enabled (`(setq lsp-ui-sideline-enable t)`), you
can also use `M-x lsp-execute-code-action` to trigger quick-fix
actions.
