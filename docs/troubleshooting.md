# Troubleshooting

## Attaching to the Language Server via a Remote Shell

Once an instance of the server is running, find the name of the node in
the [logs](#logs) or by running `epmd -names`. It will look something like:

    $ epmd -names
    epmd: up and running on port 4369 with data:
    name erlang_ls_projectname_62880311918 at port 50819

And you can connect to it via:

    $ erl -sname debug -remsh erlang_ls_projectname_62880311918@`HOSTNAME`

If you see this error like this:

    *** ERROR: Shell process terminated! (^G to start new job) ***
    =ERROR REPORT==== 5-Jun-2020::15:53:07.270087 ===
    ** System NOT running to use fully qualified hostnames **
    ** Hostname Host-Name-Here.local is illegal **

Then try running the command without the `@HOSTNAME` at the end,
like so:


    $ erl -sname debug -remsh erlang_ls_projectname_62880311918

The [redbug](https://github.com/massemanet/redbug) application is
included in the escript, so feel free to use it.

## Logging

Logs are written to your platform's log directory (i.e. the return
value from `filename:basedir(user_log, "erlang_ls").`), in a file
named `server.log`. For example on a Mac, the default location is
`/Users/USERNAME/Library/Logs/erlang_ls/PROJECTDIR/server.log`, where
USERNAME and PROJECTDIR are your operating system's user account name
and the project folder that logs were generated for, respectively.

It's possible to customize the logging directory by using the
`--log-dir` option when starting the server.

It's also possible to specify the verbosity of the logs by using the
`--log-level` option. In addition to the `notice`, `debug`, `info`,
`warning` and `error` levels, [syslog style loglevel comparison
flags](https://github.com/erlang-lager/lager#syslog-style-loglevel-comparison-flags)
can also be used.
