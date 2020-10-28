# Spacemacs

## Setup

The `develop` branch includes an Erlang layer with support for the
Language Server Protocol using Erlang LS as backend.

[Here](https://github.com/syl20bnr/spacemacs/tree/develop/layers/%2Blang/erlang)
you can find information about installation and configuration, as well
as supported features.

Both, `lsp` and `erlang-mode` variables, can be configured when
setting up `dotspacemacs-configuration-layers`, e.g:

```elisp
dotspacemacs-configuration-layers
'(
;...
lsp
(erlang :variables
        erlang-backend 'lsp
        erlang-root-dir "<path to>/otp_22/lib/erlang"
        erlang-man-root-dir "<path to>/otp_22_kred/lib/erlang/man"
        erlang-fill-column 100
        company-minimum-prefix-length 1
        company-idle-delay 0.3
        lsp-ui-doc-position 'bottom)
;...
)

```
