# Troubleshooting

## Attaching to the Language Server via a Remote Shell

Once an instance of the server is running, find the name of the node in
the [logs](#logs) or by running `epmd -names`. It will look something like:

    $ epmd -names
    epmd: up and running on port 4369 with data:
    name erlang_ls_62880311918 at port 50819

And you can connect to it via:

    erl -sname debug -remsh erlang_ls_62880311918@`HOSTNAME`

The [redbug](https://github.com/massemanet/redbug) application is
included in the escript, so feel free to use it.

## Logging

Logs are written to your platform's log directory (i.e. the return
value from `filename:basedir(user_log, "erlang_ls")`), in a file named
`server.log`.

It's possible to customize the logging directory by using the
`--log-dir` option when starting the server.

It's also possible to specify the verbosity of the logs by using the
`--log-level` option. In addition to the `notice`, `debug`, `info`,
`warning` and `error` levels, [syslog style loglevel comparison
flags](https://github.com/erlang-lager/lager#syslog-style-loglevel-comparison-flags)
can also be used.
