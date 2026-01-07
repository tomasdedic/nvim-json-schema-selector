-- Example LazyVim configuration for json-schema-selector
-- Place this in: ~/.config/nvim/lua/plugins/json-schema-selector.lua

return {
	dir = "/Users/ts/GIT/OPENSHIFT/json-schema-selector",
	name = "json-schema-selector",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		-- GitHub repository (owner/repo)
		schemas_catalog = "tomasdedic/openshift-json-schema",

		-- Local path to schema files
		schemas_catalog_local_path = vim.fn.expand("~/GIT/OPENSHIFT/openshift-json-schema/4.19"),

		-- GitHub branch
		schema_catalog_branch = "main",

		-- Remote subdirectory (auto-detected from local path if not set)
		schemas_catalog_remote_path = "4.19",

		-- Use local file:// paths (true) or GitHub URLs (false)
		local_schemas = true,
	},
	keys = {
		{ "<leader>js", "<cmd>JsonSchemaSelect<cr>", desc = "Select YAML Schema" },
	},
	config = function(_, opts)
		require("json-schema-selector").setup(opts)
	end,
}

-- Example URLs generated:
--
-- When local_schemas = true:
-- # yaml-language-server: $schema=file:///Users/you/GIT/OPENSHIFT/openshift-json-schema/4.19/deployment.json
--
-- When local_schemas = false:
-- # yaml-language-server: $schema=https://raw.githubusercontent.com/tomasdedic/openshift-json-schema/refs/heads/main/4.19/deployment.json
