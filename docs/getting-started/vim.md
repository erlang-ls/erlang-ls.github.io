# Vim / NeoVim

## Setup using Coc

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

## Setup for Neovim using the built-in language server client

The following instructions should enable Erlang language server integration
using the built-in language server client in Neovim. The
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) plugin
is used to configure, launch, and initialize the language server.

### Installing nvim-lspconfig

Install using, for example, [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'neovim/nvim-lspconfig'
```

### Enable the language server

Add the following setup call to your `init.vim` to make the language server attach
to Erlang files:

```vim
lua require'lspconfig'.erlangls.setup{}
```

Now, when you open an Erlang file you should see a message like this:

`LSP[erlangls][Info] Erlang LS (in <your-project>), version: ..., OTP version: ...`

Test it by writing some incorrect code. You should see a syntax error message.
Run `:LspInfo` to get the status of active and configured language servers.

### Configuration

There are no default keybindings for the LSP commands. You can find a good
example on how to set these up in the
[Keybindings and completion](https://github.com/neovim/nvim-lspconfig#keybindings-and-completion)
section on the nvim-lspconfig plugin page. The idea is to create a function that
sets up your keybindings and configuration, which is passed to the setup
function in the previous section. This function is then called when the Erlang
language server is attached. See the
[Neovim LSP documentation](https://neovim.io/doc/user/lsp.html) for more
information.

### Tips and tricks

Run `:h vim.diagnostic.config` inside Neovim for instructions on how to display
diagnostics. `:h vim.lsp.codelens.refresh` describes how to show code lenses.
