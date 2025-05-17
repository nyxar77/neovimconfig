local json = vim.fn.json_encode
local decode = vim.fn.json_decode
local state_file = vim.fn.stdpath('data') .. '/layout_state.json'


local layouts = {
    layout_set = {
        qwerty = true,
        azerty = true,
        qw = true,
        az = true
    },
    acceptedLayout = function(self, layout)
        return self.layout_set[layout] == true
    end
}

local alias_map = {
    qwerty = "qwerty",
    qw = "qwerty",
    azerty = "azerty",
    az = "azerty"
}

local function saveLayout(layout)
    local f = io.open(state_file, 'w')
    if not f then
        print("error: failed to open file");
        return false
    end
    local aliasLayout = alias_map[layout]
    local ok = pcall(function()
        f:write(json({ layout = aliasLayout or "" }))
    end)
    f:close()

    if not ok then
        print("error: layout is not saved!");
        return false
    end
    return true
end

local function loadLayout()
    local f = io.open(state_file, 'r')
    if f then
        local content = f:read("*a")
        f:close()
        local data = decode(content)
        if data and data.layout then
            return data.layout
        end
    end
    return nil
end

return {
    savelayout = saveLayout,
    loadlayout = loadLayout,
    acceptedLayout = function(layout)
        return layouts:acceptedLayout(layout)
    end
}
