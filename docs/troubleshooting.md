# Troubleshooting

## Debug Mode

It is possible to compile and start the language server in _debug mode_:

    rebar3 as debug escriptize

Ensure you update your `PATH` to include the new executable which now
resides in:

    /path/to/erlang_ls/_build/debug/bin/erlang_ls

Once an instance of the server is running, find the name of the node in
the [logs](#logs) or by running `epmd -names`. It will look something like:

    $ epmd -names
    epmd: up and running on port 4369 with data:
    name erlang_ls_62880311918 at port 50819

And you can connect to it via:

    erl -sname debug -remsh erlang_ls_62880311918@`HOSTNAME`

The [redbug](https://github.com/massemanet/redbug) application is
included in _debug mode_, so feel free to use it.

## Logging

When the escript is built using the `debug` profile as above, logging
will be enabled and the logs will be written to your platform's log
directory (i.e. the return value from `filename:basedir(user_log,
"erlang_ls")`), in a file named `server.log`.

It's possible to customize the logging directory by using the
`--log-dir` option when starting the server.

It's also possible to specify the verbosity of the logs by using the
`--log-level` option. In addition to the `notice`, `debug`, `info`,
`warning` and `error` levels, [syslog style loglevel comparison
flags](https://github.com/erlang-lager/lager#syslog-style-loglevel-comparison-flags)
can also be used.

When the `escript` is built in the `default` mode (i.e. `rebar3 escript`),
no log files are generated, unless the `--log-dir` option is provided.
