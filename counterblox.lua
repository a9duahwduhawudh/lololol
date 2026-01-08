-- config
local config = {
    -- esp
    esp_enabled = true,
    esp_key = "l",
    
    -- team check
    team_check = true, -- only show enemies (different team)
    
    -- colors
    skeleton_color = Color3.fromRGB(0, 255, 0), -- green
    crouch_color = Color3.fromRGB(255, 0, 0), -- red when crouching
    
    -- realistic skeleton
    skeleton_thickness = 3, -- line thickness
    skeleton_transparency = 1, -- 0 to 1
    
    -- crouch detection
    crouch_detection = true,
    crouch_height_threshold = 2, -- if humanoid height below this = crouching
    
    -- no spread
    no_spread_enabled = true, -- starts enabled
    no_spread_key = "k" -- press H to toggle no-spread
}

-- services
local plr = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local rep = game:GetService("ReplicatedStorage")

-- vars
local lp = plr.LocalPlayer
local cam = workspace.CurrentCamera
local esp = {}
local active = config.esp_enabled
local crouching = {} -- track who's crouching
local no_spread_active = config.no_spread_enabled
local original_spread = {} -- store original spread values

local r15_bones = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"}
}

local r6_bones = {
    {"Head", "Torso"},
    {"Torso", "Left Arm"},
    {"Torso", "Right Arm"},
    {"Torso", "Left Leg"},
    {"Torso", "Right Leg"}
}

local custom_bones = {
    {"Head", "Torso"},
    {"Torso", "Left Upper Arm"},
    {"Left Upper Arm", "Left Lower Arm"},
    {"Left Lower Arm", "Left Hand"},
    {"Torso", "Right Upper Arm"},
    {"Right Upper Arm", "Right Lower Arm"},
    {"Right Lower Arm", "Right Hand"},
    {"Torso", "Left Upper Leg"},
    {"Left Upper Leg", "Left Lower Leg"},
    {"Left Lower Leg", "Left Foot"},
    {"Torso", "Right Upper Leg"},
    {"Right Upper Leg", "Right Lower Leg"},
    {"Right Lower Leg", "Right Foot"}
}

local function key(k)
    return Enum.KeyCode[k:upper()] or Enum.KeyCode.E
end

local function w2s(pos)
    local vec, onscreen = cam:WorldToViewportPoint(pos)
    return Vector2.new(vec.X, vec.Y), onscreen
end

local function create_line()
    local line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = config.skeleton_thickness
    line.Color = config.skeleton_color
    line.Transparency = config.skeleton_transparency
    return line
end

local function cl(p)
    if esp[p] then
        if esp[p].lines then
            for _, bone_data in pairs(esp[p].lines) do
                if bone_data.line then
                    bone_data.line:Remove()
                end
            end
        end
        esp[p] = nil
    end
    crouching[p] = nil
end

local function rig(c)
    local h = c:FindFirstChildOfClass("Humanoid")
    if h and h.RigType == Enum.HumanoidRigType.R15 then return r15_bones end
    if c:FindFirstChild("Left Upper Arm") then return custom_bones end
    return r6_bones
end

local function make(p)
    if not p:IsA("Player") or not active then return end
    
    if config.team_check then
        if p.Team == lp.Team and p.Team ~= nil then
            cl(p)
            return
        end
    end
    
    cl(p)
    
    local c = p.Character
    if not c then return end
    
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h or h.Health <= 0 then return end
    
    if config.crouch_detection then
        local function checkCrouch()
            if h and h.Parent then
                crouching[p] = h.HipHeight < config.crouch_height_threshold
            end
        end
        checkCrouch()
        h:GetPropertyChangedSignal("HipHeight"):Connect(checkCrouch)
    end
    
    local bones = rig(c)
    local lines = {}
    
    for _, bone in pairs(bones) do
        local part1 = c:FindFirstChild(bone[1])
        local part2 = c:FindFirstChild(bone[2])
        
        if part1 and part2 then
            local line = create_line()
            table.insert(lines, {line = line, p1 = part1, p2 = part2})
        end
    end
    
    esp[p] = {lines = lines, character = c, humanoid = h}
end

local function update_skeleton_lines()
    for p, data in pairs(esp) do
        local c = data.character
        local h = data.humanoid
        
        if not c or not c.Parent or not h or h.Health <= 0 then
            cl(p)
            continue
        end
        
        local is_crouching = crouching[p]
        local color = is_crouching and config.crouch_color or config.skeleton_color
        
        for _, bone_data in pairs(data.lines) do
            local line = bone_data.line
            local p1 = bone_data.p1
            local p2 = bone_data.p2
            
            if p1 and p1.Parent and p2 and p2.Parent then
                local pos1, onscreen1 = w2s(p1.Position)
                local pos2, onscreen2 = w2s(p2.Position)
                
                if onscreen1 and onscreen2 then
                    line.From = pos1
                    line.To = pos2
                    line.Color = color
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        end
    end
end

local function upd()
    if not active then
        for _, p in pairs(plr:GetPlayers()) do cl(p) end
        return
    end
    for _, p in pairs(plr:GetPlayers()) do
        if p ~= lp then make(p) end
    end
end

local function tog()
    active = not active
    upd()
end

local function save_original_spread(w)
    local s = w:FindFirstChild("Spread")
    if s then
        original_spread[w] = {}
        for _, v in ipairs(s:GetDescendants()) do
            if v:IsA("NumberValue") then
                original_spread[w][v] = v.Value
            end
        end
    end
end

local function apply_no_spread(w)
    local s = w:FindFirstChild("Spread")
    if s then
        for _, v in ipairs(s:GetDescendants()) do
            if v:IsA("NumberValue") then
                v.Value = 0
            end
        end
    end
end

local function restore_spread(w)
    if original_spread[w] then
        for v, original_val in pairs(original_spread[w]) do
            if v and v.Parent then
                v.Value = original_val
            end
        end
    end
end

local function update_all_weapons()
    local wf = rep:FindFirstChild("Weapons")
    if wf then
        for _, w in ipairs(wf:GetChildren()) do
            if no_spread_active then
                apply_no_spread(w)
            else
                restore_spread(w)
            end
        end
    end
end

local function toggle_no_spread()
    no_spread_active = not no_spread_active
    update_all_weapons()
end

local function init()
    local wf = rep:FindFirstChild("Weapons")
    if wf then
        for _, w in ipairs(wf:GetChildren()) do
            save_original_spread(w)
            if no_spread_active then
                apply_no_spread(w)
            end
        end
        
        wf.ChildAdded:Connect(function(w)
            task.wait(0.1)
            save_original_spread(w)
            if no_spread_active then
                apply_no_spread(w)
            end
        end)
    end
end

uis.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == key(config.esp_key) then
        tog()
    elseif i.KeyCode == key(config.no_spread_key) then
        toggle_no_spread()
    end
end)

plr.PlayerAdded:Connect(function(p)
    if p ~= lp then
        p.CharacterAdded:Connect(function() task.wait(0.5) make(p) end)
        p:GetPropertyChangedSignal("Team"):Connect(function()
            task.wait(0.1)
            make(p)
        end)
    end
end)

plr.PlayerRemoving:Connect(function(p) cl(p) end)

for _, p in pairs(plr:GetPlayers()) do
    if p ~= lp then
        p.CharacterAdded:Connect(function() task.wait(0.5) make(p) end)
        p:GetPropertyChangedSignal("Team"):Connect(function()
            task.wait(0.1)
            make(p)
        end)
    end
end

rs.RenderStepped:Connect(function()
    if active then
        update_skeleton_lines()
    end
end)

upd()
init()
