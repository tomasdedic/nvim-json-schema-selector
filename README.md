# JSON Schema Selector

A Neovim plugin to select and insert YAML/JSON schema modelines from a local or remote catalog.

## Features

- Browse and select schemas from a local directory
- Support for both local file paths and remote GitHub URLs
- Toggle between local and remote schema sources
- Integrates with `yaml-language-server` for schema validation

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "tomasdedic/nvim-json-schema-selector",
  ft = "yaml",  -- Only load for YAML files
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    schemas_catalog = "tomasdedic/openshift-json-schema",
    schemas_catalog_local_path = vim.fn.expand("~/GIT/OPENSHIFT/openshift-json-schema/4.19"),
    schema_catalog_branch = "main",
    local_schemas = true,  -- Use local file paths (true) or GitHub URLs (false)
  },
  keys = {
    { "<leader>js", "<cmd>JsonSchemaSelect<cr>", desc = "Select YAML Schema", ft = "yaml" },
    { "<leader>jt", "<cmd>JsonSchemaToggle<cr>", desc = "Toggle Local/Remote Schemas", ft = "yaml" },
  },
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "tomasdedic/nvim-json-schema-selector",
  ft = "yaml",  -- Only load for YAML files
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    require("json-schema-selector").setup({
      schemas_catalog = "tomasdedic/openshift-json-schema",
      schemas_catalog_local_path = vim.fn.expand("~/GIT/OPENSHIFT/openshift-json-schema/4.19"),
      schema_catalog_branch = "main",
      local_schemas = true,
    })
  end
}
```

### Local Plugin (for development)

```lua
{
  dir = "~/path/to/nvim-json-schema-selector",
  name = "json-schema-selector",
  ft = "yaml",  -- Only load for YAML files
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    schemas_catalog_local_path = vim.fn.expand("~/GIT/OPENSHIFT/openshift-json-schema/4.19"),
    local_schemas = true,
  },
  keys = {
    { "<leader>cs", "<cmd>JsonSchemaSelect<cr>", desc = "Select YAML Schema", ft = "yaml" },
    { "<leader>ct", "<cmd>JsonSchemaToggle<cr>", desc = "Toggle Local/Remote Schemas", ft = "yaml" },
  },
}
```

## Configuration

### Default Configuration

```lua
{
  schemas_catalog = "tomasdedic/openshift-json-schema",
  schemas_catalog_local_path = vim.fn.expand("~/GIT/OPENSHIFT/openshift-json-schema/4.19"),
  schema_catalog_branch = "main",
  schemas_catalog_remote_path = "4.19",  -- Auto-detected from local path if not set
  local_schemas = false,  -- false = GitHub URLs, true = local file:// paths
}
```

### Options

| Option                        | Type    | Default                                        | Description                                                 |
| ----------------------------- | ------- | ---------------------------------------------- | ----------------------------------------------------------- |
| `schemas_catalog`             | string  | `"tomasdedic/openshift-json-schema"`           | GitHub repository (owner/repo)                              |
| `schemas_catalog_local_path`  | string  | `"~/GIT/OPENSHIFT/openshift-json-schema/4.19"` | Local path to schema directory                              |
| `schema_catalog_branch`       | string  | `"main"`                                       | GitHub branch to use for remote URLs                        |
| `schemas_catalog_remote_path` | string  | `"4.19"`                                       | Subdirectory in remote repo (auto-detected from local path) |
| `local_schemas`               | boolean | `false`                                        | Use local file paths instead of GitHub URLs                 |

## Usage

### Commands

- `:JsonSchemaSelect` - Open schema selector
- `:JsonSchemaToggle` - Toggle between local and remote schema URLs

### Lua API

```lua
local schema_selector = require("json-schema-selector")

-- Select and insert schema
schema_selector.init()

-- Toggle between local and remote
schema_selector.toggle_local_schemas()

-- Reconfigure at runtime
schema_selector.setup({
  local_schemas = true,
  schemas_catalog_local_path = "/path/to/schemas",
})
```

## Examples

### Local Schema Path

When `local_schemas = true`, the plugin generates:

```yaml
# yaml-language-server: $schema=file:///Users/you/GIT/OPENSHIFT/openshift-json-schema/4.19/deployment.json
```

### Remote Schema URL

When `local_schemas = false`, the plugin generates:

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/tomasdedic/openshift-json-schema/refs/heads/main/4.19/deployment.json
```

## Schema Catalog Structure

Your schema catalog directory should contain JSON schema files:

```
schemas/
├── deployment.json
├── service.json
├── configmap.json
└── pod.json
```

## Troubleshooting

### "Schema catalog not found"

Make sure `schemas_catalog_local_path` points to an existing directory containing `.json` files.
