# Internals

## The `erlang_ls` Database

The `erlang_ls` language server uses
[Mnesia](https://erlang.org/doc/man/mnesia.html) to persist
information. A new database is created and maintained for each
project/OTP pair. Databases are stored in the application cache
directory, which varies according to the operating system used.

Generally speaking, the directory should be:

| Operating System | Database Dir                                 |
|------------------|----------------------------------------------|
| Linux            | /home/USER/.cache/erlang\_ls                 |
| OS X             | /Users/USER/Library/Caches/erlang\_ls        |
| Windows          | c:/Users/USER/AppData/Local/erlang\_ls/Cache |

You can also run the following command on an Erlang shell to identify
the Database Directory on your system:

    > filename:basedir(user_cache, "erlang_ls").
