# `denote.nvim`

`denote.nvim` is a plugins for creating notes without any external dependencies. Main inspiration for this project was emacs package called `Denote`.


# Installation

```lua
{
    "HumanEntity/denote.nvim",
    build = "mkdir -p ~/.denote/",
    cmd = "Denote",
} 
```

This takes care of installing, lazy loading and creating note directory for `denote`. Denote has no external dependencies but I recommend you use `telescope-ui-select.nvim` plugin for better ui.

# Usage

## `Denote` command

### Creating notes

To create use `note` sub command. It will will prompt for note name and tags. Tags are space separated.

### Searching for notes

To search for note use `search` sub command. It will prompt for date in YEAR MONTH DAY format, name and tags.

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
api.note(name, tags)
```

### Searching for notes

To search for note use `search` function.`date` is table with year, month and day field, `name` just a string and `tags` list of tags.

```lua
api.search(date,name,tags)
```
