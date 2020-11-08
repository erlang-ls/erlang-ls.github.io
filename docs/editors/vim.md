# Vim / NeoVim

> **NOTE**: Neovim has recently included a [native Language
> Server](https://neovim.io/doc/user/lsp.html), though it is not yet available
> over in many distributed versions (e.g. `brew`). Once the native solution is
> verified to work well, we will update this documentation to reflect the setup.

## Setup

The following instructions should enable Erlang language server integration via
the [Coc system](https://github.com/neoclide/coc.nvim) (an intellisense engine
for both Vim and Neovim).

## Installing Coc with vim-plug

For [vim-plug](https://github.com/junegunn/vim-plug) users with nodejs >= 10.12
installed, installing the plugin is just:

```vim
" Use release branch (Recommended)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
```

To make the plugin aware of erlang\_ls however, it needs configuration.

### Coc plugin configuration

Coc is configured through `coc-settings.json`, which can be opened in vim by 
issuing the command:
```vim
:CocConfig
```

If `erlang_ls` is present in your `$PATH` variable then the following config
should suffice:
```vim
{
  "languageserver": {
    "erlang": {
      "command": "erlang_ls",
      "filetypes": ["erlang"]
    }
  }
}
```

When vim starts editing a file of filetype `erlang`, if the erlang\_ls server
can be started and connected to, you should see something like the following
message from Coc:

```vim
[coc.nvim] Erlang LS (in erlang_ls), version: X.Y.Z+build.REF
```

For suggestions on configuring Coc and possible key-bindings see its [example
configuration
documentation](https://github.com/neoclide/coc.nvim#example-vim-configuration).
