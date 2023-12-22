# `denote.nvim`

`denote.nvim` is a plugins for creating notes without any external dependencies. Main inspiration for this project was emacs package called `Denote`.


# Installation

```lua
{
 "HumanEntity/denote.nvim",
 build = "mkdir -p ~/.denote/",
} 
```

This takes care of installing and creating note directory for `denote`. Denote has no external dependencies but I recommend you use `telescope-ui-select.nvim` plugin for better ui.
