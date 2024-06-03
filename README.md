# `simple-denote.nvim`

This is a fork of HumanEntity's `denote.nvim`, modified to suit my personal preferences and be more accurate to the original emacs `denote` filename format.

The plugin just provides a command `:Denote note` that creates a new note with a `denote` style filename. For example: `20240601T174946--how-to-tie-a-tie__lifeskills_clothes.md`

There is no support for frontmatter, signatures, or any other `denote` features because I don't use them. I just like the filenaming scheme.

You can read more about the `denote` file-naming scheme here:
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

`new_heading_on_retitle` supports Markdown (#) and Org/Norg (*) headings.

# `Denote` Command

```vim
" Creates a new note in the `dir` directory with `ext` extension
" Tags are space delimited. The title or tags can be blank.
:Denote note
```

```vim
" Renames the current note with the new title
" If `new_heading_on_retitle` is true, overwrites the first line heading as well
:Denote retitle
```

```vim
" Renames the current note with the new list of tags (space delimited)
:Denote retag
```

# License

MIT
