# `denote.nvim`

This is a fork of HumanEntity's `denote.nvim`, modified to suit my personal preferences and be more accurate to the original emacs `denote` filename format.

There is no support for frontmatter, signatures, or any other `denote` features because I don't use them. I just like the filenaming scheme. This is just a simple command I use to create new markdown notes with `denote` filenaming.

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

To create use `note` sub command. It will will prompt for note name and tags. Tags are space separated.

### Change note title

To change the title, use the `retitle` sub command. It will prompt you for a new title, then update both the filename and first line (if configured).

I don't use frontmatter and all my markdown notes start with a heading that includes the title, so the default behavior is to swap the first line with the new title. You can disable this in the config so it only changes the filename.

### Change note tags

To change the tags, use the `retag` sub command. This will prompt you for new, comma-separated tags. All this does is change the filename because I don't use frontmatter.

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
