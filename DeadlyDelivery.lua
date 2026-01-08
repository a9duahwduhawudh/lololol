-- ts file was generated at discord.gg/25ms


local vu1 = game:GetService("Players")
local vu2 = game:GetService("TweenService")
local vu3 = game:GetService("UserInputService")
local vu4 = game:GetService("VirtualInputManager")
game:GetService("RunService")
local v5 = game:GetService("CoreGui")
local vu6 = game:GetService("Lighting")
local vu7 = game:GetService("ReplicatedStorage")
local vu8 = vu1.LocalPlayer
local vu9 = vu8:GetMouse()
local vu10 = vu3.TouchEnabled and not vu3.MouseEnabled and ("Mobile" or "PC") or "PC"
local vu11 = vu1.LocalPlayer
local vu12 = vu11.Character or vu11.CharacterAdded:Wait()
local vu13 = vu12:WaitForChild("HumanoidRootPart")
local vu14 = workspace.CurrentCamera
local vu15 = {
    MAX_INVENTORY = 4,
    DANGER_DISTANCE = 20,
    CONTAINER_DISTANCE = 200,
    LOOT_DISTANCE = 300,
    ESCAPE_COOLDOWN = 1,
    DESCENT_TIME = 33,
    ELEVATOR_WAIT = 2,
    LOOT_WAIT = 1.5,
    INTERACT_DIST = 25
}
local vu16 = {
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(10, 10, 15),
    Element = Color3.fromRGB(25, 25, 30),
    Hover = Color3.fromRGB(35, 35, 40),
    TextTitle = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(140, 140, 150),
    AccentStart = Color3.fromRGB(0, 200, 255),
    AccentEnd = Color3.fromRGB(255, 0, 255)
}
local vu17 = false
local vu18 = 0
local vu19 = 0
local vu20 = false
local vu21 = {}
local vu22 = {}
local vu23 = {}
local vu24 = false
local vu25 = false
local vu26 = false
local vu27 = Instance.new("Folder")
vu27.Name = "Noctyra_ESP"
vu27.Parent = v5
local vu28 = false
local vu29 = 16
local vu30 = 16
local vu31 = Enum.KeyCode.LeftControl
local vu32 = nil
local vu33 = nil
local vu34 = nil
local vu35 = nil
local function v40()
    local v36 = vu7:FindFirstChild("Config")
    if v36 then
        local vu37 = v36:FindFirstChild("enemy_monster")
        if vu37 and vu37:IsA("ModuleScript") then
            local v38, v39 = pcall(function()
                return require(vu37)
            end)
            if v38 then
                vu35 = v39
                return true
            end
        end
    end
    return false
end
local function vu45(p41)
    local v42 = p41:GetAttributes()
    local v43
    if v42 and v42.id then
        v43 = v42.id
    else
        v43 = nil
    end
    if not (v43 and (vu34 and vu34[v43])) then
        return false
    end
    local v44 = vu34[v43].type
    return v44 == "Money" or v44 == "MoneyChristmas"
end;
(function()
    local v46 = vu7:FindFirstChild("Config")
    if v46 then
        local vu47 = v46:FindFirstChild("item_loot")
        if vu47 and vu47:IsA("ModuleScript") then
            local v48, v49 = pcall(function()
                return require(vu47)
            end)
            if v48 then
                vu34 = v49
                return true
            end
        end
    end
    return false
end)()
v40()
local function vu53(p50)
    local v51 = p50:GetAttributes()
    local v52
    if v51 and v51.id then
        v52 = v51.id
    else
        v52 = nil
    end
    if v52 and (vu34 and (vu34[v52] and vu34[v52].name)) then
        return vu34[v52].name
    elseif v52 then
        return "ID: " .. tostring(v52)
    else
        return p50.Name
    end
end
local function vu55(p54)
    return "entity_" .. p54.Name:sub(1, 8)
end
local function vu62(p56)
    local v57 = p56.Name
    local v58, v59, v60 = ipairs({
        "Santa MK",
        "Santa Mk",
        "SANTA MK"
    })
    while true do
        local v61
        v60, v61 = v58(v59, v60)
        if v60 == nil then
            break
        end
        if v57:find(v61) then
            return true
        end
    end
    return false
end
local vu87 = {
    Tween = function(_, p63, p64, p65, p66, p67)
        vu2:Create(p63, TweenInfo.new(p65 or 0.3, p66 or Enum.EasingStyle.Quart, p67 or Enum.EasingDirection.Out), p64):Play()
    end,
    CreateCorner = function(_, p68, p69)
        local v70 = Instance.new("UICorner")
        v70.CornerRadius = UDim.new(0, p69)
        v70.Parent = p68
        return v70
    end,
    CreateRipple = function(_, pu71)
        spawn(function()
            local v72 = Instance.new("ImageLabel")
            v72.Name = "Ripple"
            v72.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            v72.BackgroundTransparency = 1
            v72.BorderSizePixel = 0
            v72.Image = "rbxassetid://2708891598"
            v72.ImageColor3 = Color3.fromRGB(255, 255, 255)
            v72.ImageTransparency = 0.8
            v72.Parent = pu71
            local v73 = vu9.X - pu71.AbsolutePosition.X
            local v74 = vu9.Y - pu71.AbsolutePosition.Y
            v72.Position = UDim2.new(0, v73, 0, v74)
            v72.Size = UDim2.new(0, 0, 0, 0)
            local v75 = math.max(pu71.AbsoluteSize.X, pu71.AbsoluteSize.Y) * 2
            vu87:Tween(v72, {
                Size = UDim2.new(0, v75, 0, v75),
                Position = UDim2.new(0, v73 - v75 / 2, 0, v74 - v75 / 2),
                ImageTransparency = 1
            }, 0.5)
            task.wait(0.5)
            v72:Destroy()
        end)
    end,
    MakeDraggable = function(_, pu76, p77)
        local v78 = p77 or pu76
        local vu79 = nil
        local vu80 = nil
        local vu81 = nil
        local vu82 = nil
        v78.InputBegan:Connect(function(pu83)
            if pu83.UserInputType == Enum.UserInputType.MouseButton1 or pu83.UserInputType == Enum.UserInputType.Touch then
                vu79 = true
                vu81 = pu83.Position
                vu82 = pu76.Position
                pu83.Changed:Connect(function()
                    if pu83.UserInputState == Enum.UserInputState.End then
                        vu79 = false
                    end
                end)
            end
        end)
        v78.InputChanged:Connect(function(p84)
            if p84.UserInputType == Enum.UserInputType.MouseMovement or p84.UserInputType == Enum.UserInputType.Touch then
                vu80 = p84
            end
        end)
        vu3.InputChanged:Connect(function(p85)
            if p85 == vu80 and vu79 then
                local v86 = p85.Position - vu81
                vu87:Tween(pu76, {
                    Position = UDim2.new(vu82.X.Scale, vu82.X.Offset + v86.X, vu82.Y.Scale, vu82.Y.Offset + v86.Y)
                }, 0.05)
            end
        end)
    end
};
(function()
    local v88 = Instance.new("BlurEffect")
    v88.Size = 0
    v88.Parent = vu6
    vu87:Tween(v88, {
        Size = 24
    }, 0.5)
    local v89 = Instance.new("ScreenGui")
    v89.Name = "Noctyra_Loader"
    v89.ResetOnSpawn = false
    v89.Parent = vu8.PlayerGui
    local vu90 = Instance.new("Frame")
    vu90.Size = UDim2.new(0, 200, 0, 200)
    vu90.Position = UDim2.new(0.5, - 100, 0.5, - 100)
    vu90.BackgroundTransparency = 1
    vu90.Parent = v89
    local v91 = Instance.new("Frame")
    v91.Size = UDim2.new(1, 0, 1, 0)
    v91.BackgroundTransparency = 1
    v91.Parent = vu90
    vu87:CreateCorner(v91, 100)
    local v92 = Instance.new("UIStroke")
    v92.Thickness = 4
    v92.Parent = v91
    local vu93 = Instance.new("UIGradient")
    vu93.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, vu16.AccentStart),
        ColorSequenceKeypoint.new(1, vu16.AccentEnd)
    })
    vu93.Parent = v92
    local v94 = Instance.new("TextLabel")
    v94.Text = "N O C T Y R A"
    v94.Font = Enum.Font.GothamBlack
    v94.TextSize = 24
    v94.TextColor3 = vu16.TextTitle
    v94.Size = UDim2.new(1, 0, 1, 0)
    v94.Position = UDim2.new(0, 0, 0, 0)
    v94.BackgroundTransparency = 1
    v94.TextTransparency = 1
    v94.Parent = vu90
    vu87:Tween(v94, {
        TextTransparency = 0
    }, 1)
    local vu95 = true
    task.spawn(function()
        while vu95 and vu90.Parent do
            vu93.Rotation = vu93.Rotation + 5
            task.wait(0.01)
        end
    end)
    task.wait(2.5)
    vu95 = false
    vu87:Tween(v88, {
        Size = 0
    }, 0.5)
    vu87:Tween(vu90, {
        BackgroundTransparency = 1
    }, 0.5)
    vu87:Tween(v94, {
        TextTransparency = 1
    }, 0.5)
    vu87:Tween(v92, {
        Transparency = 1
    }, 0.5)
    task.wait(0.5)
    v89:Destroy()
    v88:Destroy()
