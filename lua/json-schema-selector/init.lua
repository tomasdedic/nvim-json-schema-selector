local fs = require("plenary.scandir")
local path = require("plenary.path")

local M = {}

-- Default configuration
local default_config = {
    schemas_catalog = "tomasdedic/openshift-json-schema",
    schemas_catalog_local_path = vim.fn.expand("~/GIT/OPENSHIFT/openshift-json-schema/4.19"),
    schema_catalog_branch = "main",
    schemas_catalog_remote_path = "4.19",  -- Subdirectory in the remote repo
    local_schemas = false,
}

-- Current configuration
local config = {}

-- Setup function to merge user config
M.setup = function(opts)
    config = vim.tbl_deep_extend("force", default_config, opts or {})

    -- Auto-detect remote path from local path if not explicitly set
    if opts and opts.schemas_catalog_local_path and not opts.schemas_catalog_remote_path then
        -- Extract last directory component (e.g., "4.19" from "/path/to/schemas/4.19")
        local parts = vim.split(config.schemas_catalog_local_path, "/", { plain = true })
        config.schemas_catalog_remote_path = parts[#parts]
    end

    -- Set schema_url based on local_schemas option
    if config.local_schemas then
        -- Use local file path with file:// protocol
        M.schema_url = "file://" .. config.schemas_catalog_local_path
    else
        -- Use GitHub raw URL with /refs/heads/ and version path
        M.schema_url = "https://raw.githubusercontent.com/"
            .. config.schemas_catalog
            .. "/refs/heads/"
            .. config.schema_catalog_branch
            .. "/"
            .. config.schemas_catalog_remote_path
    end
end

M.only_in_directory = function(fullpath)
    local stringlen = config.schemas_catalog_local_path:len()
    return fullpath:sub(stringlen + 2)
end

M.list_files = function(directory)
    local opts = {
        hidden = false,
        add_dirs = false,
    }

    local fileList = {}
    local dir = fs.scan_dir(directory, opts)
    for _, fileName in ipairs(dir) do
        if fileName:match("^.+(%.json)$") then
            table.insert(fileList, M.only_in_directory(fileName))
        end
    end
    return fileList
end

M.toggle_local_schemas = function()
    config.local_schemas = not config.local_schemas
    M.setup(config)

    -- Debug: Show the schema_url after toggle
    print("DEBUG toggle: local_schemas = " .. tostring(config.local_schemas))
    print("DEBUG toggle: schema_url = " .. M.schema_url)

    local mode = config.local_schemas and "LOCAL" or "REMOTE"
    vim.notify("Schema mode: " .. mode, vim.log.levels.INFO, { title = "JSON Schema Selector" })
end

M.init = function()
    -- Check if path exists
    local p = path.new(config.schemas_catalog_local_path)
    if not p:exists() then
        vim.notify(
            "Schema catalog not found at: " .. config.schemas_catalog_local_path,
            vim.log.levels.ERROR,
            { title = "JSON Schema Selector" }
        )
        return
    end

    local all_schemas = M.list_files(config.schemas_catalog_local_path)

    if #all_schemas == 0 then
        vim.notify("No schema files found", vim.log.levels.WARN, { title = "JSON Schema Selector" })
        return
    end

    local mode_indicator = config.local_schemas and " [LOCAL]" or " [REMOTE]"

    vim.ui.select(all_schemas, {
        prompt = "Select schema" .. mode_indicator .. " (" .. #all_schemas .. " schemas)",
        format_item = function(item)
            return item:gsub("%.json$", "")
        end
    }, function(selection)
        if not selection then
            vim.notify("Canceled.", vim.log.levels.WARN, { title = "JSON Schema Selector" })
            return
        end

        local schema_url = M.schema_url .. "/" .. selection
        local schema_modeline = "# yaml-language-server: $schema=" .. schema_url

        -- Debug: Print what we're about to insert
        print("DEBUG: schema_url = " .. schema_url)
        print("DEBUG: schema_modeline = " .. schema_modeline)
        print("DEBUG: local_schemas = " .. tostring(config.local_schemas))

        vim.api.nvim_buf_set_lines(0, 0, 0, false, { schema_modeline })

        local mode_msg = config.local_schemas and " (local)" or " (remote)"
        vim.notify(
            "Added schema: " .. selection:gsub("%.json$", "") .. mode_msg,
            vim.log.levels.INFO,
            { title = "JSON Schema Selector" }
        )
    end)
end

-- Initialize with default config if setup wasn't called
M.setup(default_config)

return M
