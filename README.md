# `denote.nvim`

This is a fork of HumanEntity's `denote.nvim`, modified to suit my personal preferences and be more accurate to the original emacs `denote` filename format.

The plugin just provides a command `:Denote note` that creates a new note with a `denote` style filename.

There is no support for frontmatter, signatures, or any other `denote` features because I don't use them. I just like the filenaming scheme.

You can read more about the `denote` file-naming scheme here:
https://protesilaos.com/emacs/denote#h:4e9c7512-84dc-4dfb-9fa9-e15d51178e5d

# Installation / Config

Example config via [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "DefaultGen/denote.nvim",
  opts = {
    ext = "md",
    dir = "~/notes/",
    new_heading_on_retitle = true,
  },
} 
```

`ext` is the file extension for your notes (e.g. md, org, norg)

`dir` is your notes directory. Make sure you create it beforehand.

`new_heading_on_retitle` determines whether `denote.nvim` will replace the first line with a new heading when you retitle a note. It will only do this if the first line is a heading to begin with.


# Usage

## `Denote` command

### Creating notes

To create use `:Denote note` command. It will will prompt for note name and tags. Tags are space separated.

### Change note title

To change the title, use the `:Denote retitle` command. It will prompt you for a new title, then update both the filename and first line (if configured).

### Change note tags

To change the tags, use the `:Denote retag` command. This will replace your tags with the new tags. All this does is change the filename.

## `api` way

To use `denote` api either require it using

```lua
local api = require("denote.api")
```

or use `denote.api`

```lua
local api = require("denote").api
```

One thing to note is that you can use the api just like the command just don't pass any argument to function.

### Creating notes

To create the note use `note` function.

```lua
api.note(options, name, tags)
```

# License

MIT
