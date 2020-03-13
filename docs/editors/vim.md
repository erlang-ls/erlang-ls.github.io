# Vim / NeoVim

## Setup

For [vim-plug](https://github.com/junegunn/vim-plug) users, install
[Coc](https://github.com/neoclide/coc.nvim) and its plugin
[coc-erlang_ls](https://github.com/hyhugh/coc-erlang_ls) by entering the
following in your `init.vim` or `.vimrc` plugin section:

```vim
" Use release branch (Recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'hyhugh/coc-erlang_ls', {'do': 'yarn install --frozen-lockfile'}
```

You should ensure your `yarn` has frozen-lockfile support (current version
distributed by `brew` does not). Then restart vim and run `:PlugInstall`. If
the erlang_ls server is running, and you have [configured the CoC
plugin](https://github.com/hyhugh/coc-erlang_ls#config), then when vim starts
you should see the message that Coc has connected to it:

```vim
[coc.nvim] coc-erlang_ls is ready
```

For suggestions on configuring Coc see its [example configuration
documentation](https://github.com/neoclide/coc.nvim#example-vim-configuration).
