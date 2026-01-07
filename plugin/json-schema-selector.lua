-- User commands for JSON Schema Selector
vim.api.nvim_create_user_command("JsonSchemaSelect", function()
    require("json-schema-selector").init()
end, {
    desc = "Select and insert YAML/JSON schema modeline",
})

vim.api.nvim_create_user_command("JsonSchemaToggle", function()
    require("json-schema-selector").toggle_local_schemas()
end, {
    desc = "Toggle between local and remote schema URLs",
})
