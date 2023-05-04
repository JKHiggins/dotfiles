local TaskList = {}

-- see if the file exists
local function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
local function lines_from(file)
    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

function TaskList.send_tmux_cmd_to_ultralist(subject)
    -- Silently send keys to my tasklist pane in another window
    local command = "silent !tmux send-keys -t std-dev:tasklist.1 'ula " .. subject .. "' Enter"
    vim.cmd(command)
end

function TaskList.input_subject(project)
    vim.ui.input({
        prompt = "Enter subject (" .. project .. "): ",
        completion = "file",
    }, function(input)
        if input then
            local subject = project .. " " .. input
            -- Send full subject to tmux for tasklist insertion
            TaskList.send_tmux_cmd_to_ultralist(subject)
        else
            print "You cancelled"
        end
    end)
end

function TaskList.input_project()
    vim.ui.input({
        prompt = "Enter a project name: ",
        default = "+ProjectName",
        completion = "file",
    }, function(project)
        if project then
            TaskList.write_project_to_file(project)
            TaskList.input_subject(project)
        else
            print "You cancelled"
        end
    end)

    return projectName
end

function TaskList.write_project_to_file(projectName)
    if file_exists(".ul_projects") then
        print("Appending...")
        local file = io.open(".ul_projects", "a+")
        file:write(projectName, "\n")
        file:close()
    else
        print("Writing...")
        local file = io.open(".ul_projects", "w")
        file:write(projectName, "\n")
        file:close()
    end
end

function TaskList.new_task()
    local projects = {}
    projects = lines_from(".ul_projects")

    table.insert(projects, "--New Project--")

    vim.ui.select(projects, {
        prompt = "Select a project",
        format_item = function(item)
            return item
        end,
    }, function(project, idx)
        if project then
            local selected = project
            print("You selected " .. selected .. " at index " .. idx)

            if selected == "--New Project--" then
                -- Input a new project which will trigger subject upon completion
                TaskList.input_project()
            else
                -- Jump straight to subject input
                TaskList.input_subject(selected)
            end
        else
            print "You cancelled"
        end
    end)
end

vim.api.nvim_set_keymap('n', '<leader>nt', ':lua require"jhiggins.tasklist".new_task()<CR>', {noremap = true})

return TaskList
