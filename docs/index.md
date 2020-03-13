# Welcome to Erlang LS

![erlang_ls](images/erlang-ls-logo-small.png?raw=true "Erlang LS")

Implementing features such as _auto-complete_ or _go-to-definition_
for a programming language is not trivial. Traditionally, this work
had to be repeated for each development tool and it required a mix of
expertise in both the targeted programming language and the
programming language internally used by the development tool of
choice.

A brilliant intuition, the [Language Server Protocol][lsp], also known
as _LSP_, changes the rules of the game. A real blessing for the
Erlang community.

[Erlang LS][git] is a language server providing language features for
the [Erlang][erlang] programming language. The server works with
_Emacs_, _VSCode_, _Sublime Text 3_, _Vim_ and probably many more text
editors and IDE which adhere to the _LSP_ protocol.

These pages contain all the information needed to configure your
favourite text editor or IDE and to work with Erlang LS. You will also
find instructions on how to configure the server to recognize the
structure of your projects and to troubleshoot your installation when
things do not work as expected.

## Get in touch

If you have any questions about the project, feel free to open a [new
issue][issue] on GitHub. You can also join the [#erlang-ls][slack]
channel in the _Erlanger_ Slack if you would like to get involved or
if you prefer a more informal mean of communication. All contributions
are welcome, be them in the form of a bug report, a question,
feedback, or code.

[git]:https://github.com/erlang-ls/erlang_ls
[lsp]:https://microsoft.github.io/language-server-protocol/
[erlang]:https://www.erlang.org
[issue]:https://github.com/erlang-ls/erlang_ls/issues
[slack]:https://slack.com/app_redirect?channel=erlang-ls
