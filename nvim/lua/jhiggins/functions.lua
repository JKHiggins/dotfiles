vim.g.hidden_all = 0

function ToggleHiddenAll()
    if vim.g.hidden_all == 0
    then
        vim.g.hidden_all = 1
        vim.opt.ruler = false
        vim.opt.showmode = false
        vim.opt.laststatus = 0
        vim.opt.showcmd = false
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.cmd("hi NonText guifg=bg")
    else
        vim.g.hidden_all = 0
        vim.opt.ruler = true
        vim.opt.showmode = true
        vim.opt.laststatus = 2
        vim.opt.showcmd = true
        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.cmd("hi NonText guifg=fg")
    end
end

local PROJECT_ROOT =
"/home/jhiggins/projects/kelyn-technologies/dsio-controlplane-infrastructure/saas_app/core_services/task_supervisor/lambda/layers/sculptor_orchestrator"

local function get_component_info(filepath)
    local prefix = filepath:match(".*/resources/components/(.*)%.py$")
    if prefix then
        return "component_model", prefix
    end

    prefix = filepath:match(".*/resources/constructs/(.*)%.py$")
    if prefix then
        return "construct_model", prefix
    end

    prefix = filepath:match(".*/resources/builders/(.*)_builder%.py$")
    if prefix then
        return "builder", prefix
    end

    prefix = filepath:match(".*/orchestrators/components/(.*)_orchestrator%.py$")
    if prefix then
        return "component_orchestrator", prefix
    end

    prefix = filepath:match(".*/orchestrators/constructs/(.*)_orchestrator%.py$")
    if prefix then
        return "construct_orchestrator", prefix
    end

    return nil, nil
end

local function build_path(target_type, prefix)
    if target_type == "component_model" then
        return PROJECT_ROOT .. "/sculptor_orchestrator/resources/components/" .. prefix .. ".py"
    elseif target_type == "construct_model" then
        return PROJECT_ROOT .. "/sculptor_orchestrator/resources/constructs/" .. prefix .. ".py"
    elseif target_type == "builder" then
        return PROJECT_ROOT .. "/sculptor_orchestrator/resources/builders/" .. prefix .. "_builder.py"
    elseif target_type == "component_orchestrator" then
        return PROJECT_ROOT .. "/sculptor_orchestrator/orchestrators/components/" .. prefix .. "_orchestrator.py"
    elseif target_type == "construct_orchestrator" then
        return PROJECT_ROOT .. "/sculptor_orchestrator/orchestrators/constructs/" .. prefix .. "_orchestrator.py"
    else
        return nil
    end
end

function SwitchComponentFile(target_type)
    local current = vim.api.nvim_buf_get_name(0)
    local current_type, prefix = get_component_info(current)

    if not current_type then
        print("Not a recognized component file.")
        return
    end

    if target_type == current_type then
        print("Already in " .. target_type .. " file.")
        return
    end

    local target = build_path(target_type, prefix)
    if vim.fn.filereadable(target) == 1 then
        vim.cmd("edit " .. target)
    else
        print("File not found: " .. target)
    end
end

-- Sculptor Validation
vim.api.nvim_create_user_command('SculptorValidate', function(opts)
    local root = opts.args ~= '' and opts.args or PROJECT_ROOT
    local tmp = vim.fn.tempname() .. ".qf"
    local include_pass = vim.v.cmdbang == 1 -- :SculptorValidate! includes PASS
    local cmd = {
        'sculptor-validate', '--root', root,
        '--qf-out', tmp,
    }
    if include_pass then table.insert(cmd, '--qf-include-pass') end

    vim.system(cmd, { text = true }, function(res)
        vim.schedule(function()
            if res.code ~= 0 then
                vim.notify('sculptor-validate failed: ' .. (res.stderr or res.stdout or ''), vim.log.levels.ERROR)
                return
            end
            if vim.fn.filereadable(tmp) ~= 1 then
                vim.notify('Quickfix file not found: ' .. tmp, vim.log.levels.ERROR)
                return
            end
            vim.cmd('cgetfile ' .. vim.fn.fnameescape(tmp))
            -- open list and jump to first error by default
            vim.cmd('copen')
        end)
    end)
end, { nargs = '?' })
