# simple-denote.nvim

This plugin provides a command `:Denote note` that prompts for a title and tags, then creates a new file using the emacs `denote` package file-naming scheme:

`DATE==SIGNATURE--TITLE__KEYWORDS.EXTENSION`

![](https://i.imgur.com/sRlQeMk.mp4)

For example:
1. `20240601T174946--how-to-tie-a-tie__lifeskills_clothes.md`
2. `20240601T180054--i-have-no-tags.md`
3. `20240601T193022__im_only_tags.md`
4. `20240601T200121.md`
5. `20240601T213392=1a1--i-have-a-signature__denote_coolstuff.md` (Not yet implemented)

There is no support for frontmatter, links, or any other denote features. I just like the file-naming scheme. It's easy to parse, search, and sort chronologically.

You can read more about the denote file-naming scheme here:
https://protesilaos.com/emacs/denote#h:4e9c7512-84dc-4dfb-9fa9-e15d51178e5d

# Installation / Config

Example config via [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "DefaultGen/simple-denote.nvim",
  opts = {
    ext = "md",             -- Note file extension
    dir = "~/notes",        -- Notes directory (should already exist)
    add_heading = true,     -- Add a md/org heading to new notes
    retitle_heading = true, -- Replace the first line with a new heading when retitling
  },
},
```

The heading options automatically support Markdown (#) and Org/Norg (*) headings.

# :Denote Command

```vim
" Creates a new note in the `dir` directory with `ext` extension
" Tags are space delimited. The title or tags can be blank.
:Denote note
```

```vim
" Renames the current note with the new title
" If `retitle_heading` is true, overwrites the first line heading as well
:Denote retitle
```

```vim
" Renames the current note with the new list of tags (space delimited)
:Denote retag
```

# Credits

* [HumanEntity's denote.nvim](https://github.com/HumanEntity/denote.nvim) - This project was based on denote.nvim and modified to suit my personal preference or closer adhere to the original Denote spec.
* [denote.el](https://protesilaos.com/emacs/denote) - The original Emacs package

# License

MIT
