# Neovim cheatsheet

`<leader>` is `Space`.

Open this file with `:Cheatsheet`. It opens in a read-only tab; press `q` to close it.

## General editing

| Mode | Key | Action |
|---|---|---|
| Insert | `<C-c>` | Return to normal mode |
| Normal | `<Esc>` | Clear search highlighting |
| Normal | `<C-d>` / `<C-u>` | Scroll half a page and keep the cursor centered |
| Normal | `n` / `N` | Move through search matches and keep the cursor centered |
| Normal | `J` | Join lines without moving the cursor |
| Visual | `J` / `K` | Move the selected lines down/up |
| Visual | `<` / `>` | Indent and keep the selection |
| Visual | `P` | Paste without replacing the unnamed register |
| Normal, Visual | `Y` | Yank to the system clipboard |
| Normal, Visual | `D` | Delete into register `d` |
| Normal | `<leader>s` | Replace the word under the cursor throughout the buffer |
| Normal | `<leader>x` | Toggle the current file's executable bit |
| Normal | `<C-f>` | Open `tmux-sessionizer` in a new tmux window |
| Normal | `<leader>?` | Show buffer-local mappings with WhichKey |

## Find and navigate

| Key | Action |
|---|---|
| `<leader>ft` | Find files |
| `<leader>fg` | Find Git-tracked files near the current file |
| `<leader>fl` | Live grep |
| `<leader>fr` | Live grep with arguments |
| `<leader>fd` | Search diagnostics |
| `<leader>tb` | List open buffers |
| `d` in the buffer picker | Delete the selected unmodified buffer |
| `-` | Open Oil at the current file's directory |
| `+` | Close Oil |
| `gx` | Open the URL under the cursor |

## Terminals

| Key | Action |
|---|---|
| `<M-,>` | Toggle the floating terminal |
| `<leader>tt` | List and select active terminals |
| `<Esc>` or `²` in a terminal | Leave terminal-input mode |

## Harpoon

| Key | Action |
|---|---|
| `<leader>a` | Add the current file |
| `M` | Open the Harpoon file picker |
| `d` in the Harpoon picker | Remove the selected entry |
| `Mp` / `Mn` | Select the previous/next Harpoon entry |
| `ma`, `mz`, `me`, `ms` | Select entries 1-4 with AZERTY layout |
| `mq`, `mw`, `me`, `ms` | Select entries 1-4 with QWERTY layout |

## Sessions and history

| Key | Action |
|---|---|
| `<leader>os` | Search saved sessions |
| `<leader>oa` | Toggle automatic session saving |
| `<leader>u` | Toggle the undo tree for the current buffer |

## Formatting and completion

| Mode | Key | Action |
|---|---|---|
| Normal | `<leader>ff` | Format the current buffer |
| Insert | `<C-p>` / `<C-n>` | Select the previous/next completion item |
| Insert | `<C-Space>` | Open completion |
| Insert | `<Tab>` | Confirm the selected completion item |
| Insert | `<C-e>` | Close completion |
| Insert | `<C-u>` / `<C-d>` | Scroll completion documentation |
| Insert, Select | `<C-k>` / `<C-j>` | Jump forward/backward through snippet fields |

Files are also formatted automatically before saving when a formatter is configured.

## Code navigation

These mappings are available in buffers with an attached language server.

| Key | Action |
|---|---|
| `gd` | Find definitions |
| `grd` | Go to declaration |
| `grr` | Find references |
| `gri` | Go to implementation |
| `grn` | Rename symbol |
| `gra` | Code actions |
| `gO` | Search document symbols |
| `grw` | Search workspace symbols |
| `K` | Show hover documentation |
| `gl` | Show diagnostics for the current line |
| `<leader>v` | Open the definition in a vertical split |

## Treesitter selections

Use these from visual or operator-pending mode.

| Key | Select |
|---|---|
| `af` / `if` | Around/inside a function |
| `ac` / `ic` | Around/inside a class |
| `aP` / `iP` | Around/inside a parameter |
| `aC` / `iC` | Around/inside a conditional |
| `al` / `il` | Around/inside a loop |

## Debugging

| Key | Action |
|---|---|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Set a conditional breakpoint |
| `<leader>dc` | Start or continue |
| `<leader>dC` | Run to cursor |
| `<leader>di` | Step into |
| `<leader>dO` | Step over |
| `<leader>do` | Step out |
| `<leader>dP` | Pause |
| `<leader>dt` | Terminate |
| `<leader>dl` | Run the previous debug configuration |
| `<leader>dr` | Toggle the debug REPL |
| `<leader>du` | Toggle the debug UI |
| `<leader>de` | Evaluate the expression under the cursor/selection |

## Useful commands

| Command | Action |
|---|---|
| `:Cheatsheet` | Open this cheatsheet in a read-only tab |
| `:Registers` | Browse registers with Telescope |
| `:SetLayout azerty` | Use AZERTY Harpoon indicators |
| `:SetLayout qwerty` | Use QWERTY Harpoon indicators |

Standard Vim mappings such as `u`, `<C-r>`, `gc`, `gb`, `za`, `zm`, and `zr` continue to work normally.