end)()
local vu96 = Instance.new("ScreenGui")
vu96.Name = "Noctyra_Overlay"
vu96.ResetOnSpawn = false
vu96.IgnoreGuiInset = true
if vu8.PlayerGui:FindFirstChild("Noctyra_Overlay") then
    vu8.PlayerGui.Noctyra_Overlay:Destroy()
end
vu96.Parent = vu8.PlayerGui
local v97 = Instance.new("Frame")
v97.AnchorPoint = Vector2.new(0.5, 0)
v97.Size = UDim2.new(0, 220, 0, 30)
v97.Position = UDim2.new(0.5, 0, 0, 5)
v97.BackgroundColor3 = vu16.Background
v97.Parent = vu96
local v98 = vu87
vu87.CreateCorner(v98, v97, 6)
local v99 = Instance.new("UIStroke")
v99.Color = vu16.AccentStart
v99.Thickness = 1
v99.Parent = v97
local vu100 = Instance.new("TextLabel")
vu100.Size = UDim2.new(1, 0, 1, 0)
vu100.BackgroundTransparency = 1
vu100.TextColor3 = vu16.TextTitle
vu100.Font = Enum.Font.Code
vu100.TextSize = 12
vu100.Parent = v97
task.spawn(function()
    while vu96.Parent do
        local v101 = math.floor(workspace:GetRealPhysicsFPS())
        local vu102 = 0
        pcall(function()
            vu102 = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString():match("%d+"))
        end)
        vu100.Text = string.format("Noctyra | FPS: %d | Ping: %dms", v101, vu102)
        task.wait(1)
    end
end)
local vu103 = Instance.new("Frame")
vu103.AnchorPoint = Vector2.new(1, 0)
vu103.Size = UDim2.new(0, 300, 1, 0)
vu103.Position = UDim2.new(1, - 20, 0, 50)
vu103.BackgroundTransparency = 1
vu103.Parent = vu96
local v104 = Instance.new("UIListLayout")
v104.Padding = UDim.new(0, 10)
v104.VerticalAlignment = Enum.VerticalAlignment.Top
v104.HorizontalAlignment = Enum.HorizontalAlignment.Right
v104.Parent = vu103
function vu87.Notify(_, p105, p106, p107, _)
    local vu108 = Instance.new("Frame")
    vu108.Size = UDim2.new(0, 280, 0, 60)
    vu108.BackgroundColor3 = vu16.Element
    vu108.BackgroundTransparency = 0.1
    vu108.Parent = vu103
    vu87:CreateCorner(vu108, 8)
    local v109 = Instance.new("UIStroke")
    v109.Color = vu16.AccentStart
    v109.Transparency = 0.5
    v109.Parent = vu108
    local v110 = Instance.new("TextLabel")
    v110.Text = p105
    v110.Font = Enum.Font.GothamBold
    v110.TextSize = 14
    v110.TextColor3 = vu16.AccentStart
    v110.Position = UDim2.new(0, 15, 0, 8)
    v110.Size = UDim2.new(1, - 20, 0, 20)
    v110.BackgroundTransparency = 1
    v110.TextXAlignment = Enum.TextXAlignment.Left
    v110.Parent = vu108
    local v111 = Instance.new("TextLabel")
    v111.Text = p106
    v111.Font = Enum.Font.Gotham
    v111.TextSize = 12
    v111.TextColor3 = vu16.TextDim
    v111.Position = UDim2.new(0, 15, 0, 28)
    v111.Size = UDim2.new(1, - 20, 0, 25)
    v111.BackgroundTransparency = 1
    v111.TextXAlignment = Enum.TextXAlignment.Left
    v111.TextWrapped = true
    v111.Parent = vu108
    vu108.Position = UDim2.new(1, 100, 0, 0)
    vu87:Tween(vu108, {
        Position = UDim2.new(0, 0, 0, 0)
    }, 0.5, Enum.EasingStyle.Back)
    task.delay(p107 or 3, function()
        vu87:Tween(vu108, {
            Position = UDim2.new(1, 50, 0, 0),
            BackgroundTransparency = 1
        }, 0.5)
        task.wait(0.5)
        vu108:Destroy()
    end)
end
local function vu113(pu112)
    pcall(function()
        vu4:SendKeyEvent(true, Enum.KeyCode[pu112], false, game)
        task.wait(0.05)
        vu4:SendKeyEvent(false, Enum.KeyCode[pu112], false, game)
    end)
end
local function vu115()
    pcall(function()
        local v114 = vu3:GetMouseLocation()
        vu4:SendMouseButtonEvent(v114.X, v114.Y, 0, true, game, 0)
        task.wait(0.05)
        vu4:SendMouseButtonEvent(v114.X, v114.Y, 0, false, game, 0)
    end)
end
local function vu117(p116)
    if vu13 then
        vu13.CFrame = p116
    end
end
local function vu119(p118)
    vu14.CFrame = CFrame.new(vu14.CFrame.Position, p118)
end
local function vu120()
    vu14.CFrame = CFrame.new(vu14.CFrame.Position, vu13.Position + Vector3.new(0, - 5, 0))
