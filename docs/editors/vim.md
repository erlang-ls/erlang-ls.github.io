# Vim / NeoVim

> **NOTE**: Neovim has recently included a [native Language
> Server](https://neovim.io/doc/user/lsp.html), though it is not yet available
> over in many distributed versions (e.g. `brew`). Once the native solution is
> verified to work well, we will update this documentation to reflect the setup.

## Setup

The following instructions should enable Erlang language server integration via
the [https://github.com/neoclide/coc.nvim](Coc system) (an intellisense engine
for both Vim and Neovim). There is a [plugin for Coc which interacts with
erlang_ls](https://github.com/hyhugh/coc-erlang_ls).


### Vim plugins

For [vim-plug](https://github.com/junegunn/vim-plug) users, install Coc and its
plugin coc-erlang_ls by entering the following in your `init.vim` or `.vimrc`
plugin section:

```vim
" Use release branch (Recommended)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'hyhugh/coc-erlang_ls', {'do': 'yarn install --frozen-lockfile'}
```

You should ensure your `yarn` has frozen-lockfile support (current version
distributed by `brew` does not). Then restart vim and run `:PlugInstall`.


### Coc plugin and configuration

Configure Coc by editing `coc-settings.json`, easily done in vim by issuing the
command:
```vim
:CocConfig
```

If you installed `erlang_ls` to its default location then the following config
should suffice:
```vim
{
  "erlang_ls.erlang_ls_path": "/usr/local/bin/erlang_ls",
  "erlang_ls.trace.server": "off"
}
```

When vim starts editing a file of filetype `erlang`, if the erlang_ls server
can be started and connected to, you should see something like the following
message from Coc:

```vim
[coc.nvim] Erlang LS (in erlang_ls), version: X.Y.Z+build.REF
```

For suggestions on configuring Coc and possible key-bindings see its [example
configuration
documentation](https://github.com/neoclide/coc.nvim#example-vim-configuration).
