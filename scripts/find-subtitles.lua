local function find_file(file_name, root_path)
    -- Search files in the current directory
    local file_list = io.popen('dir "' .. root_path .. '" /b /a-d'):lines()

    for file in file_list do
        if file == file_name then
            return root_path .. '\\' .. file_name
        end
    end

    -- Search recursively in subdirectories
    local subdir_list = io.popen('dir "' .. root_path .. '" /b /ad'):lines()

    for subdir in subdir_list do
        if subdir ~= '.' and subdir ~= '..' then
            local result = find_file(file_name, root_path .. '\\' .. subdir)

            if result then
                return result
            end
        end
    end
end

local function find_subs(file_name)
    local root_path = "."
    local file_path = find_file(file_name, root_path)

    if file_path then
        mp.command_native({"sub-add", file_path})
    end
end

local function on_file_loaded(event)
    local title = mp.get_property_native("media-title")

    if title then
        title = string.sub(title, 1, -5)
        title = title .. ".srt"
        find_subs(title)
    end
end

mp.register_event("file-loaded", on_file_loaded)
