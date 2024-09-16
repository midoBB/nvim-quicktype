# Nvim-Quicktype

A Neovim plugin for creating types in a multitude of languages based from a JSON in the clipboard.

Same behavior as this [VS Code plugin](https://github.com/glideapps/quicktype-vscode).


## Prerequisites

This plugin depends on the `quicktype` CLI tool being installed on your system. You can install it from the [quicktype repository](https://github.com/glideapps/quicktype).

## Installation

Use your favorite plugin manager, for example with `lazy.nvim`:

```lua
return {
  "midoBB/nvim-quicktype" ,
  cmd = "QuickType",
  ft = { "typescript", "python", "java", "go", "rust", "cs", "swift", "elixir", "kotlin" "typescriptreact" }
}
```

## Supported Languages

* C#
* Elixir
* Go
* Java
* Kotlin
* Python
* Rust
* TypeScript

## Configuration

This plugin can be configured via the `setup` function.

You can specify the command used to run QuickType. By default, it's `quicktype`.

```lua
require("nvim-quicktype").setup({
  global = {
    -- Quicktype global options
    cmd = "quicktype", -- Path to the quicktype executable
    src_lang = "json", -- The language of the input
    no_combine_classes = false, -- Do not combine classes with shared properties into a single base class
    all_properties_optional = false, -- Make all properties optional
    alphabetize_properties = false, -- Alphabetize properties
    telemetry = "disable", -- Send telemetry data to Quicktype (can be "enable", or "disable")
    output_file = nil, -- Output file (if not specified, output is printed to stdout)
    debug_dir = nil, -- Directory to write debug info to (if not specified, no debug info is written)
    clipboard_source_register = nil, -- Register from which to read the copied JSON (if not specified, if will default to system then to unnamed and lastly to 0 register)
  },
  filetypes = {
    -- Quicktype language-specific options
    typescript = {
      lang = "typescript", -- The language to generate types for
      additional_options = {
        -- Add any additional options here
        -- Example:
        -- ["just-types"] = true,
        -- ["prefer-unions"] = true,
      },
    },
    python = {
      lang = "python", -- The language to generate types for
      additional_options = {
      },
    },
    -- Add more filetypes as needed
  },
})
```

For more information about the available options, please refer to the help of the quicktype command.

```bash
quicktype --help
```

# Usage

You have a JSON in the clipboard or the first register, and you get prompted for the top-level type name.

Then you'll get the newly generated type inserted at the cursor position.

Here is it in practice :

![Demo](./demo/Recording.gif)