end
local function vu130()
    local v121 = workspace:FindFirstChild("GameSystem")
    if not v121 then
        return false
    end
    local v122 = v121:FindFirstChild("Monsters")
    if not v122 then
        return false
    end
    local v123, v124, v125 = pairs(v122:GetChildren())
    while true do
        local v126
        v125, v126 = v123(v124, v125)
        if v125 == nil then
            break
        end
        if v126:IsA("Model") then
            local v127 = v126:FindFirstChildOfClass("Humanoid")
            if v127 and (v127.Health > 0 and not vu62(v126)) then
                local v128 = v126.PrimaryPart or (v126:FindFirstChild("HumanoidRootPart") or v126:FindFirstChildWhichIsA("BasePart"))
                if v128 then
                    local v129 = (vu13.Position - v128.Position).Magnitude
                    if v129 <= vu15.DANGER_DISTANCE then
                        return true, v126, v129
                    end
                end
            end
        end
    end
    return false, nil, nil
end
local function vu144()
    local function v139()
        local v131 = workspace:FindFirstChild("GameSystem")
        if v131 then
            local v132 = v131:FindFirstChild("Loots")
            if v132 then
                local v133 = v132:FindFirstChild("World")
                if v133 then
                    local v134, v135, v136 = pairs(v133:GetChildren())
                    while true do
                        local v137
                        v136, v137 = v134(v135, v136)
                        if v136 == nil then
                            break
                        end
                        local v138 = nil
                        if v137:IsA("BasePart") then
                            v138 = v137
                        elseif v137:IsA("Model") then
                            v138 = v137.PrimaryPart or v137:FindFirstChildWhichIsA("BasePart")
                        end
                        if v138 and (vu13.Position - v138.Position).Magnitude <= 20 then
                            vu23[v137.Name] = true
                        end
                    end
                end
            else
                return
            end
        else
            return
        end
    end
    local v140, v141, v142 = ipairs({
        "One",
        "Two",
        "Three",
        "Four"
    })
    while true do
        local v143
        v142, v143 = v140(v141, v142)
        if v142 == nil then
            break
        end
        vu113(v143)
        task.wait(0.2)
        vu115()
        task.wait(0.3)
        vu113("G")
        task.wait(0.2)
        v139()
    end
end
local function vu154(p145)
    local v146 = workspace:FindFirstChild("GameSystem")
    if not v146 then
        return false
    end
    local v147 = v146:FindFirstChild("Loots")
    if not v147 then
        return false
    end
    local v148 = v147:FindFirstChild("ElevatorCollect")
    if not v148 then
        vu18 = 0
        return false
    end
    local v149 = nil
    if v148:IsA("Model") then
        v148 = v148.PrimaryPart or v148:FindFirstChildWhichIsA("BasePart")
    elseif v148:IsA("Folder") then
        v148 = v148:FindFirstChildWhichIsA("BasePart", true)
    elseif not v148:IsA("BasePart") then
        v148 = v149
    end
    if not v148 then
        vu18 = 0
        return false
    end
    vu117(CFrame.new(v148.Position) * CFrame.new(0, 5, 0))
    task.wait(2)
    local v150 = vu18
    vu18 = 0
    vu87:Notify("Farm", "Items Sold", 2, "Success")
    task.wait(0.5)
    if v150 > 0 then
        vu87:Notify("Farm", "Clearing unwanted items...", 2, "Warning")
        vu144()
        task.wait(0.5)
    end
    if p145 then
        local v151 = workspace:FindFirstChild("\239\191\189\239\191\189\230\162\175")
        local v152 = v151 and v151:FindFirstChild("ContinuePart", true)
        if v152 then
            local v153 = v152:FindFirstChild("Interactable")
            if v153 and v153:IsA("BasePart") then
                vu117(CFrame.new(v153.Position) * CFrame.new(0, 3, 5))
                task.wait(0.5)
                for _ = 1, 3 do
                    vu119(v153.Position)
                    task.wait(0.2)
                    vu113("E")
                    task.wait(0.3)
                end
                vu20 = true
                vu87:Notify("Elevator", "Going Deep...", 2, "Info")
                task.wait(vu15.DESCENT_TIME)
                vu20 = false
            end
        end
    end
    return true
end
local function vu166()
    local v155 = {}
    local v156 = workspace:FindFirstChild("GameSystem")
    if not v156 then
        return v155
    end
    local v157 = v156:FindFirstChild("InteractiveItem")
    if not v157 then
        return v155
    end
    local v158, v159, v160 = pairs(v157:GetChildren())
    while true do
        local v161
        v160, v161 = v158(v159, v160)
        if v160 == nil then
            break
        end
        if v161:IsA("Model") and not vu21[v161] then
            local v162 = v161.PrimaryPart or v161:FindFirstChildWhichIsA("BasePart")
            if v162 then
                local v163 = (vu13.Position - v162.Position).Magnitude
                if v163 <= vu15.CONTAINER_DISTANCE then
                    table.insert(v155, {
                        Model = v161,
                        Name = v161.Name,
                        Position = v162.Position,
                        Distance = v163
                    })
                end
            end
        end
    end
    table.sort(v155, function(p164, p165)
        return p164.Distance < p165.Distance
    end)
    return v155
end
local function vu168(p167)
    vu117(CFrame.new(p167.Position) * CFrame.new(0, 3, 0))
    task.wait(0.15)
    vu113("E")
    task.wait(0.1)
    vu21[p167.Model] = true
    return true
end
local function vu181()
    local v169 = {}
    local v170 = workspace:FindFirstChild("GameSystem")
    if not v170 then
        return v169
    end
    local v171 = v170:FindFirstChild("Loots")
    if not v171 then
        return v169
    end
    local v172 = v171:FindFirstChild("World")
    if not v172 then
        return v169
    end
    local v173, v174, v175 = pairs(v172:GetChildren())
    while true do
        local v176
        v175, v176 = v173(v174, v175)
        if v175 == nil then
            break
        end
        if not vu22[v176] then
            local v177 = nil
            if v176:IsA("BasePart") then
                v177 = v176
            elseif v176:IsA("Model") then
                v177 = v176.PrimaryPart or v176:FindFirstChildWhichIsA("BasePart")
            end
            if v177 then
                local v178 = (vu13.Position - v177.Position).Magnitude
                if v178 <= vu15.LOOT_DISTANCE then
                    table.insert(v169, {
                        Object = v176,
                        Name = v176.Name,
                        Position = v177.Position,
                        Distance = v178
                    })
                end
            end
        end
    end
    table.sort(v169, function(p179, p180)
        return p179.Distance < p180.Distance
    end)
    return v169
end
local function vu183(p182)
    if vu23[p182.Name] then
        vu22[p182.Object] = true
        return false
    end
    vu120()
    vu117(CFrame.new(p182.Position) * CFrame.new(0, 2, 0))
    task.wait(0.2)
    vu113("E")
    task.wait(0.1)
    vu113("E")
    task.wait(0.2)
    vu22[p182.Object] = true
    if not vu45(p182.Object) then
        vu18 = vu18 + 1
    end
    return true
