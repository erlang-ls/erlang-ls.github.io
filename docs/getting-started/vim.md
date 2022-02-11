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

#### Example

```vim
" init.vim
...
lua require'lspconfig'.erlangls.setup{}

lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=Grey guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=Grey guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=Grey guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

 -- Use a loop to conveniently both setup defined servers 
 -- and map buffer local keybindings when the language server attaches
 local servers = { "erlangls" }
 for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
 end

EOF
```

### Tips and tricks

Run `:h vim.diagnostic.config` inside Neovim for instructions on how to display
diagnostics. `:h vim.lsp.codelens.refresh` describes how to show code lenses.
