# simple-denote.nvim

This plugin provides a command `:Denote note` that prompts for a title and tags, then creates a new file in a flat notes directory using the [Emacs Denote package's file-naming scheme](https://protesilaos.com/emacs/denote#h:4e9c7512-84dc-4dfb-9fa9-e15d51178e5d):

`DATE==SIGNATURE--TITLE__KEYWORDS.EXTENSION`

For example:
1. `20240601T174946--how-to-tie-a-tie__lifeskills_clothes.md`
2. `20240601T180054--i-have-no-tags.md`
3. `20240601T193022__im_only_tags.md`
4. `20240601T200121.md`
5. `20240601T213392==1a1--i-have-a-signature__denote_coolstuff.md`

That's almost this does: open a file. I have overcomplicated my notes too many times with fancy Org Mode and Zettelkasten systems and this is my minimalist endgame. This readme is just overly long to guide any first time Neovim users coming from the Emacs side.

# Installation / Config

Example config via [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "DefaultGen/simple-denote.nvim",
  opts = {
    ext = "md",             -- Note file extension (e.g. md, org, norg, txt)
    dir = "~/notes",        -- Notes directory (should already exist)
    add_heading = true,     -- Add a md/org heading to new notes
    retitle_heading = true, -- Replace the first line heading when retitling
  },
},
```

The heading options automatically support Markdown (#) and Org/Norg (*) headings.

## Keymaps

Maybe you want to set keymaps for the commands as well

```lua
vim.keymap.set({'n','v'}, '<leader>nn', ":Denote note<cr>",      { desc = "New note"         })
vim.keymap.set({'n','v'}, '<leader>nt', ":Denote title<cr>",     { desc = "Change title"     })
vim.keymap.set({'n','v'}, '<leader>nk', ":Denote tag<cr>",       { desc = "Change tags"      })
vim.keymap.set({'n','v'}, '<leader>nz', ":Denote signature<cr>", { desc = "Change signature" })
```

## Manual Install

To install without a package manager:

```bash
mkdir -p ~/.local/share/nvim/site/pack/simple-denote.nvim/start
cd ~/.local/share/nvim/site/pack/simple-denote.nvim/start
git clone https://github.com/DefaultGen/simple-denote.nvim
```

Add the following to `~/.config/nvim/init.lua`

```lua
require('simple-denote').setup({
  ext = "md",
  dir = "~/notes",
  add_heading = true,
  retitle_heading = true,
})
```

### Manual upgrade

```bash
cd ~/.local/share/nvim/site/pack/simple-denote.nvim/start/simple-denote.nvim
git pull
```

# :Denote Command

```vim
" Creates a new note in the `dir` directory with `ext` extension
" Tags are space delimited. The title or tags can be blank.
:Denote note

" Renames the current note with the new title
" If `retitle_heading` is true, overwrites the first line heading as well
:Denote title

" Renames the current note with the new list of tags (space delimited)
:Denote tag

" Rename the current note with a signature
" This has a user-defined meaning and no particular purpose
:Denote signature

" Built in cursed search command (depends on fzf, fd, and sd)
:Denote search
```

# Search

You probably have a separate search plugin you will configure, but there is a cursed a built-in `:Denote search` command that depends on `fzf`, `fd`, and `sd`. It's both reinventing the wheel and WIP.

## Better Alternative: Minimal fzf.vim plugin

Instead of `:Denote search`, you can keep things as fast/minimal as possible by using the built-in `fzf.vim` plugin that comes with `fzf`. This is a barebones wrapper confusingly *not* the same as the identically named `junegunn/fzf.vim` plugin on Github. It's a single file in the `/plugin` directory in the `fzf` repo.

Arch Linux installs it with the `fzf` package under `/usr/share/vim/vimfiles/plugin`. Debian doesn't automatically install it. Find/download and source this file in your `init.lua`:

```lua
vim.cmd('source /usr/share/vim/vimfiles/plugin/fzf.vim')
```

Add a keymap to call `:FZF [dir]`:

```lua
vim.keymap.set({'n','v'}, '<leader>ns', ":FZF ~/notes<cr>", { desc = "Search Notes" })
```

# Credits

* [HumanEntity/denote.nvim](https://github.com/HumanEntity/denote.nvim) - This project was based on denote.nvim and modified to suit my personal preference or closer adhere to the original Denote spec.
* [denote.el](https://protesilaos.com/emacs/denote) - The original Emacs package
* [Christopher DeLuca](https://www.chrisdeluca.me/2022/01/12/diy-neovim-fzy.html) - Boilerplate code for search function

# License

MIT