end
spawn(function()
    while true do
        local vu184 = false
        local function v185()
            vu184 = true
        end
        task.wait(0.5)
        if vu17 and not vu20 then
            local v186, _, _ = vu130()
            if v186 then
                local v187 = tick()
                if v187 - vu19 > vu15.ESCAPE_COOLDOWN then
                    vu87:Notify("Warning", "Monster Detected!", 2, "Error")
                    vu154(false)
                    vu19 = v187
                    task.wait(1)
                end
            end
            if vu17 then
                if vu18 >= vu15.MAX_INVENTORY then
                    vu154(false)
                end
                if vu17 then
                    local v188 = vu166()
                    if # v188 > 0 then
                        for v189 = 1, math.min(3, # v188) do
                            if not vu17 then
                                v185()
                            end
                            vu168(v188[v189])
                        end
                        task.wait(0.5)
                    end
                    if vu17 then
                        local v190 = vu181()
                        if # v190 <= 0 then
                            if vu18 > 0 then
                                vu154(true)
                            end
                        else
                            local v191, v192, v193 = ipairs(v190)
                            while true do
                                local v194
                                v193, v194 = v191(v192, v193)
                                if v193 == nil then
                                    break
                                end
                                if not vu17 then
                                    v185()
                                end
                                if v193 <= 10 then
                                    vu183(v194)
                                    if vu18 >= vu15.MAX_INVENTORY then
                                        vu154(false)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if vu184 then
            return
        end
    end
end)
spawn(function()
    while true do
        repeat
            task.wait(0.1)
            local v195 = vu28 and vu12 and vu12:FindFirstChildOfClass("Humanoid")
        until v195
        v195.WalkSpeed = vu29
    end
end)
local function vu206(p196, p197, p198, p199)
    local v200 = "ESP_" .. tostring(p196)
    if not vu27:FindFirstChild(v200) then
        local v201 = Instance.new("BillboardGui")
        v201.Name = v200
        v201.AlwaysOnTop = true
        v201.Size = UDim2.new(0, 100, 0, 50)
        v201.StudsOffset = Vector3.new(0, 2, 0)
        v201.Parent = vu27
        local v202 = Instance.new("TextLabel")
        v202.Name = "NameLabel"
        v202.Size = UDim2.new(1, 0, 0, 20)
        v202.BackgroundTransparency = 1
        v202.Text = p199 and p197 and p197 or ""
        v202.TextColor3 = p198
        v202.TextStrokeTransparency = 0.5
        v202.Font = Enum.Font.GothamBold
        v202.TextSize = 14
        v202.Visible = p199
        v202.Parent = v201
        local v203 = Instance.new("TextLabel")
        v203.Name = "DistLabel"
        v203.Size = UDim2.new(1, 0, 0, 15)
        v203.Position = p199 and UDim2.new(0, 0, 0, 20) or UDim2.new(0, 0, 0, 0)
        v203.BackgroundTransparency = 1
        v203.Text = "0m"
        v203.TextColor3 = Color3.fromRGB(255, 255, 255)
        v203.TextStrokeTransparency = 0.5
        v203.Font = Enum.Font.Gotham
        v203.TextSize = 12
        v203.Parent = v201
        local v204 = Instance.new("Frame")
        v204.Size = UDim2.new(1, 0, 1, 0)
        v204.BackgroundTransparency = 1
        v204.Parent = v201
        local v205 = Instance.new("UIStroke")
        v205.Color = p198
        v205.Thickness = 2
        v205.Transparency = 0.3
        v205.Parent = v204
        vu87:CreateCorner(v204, 6)
        return v201, v203
    end
end
spawn(function()
    task.wait(0.5)
    vu12 = vu11.Character
    if vu12 then
        vu13 = vu12:FindFirstChild("HumanoidRootPart")
    end
    if vu13 then
        local v207 = vu27
        local v208, v209, v210 = pairs(v207:GetChildren())
        while true do
            local v211
            v210, v211 = v208(v209, v210)
            if v210 == nil then
                break
            end
            if v211:IsA("BillboardGui") and v211.Adornee then
                local v212 = v211:FindFirstChild("DistLabel")
                if v212 and v212:IsA("TextLabel") then
                    local vu213 = v211.Adornee
                    if vu213 then
                        local v214, v215 = pcall(function()
                            return (vu13.Position - vu213.Position).Magnitude
                        end)
                        if v214 and v215 then
                            v212.Text = math.floor(v215) .. "m"
                        end
                    end
                end
            end
        end
    end
    local v216 = vu27
    local v217, v218, v219 = pairs(v216:GetChildren())
    local v220 = v226.Name:gsub("ESP_", "")
    local v221, v222, v223 = pairs(workspace:GetDescendants())
    local v224 = false
    while true do
        local v225
        v223, v225 = v221(v222, v223)
        if v223 == nil then
            break
        end
        if tostring(v225) == v220 then
            v224 = true
        end
    end
    if not v224 then
        v226:Destroy()
    end
    local v226
    v219, v226 = v217(v218, v219)
    if v219 ~= nil then
    else
    end
    if vu24 then
        local v227 = workspace:FindFirstChild("GameSystem")
        if v227 and v227:FindFirstChild("Monsters") then
            local v228, v229, v230 = pairs(v227.Monsters:GetChildren())
            while true do
                local v231, v232 = v228(v229, v230)
                if v231 == nil then
                    break
                end
                v230 = v231
                if v232:IsA("Model") then
                    local v233 = v232:FindFirstChildOfClass("Humanoid")
                    if v233 and v233.Health > 0 then
                        local v234 = v232.PrimaryPart or v232:FindFirstChild("HumanoidRootPart")
                        if v234 then
                            local v235, _ = vu206(v232, vu55(v232), vu62(v232) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), true)
                            if v235 then
                                v235.Adornee = v234
                            end
                        end
                    end
                end
            end
        end
    else
        local v236 = vu27
        local v237, v238, v239 = pairs(v236:GetChildren())
        while true do
            local v240
            v239, v240 = v237(v238, v239)
            if v239 == nil then
                break
            end
            if v240.Name:find("ESP_") and (v240.Adornee and v240.Adornee.Parent.Parent.Name == "Monsters") then
                v240:Destroy()
            end
        end
    end
    if vu25 then
        local v241 = workspace:FindFirstChild("GameSystem")
        if v241 and v241:FindFirstChild("Loots") and v241.Loots:FindFirstChild("World") then
            local v242, v243, v244 = pairs(v241.Loots.World:GetChildren())
            while true do
                local v245, v246 = v242(v243, v244)
                if v245 == nil then
                    break
                end
                v244 = v245
                local v247 = nil
                if v246:IsA("BasePart") then
                    v247 = v246
                elseif v246:IsA("Model") then
                    v247 = v246.PrimaryPart
                end
                if v247 then
                    local v248, _ = vu206(v246, vu53(v246), Color3.fromRGB(0, 255, 0), true)
                    if v248 then
                        v248.Adornee = v247
                    end
                end
            end
        end
    else
        local v249 = vu27
        local v250, v251, v252 = pairs(v249:GetChildren())
        while true do
            local vu253
            v252, vu253 = v250(v251, v252)
            if v252 == nil then
                break
            end
            if vu253.Name:find("ESP_") and vu253.Adornee then
                local vu254 = false
                pcall(function()
                    if vu253.Adornee.Parent and vu253.Adornee.Parent.Parent then
                        vu254 = vu253.Adornee.Parent.Parent.Name == "Monsters"
                    end
                end)
                if not vu254 then
                    vu253:Destroy()
                end
            end
        end
    end
    if vu26 then
        local v255 = workspace:FindFirstChild("GameSystem")
        if v255 and v255:FindFirstChild("InteractiveItem") then
            local v256, v257, v258 = pairs(v255.InteractiveItem:GetChildren())
            while true do
                local v259, v260 = v256(v257, v258)
                if v259 == nil then
                    break
                end
                v258 = v259
                if v260:IsA("Model") then
                    local v261 = v260.PrimaryPart or v260:FindFirstChildWhichIsA("BasePart")
                    if v261 then
                        local v262, _ = vu206(v260, v260.Name:match("^(.-)_?%d*$") or v260.Name, Color3.fromRGB(255, 255, 0), true)
                        if v262 then
                            v262.Adornee = v261
                        end
                    end
                end
            end
        end
    else
        local v263 = vu27
        local v264, v265, v266 = pairs(v263:GetChildren())
        while true do
            local vu267
            v266, vu267 = v264(v265, v266)
            if v266 == nil then
                break
            end
            if vu267.Name:find("ESP_") and vu267.Adornee then
                local vu268 = false
                pcall(function()
                    if vu267.Adornee.Parent and vu267.Adornee.Parent.Parent then
                        vu268 = vu267.Adornee.Parent.Parent.Name == "InteractiveItem"
                    end
                end)
                if vu268 then
                    vu267:Destroy()
                end
            end
        end
    end
	
end)
function vu87.Window(_)
    local v269 = {}
    local v270 = vu10 == "Mobile" and 600 or 700
    local v271 = vu10 == "Mobile" and 320 or 450
    if vu10 == "Mobile" and workspace.CurrentCamera.ViewportSize.X < 600 then
        v270 = workspace.CurrentCamera.ViewportSize.X - 20
    end
    local vu272 = Instance.new("Frame")
    vu272.Name = "NoctyraFrame"
    vu272.Size = UDim2.new(0, v270, 0, v271)
    vu272.Position = UDim2.new(0.5, - v270 / 2, 0.5, - v271 / 2)
    vu272.BackgroundColor3 = vu16.Background
    vu272.BorderSizePixel = 0
    vu272.ClipsDescendants = false
    vu272.Parent = vu96
    vu87:CreateCorner(vu272, 12)
    local v273 = Instance.new("UIStroke")
    v273.Thickness = 2
    v273.Parent = vu272
    local vu274 = Instance.new("UIGradient")
    vu274.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, vu16.AccentStart),
        ColorSequenceKeypoint.new(0.5, vu16.AccentEnd),
        ColorSequenceKeypoint.new(1, vu16.AccentStart)
    })
    vu274.Parent = v273
    spawn(function()
        while vu272.Parent do
            vu274.Rotation = vu274.Rotation + 1
            if vu274.Rotation >= 360 then
                vu274.Rotation = 0
            end
            task.wait(0.02)
        end
    end)
    vu87:MakeDraggable(vu272)
    local v275 = 180
    local v276 = Instance.new("Frame")
    v276.Size = UDim2.new(0, v275, 1, 0)
    v276.BackgroundColor3 = vu16.Sidebar
    v276.Parent = vu272
    vu87:CreateCorner(v276, 12)
    local v277 = Instance.new("Frame")
    v277.Size = UDim2.new(1, 0, 0, 90)
    v277.BackgroundTransparency = 1
    v277.Parent = v276
    local vu278 = Instance.new("ImageLabel")
    vu278.Size = UDim2.new(0, 35, 0, 35)
    vu278.Position = UDim2.new(0, 10, 0, 25)
    vu278.BackgroundColor3 = vu16.Element
    vu278.Parent = v277
    vu87:CreateCorner(vu278, 20)
    spawn(function()
        vu278.Image = vu1:GetUserThumbnailAsync(vu8.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    local v279 = Instance.new("TextLabel")
    v279.Text = vu8.DisplayName
    v279.Font = Enum.Font.GothamBold
    v279.TextSize = 13
    v279.TextColor3 = vu16.TextTitle
    v279.Position = UDim2.new(0, 55, 0, 15)
    v279.Size = UDim2.new(1, - 60, 0, 15)
    v279.BackgroundTransparency = 1
    v279.TextXAlignment = Enum.TextXAlignment.Left
    v279.TextTruncate = Enum.TextTruncate.AtEnd
    v279.Parent = v277
    local v280 = Instance.new("TextLabel")
    v280.Text = "Noctyra"
    v280.Font = Enum.Font.GothamBlack
    v280.TextSize = 14
    v280.TextColor3 = vu16.AccentStart
    v280.Position = UDim2.new(0, 55, 0, 32)
    v280.Size = UDim2.new(1, - 60, 0, 15)
    v280.BackgroundTransparency = 1
    v280.TextXAlignment = Enum.TextXAlignment.Left
    v280.Parent = v277
    local vu281 = Instance.new("ScrollingFrame")
    vu281.Size = UDim2.new(1, 0, 1, - 140)
    vu281.Position = UDim2.new(0, 0, 0, 100)
    vu281.BackgroundTransparency = 1
    vu281.ScrollBarThickness = 2
    vu281.Parent = v276
    local v282 = Instance.new("UIListLayout")
    v282.Padding = UDim.new(0, 5)
    v282.HorizontalAlignment = Enum.HorizontalAlignment.Center
    v282.Parent = vu281
    local v283 = Instance.new("Frame")
    v283.Size = UDim2.new(1, - v275, 1, 0)
    v283.Position = UDim2.new(0, v275, 0, 0)
    v283.BackgroundTransparency = 1
    v283.Parent = vu272
    local v284 = Instance.new("Frame")
    v284.Size = UDim2.new(1, - 20, 0, 40)
    v284.Position = UDim2.new(0, 10, 0, 15)
    v284.BackgroundColor3 = vu16.Element
    v284.Parent = v283
    vu87:CreateCorner(v284, 8)
    local v285 = Instance.new("ImageLabel")
    v285.Image = "rbxassetid://3926305904"
    v285.Size = UDim2.new(0, 20, 0, 20)
    v285.Position = UDim2.new(0, 10, 0.5, - 10)
    v285.ImageColor3 = vu16.TextDim
    v285.BackgroundTransparency = 1
    v285.Parent = v284
    local vu286 = Instance.new("TextBox")
    vu286.Size = UDim2.new(1, - 40, 1, 0)
    vu286.Position = UDim2.new(0, 40, 0, 0)
    vu286.BackgroundTransparency = 1
    vu286.Text = ""
    vu286.PlaceholderText = "Search features..."
    vu286.PlaceholderColor3 = vu16.TextDim
    vu286.TextColor3 = vu16.TextTitle
    vu286.Font = Enum.Font.Gotham
    vu286.TextSize = 14
    vu286.TextXAlignment = Enum.TextXAlignment.Left
    vu286.Parent = v284
    local vu287 = Instance.new("Frame")
    vu287.Size = UDim2.new(1, 0, 1, - 70)
    vu287.Position = UDim2.new(0, 0, 0, 70)
    vu287.BackgroundTransparency = 1
    vu287.ClipsDescendants = true
    vu287.Parent = v283
    local vu288 = {}
    local vu289 = Instance.new("ScrollingFrame")
    vu289.Name = "SearchResults"
    vu289.Size = UDim2.new(1, - 20, 1, 0)
    vu289.Position = UDim2.new(0, 10, 0, 0)
    vu289.BackgroundTransparency = 1
    vu289.Visible = false
    vu289.ScrollBarThickness = 2
    vu289.Parent = vu287
    local v290 = Instance.new("UIListLayout")
    v290.Padding = UDim.new(0, 8)
    v290.SortOrder = Enum.SortOrder.LayoutOrder
    v290.Parent = vu289
    local vu291 = {}
    local vu292 = nil
    local v293 = vu286
    vu286.GetPropertyChangedSignal(v293, "Text"):Connect(function()
        local v294 = vu286.Text:lower()
        if v294 == "" then
            vu289.Visible = false
            local v295, v296, v297 = ipairs(vu288)
            while true do
                local v298
                v297, v298 = v295(v296, v297)
                if v297 == nil then
                    break
                end
                v298.Frame.Parent = v298.OriginalParent
                v298.Frame.Visible = true
            end
            local v299, v300, v301 = pairs(vu291)
            while true do
                local v302
                v301, v302 = v299(v300, v301)
                if v301 == nil then
                    break
                end
                v302.Page.Visible = v302 == vu292
            end
        else
            vu289.Visible = true
            local v303, v304, v305 = pairs(vu291)
            while true do
                local v306
                v305, v306 = v303(v304, v305)
                if v305 == nil then
                    break
                end
                v306.Page.Visible = false
            end
            local v307, v308, v309 = ipairs(vu288)
            while true do
                local v310
                v309, v310 = v307(v308, v309)
                if v309 == nil then
                    break
                end
                if v310.Text:find(v294) then
                    v310.Frame.Parent = vu289
                    v310.Frame.Visible = true
                else
                    v310.Frame.Parent = v310.OriginalParent
                end
            end
        end
    end)
    local vu311 = true
    function v269.Tab(_, p312)
        local v313 = {}
        local vu314 = Instance.new("TextButton")
        vu314.Size = UDim2.new(0.9, 0, 0, 40)
        vu314.BackgroundColor3 = vu16.Background
        vu314.BackgroundTransparency = 1
        vu314.Text = "  " .. p312
        vu314.TextColor3 = vu16.TextDim
        vu314.Font = Enum.Font.GothamMedium
        vu314.TextSize = 14
        vu314.TextXAlignment = Enum.TextXAlignment.Left
        vu314.AutoButtonColor = false
        vu314.Parent = vu281
        vu87:CreateCorner(vu314, 8)
        local vu315 = Instance.new("Frame")
        vu315.Size = UDim2.new(0, 3, 0.6, 0)
        vu315.Position = UDim2.new(0, 0, 0.2, 0)
        vu315.BackgroundColor3 = vu16.AccentStart
        vu315.BackgroundTransparency = 1
        vu315.Parent = vu314
        vu87:CreateCorner(vu315, 2)
        local vu316 = Instance.new("ScrollingFrame")
        vu316.Size = UDim2.new(1, - 20, 1, 0)
        vu316.Position = UDim2.new(0, 10, 0, 0)
        vu316.BackgroundTransparency = 1
        vu316.Visible = false
        vu316.ScrollBarThickness = 2
        vu316.Parent = vu287
        local v317 = Instance.new("UIListLayout")
        v317.Padding = UDim.new(0, 8)
        v317.SortOrder = Enum.SortOrder.LayoutOrder
        v317.Parent = vu316
        local vu318 = {
            Btn = vu314,
            Ind = vu315,
            Page = vu316
        }
        vu314.MouseButton1Click:Connect(function()
            if vu286.Text == "" then
                local v319, v320, v321 = pairs(vu291)
                while true do
                    local v322
                    v321, v322 = v319(v320, v321)
                    if v321 == nil then
                        break
                    end
                    vu87:Tween(v322.Btn, {
                        BackgroundTransparency = 1,
                        TextColor3 = vu16.TextDim
                    })
                    vu87:Tween(v322.Ind, {
                        BackgroundTransparency = 1
                    })
                    v322.Page.Visible = false
                end
                vu87:Tween(vu314, {
                    BackgroundTransparency = 0,
                    BackgroundColor3 = vu16.Element,
                    TextColor3 = vu16.TextTitle
                })
                vu87:Tween(vu315, {
                    BackgroundTransparency = 0
                })
                vu316.Visible = true
                vu292 = vu318
                vu87:CreateRipple(vu314)
            end
        end)
        if vu311 then
            vu311 = false
            vu314.BackgroundTransparency = 0
            vu314.BackgroundColor3 = vu16.Element
            vu314.TextColor3 = vu16.TextTitle
            vu315.BackgroundTransparency = 0
            vu316.Visible = true
            vu292 = vu318
        end
        table.insert(vu291, vu318)
        function v313.Label(_, p323)
            local v324 = Instance.new("TextLabel")
            v324.Size = UDim2.new(1, 0, 0, 30)
            v324.BackgroundTransparency = 1
            v324.Text = p323
            v324.TextColor3 = vu16.TextDim
            v324.Font = Enum.Font.GothamBold
            v324.TextSize = 13
            v324.TextXAlignment = Enum.TextXAlignment.Left
            v324.Parent = vu316
            return v324
        end
        function v313.Button(_, p325, pu326)
            local v327 = Instance.new("Frame")
            v327.Size = UDim2.new(1, 0, 0, 45)
            v327.BackgroundTransparency = 1
            v327.Parent = vu316
            table.insert(vu288, {
                Frame = v327,
                Text = p325:lower(),
                OriginalParent = vu316
            })
            local vu328 = Instance.new("TextButton")
            vu328.Size = UDim2.new(1, 0, 1, 0)
            vu328.BackgroundColor3 = vu16.Element
            vu328.Text = p325
            vu328.TextColor3 = vu16.TextTitle
            vu328.Font = Enum.Font.GothamMedium
            vu328.TextSize = 14
            vu328.AutoButtonColor = false
            vu328.Parent = v327
            vu87:CreateCorner(vu328, 8)
            vu328.MouseButton1Click:Connect(function()
                vu87:CreateRipple(vu328)
                pu326()
            end)
            vu328.MouseEnter:Connect(function()
                vu87:Tween(vu328, {
                    BackgroundColor3 = vu16.Hover
                })
            end)
            vu328.MouseLeave:Connect(function()
                vu87:Tween(vu328, {
                    BackgroundColor3 = vu16.Element
                })
            end)
        end
        function v313.Toggle(_, p329, p330, pu331)
            local v332 = Instance.new("Frame")
            v332.Size = UDim2.new(1, 0, 0, 45)
            v332.BackgroundColor3 = vu16.Element
            v332.Parent = vu316
            table.insert(vu288, {
                Frame = v332,
                Text = p329:lower(),
                OriginalParent = vu316
            })
            vu87:CreateCorner(v332, 8)
            local v333 = Instance.new("TextLabel")
            v333.Text = p329
            v333.TextColor3 = vu16.TextTitle
            v333.Font = Enum.Font.GothamMedium
            v333.TextSize = 14
            v333.Position = UDim2.new(0, 15, 0, 0)
            v333.Size = UDim2.new(0.6, 0, 1, 0)
            v333.BackgroundTransparency = 1
            v333.TextXAlignment = Enum.TextXAlignment.Left
            v333.Parent = v332
            local vu334 = Instance.new("TextButton")
            vu334.Size = UDim2.new(0, 44, 0, 22)
            vu334.Position = UDim2.new(1, - 55, 0.5, - 11)
            vu334.BackgroundColor3 = vu16.Sidebar
            vu334.Text = ""
            vu334.AutoButtonColor = false
            vu334.Parent = v332
            vu87:CreateCorner(vu334, 11)
            local vu335 = Instance.new("Frame")
            vu335.Size = UDim2.new(0, 18, 0, 18)
            vu335.Position = UDim2.new(0, 2, 0.5, - 9)
            vu335.BackgroundColor3 = vu16.TextDim
            vu335.Parent = vu334
            vu87:CreateCorner(vu335, 9)
            local vu336 = p330 or false
            local function vu337()
                if vu336 then
                    vu87:Tween(vu334, {
                        BackgroundColor3 = vu16.AccentStart
                    })
                    vu87:Tween(vu335, {
                        Position = UDim2.new(1, - 20, 0.5, - 9),
                        BackgroundColor3 = vu16.TextTitle
                    })
                else
                    vu87:Tween(vu334, {
                        BackgroundColor3 = vu16.Sidebar
                    })
                    vu87:Tween(vu335, {
                        Position = UDim2.new(0, 2, 0.5, - 9),
                        BackgroundColor3 = vu16.TextDim
                    })
                end
                pu331(vu336)
            end
            vu334.MouseButton1Click:Connect(function()
                vu336 = not vu336
                vu337()
            end)
            if p330 then
                vu337()
            end
        end
        function v313.Slider(_, p338, pu339, pu340, p341, pu342)
            local v343 = Instance.new("Frame")
            v343.Size = UDim2.new(1, 0, 0, 60)
            v343.BackgroundColor3 = vu16.Element
            v343.Parent = vu316
            table.insert(vu288, {
                Frame = v343,
                Text = p338:lower(),
                OriginalParent = vu316
            })
            vu87:CreateCorner(v343, 8)
            local v344 = Instance.new("TextLabel")
            v344.Text = p338
            v344.TextColor3 = vu16.TextTitle
            v344.Font = Enum.Font.GothamMedium
            v344.TextSize = 14
            v344.Position = UDim2.new(0, 15, 0, 10)
            v344.BackgroundTransparency = 1
            v344.TextXAlignment = Enum.TextXAlignment.Left
            v344.Parent = v343
            local vu345 = Instance.new("TextLabel")
            vu345.Text = tostring(p341)
            vu345.TextColor3 = vu16.AccentStart
            vu345.Font = Enum.Font.GothamBold
            vu345.TextSize = 14
            vu345.Position = UDim2.new(1, - 60, 0, 10)
            vu345.Size = UDim2.new(0, 45, 0, 20)
            vu345.BackgroundTransparency = 1
            vu345.TextXAlignment = Enum.TextXAlignment.Right
            vu345.Parent = v343
            local vu346 = Instance.new("TextButton")
            vu346.Size = UDim2.new(1, - 30, 0, 6)
            vu346.Position = UDim2.new(0, 15, 0, 40)
            vu346.BackgroundColor3 = vu16.Sidebar
            vu346.Text = ""
            vu346.AutoButtonColor = false
            vu346.Parent = v343
            vu87:CreateCorner(vu346, 3)
            local vu347 = Instance.new("Frame")
            vu347.Size = UDim2.new((p341 - pu339) / (pu340 - pu339), 0, 1, 0)
            vu347.BackgroundColor3 = vu16.AccentStart
            vu347.Parent = vu346
            vu87:CreateCorner(vu347, 3)
            local vu348 = false
            local function vu352(p349)
                local v350 = math.clamp((p349.Position.X - vu346.AbsolutePosition.X) / vu346.AbsoluteSize.X, 0, 1)
                vu87:Tween(vu347, {
                    Size = UDim2.new(v350, 0, 1, 0)
                }, 0.05)
                local v351 = math.floor(pu339 + (pu340 - pu339) * v350)
                vu345.Text = tostring(v351)
                pu342(v351)
            end
            vu346.InputBegan:Connect(function(p353)
                if p353.UserInputType == Enum.UserInputType.MouseButton1 or p353.UserInputType == Enum.UserInputType.Touch then
                    vu348 = true
                    vu352(p353)
                end
            end)
            vu3.InputEnded:Connect(function(p354)
                if p354.UserInputType == Enum.UserInputType.MouseButton1 or p354.UserInputType == Enum.UserInputType.Touch then
                    vu348 = false
                end
            end)
            vu3.InputChanged:Connect(function(p355)
                if vu348 and (p355.UserInputType == Enum.UserInputType.MouseMovement or p355.UserInputType == Enum.UserInputType.Touch) then
                    vu352(p355)
                end
            end)
        end
        return v313
    end
    local vu356 = true
    local function vu357()
        vu356 = not vu356
        vu272.Visible = vu356
    end;
    (function()
        if vu33 then
            vu33:Disconnect()
            vu33 = nil
        end
        vu33 = vu3.InputBegan:Connect(function(p358, p359)
            if not p359 then
                if p358.KeyCode == vu31 then
                    vu357()
                end
            end
        end)
    end)()
    if vu10 == "Mobile" then
        local v360 = Instance.new("ImageButton")
        v360.Name = "NoctyraToggle"
        v360.Size = UDim2.new(0, 50, 0, 50)
        v360.Position = UDim2.new(0, 20, 0.5, - 25)
        v360.BackgroundColor3 = vu16.Background
        v360.Image = "rbxassetid://6026568198"
        v360.Parent = vu96
        vu87:CreateCorner(v360, 25)
        local v361 = Instance.new("UIStroke")
        v361.Color = vu16.AccentStart
        v361.Thickness = 2
        v361.Parent = v360
        v360.MouseButton1Click:Connect(vu357)
    end
    return v269
end
local v362 = vu87
local v363 = vu87.Window(v362)
local v364 = v363:Tab("Dashboard")
v364:Label("Main Controls")
v364:Toggle("Enable Auto-Farm", false, function(p365)
    vu17 = p365
    vu87:Notify("System", p365 and "Farming started." or "Farming paused.", 2)
end)
v364:Button("TP Elevator", function()
    local v366 = workspace:FindFirstChild("GameSystem")
    if v366 then
        local v367 = v366:FindFirstChild("Loots")
        if v367 then
            local v368 = v367:FindFirstChild("ElevatorCollect")
            if v368 then
                local v369 = nil
                if v368:IsA("Model") then
                    v368 = v368.PrimaryPart or v368:FindFirstChildWhichIsA("BasePart")
                elseif v368:IsA("Folder") then
                    v368 = v368:FindFirstChildWhichIsA("BasePart", true)
                elseif not v368:IsA("BasePart") then
                    v368 = v369
                end
                if v368 then
                    vu117(CFrame.new(v368.Position) * CFrame.new(0, 5, 0))
                    vu87:Notify("Teleport", "Teleported to the elevator", 2, "Success")
                else
                    vu87:Notify("Error", "Elevator part not found", 2, "Error")
                end
            else
                vu87:Notify("Error", "Elevator not found", 2, "Error")
            end
        else
            vu87:Notify("Error", "Loots folder not found", 2, "Error")
            return
        end
    else
        vu87:Notify("Error", "GameSystem not found", 2, "Error")
        return
    end
end)
v364:Label("Configuration")
v364:Slider("Interact Distance", 10, 100, 25, function(p370)
    vu15.INTERACT_DIST = p370
end)
local v371 = v363:Tab("ESP")
v371:Label("ESP Options")
v371:Toggle("ESP Entity", false, function(p372)
    vu24 = p372
    vu87:Notify("ESP", p372 and "Entity ESP Enabled" or "Entity ESP Disabled", 2)
end)
v371:Toggle("ESP Loot", false, function(p373)
    vu25 = p373
    vu87:Notify("ESP", p373 and "Loot ESP Enabled" or "Loot ESP Disabled", 2)
end)
v371:Toggle("ESP Container", false, function(p374)
    vu26 = p374
    vu87:Notify("ESP", p374 and "Container ESP Enabled" or "Container ESP Disabled", 2)
end)
local v375 = v363:Tab("Misc")
v375:Label("Player Options")
v375:Toggle("Speed Hack", false, function(p376)
    vu28 = p376
    local v377 = not p376 and vu12:FindFirstChildOfClass("Humanoid")
    if v377 then
        v377.WalkSpeed = vu30
    end
    vu87:Notify("Speed", p376 and "Speed Enabled" or "Speed Disabled", 2)
end)
v375:Slider("Walk Speed", 16, 200, 16, function(p378)
    vu29 = p378
end)
local v379 = v363:Tab("Settings")
v379:Label("Keybind Settings")
local vu380 = v379:Label("Current Toggle Key: " .. vu31.Name)
v379:Button("Change Toggle Key (Press Any Key)", function()
    if vu32 then
        vu32:Disconnect()
        vu32 = nil
    end
    vu380.Text = "Press any key..."
    vu32 = vu3.InputBegan:Connect(function(p381, _)
        if p381.UserInputType == Enum.UserInputType.Keyboard and p381.KeyCode ~= Enum.KeyCode.Unknown then
            vu31 = p381.KeyCode
            vu380.Text = "Current Toggle Key: " .. vu31.Name
            vu87:Notify("Keybind", "Toggle key set to: " .. vu31.Name, 2)
            if vu32 then
                vu32:Disconnect()
                vu32 = nil
            end
        end
    end)
end)
v379:Label("Credits")
v379:Label("Developer: Noctyra")
v379:Button("Unload Script", function()
    vu96:Destroy()
    vu27:Destroy()
end)
local v382 = vu87
vu87.Notify(v382, "Noctyra", "Deadly Delivery Loaded.", 5)
task.delay(5, function()
    local vu383 = Instance.new("ScreenGui")
    vu383.Name = "DiscordInvite"
    vu383.ResetOnSpawn = false
    vu383.DisplayOrder = 999
    vu383.Parent = vu8.PlayerGui
    local vu384 = Instance.new("Frame")
    vu384.Size = UDim2.new(1, 0, 1, 0)
    vu384.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    vu384.BackgroundTransparency = 0.5
    vu384.BorderSizePixel = 0
    vu384.Parent = vu383
    local vu385 = Instance.new("Frame")
    vu385.Size = UDim2.new(0, 400, 0, 250)
    vu385.Position = UDim2.new(0.5, - 200, 0.5, - 125)
    vu385.BackgroundColor3 = vu16.Background
    vu385.BorderSizePixel = 0
    vu385.Parent = vu383
    vu87:CreateCorner(vu385, 12)
    local v386 = Instance.new("UIStroke")
    v386.Color = vu16.AccentStart
    v386.Thickness = 2
    v386.Parent = vu385
    local v387 = Instance.new("ImageLabel")
    v387.Size = UDim2.new(0, 80, 0, 80)
    v387.Position = UDim2.new(0.5, - 40, 0, 25)
    v387.BackgroundTransparency = 1
    v387.Image = "rbxassetid://6031229361"
    v387.Parent = vu385
    local v388 = Instance.new("TextLabel")
    v388.Text = "Join Our Discord!"
    v388.Font = Enum.Font.GothamBlack
    v388.TextSize = 22
    v388.TextColor3 = vu16.TextTitle
    v388.Position = UDim2.new(0, 0, 0, 115)
    v388.Size = UDim2.new(1, 0, 0, 30)
    v388.BackgroundTransparency = 1
    v388.Parent = vu385
    local v389 = Instance.new("TextLabel")
    v389.Text = "Get updates, support, and more scripts!"
    v389.Font = Enum.Font.Gotham
    v389.TextSize = 13
    v389.TextColor3 = vu16.TextDim
    v389.Position = UDim2.new(0, 0, 0, 145)
    v389.Size = UDim2.new(1, 0, 0, 20)
    v389.BackgroundTransparency = 1
    v389.Parent = vu385
    local vu390 = Instance.new("TextButton")
    vu390.Size = UDim2.new(0, 180, 0, 40)
    vu390.Position = UDim2.new(0.5, - 90, 0, 180)
    vu390.BackgroundColor3 = vu16.AccentStart
    vu390.Text = "Copy Invite Link"
    vu390.TextColor3 = vu16.TextTitle
    vu390.Font = Enum.Font.GothamBold
    vu390.TextSize = 14
    vu390.AutoButtonColor = false
    vu390.Parent = vu385
    vu87:CreateCorner(vu390, 8)
    vu390.MouseEnter:Connect(function()
        vu87:Tween(vu390, {
            BackgroundColor3 = vu16.AccentEnd
        })
    end)
    vu390.MouseLeave:Connect(function()
        vu87:Tween(vu390, {
            BackgroundColor3 = vu16.AccentStart
        })
    end)
    vu390.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/nacepzPQKh")
        vu390.Text = "\239\191\189\239\191\189 Copied!"
        vu87:Notify("Discord", "Invite link copied to clipboard!", 2)
        task.wait(1.5)
        vu87:Tween(vu385, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.3)
        vu87:Tween(vu384, {
            BackgroundTransparency = 1
        }, 0.3)
        task.wait(0.3)
        vu383:Destroy()
    end)
    local vu391 = Instance.new("TextButton")
    vu391.Size = UDim2.new(0, 30, 0, 30)
    vu391.Position = UDim2.new(1, - 35, 0, 5)
    vu391.BackgroundColor3 = vu16.Element
    vu391.Text = "\239\191\189"
    vu391.TextColor3 = vu16.TextDim
    vu391.Font = Enum.Font.GothamBold
    vu391.TextSize = 20
    vu391.AutoButtonColor = false
    vu391.Parent = vu385
    vu87:CreateCorner(vu391, 8)
    vu391.MouseEnter:Connect(function()
        vu87:Tween(vu391, {
            BackgroundColor3 = vu16.Hover,
            TextColor3 = vu16.TextTitle
        })
    end)
    vu391.MouseLeave:Connect(function()
        vu87:Tween(vu391, {
            BackgroundColor3 = vu16.Element,
            TextColor3 = vu16.TextDim
        })
    end)
    vu391.MouseButton1Click:Connect(function()
        vu87:Tween(vu385, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.3)
        vu87:Tween(vu384, {
            BackgroundTransparency = 1
        }, 0.3)
        task.wait(0.3)
        vu383:Destroy()
    end)
    vu385.Size = UDim2.new(0, 0, 0, 0)
    vu385.Position = UDim2.new(0.5, 0, 0.5, 0)
    vu87:Tween(vu385, {
        Size = UDim2.new(0, 400, 0, 250),
        Position = UDim2.new(0.5, - 200, 0.5, - 125)
    }, 0.5, Enum.EasingStyle.Back)
end)
