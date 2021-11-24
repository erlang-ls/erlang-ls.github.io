# Configuration

## The `erlang_ls.config` file

It is possible to customize the behaviour of the `erlang_ls` server
via a configuration file, named `erlang_ls.config`. The
`erlang_ls.config` file should be placed in the root directory of a
given project to store the configuration for that project.

A sample `erlang_ls.config` file would look like the following:

```yaml
otp_path: "/path/to/otp/lib/erlang"
deps_dirs:
  - "lib/*"
diagnostics:
  enabled:
    - crossref
  disabled:
    - dialyzer
include_dirs:
  - "include"
  - "_build/default/lib"
lenses:
  enabled:
    - ct-run-test
  disabled:
    - show-behaviour-usages
macros:
  - name: DEFINED_WITH_VALUE
    value: 42
  - name: DEFINED_WITHOUT_VALUE
code_reload:
  node: node@example
```

The file format is `yaml`.

The following customizations are possible:

| Parameter                    | Description                                                                                                                               |
|------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| apps\_dirs                   | List of directories containing project applications. It supports wildcards.                                                               |
| code\_reload                 | Whether or not an rpc call should be made to a remote node to compile and reload a module                                                 |
| deps\_dirs                   | List of directories containing dependencies. It supports wildcards.                                                                       |
| diagnostics                  | Customize the list of active diagnostics. See below for a list of available diagnostics.                                                  |
| include\_dirs                | List of directories provided to the compiler as include dirs. It supports wildcards.                                                      |
| incremental\_sync            | Whether or not to support incremental synchronization of text changes in the client. Enabled by default.                                  |
| lenses                       | Customize the list of active code lenses                                                                                                  |
| macros                       | List of cusom macros to be passed to the compiler, expressed as a name/value pair. If the value is omitted or is invalid, 'true' is used. |
| otp\_apps\_exclude           | List of OTP applications that will not be indexed (default: megaco, diameter, snmp, wx)                                                   |
| otp\_path                    | Path to the OTP installation                                                                                                              |
| plt\_path                    | Path to the dialyzer PLT file. When none is provided the dialyzer diagnostics will not be available.                                      |
| code\_path\_extra\_dirs      | List of wildcard Paths erlang\_ls will add with code:add\_path/1                                                                          |
| elvis\_config\_path          | Path to the elvis.config file. Defaults to ROOT_DIR/elvis.config                                                                          |
| exclude\_unused\_includes    | List of includes files that are excluded from the `UnusedIncludes` warnings.                                                              |
| compiler\_telemetry\_enabled | When enabled, send `telemetry/event` LSP messages containing the `code` field of any diagnostics present in a file. Defaults to false.    |

### Diagnostics

When a file is open or saved, a list of _diagnostics_ are run in the
background, reporting eventual issues with the code base to the
editor. The following diagnostics are available:

| Diagnostic Name         | Purpose                                                                                           | Default  |
|-------------------------|---------------------------------------------------------------------------------------------------|----------|
| bound\_var\_in\_pattern | Report already bound variables in patterns (inspired by the [pinning operator][pinning-operator]) | enabled  |
| compiler                | Report in-line warnings and errors from the Erlang [compiler][compiler]                           | enabled  |
| crossref                | Use information from the Erlang LS Database to find out about undefined functions                 | disabled |
| dialyzer                | Use the [dialyzer][dialyzer] static analysis tool to find discrepancies in your code              | enabled  |
| elvis                   | Use [elvis][elvis] to review the style of your Erlang code                                        | enabled  |
| unused\_includes        | Warn about header files which are included but not utilized                                       | enabled  |
| unused\_macros          | Warn about macros which are defined but not utilized                                              | enabled  |

It is possible to customize diagnostics for a specific project. For example:

```
diagnostics:
  disabled:
    - dialyzer
  enabled:
    - crossref
```

## Automatic Code Reloading

The `code_reload` takes the following options:

| Parameter | Description                                                          |
|-----------|----------------------------------------------------------------------|
| node      | The node to be called for code reloading. Example erlang_ls@hostname |

## Code Lenses

_Code Lenses_ are also available in Erlang LS. The following lenses
are available in Erlang LS:

| Code Lens Name        | Purpose                                                                              |
|-----------------------|--------------------------------------------------------------------------------------|
| ct-run-test           | Display a _run_ button next to a Common Test testcase                                |
| function-references   | Show the number of references to a function                                          |
| server-info           | Display some Erlang LS server information on the top of each module. For debug only. |
| show-behaviour-usages | Show the number of modules implementing a behaviour                                  |
| suggest-spec          | Use information from dialyzer to suggest a spec                                      |

The following lenses are enabled by default:

* show-behaviour-usages

It is possible to customize lenses for a specific project. For example:

```
lenses:
  enabled:
    - ct-run-test
  disabled:
    - show-behaviour-usages
```

## Global Configuration

It is also possible to store a system-wide default configuration in an
`erlang_ls.config` file located in the _User Config_ directory. The
exact location of the _User Config_ directory depends on the operating
system used and it can be identified by executing the following
command on an Erlang shell:

    > filename:basedir(user_config, "erlang_ls").

Normally, the location of the _User Config_ directory is:

| Operating System | User Config Directory                               |
|------------------|-----------------------------------------------------|
| Linux            | /home/USER/.config/erlang\_ls                       |
| OS X             | /Users/USER/Library/Application\ Support/erlang\_ls |
| Windows          | c:/Users/USER/AppData/Local/erlang\_ls              |

Thus on Linux, for example, the full path to the default configuation file
would be `/home/USER/.config/erlang_ls/erlang_ls.config`

## Common configurations

Many Erlang repositories follow the same structure. We include common
Erlang LS configurations in this section, for easy reuse.

### `rebar3` project

The following configuration can be used for most [rebar3][rebar3]
based projects.

```yaml
apps_dirs:
  - "_build/default/lib/*"
include_dirs:
  - "_build/default/lib/*/include"
  - "include"
```

### `rebar3` _umbrella_ project

If your `rebar3` project includes multiple application (e.g. in an
`apps` folder), you may want to adapt your Erlang LS configuration as
follows.

```yaml
apps_dirs:
  - "apps/*"
deps_dirs:
  - "_build/default/lib/*"
include_dirs:
  - "apps"
  - "apps/*/include"
  - "_build/default/lib/"
  - "_build/default/lib/*/include"
```

### The `erlang/otp` repository

To be able to use the major Erlang LS features with the
[erlang/otp][otp] repository, the following minimal configuration
should suffice.

```yaml
otp_path: "/path/to/otp"
apps_dirs:
  - "lib/*"
include_dirs:
  - "lib"
  - "lib/*/include"
```

[compiler]:https://erlang.org/doc/man/compile.html
[dialyzer]:http://erlang.org/doc/apps/dialyzer/dialyzer_chapter.html
[elvis]:https://github.com/inaka/elvis
[otp]:https://github.com/erlang/otp
[rebar3]:https://rebar3.org
[pinning-operator]:https://www.erlang.org/erlang-enhancement-proposals/eep-0055.html
