-- ts file was generated at discord.gg/25ms


local vu1 = game:GetService("Players")
local vu2 = game:GetService("RunService")
local vu3 = game:GetService("Workspace")
local vu4 = game:GetService("Lighting")
local vu5 = game:GetService("CoreGui")
local vu6 = game:GetService("UserInputService")
local vu7 = game:GetService("TweenService")
local vu8 = vu1.LocalPlayer
local _ = vu3.CurrentCamera
local v9 = "HideOrDie_Noctyra"
if vu5:FindFirstChild(v9) then
    vu5[v9]:Destroy()
end
local vu10 = {
    PlayerESP = false,
    PlayerESPColor = Color3.fromRGB(255, 100, 100),
    CoinESP = false,
    CoinESPColor = Color3.fromRGB(255, 223, 0),
    SpeedEnabled = false,
    SpeedValue = 50,
    Fullbright = false,
    AutoKillEnabled = false,
    AutoKillRange = 50,
    AutoCoinCollect = false,
    CoinCollectDelay = 0.5,
    NoclipEnabled = false,
    JumpPowerEnabled = false,
    JumpPowerValue = 50,
    FlyEnabled = false,
    FlySpeed = 50
}
local vu11 = {}
local vu12 = nil
local vu13 = nil
local vu14 = nil
local vu15 = nil
local vu16 = nil
local vu17 = nil
local vu18 = Enum.KeyCode.K
local vu19 = {
    Main = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 25),
    Section = Color3.fromRGB(25, 25, 30),
    Accent = Color3.fromRGB(138, 43, 226),
    AccentGlow = Color3.fromRGB(160, 60, 240),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(145, 145, 155),
    Stroke = Color3.fromRGB(40, 40, 45)
}
local function vu25(p20, p21, p22, p23, p24)
    vu7:Create(p20, TweenInfo.new(p22 or 0.3, p23 or Enum.EasingStyle.Quart, p24 or Enum.EasingDirection.Out), p21):Play()
end
local function vu29(p26, p27)
    local v28 = Instance.new("UICorner")
    v28.CornerRadius = UDim.new(0, p27)
    v28.Parent = p26
    return v28
end
local function vu35(p30, p31, p32, p33)
    local v34 = Instance.new("UIStroke")
    v34.Color = p31 or vu19.Stroke
    v34.Thickness = p32 or 1
    v34.Transparency = p33 or 0
    v34.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    v34.Parent = p30
    return v34
end
local vu36 = Instance.new("ScreenGui")
vu36.Name = "Noctyra_Notifications"
vu36.Parent = vu5
vu36.ResetOnSpawn = false
vu36.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local function vu53(p37, p38, p39)
    local vu40 = Instance.new("Frame")
    vu40.Size = UDim2.new(0, 260, 0, 55)
    vu40.Position = UDim2.new(1, 20, 1, - 70)
    vu40.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    vu40.BorderSizePixel = 0
    vu40.ClipsDescendants = true
    vu40.Parent = vu36
    vu29(vu40, 8)
    local v41 = Instance.new("UIGradient")
    v41.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
    })
    v41.Rotation = 45
    v41.Parent = vu40
    vu35(vu40, vu19.Accent, 1.5).Transparency = 0.3
    local v42 = Instance.new("ImageLabel")
    v42.Image = "rbxassetid://6015897843"
    v42.ImageColor3 = Color3.fromRGB(0, 0, 0)
    v42.ImageTransparency = 0.7
    v42.Size = UDim2.new(1, 30, 1, 30)
    v42.Position = UDim2.new(0, - 15, 0, - 15)
    v42.BackgroundTransparency = 1
    v42.ZIndex = - 1
    v42.Parent = vu40
    local v43 = Instance.new("Frame")
    v43.Size = UDim2.new(0, 3, 1, 0)
    v43.Position = UDim2.new(0, 0, 0, 0)
    v43.BackgroundColor3 = vu19.Accent
    v43.BorderSizePixel = 0
    v43.Parent = vu40
    local v44 = Instance.new("UIGradient")
    v44.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, vu19.Accent),
        ColorSequenceKeypoint.new(1, vu19.AccentGlow)
    })
    v44.Rotation = 90
    v44.Parent = v43
    local v45 = Instance.new("TextLabel")
    v45.Size = UDim2.new(1, - 15, 0, 18)
    v45.Position = UDim2.new(0, 12, 0, 5)
    v45.BackgroundTransparency = 1
    v45.Font = Enum.Font.GothamBold
    v45.TextSize = 12
    v45.TextColor3 = vu19.Text
    v45.TextXAlignment = Enum.TextXAlignment.Left
    v45.Text = p37
    v45.Parent = vu40
    local v46 = Instance.new("TextLabel")
    v46.Size = UDim2.new(1, - 15, 0, 28)
    v46.Position = UDim2.new(0, 12, 0, 24)
    v46.BackgroundTransparency = 1
    v46.Font = Enum.Font.Gotham
    v46.TextSize = 11
    v46.TextColor3 = vu19.TextDim
    v46.TextXAlignment = Enum.TextXAlignment.Left
    v46.TextYAlignment = Enum.TextYAlignment.Top
    v46.TextWrapped = true
    v46.Text = p38
    v46.Parent = vu40
    local v47 = vu36
    local v48, v49, v50 = pairs(v47:GetChildren())
    local v51 = 0
    while true do
        local v52
        v50, v52 = v48(v49, v50)
        if v50 == nil then
            break
        end
        if v52 ~= vu40 and v52:IsA("Frame") then
            v51 = v51 + 65
            vu25(v52, {
                Position = UDim2.new(1, - 270, 1, - 70 - v51)
            }, 0.3)
        end
    end
    vu25(vu40, {
        Position = UDim2.new(1, - 270, 1, - 70)
    }, 0.5, Enum.EasingStyle.Back)
    task.delay(p39 or 3, function()
        vu25(vu40, {
            Position = UDim2.new(1, 20, 1, - 70)
        }, 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.wait(0.4)
        vu40:Destroy()
    end)
end
local function vu66(pu54, p55, p56, p57)
    if vu11[pu54] then
        return
    else
        local v58 = pu54.Parent
        if v58 then
            local v59 = Instance.new("Highlight")
            v59.Name = "ESP_Highlight_" .. p55
            v59.Adornee = v58
            v59.FillColor = p56
            v59.OutlineColor = p56
            v59.FillTransparency = 0.5
            v59.OutlineTransparency = 0
            v59.Parent = v58
            local v60 = Instance.new("BillboardGui")
            v60.Name = "ESP_Info_" .. p55
            v60.Adornee = pu54
            v60.Size = UDim2.new(0, 200, 0, 50)
            v60.StudsOffset = Vector3.new(0, 3, 0)
            v60.AlwaysOnTop = true
            v60.Parent = vu5
            local v61 = Instance.new("Frame")
            v61.Size = UDim2.new(1, 0, 1, 0)
            v61.BackgroundTransparency = 1
            v61.BorderSizePixel = 0
            v61.Parent = v60
            local v62 = Instance.new("TextLabel")
            v62.Size = UDim2.new(1, 0, 0.5, 0)
            v62.Position = UDim2.new(0, 0, 0, 0)
            v62.BackgroundTransparency = 1
            v62.Text = p57 or pu54.Name
            v62.TextColor3 = p56
            v62.TextSize = 16
            v62.Font = Enum.Font.GothamBold
            v62.TextStrokeTransparency = 0.3
            v62.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            v62.Parent = v61
            local vu63 = Instance.new("TextLabel")
            vu63.Size = UDim2.new(1, 0, 0.5, 0)
            vu63.Position = UDim2.new(0, 0, 0.5, 0)
            vu63.BackgroundTransparency = 1
            vu63.Text = "0m"
            vu63.TextColor3 = Color3.fromRGB(255, 255, 255)
            vu63.TextSize = 14
            vu63.Font = Enum.Font.Gotham
            vu63.TextStrokeTransparency = 0.3
            vu63.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            vu63.Parent = v61
            local v64 = Instance.new("BoxHandleAdornment")
            v64.Name = "ESP_Box_" .. p55
            v64.Adornee = pu54
            v64.Size = pu54.Size + Vector3.new(0.1, 0.1, 0.1)
            v64.Color3 = p56
            v64.AlwaysOnTop = true
            v64.ZIndex = 1
            v64.Transparency = 0.7
            v64.Parent = pu54
            vu11[pu54] = {
                Highlight = v59,
                BillboardGui = v60,
                Box = v64,
                DistanceLabel = vu63,
                Type = p55
            }
            vu2.RenderStepped:Connect(function()
                if pu54 and pu54.Parent then
                    if vu8.Character and vu8.Character:FindFirstChild("HumanoidRootPart") then
                        local v65 = (pu54.Position - vu8.Character.HumanoidRootPart.Position).Magnitude
                        vu63.Text = math.floor(v65) .. "m"
                    end
                elseif vu11[pu54] then
                    if vu11[pu54].Highlight then
                        vu11[pu54].Highlight:Destroy()
                    end
                    if vu11[pu54].BillboardGui then
                        vu11[pu54].BillboardGui:Destroy()
                    end
                    if vu11[pu54].Box then
                        vu11[pu54].Box:Destroy()
                    end
                    vu11[pu54] = nil
                end
            end)
        end
    end
end
local function vu72(p67)
    local v68, v69, v70 = pairs(vu11)
    while true do
        local v71
        v70, v71 = v68(v69, v70)
        if v70 == nil then
            break
        end
        if not p67 or v71.Type == p67 then
            if v71.Highlight then
                v71.Highlight:Destroy()
            end
            if v71.BillboardGui then
                v71.BillboardGui:Destroy()
            end
            if v71.Box then
                v71.Box:Destroy()
            end
            vu11[v70] = nil
        end
    end
end
local function vu79()
    vu72("Player")
    if vu10.PlayerESP then
        local v73 = vu1
        local v74, v75, v76 = pairs(v73:GetPlayers())
        while true do
            local v77
            v76, v77 = v74(v75, v76)
            if v76 == nil then
                break
            end
            if v77 ~= vu8 and (not v77.Team or (not vu8.Team or v77.Team ~= vu8.Team)) and v77.Character then
                local v78 = v77.Character:FindFirstChild("HumanoidRootPart")
                if v78 then
                    vu66(v78, "Player", vu10.PlayerESPColor, v77.Name)
                end
            end
        end
    end
end
local function vu92()
    vu72("Coin")
    if vu10.CoinESP then
        local v80 = vu3
        local v81, v82, v83 = pairs(v80:GetDescendants())
        while true do
            local vu84
            v83, vu84 = v81(v82, v83)
            if v83 == nil then
                break
            end
            if vu84.Name == "Coin" and (vu84:IsA("BasePart") and not vu11[vu84]) then
                local v85 = Instance.new("Highlight")
                v85.Name = "ESP_Highlight_Coin"
                v85.Adornee = vu84
                v85.FillColor = vu10.CoinESPColor
                v85.OutlineColor = vu10.CoinESPColor
                v85.FillTransparency = 0.3
                v85.OutlineTransparency = 0
                v85.Parent = vu84
                local v86 = Instance.new("BillboardGui")
                v86.Name = "ESP_Coin"
                v86.Adornee = vu84
                v86.Size = UDim2.new(0, 150, 0, 40)
                v86.StudsOffset = Vector3.new(0, 2, 0)
                v86.AlwaysOnTop = true
                v86.Parent = vu5
                local v87 = Instance.new("Frame")
                v87.Size = UDim2.new(1, 0, 1, 0)
                v87.BackgroundTransparency = 1
                v87.BorderSizePixel = 0
                v87.Parent = v86
                local v88 = Instance.new("TextLabel")
                v88.Size = UDim2.new(1, 0, 0.6, 0)
                v88.BackgroundTransparency = 1
                v88.Text = "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189 Coin"
                v88.TextColor3 = vu10.CoinESPColor
                v88.TextSize = 15
                v88.Font = Enum.Font.GothamBold
                v88.TextStrokeTransparency = 0.3
                v88.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                v88.Parent = v87
                local vu89 = Instance.new("TextLabel")
                vu89.Size = UDim2.new(1, 0, 0.4, 0)
                vu89.Position = UDim2.new(0, 0, 0.6, 0)
                vu89.BackgroundTransparency = 1
                vu89.Text = "0m"
                vu89.TextColor3 = Color3.fromRGB(255, 255, 255)
                vu89.TextSize = 13
                vu89.Font = Enum.Font.Gotham
                vu89.TextStrokeTransparency = 0.3
                vu89.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                vu89.Parent = v87
                local v90 = Instance.new("BoxHandleAdornment")
                v90.Name = "ESP_Box_Coin"
                v90.Adornee = vu84
                v90.Size = vu84.Size + Vector3.new(0.2, 0.2, 0.2)
                v90.Color3 = vu10.CoinESPColor
                v90.AlwaysOnTop = true
                v90.ZIndex = 1
                v90.Transparency = 0.6
                v90.Parent = vu84
                vu11[vu84] = {
                    Highlight = v85,
                    BillboardGui = v86,
                    Box = v90,
                    DistanceLabel = vu89,
                    Type = "Coin"
                }
                vu2.RenderStepped:Connect(function()
                    if vu84 and vu84.Parent then
                        if vu8.Character and vu8.Character:FindFirstChild("HumanoidRootPart") then
                            local v91 = (vu84.Position - vu8.Character.HumanoidRootPart.Position).Magnitude
                            vu89.Text = math.floor(v91) .. "m"
                        end
                    elseif vu11[vu84] then
                        if vu11[vu84].Highlight then
                            vu11[vu84].Highlight:Destroy()
                        end
                        if vu11[vu84].BillboardGui then
                            vu11[vu84].BillboardGui:Destroy()
                        end
                        if vu11[vu84].Box then
                            vu11[vu84].Box:Destroy()
                        end
                        vu11[vu84] = nil
                    end
                end)
            end
        end
    end
end
local function vu93()
    if vu8.Character and vu8.Character:FindFirstChild("Humanoid") then
        vu8.Character.Humanoid.WalkSpeed = vu10.SpeedEnabled and vu10.SpeedValue or 16
    end
end
local function vu102()
    if vu14 then
        vu14:Disconnect()
        vu14 = nil
    end
    if vu10.NoclipEnabled then
        vu14 = vu2.Stepped:Connect(function()
            if vu8.Character then
                local v94, v95, v96 = pairs(vu8.Character:GetDescendants())
                while true do
                    local v97
                    v96, v97 = v94(v95, v96)
                    if v96 == nil then
                        break
                    end
                    if v97:IsA("BasePart") then
                        v97.CanCollide = false
                    end
                end
            end
        end)
    elseif vu8.Character then
        local v98, v99, v100 = pairs(vu8.Character:GetDescendants())
        while true do
            local v101
            v100, v101 = v98(v99, v100)
            if v100 == nil then
                break
            end
            if v101:IsA("BasePart") and v101.Name ~= "HumanoidRootPart" then
                v101.CanCollide = true
            end
        end
    end
end
local function vu103()
    if vu8.Character and vu8.Character:FindFirstChild("Humanoid") then
        vu8.Character.Humanoid.JumpPower = vu10.JumpPowerEnabled and vu10.JumpPowerValue or 50
    end
end
local function vu109()
    if vu15 then
        vu15:Disconnect()
        vu15 = nil
    end
    if vu16 then
        vu16:Destroy()
        vu16 = nil
    end
    if vu17 then
        vu17:Destroy()
        vu17 = nil
    end
    if vu10.FlyEnabled and vu8.Character and vu8.Character:FindFirstChild("HumanoidRootPart") then
        local v104 = vu8.Character.HumanoidRootPart
        vu16 = Instance.new("BodyVelocity")
        vu16.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
        vu16.Velocity = Vector3.new(0, 0, 0)
        vu16.Parent = v104
        vu17 = Instance.new("BodyGyro")
        vu17.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
        vu17.P = 90000
        vu17.CFrame = v104.CFrame
        vu17.Parent = v104
        vu15 = vu2.Heartbeat:Connect(function()
            if vu8.Character and vu8.Character:FindFirstChild("HumanoidRootPart") then
                local v105 = workspace.CurrentCamera
                local _ = vu8.Character.HumanoidRootPart
                local v106 = vu10.FlySpeed
                vu17.CFrame = v105.CFrame
                local v107 = Vector3.new(0, 0, 0)
                local v108 = game:GetService("UserInputService")
                if v108:IsKeyDown(Enum.KeyCode.W) then
                    v107 = v107 + v105.CFrame.LookVector * v106
                end
                if v108:IsKeyDown(Enum.KeyCode.S) then
                    v107 = v107 - v105.CFrame.LookVector * v106
                end
                if v108:IsKeyDown(Enum.KeyCode.A) then
                    v107 = v107 - v105.CFrame.RightVector * v106
                end
                if v108:IsKeyDown(Enum.KeyCode.D) then
                    v107 = v107 + v105.CFrame.RightVector * v106
                end
                if v108:IsKeyDown(Enum.KeyCode.Space) then
                    v107 = v107 + Vector3.new(0, v106, 0)
                end
                if v108:IsKeyDown(Enum.KeyCode.LeftShift) then
                    v107 = v107 - Vector3.new(0, v106, 0)
                end
                vu16.Velocity = v107
            end
        end)
    end
end
local vu110 = {}
local function vu115()
    if vu10.Fullbright then
        vu110 = {
            Ambient = vu4.Ambient,
            Brightness = vu4.Brightness,
            ColorShift_Bottom = vu4.ColorShift_Bottom,
            ColorShift_Top = vu4.ColorShift_Top,
            OutdoorAmbient = vu4.OutdoorAmbient,
            ClockTime = vu4.ClockTime
        }
        vu4.Ambient = Color3.fromRGB(255, 255, 255)
        vu4.Brightness = 2
        vu4.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
        vu4.ColorShift_Top = Color3.fromRGB(255, 255, 255)
        vu4.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        vu4.ClockTime = 12
    elseif vu110.Ambient then
        local v111, v112, v113 = pairs(vu110)
        while true do
            local v114
            v113, v114 = v111(v112, v113)
            if v113 == nil then
                break
            end
            vu4[v113] = v114
        end
    end
end
local function vu147()
    if vu12 then
        vu12:Disconnect()
    end
    if vu10.AutoKillEnabled then
        local vu116 = nil
        local function vu121()
            local v117 = vu8.Character
            if not v117 then
                return false
            end
            local v118 = v117:FindFirstChild("Primary")
            if v118 and v118:IsA("Tool") then
                return true
            end
            if not vu8.Backpack:FindFirstChild("Primary") then
                vu10.AutoKillEnabled = false
                StopAutoKill()
                return false
            end
            local v119 = game:GetService("VirtualInputManager")
            v119:SendKeyEvent(true, Enum.KeyCode.One, false, game)
            task.wait(0.15)
            v119:SendKeyEvent(false, Enum.KeyCode.One, false, game)
            task.wait(0.2)
            local v120 = v117:FindFirstChild("Primary")
            if v120 and v120:IsA("Tool") then
                return true
            end
            vu10.AutoKillEnabled = false
            StopAutoKill()
            return false
        end
        local function vu126()
            local v122 = vu8.Character
            if v122 then
                local vu123 = v122:FindFirstChild("Primary")
                if vu123 and vu123:IsA("Tool") then
                    vu123:Activate()
                    pcall(function()
                        if vu123:FindFirstChild("MouseButton1Down") then
                            vu123.MouseButton1Down:Fire()
                        end
                    end)
                    local v124 = game:GetService("VirtualInputManager")
                    local v125 = workspace.CurrentCamera.ViewportSize / 2
                    v124:SendMouseButtonEvent(v125.X, v125.Y, 0, true, game, 0)
                    task.wait(0.05)
                    v124:SendMouseButtonEvent(v125.X, v125.Y, 0, false, game, 0)
                end
            else
                return
            end
        end
        local function vu138()
            if not vu8.Team or vu8.Team.Name ~= "Seeker" then
                return nil
            end
            local v127 = vu1
            local v128, v129, v130 = pairs(v127:GetPlayers())
            local v131 = {}
            while true do
                local v132
                v130, v132 = v128(v129, v130)
                if v130 == nil then
                    break
                end
                if v132 ~= vu8 and (v132.Team and (v132.Team.Name == "Hider" and v132.Character)) then
                    local v133 = v132.Character:FindFirstChild("HumanoidRootPart")
                    local v134 = v132.Character:FindFirstChild("Humanoid")
                    if v133 and (v134 and v134.Health > 0) then
                        local v135 = vu8.Character and (vu8.Character:FindFirstChild("HumanoidRootPart") and (v133.Position - vu8.Character.HumanoidRootPart.Position).Magnitude) or math.huge
                        table.insert(v131, {
                            Player = v132,
                            HRP = v133,
                            Humanoid = v134,
                            Distance = v135
                        })
                    end
                end
            end
            table.sort(v131, function(p136, p137)
                return p136.Distance < p137.Distance
            end)
            return v131[1]
        end
        vu12 = vu2.Heartbeat:Connect(function()
            if vu10.AutoKillEnabled then
                if vu8.Team and vu8.Team.Name == "Seeker" then
                    local vu139 = vu8.Character
                    local v140
                    if vu139 then
                        v140 = vu139:FindFirstChild("HumanoidRootPart")
                    else
                        v140 = vu139
                    end
                    if vu139 and v140 then
                        task.spawn(function()
                            if not vu139:FindFirstChild("Knife") then
                                vu121()
                            end
                        end)
                        if vu116 then
                            local v141 = vu116.Player.Character
                            local v142
                            if v141 then
                                v142 = v141:FindFirstChild("HumanoidRootPart")
                            else
                                v142 = v141
                            end
                            local v143
                            if v141 then
                                v143 = v141:FindFirstChild("Humanoid")
                            else
                                v143 = v141
                            end
                            if not v141 or (not v142 or (not v143 or v143.Health <= 0)) then
                                vu116 = nil
                                return
                            end
                            v140.CFrame = v142.CFrame * CFrame.new(0, 0, 3)
                            v140.CFrame = CFrame.lookAt(v140.Position, v142.Position)
                            local v144 = workspace.CurrentCamera
                            local v145 = v141:FindFirstChild("Head") or v142
                            if v144 and v145 then
                                v144.CFrame = CFrame.new(v144.CFrame.Position, v145.Position)
                            end
                            vu126()
                        else
                            local v146 = vu138()
                            if v146 then
                                vu116 = v146
                                vu53("Auto-Kill", "Target: " .. v146.Player.DisplayName, 3)
                            end
                        end
                    end
                else
                    return
                end
            else
                return
            end
        end)
    end
end
local function vu148()
    if vu12 then
        vu12:Disconnect()
        vu12 = nil
    end
end
local vu149 = nil
local vu150 = {}
local function vu162()
    if vu13 then
        vu13:Disconnect()
    end
    if vu10.AutoCoinCollect then
        vu150 = {}
        vu149 = nil
        vu13 = vu2.Heartbeat:Connect(function()
            if vu10.AutoCoinCollect then
                if vu8.Team and vu8.Team.Name == "Hider" then
                    local v151 = vu8.Character
                    local v152
                    if v151 then
                        v152 = v151:FindFirstChild("HumanoidRootPart")
                    else
                        v152 = v151
                    end
                    if v151 and v152 then
                        local v153 = math.huge
                        local v154 = vu3
                        local v155, v156, v157 = pairs(v154:GetDescendants())
                        local v158 = nil
                        while true do
                            local v159
                            v157, v159 = v155(v156, v157)
                            if v157 == nil then
                                break
                            end
                            if v159.Name == "Coin" and (v159:IsA("BasePart") and (v159.Parent and not vu150[v159])) then
                                local v160 = (v159.Position - v152.Position).Magnitude
                                if v160 < v153 then
                                    v158 = v159
                                    v153 = v160
                                end
                            end
                        end
                        if v158 then
                            if not vu149 then
                                vu149 = v158.CFrame + Vector3.new(0, 3, 0)
                            end
                            vu150[v158] = true
                            v152.CFrame = v158.CFrame + Vector3.new(0, 3, 0)
                            local v161 = v158:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if v161 then
                                fireproximityprompt(v161)
                            end
                            task.wait(vu10.CoinCollectDelay)
                        elseif vu149 then
                            task.wait(0.3)
                            if v152 then
                                v152.CFrame = vu149
                            end
                            task.wait(0.5)
                            vu10.AutoCoinCollect = false
                            if vu13 then
                                vu13:Disconnect()
                                vu13 = nil
                            end
                            vu149 = nil
                            vu150 = {}
                        end
                    end
                else
                    return
                end
            else
                return
            end
        end)
    end
end
local function vu163()
    if vu13 then
        vu13:Disconnect()
        vu13 = nil
    end
    vu149 = nil
    vu150 = {}
end
vu8.CharacterAdded:Connect(function()
    wait(1)
    vu93()
    vu103()
    vu102()
    vu109()
    vu79()
    vu92()
end)
vu1.PlayerAdded:Connect(function()
    if vu10.PlayerESP then
        wait(1)
        vu79()
    end
end)
vu1.PlayerRemoving:Connect(function()
    if vu10.PlayerESP then
        vu79()
    end
end)
vu3.DescendantAdded:Connect(function(p164)
    if p164.Name == "Coin" and (p164:IsA("BasePart") and vu10.CoinESP) then
        wait(0.1)
        vu66(p164, "Coin", vu10.CoinESPColor, "Coin")
    end
end)
local vu165 = Instance.new("ScreenGui")
vu165.Name = v9
vu165.Parent = vu5
vu165.ResetOnSpawn = false
vu165.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
vu165.IgnoreGuiInset = true;
(function()
    local v166 = Instance.new("BlurEffect")
    v166.Size = 0
    v166.Parent = vu4
    vu25(v166, {
        Size = 15
    }, 0.5)
    local v167 = Instance.new("Frame")
    v167.Size = UDim2.new(0, 0, 0, 0)
    v167.Position = UDim2.new(0.5, 0, 0.5, 0)
    v167.BackgroundColor3 = vu19.Main
    v167.AnchorPoint = Vector2.new(0.5, 0.5)
    v167.BorderSizePixel = 0
    v167.Parent = vu165
    vu29(v167, 14)
    vu35(v167, vu19.Accent, 1.5)
    local v168 = Instance.new("ImageLabel")
    v168.Image = "rbxassetid://6015897843"
    v168.Size = UDim2.new(1, 60, 1, 60)
    v168.Position = UDim2.new(0, - 30, 0, - 30)
    v168.BackgroundTransparency = 1
    v168.ImageColor3 = vu19.Accent
    v168.ImageTransparency = 0.8
    v168.ZIndex = - 1
    v168.Parent = v167
    local v169 = Instance.new("TextLabel")
    v169.Size = UDim2.new(1, 0, 1, 0)
    v169.BackgroundTransparency = 1
    v169.Font = Enum.Font.GothamBlack
    v169.TextSize = 26
    v169.TextColor3 = vu19.Text
    v169.TextTransparency = 1
    v169.Text = ""
    v169.Parent = v167
    vu25(v167, {
        Size = UDim2.new(0, 280, 0, 120)
    }, 0.5)
    task.wait(0.5)
    v169.Text = "N O C T Y R A"
    vu25(v169, {
        TextTransparency = 0
    }, 0.5)
    task.wait(1)
    vu25(v169, {
        TextTransparency = 1
    }, 0.3)
    task.wait(0.3)
    v169.TextColor3 = vu19.Accent
    v169.Text = "HIDE OR DIE"
    vu25(v169, {
        TextTransparency = 0
    }, 0.5)
    task.wait(1)
    vu25(v169, {
        TextTransparency = 1
    }, 0.3)
    vu25(v167, {
        Size = UDim2.new(0, 0, 0, 0)
    }, 0.4)
    vu25(v166, {
        Size = 0
    }, 0.4)
    task.wait(0.4)
    v167:Destroy()
    v166:Destroy()
end)()
local vu170 = Instance.new("Frame")
vu170.Name = "MainFrame"
vu170.Size = UDim2.new(0, 600, 0, 400)
vu170.Position = UDim2.new(0.5, - 300, 0.5, - 200)
vu170.BackgroundColor3 = vu19.Main
vu170.ClipsDescendants = false
vu170.Visible = false
vu170.Parent = vu165
vu29(vu170, 12)
local v171 = vu35(vu170, vu19.Accent, 2)
local vu172 = Instance.new("UIGradient")
vu172.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, vu19.Accent),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1, vu19.Accent)
})
vu172.Parent = v171
task.spawn(function()
    while vu170.Parent do
        vu172.Rotation = vu172.Rotation + 1
        if vu172.Rotation >= 360 then
            vu172.Rotation = 0
        end
        task.wait(0.02)
    end
end)
task.delay(3.5, function()
    vu170.Visible = true
    vu170.Size = UDim2.new(0, 0, 0, 0)
    vu25(vu170, {
        Size = UDim2.new(0, 600, 0, 400)
    }, 0.6, Enum.EasingStyle.Back)
    vu53("Noctyra Loaded", "Press K to toggle UI!", 5)
end)
vu6.InputBegan:Connect(function(p173, p174)
    if not p174 and p173.KeyCode == vu18 then
        vu170.Visible = not vu170.Visible
    end
end)
local vu175 = nil
local vu176 = nil
local vu177 = nil
local v178 = Instance.new("Frame")
v178.Size = UDim2.new(1, 0, 0, 40)
v178.BackgroundTransparency = 1
v178.Parent = vu170
v178.InputBegan:Connect(function(p179)
    if p179.UserInputType == Enum.UserInputType.MouseButton1 then
        vu175 = true
        vu176 = p179.Position
        vu177 = vu170.Position
    end
end)
vu6.InputChanged:Connect(function(p180)
    if p180.UserInputType == Enum.UserInputType.MouseMovement and vu175 then
        local v181 = p180.Position - vu176
        vu25(vu170, {
            Position = UDim2.new(vu177.X.Scale, vu177.X.Offset + v181.X, vu177.Y.Scale, vu177.Y.Offset + v181.Y)
        }, 0.05)
    end
end)
vu6.InputEnded:Connect(function(p182)
    if p182.UserInputType == Enum.UserInputType.MouseButton1 then
        vu175 = false
    end
end)
local v183 = Instance.new("Frame")
v183.Size = UDim2.new(0, 180, 1, 0)
v183.BackgroundColor3 = vu19.Sidebar
v183.Parent = vu170
vu29(v183, 12)
local v184 = Instance.new("Frame")
v184.Size = UDim2.new(0, 10, 1, 0)
v184.Position = UDim2.new(1, - 5, 0, 0)
v184.BackgroundColor3 = vu19.Sidebar
v184.BorderSizePixel = 0
v184.Parent = v183
local v185 = Instance.new("TextLabel")
v185.Text = "Noctyra"
v185.Font = Enum.Font.GothamBlack
v185.TextSize = 24
v185.TextColor3 = vu19.Accent
v185.Size = UDim2.new(1, 0, 0, 60)
v185.BackgroundTransparency = 1
v185.Position = UDim2.new(0, 0, 0, 10)
v185.Parent = v183
local v186 = Instance.new("TextLabel")
v186.Text = "HIDE OR DIE"
v186.Font = Enum.Font.Code
v186.TextSize = 12
v186.TextColor3 = vu19.TextDim
v186.Size = UDim2.new(1, 0, 0, 20)
v186.Position = UDim2.new(0, 0, 0, 45)
v186.BackgroundTransparency = 1
v186.Parent = v183
local vu187 = Instance.new("ScrollingFrame")
vu187.Size = UDim2.new(1, 0, 1, - 150)
vu187.Position = UDim2.new(0, 0, 0, 80)
vu187.BackgroundTransparency = 1
vu187.ScrollBarThickness = 0
vu187.Parent = v183
local v188 = Instance.new("UIListLayout")
v188.Padding = UDim.new(0, 8)
v188.HorizontalAlignment = Enum.HorizontalAlignment.Center
v188.Parent = vu187
local v189 = Instance.new("Frame")
v189.Size = UDim2.new(1, - 20, 0, 45)
v189.Position = UDim2.new(0, 10, 1, - 55)
v189.BackgroundColor3 = vu19.Main
v189.Parent = v183
vu29(v189, 8)
vu35(v189, vu19.Stroke, 1)
local vu190 = Instance.new("ImageLabel")
vu190.Size = UDim2.new(0, 28, 0, 28)
vu190.Position = UDim2.new(0, 8, 0.5, - 14)
vu190.BackgroundColor3 = vu19.Section
vu190.Parent = v189
vu29(vu190, 14)
pcall(function()
    vu190.Image = vu1:GetUserThumbnailAsync(vu8.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
end)
local v191 = Instance.new("TextLabel")
v191.Text = vu8.DisplayName
v191.TextColor3 = vu19.Text
v191.Font = Enum.Font.GothamBold
v191.TextSize = 11
v191.Size = UDim2.new(0, 100, 0, 15)
v191.Position = UDim2.new(0, 44, 0, 8)
v191.BackgroundTransparency = 1
v191.TextXAlignment = Enum.TextXAlignment.Left
v191.TextTruncate = Enum.TextTruncate.AtEnd
v191.Parent = v189
local v192 = Instance.new("TextLabel")
v192.Text = "Noctyra"
v192.TextColor3 = vu19.Accent
v192.Font = Enum.Font.Code
v192.TextSize = 10
v192.Size = UDim2.new(0, 100, 0, 15)
v192.Position = UDim2.new(0, 44, 0, 22)
v192.BackgroundTransparency = 1
v192.TextXAlignment = Enum.TextXAlignment.Left
v192.Parent = v189
local vu193 = Instance.new("Frame")
vu193.Size = UDim2.new(1, - 190, 1, - 20)
vu193.Position = UDim2.new(0, 190, 0, 10)
vu193.BackgroundTransparency = 1
vu193.Parent = vu170
local vu194 = {}
local v195 = {
    AutoFarm = "rbxassetid://10723407389",
    Movement = "rbxassetid://10734949856",
    Combat = "rbxassetid://10747372992",
    Misc = "rbxassetid://10734923214",
    Settings = "rbxassetid://6031280882"
}
local function v263(p196, p197)
    local v198 = {}
    local v199 = Instance.new("TextButton")
    v199.Size = UDim2.new(0.9, 0, 0, 38)
    v199.BackgroundColor3 = vu19.Sidebar
    v199.BackgroundTransparency = 1
    v199.Text = ""
    v199.Parent = vu187
    local vu200 = Instance.new("ImageLabel")
    vu200.Image = p197
    vu200.Size = UDim2.new(0, 20, 0, 20)
    vu200.Position = UDim2.new(0, 10, 0.5, - 10)
    vu200.ImageColor3 = vu19.TextDim
    vu200.BackgroundTransparency = 1
    vu200.Parent = v199
    local vu201 = Instance.new("TextLabel")
    vu201.Text = p196
    vu201.Font = Enum.Font.GothamMedium
    vu201.TextSize = 13
    vu201.TextColor3 = vu19.TextDim
    vu201.Position = UDim2.new(0, 40, 0, 0)
    vu201.Size = UDim2.new(1, - 40, 1, 0)
    vu201.BackgroundTransparency = 1
    vu201.TextXAlignment = Enum.TextXAlignment.Left
    vu201.Parent = v199
    local vu202 = Instance.new("Frame")
    vu202.Size = UDim2.new(0, 3, 0, 16)
    vu202.Position = UDim2.new(0, 0, 0.5, - 8)
    vu202.BackgroundColor3 = vu19.Accent
    vu202.BackgroundTransparency = 1
    vu202.Parent = v199
    vu29(vu202, 2)
    local vu203 = Instance.new("ScrollingFrame")
    vu203.Size = UDim2.new(1, - 20, 1, - 20)
    vu203.Position = UDim2.new(0, 10, 0, 10)
    vu203.BackgroundTransparency = 1
    vu203.ScrollBarThickness = 2
    vu203.ScrollBarImageColor3 = vu19.Accent
    vu203.Visible = false
    vu203.Parent = vu193
    local vu204 = Instance.new("UIListLayout")
    vu204.Parent = vu203
    vu204.SortOrder = Enum.SortOrder.LayoutOrder
    vu204.Padding = UDim.new(0, 10)
    local v205 = vu204
    vu204.GetPropertyChangedSignal(v205, "AbsoluteContentSize"):Connect(function()
        vu203.CanvasSize = UDim2.new(0, 0, 0, vu204.AbsoluteContentSize.Y + 20)
    end)
    local function v210()
        local v206, v207, v208 = pairs(vu194)
        while true do
            local v209
            v208, v209 = v206(v207, v208)
            if v208 == nil then
                break
            end
            vu25(v209.Img, {
                ImageColor3 = vu19.TextDim
            })
            vu25(v209.Txt, {
                TextColor3 = vu19.TextDim
            })
            vu25(v209.Ind, {
                BackgroundTransparency = 1
            })
            v209.Page.Visible = false
        end
        vu25(vu200, {
            ImageColor3 = vu19.Accent
        })
        vu25(vu201, {
            TextColor3 = vu19.Text
        })
        vu25(vu202, {
            BackgroundTransparency = 0
        })
        vu203.Visible = true
    end
    v199.MouseButton1Click:Connect(v210)
    local v211 = {
        Btn = v199,
        Txt = vu201,
        Img = vu200,
        Ind = vu202,
        Page = vu203
    }
    table.insert(vu194, v211)
    if # vu194 == 1 then
        v210()
    end
    v198.Page = vu203
    function v198.Section(_, p212)
        local v213 = Instance.new("Frame")
        v213.Size = UDim2.new(1, 0, 0, 30)
        v213.BackgroundTransparency = 1
        v213.Parent = vu203
        local v214 = Instance.new("TextLabel")
        v214.Text = string.upper(p212)
        v214.Font = Enum.Font.GothamBold
        v214.TextSize = 11
        v214.TextColor3 = vu19.Accent
        v214.Size = UDim2.new(1, 0, 1, 0)
        v214.BackgroundTransparency = 1
        v214.TextXAlignment = Enum.TextXAlignment.Left
        v214.TextYAlignment = Enum.TextYAlignment.Bottom
        v214.Parent = v213
        local v215 = Instance.new("Frame")
        v215.Size = UDim2.new(1, 0, 0, 1)
        v215.Position = UDim2.new(0, 0, 1, 0)
        v215.BackgroundColor3 = vu19.Stroke
        v215.BorderSizePixel = 0
        v215.Parent = v213
    end
    function v198.Toggle(_, p216, p217, pu218)
        local v219 = Instance.new("Frame")
        v219.Size = UDim2.new(1, 0, 0, 42)
        v219.BackgroundColor3 = vu19.Section
        v219.Parent = vu203
        vu29(v219, 8)
        vu35(v219, vu19.Stroke, 1)
        local vu220 = Instance.new("TextLabel")
        vu220.Text = p216
        vu220.Font = Enum.Font.GothamMedium
        vu220.TextSize = 13
        vu220.TextColor3 = vu19.TextDim
        vu220.Size = UDim2.new(1, - 60, 1, 0)
        vu220.Position = UDim2.new(0, 15, 0, 0)
        vu220.BackgroundTransparency = 1
        vu220.TextXAlignment = Enum.TextXAlignment.Left
        vu220.Parent = v219
        local vu221 = Instance.new("Frame")
        vu221.Size = UDim2.new(0, 42, 0, 24)
        vu221.Position = UDim2.new(1, - 52, 0.5, - 12)
        vu221.BackgroundColor3 = vu19.Main
        vu221.Parent = v219
        vu29(vu221, 12)
        local vu222 = vu35(vu221, vu19.Stroke, 1)
        local vu223 = Instance.new("Frame")
        vu223.Size = UDim2.new(0, 18, 0, 18)
        vu223.Position = UDim2.new(0, 3, 0.5, - 9)
        vu223.BackgroundColor3 = vu19.TextDim
        vu223.Parent = vu221
        vu29(vu223, 9)
        local v224 = Instance.new("TextButton")
        v224.Size = UDim2.new(1, 0, 1, 0)
        v224.BackgroundTransparency = 1
        v224.Text = ""
        v224.Parent = v219
        local vu225 = p217 or false
        local function vu226()
            if vu225 then
                vu25(vu221, {
                    BackgroundColor3 = vu19.Accent
                })
                vu25(vu222, {
                    Color = vu19.AccentGlow,
                    Transparency = 0.5
                })
                vu25(vu223, {
                    Position = UDim2.new(1, - 21, 0.5, - 9),
                    BackgroundColor3 = vu19.Text
                })
                vu25(vu220, {
                    TextColor3 = vu19.Text
                })
            else
                vu25(vu221, {
                    BackgroundColor3 = vu19.Main
                })
                vu25(vu222, {
                    Color = vu19.Stroke,
                    Transparency = 0
                })
                vu25(vu223, {
                    Position = UDim2.new(0, 3, 0.5, - 9),
                    BackgroundColor3 = vu19.TextDim
                })
                vu25(vu220, {
                    TextColor3 = vu19.TextDim
                })
            end
            pu218(vu225)
        end
        local v228 = {
            Set = function(_, p227)
                vu225 = p227
                vu226()
            end
        }
        v224.MouseButton1Click:Connect(function()
            vu225 = not vu225
            vu226()
        end)
        if vu225 then
            vu226()
        end
        return v228
    end
    function v198.Slider(_, p229, pu230, pu231, p232, pu233)
        local v234 = Instance.new("Frame")
        v234.Size = UDim2.new(1, 0, 0, 60)
        v234.BackgroundColor3 = vu19.Section
        v234.Parent = vu203
        vu29(v234, 8)
        vu35(v234, vu19.Stroke, 1)
        local v235 = Instance.new("TextLabel")
        v235.Text = p229
        v235.Font = Enum.Font.GothamMedium
        v235.TextSize = 13
        v235.TextColor3 = vu19.TextDim
        v235.Position = UDim2.new(0, 15, 0, 10)
        v235.Size = UDim2.new(1, - 30, 0, 20)
        v235.BackgroundTransparency = 1
        v235.TextXAlignment = Enum.TextXAlignment.Left
        v235.Parent = v234
        local vu236 = Instance.new("TextLabel")
        vu236.Text = tostring(p232)
        vu236.Font = Enum.Font.GothamBold
        vu236.TextSize = 13
        vu236.TextColor3 = vu19.Accent
        vu236.Position = UDim2.new(1, - 40, 0, 10)
        vu236.Size = UDim2.new(0, 25, 0, 20)
        vu236.BackgroundTransparency = 1
        vu236.TextXAlignment = Enum.TextXAlignment.Right
        vu236.Parent = v234
        local vu237 = Instance.new("Frame")
        vu237.Size = UDim2.new(1, - 30, 0, 6)
        vu237.Position = UDim2.new(0, 15, 0, 42)
        vu237.BackgroundColor3 = vu19.Main
        vu237.Parent = v234
        vu29(vu237, 3)
        local vu238 = Instance.new("Frame")
        vu238.Size = UDim2.new(0, 0, 1, 0)
        vu238.BackgroundColor3 = vu19.Accent
        vu238.Parent = vu237
        vu29(vu238, 3)
        local vu239 = Instance.new("Frame")
        vu239.Size = UDim2.new(0, 14, 0, 14)
        vu239.Position = UDim2.new(0, 0, 0.5, - 7)
        vu239.BackgroundColor3 = vu19.Text
        vu239.Parent = vu237
        vu29(vu239, 7)
        local vu240 = vu35(vu239, vu19.Accent, 1)
        local vu241 = false
        local function vu245(p242)
            local v243 = UDim2.new(math.clamp((p242.Position.X - vu237.AbsolutePosition.X) / vu237.AbsoluteSize.X, 0, 1), 0, 0, 0)
            local v244 = math.floor(pu230 + (pu231 - pu230) * v243.X.Scale)
            vu25(vu238, {
                Size = UDim2.new(v243.X.Scale, 0, 1, 0)
            }, 0.1)
            vu25(vu239, {
                Position = UDim2.new(v243.X.Scale, 0, 0.5, - 7)
            }, 0.1)
            vu236.Text = tostring(v244)
            pu233(v244)
        end
        vu239.InputBegan:Connect(function(p246)
            if p246.UserInputType == Enum.UserInputType.MouseButton1 then
                vu241 = true
                vu25(vu239, {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new(vu239.Position.X.Scale, 0, 0.5, - 9)
                })
                vu25(vu240, {
                    Transparency = 0.5
                })
            end
        end)
        vu6.InputEnded:Connect(function(p247)
            if p247.UserInputType == Enum.UserInputType.MouseButton1 then
                vu241 = false
                vu25(vu239, {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(vu239.Position.X.Scale, 0, 0.5, - 7)
                })
                vu25(vu240, {
                    Transparency = 0
                })
            end
        end)
        vu6.InputChanged:Connect(function(p248)
            if vu241 and p248.UserInputType == Enum.UserInputType.MouseMovement then
                vu245(p248)
            end
        end)
        local v249 = (p232 - pu230) / (pu231 - pu230)
        vu25(vu238, {
            Size = UDim2.new(v249, 0, 1, 0)
        })
        vu25(vu239, {
            Position = UDim2.new(v249, 0, 0.5, - 7)
        })
    end
    function v198.Button(_, p250, p251)
        local vu252 = Instance.new("Frame")
        vu252.Size = UDim2.new(1, 0, 0, 36)
        vu252.BackgroundColor3 = vu19.Section
        vu252.Parent = vu203
        vu29(vu252, 8)
        vu35(vu252, vu19.Stroke, 1)
        local v253 = Instance.new("TextButton")
        v253.Size = UDim2.new(1, 0, 1, 0)
        v253.BackgroundTransparency = 1
        v253.Text = p250
        v253.TextColor3 = vu19.Text
        v253.Font = Enum.Font.GothamMedium
        v253.TextSize = 13
        v253.Parent = vu252
        v253.MouseEnter:Connect(function()
            vu25(vu252, {
                BackgroundColor3 = vu19.Sidebar
            })
        end)
        v253.MouseLeave:Connect(function()
            vu25(vu252, {
                BackgroundColor3 = vu19.Section
            })
        end)
        v253.MouseButton1Click:Connect(p251)
    end
    function v198.Keybind(_, p254, p255, pu256)
        local v257 = Instance.new("Frame")
        v257.Size = UDim2.new(1, 0, 0, 42)
        v257.BackgroundColor3 = vu19.Section
        v257.Parent = vu203
        vu29(v257, 8)
        vu35(v257, vu19.Stroke, 1)
        local v258 = Instance.new("TextLabel")
        v258.Text = p254
        v258.Font = Enum.Font.GothamMedium
        v258.TextSize = 13
        v258.TextColor3 = vu19.Text
        v258.Size = UDim2.new(0.6, 0, 1, 0)
        v258.Position = UDim2.new(0, 15, 0, 0)
        v258.BackgroundTransparency = 1
        v258.TextXAlignment = Enum.TextXAlignment.Left
        v258.Parent = v257
        local vu259 = Instance.new("TextButton")
        vu259.Size = UDim2.new(0, 70, 0, 28)
        vu259.Position = UDim2.new(1, - 80, 0.5, - 14)
        vu259.BackgroundColor3 = vu19.Sidebar
        vu259.Text = p255 and p255.Name or "None"
        vu259.TextColor3 = vu19.TextDim
        vu259.Font = Enum.Font.GothamBold
        vu259.TextSize = 12
        vu259.Parent = v257
        vu29(vu259, 6)
        vu35(vu259, vu19.Stroke, 1)
        local vu260 = false
        vu259.MouseButton1Click:Connect(function()
            if not vu260 then
                vu260 = true
                vu259.Text = "..."
                vu25(vu259, {
                    BackgroundColor3 = vu19.Accent
                })
                vu259.TextColor3 = vu19.Text
            end
        end)
        vu6.InputBegan:Connect(function(p261, p262)
            if not p262 then
                if vu260 and p261.UserInputType == Enum.UserInputType.Keyboard then
                    vu260 = false
                    vu259.Text = p261.KeyCode.Name
                    vu259.TextColor3 = vu19.TextDim
                    vu25(vu259, {
                        BackgroundColor3 = vu19.Sidebar
                    })
                    pu256(p261.KeyCode)
                end
            end
        end)
    end
    return v198
end
local v264 = v263("Auto Farm", v195.AutoFarm)
local v265 = v263("Movement", v195.Movement)
local v266 = v263("Combat", v195.Combat)
local v267 = v263("Misc", v195.Misc)
local v268 = v263("Settings", v195.Settings)
v264:Section("Coin Collection")
v264:Toggle("Auto Coin Collect", vu10.AutoCoinCollect, function(p269)
    vu10.AutoCoinCollect = p269
    if p269 then
        vu162()
        vu53("Auto Farm", "Enabled! (Only works for Hiders)", 2)
    else
        vu163()
        vu53("Auto Farm", "Coin collection stopped", 2)
    end
end)
v264:Slider("Collection Delay", 0, 2, vu10.CoinCollectDelay, function(p270)
    vu10.CoinCollectDelay = p270 / 10
end)
v265:Section("Speed Boost")
v265:Toggle("Enable Speed Boost", vu10.SpeedEnabled, function(p271)
    vu10.SpeedEnabled = p271
    vu93()
    vu53("Speed Boost", p271 and "Enabled" or "Disabled", 2)
end)
v265:Slider("Walk Speed", 16, 200, vu10.SpeedValue, function(p272)
    vu10.SpeedValue = p272
    vu93()
end)
v265:Section("Jump Power")
v265:Toggle("Enable Jump Power", vu10.JumpPowerEnabled, function(p273)
    vu10.JumpPowerEnabled = p273
    vu103()
    vu53("Jump Power", p273 and "Enabled" or "Disabled", 2)
end)
v265:Slider("Jump Power", 50, 200, vu10.JumpPowerValue, function(p274)
    vu10.JumpPowerValue = p274
    vu103()
end)
v265:Section("Advanced Movement")
v265:Toggle("Noclip (Walk Through Walls)", vu10.NoclipEnabled, function(p275)
    vu10.NoclipEnabled = p275
    vu102()
    vu53("Noclip", p275 and "Enabled - Walk through walls!" or "Disabled", 2)
end)
v265:Toggle("Fly", vu10.FlyEnabled, function(p276)
    vu10.FlyEnabled = p276
    vu109()
    vu53("Fly", p276 and "Enabled - Use WASD, Space, Shift" or "Disabled", 2)
end)
v265:Slider("Fly Speed", 16, 200, vu10.FlySpeed, function(p277)
    vu10.FlySpeed = p277
end)
v266:Section("Auto-Kill (Seeker)")
v266:Toggle("Auto-Kill", vu10.AutoKillEnabled, function(p278)
    vu10.AutoKillEnabled = p278
    if p278 then
        vu147()
        vu53("Auto-Kill", "Enabled! (Only works for Seekers)", 2)
    else
        vu148()
        vu53("Auto-Kill", "Disabled", 2)
    end
end)
v267:Section("ESP Settings")
v267:Toggle("Player ESP", vu10.PlayerESP, function(p279)
    vu10.PlayerESP = p279
    vu79()
    vu53("Player ESP", p279 and "Enabled" or "Disabled", 2)
end)
v267:Toggle("Coin ESP", vu10.CoinESP, function(p280)
    vu10.CoinESP = p280
    vu92()
    vu53("Coin ESP", p280 and "Enabled" or "Disabled", 2)
end)
v267:Section("Visual Settings")
v267:Toggle("Fullbright", vu10.Fullbright, function(p281)
    vu10.Fullbright = p281
    vu115()
    vu53("Fullbright", p281 and "Enabled" or "Disabled", 2)
end)
v267:Section("Other")
v267:Section("Player Teleport")
local vu282 = Instance.new("Frame")
vu282.Size = UDim2.new(1, 0, 0, 0)
vu282.BackgroundTransparency = 1
vu282.Parent = v267.Page or v267
local vu283 = Instance.new("UIListLayout")
vu283.Parent = vu282
vu283.SortOrder = Enum.SortOrder.LayoutOrder
vu283.Padding = UDim.new(0, 5)
local v284 = vu283
vu283.GetPropertyChangedSignal(v284, "AbsoluteContentSize"):Connect(function()
    vu282.Size = UDim2.new(1, 0, 0, vu283.AbsoluteContentSize.Y)
end)
local function vu343()
    local v285 = vu282
    local v286, v287, v288 = pairs(v285:GetChildren())
    while true do
        local v289
        v288, v289 = v286(v287, v288)
        if v288 == nil then
            break
        end
        if not v289:IsA("UIListLayout") then
            v289:Destroy()
        end
    end
    local v290 = vu1
    local v291, v292, v293 = pairs(v290:GetPlayers())
    local v294 = {}
    local v295 = {}
    local v296 = {}
    while true do
        local v297
        v293, v297 = v291(v292, v293)
        if v293 == nil then
            break
        end
        if v297 ~= vu8 and v297.Team then
            if v297.Team.Name ~= "Seeker" then
                if v297.Team.Name ~= "Hider" then
                    if v297.Team.Name == "Dead" then
                        table.insert(v294, v297)
                    end
                else
                    table.insert(v295, v297)
                end
            else
                table.insert(v296, v297)
            end
        end
    end
    if # v296 > 0 then
        local v298 = Instance.new("Frame")
        v298.Size = UDim2.new(1, 0, 0, 28)
        v298.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        v298.Parent = vu282
        vu29(v298, 8)
        local v299 = Instance.new("UIGradient")
        v299.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 50))
        })
        v299.Rotation = 90
        v299.Parent = v298
        local v300 = Instance.new("TextLabel")
        v300.Text = "SEEKERS"
        v300.Font = Enum.Font.GothamBold
        v300.TextSize = 13
        v300.TextColor3 = Color3.fromRGB(255, 255, 255)
        v300.Size = UDim2.new(1, - 20, 1, 0)
        v300.Position = UDim2.new(0, 10, 0, 0)
        v300.BackgroundTransparency = 1
        v300.TextXAlignment = Enum.TextXAlignment.Left
        v300.Parent = v298
        local v301, v302, v303 = ipairs(v296)
        while true do
            local vu304
            v303, vu304 = v301(v302, v303)
            if v303 == nil then
                break
            end
            local vu305 = Instance.new("Frame")
            vu305.Size = UDim2.new(1, 0, 0, 45)
            vu305.BackgroundColor3 = vu19.Section
            vu305.Parent = vu282
            vu29(vu305, 8)
            local vu306 = vu35(vu305, Color3.fromRGB(255, 100, 100), 1)
            vu306.Transparency = 0.7
            local vu307 = Instance.new("ImageLabel")
            vu307.Size = UDim2.new(0, 32, 0, 32)
            vu307.Position = UDim2.new(0, 8, 0.5, - 16)
            vu307.BackgroundColor3 = vu19.Main
            vu307.Parent = vu305
            vu29(vu307, 16)
            pcall(function()
                vu307.Image = vu1:GetUserThumbnailAsync(vu304.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            end)
            local v308 = Instance.new("TextLabel")
            v308.Text = vu304.DisplayName
            v308.Font = Enum.Font.GothamBold
            v308.TextSize = 13
            v308.TextColor3 = vu19.Text
            v308.Position = UDim2.new(0, 48, 0, 6)
            v308.Size = UDim2.new(0.6, - 48, 0, 16)
            v308.BackgroundTransparency = 1
            v308.TextXAlignment = Enum.TextXAlignment.Left
            v308.TextTruncate = Enum.TextTruncate.AtEnd
            v308.Parent = vu305
            local vu309 = Instance.new("TextLabel")
            vu309.Text = "..."
            vu309.Font = Enum.Font.GothamMedium
            vu309.TextSize = 11
            vu309.TextColor3 = vu19.TextDim
            vu309.Position = UDim2.new(0, 48, 0, 24)
            vu309.Size = UDim2.new(0.5, - 48, 0, 14)
            vu309.BackgroundTransparency = 1
            vu309.TextXAlignment = Enum.TextXAlignment.Left
            vu309.Parent = vu305
            task.spawn(function()
                while vu305.Parent do
                    if vu304.Character and vu304.Character:FindFirstChild("HumanoidRootPart") then
                        if vu8.Character and vu8.Character:FindFirstChild("HumanoidRootPart") then
                            local v310 = (vu304.Character.HumanoidRootPart.Position - vu8.Character.HumanoidRootPart.Position).Magnitude
                            vu309.Text = "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189 " .. math.floor(v310) .. "m"
                        end
                    else
                        vu309.Text = "\239\191\189\239\191\189 Not spawned"
                    end
                    task.wait(0.5)
                end
            end)
            local vu311 = Instance.new("TextButton")
            vu311.Size = UDim2.new(0, 80, 0, 30)
            vu311.Position = UDim2.new(1, - 88, 0.5, - 15)
            vu311.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            vu311.Text = "TP"
            vu311.TextColor3 = Color3.fromRGB(255, 255, 255)
            vu311.Font = Enum.Font.GothamBold
            vu311.TextSize = 13
            vu311.Parent = vu305
            vu29(vu311, 6)
            local v312 = Instance.new("UIGradient")
            v312.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 120)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 80, 80))
            })
            v312.Rotation = 45
            v312.Parent = vu311
            vu311.MouseButton1Click:Connect(function()
                if vu304.Character and vu304.Character:FindFirstChild("HumanoidRootPart") then
                    if vu8.Character and vu8.Character:FindFirstChild("HumanoidRootPart") then
                        vu8.Character.HumanoidRootPart.CFrame = vu304.Character.HumanoidRootPart.CFrame
                        vu53("Teleported", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189 " .. vu304.DisplayName, 2)
                    end
                else
                    vu53("Error", "Player not spawned!", 2)
                end
            end)
            vu311.MouseEnter:Connect(function()
                vu25(vu311, {
                    Size = UDim2.new(0, 85, 0, 32)
                })
                vu25(vu306, {
                    Transparency = 0.3
                })
            end)
            vu311.MouseLeave:Connect(function()
                vu25(vu311, {
                    Size = UDim2.new(0, 80, 0, 30)
                })
                vu25(vu306, {
                    Transparency = 0.7
                })
            end)
        end
    end
    if # v295 > 0 then
        local v313 = Instance.new("Frame")
        v313.Size = UDim2.new(1, 0, 0, 28)
        v313.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        v313.Parent = vu282
        vu29(v313, 8)
        local v314 = Instance.new("UIGradient")
        v314.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 170, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 130, 220))
        })
        v314.Rotation = 90
        v314.Parent = v313
        local v315 = Instance.new("TextLabel")
        v315.Text = "HIDERS"
        v315.Font = Enum.Font.GothamBold
        v315.TextSize = 13
        v315.TextColor3 = Color3.fromRGB(255, 255, 255)
        v315.Size = UDim2.new(1, - 20, 1, 0)
        v315.Position = UDim2.new(0, 10, 0, 0)
        v315.BackgroundTransparency = 1
        v315.TextXAlignment = Enum.TextXAlignment.Left
        v315.Parent = v313
        local v316, v317, v318 = ipairs(v295)
        while true do
            local vu319
            v318, vu319 = v316(v317, v318)
            if v318 == nil then
                break
            end
            local vu320 = Instance.new("Frame")
            vu320.Size = UDim2.new(1, 0, 0, 45)
            vu320.BackgroundColor3 = vu19.Section
            vu320.Parent = vu282
            vu29(vu320, 8)
            local vu321 = vu35(vu320, Color3.fromRGB(100, 150, 255), 1)
            vu321.Transparency = 0.7
            local vu322 = Instance.new("ImageLabel")
            vu322.Size = UDim2.new(0, 32, 0, 32)
            vu322.Position = UDim2.new(0, 8, 0.5, - 16)
            vu322.BackgroundColor3 = vu19.Main
            vu322.Parent = vu320
            vu29(vu322, 16)
            pcall(function()
                vu322.Image = vu1:GetUserThumbnailAsync(vu319.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            end)
            local v323 = Instance.new("TextLabel")
            v323.Text = vu319.DisplayName
            v323.Font = Enum.Font.GothamBold
            v323.TextSize = 13
            v323.TextColor3 = vu19.Text
            v323.Position = UDim2.new(0, 48, 0, 6)
            v323.Size = UDim2.new(0.6, - 48, 0, 16)
            v323.BackgroundTransparency = 1
            v323.TextXAlignment = Enum.TextXAlignment.Left
            v323.TextTruncate = Enum.TextTruncate.AtEnd
            v323.Parent = vu320
            local vu324 = Instance.new("TextLabel")
            vu324.Text = "..."
            vu324.Font = Enum.Font.GothamMedium
            vu324.TextSize = 11
            vu324.TextColor3 = vu19.TextDim
            vu324.Position = UDim2.new(0, 48, 0, 24)
            vu324.Size = UDim2.new(0.5, - 48, 0, 14)
            vu324.BackgroundTransparency = 1
            vu324.TextXAlignment = Enum.TextXAlignment.Left
            vu324.Parent = vu320
            task.spawn(function()
                while vu320.Parent do
                    if vu319.Character and vu319.Character:FindFirstChild("HumanoidRootPart") then
                        if vu8.Character and vu8.Character:FindFirstChild("HumanoidRootPart") then
                            local v325 = (vu319.Character.HumanoidRootPart.Position - vu8.Character.HumanoidRootPart.Position).Magnitude
                            vu324.Text = "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189 " .. math.floor(v325) .. "m"
                        end
                    else
                        vu324.Text = "\239\191\189\239\191\189 Not spawned"
                    end
                    task.wait(0.5)
                end
            end)
            local vu326 = Instance.new("TextButton")
            vu326.Size = UDim2.new(0, 80, 0, 30)
            vu326.Position = UDim2.new(1, - 88, 0.5, - 15)
            vu326.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            vu326.Text = "TP"
            vu326.TextColor3 = Color3.fromRGB(255, 255, 255)
            vu326.Font = Enum.Font.GothamBold
            vu326.TextSize = 13
            vu326.Parent = vu320
            vu29(vu326, 6)
            local v327 = Instance.new("UIGradient")
            v327.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 170, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 130, 220))
            })
            v327.Rotation = 45
            v327.Parent = vu326
            vu326.MouseButton1Click:Connect(function()
                if vu319.Character and vu319.Character:FindFirstChild("HumanoidRootPart") then
                    if vu8.Character and vu8.Character:FindFirstChild("HumanoidRootPart") then
                        vu8.Character.HumanoidRootPart.CFrame = vu319.Character.HumanoidRootPart.CFrame
                        vu53("Teleported", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189 " .. vu319.DisplayName, 2)
                    end
                else
                    vu53("Error", "Player not spawned!", 2)
                end
            end)
            vu326.MouseEnter:Connect(function()
                vu25(vu326, {
                    Size = UDim2.new(0, 85, 0, 32)
                })
                vu25(vu321, {
                    Transparency = 0.3
                })
            end)
            vu326.MouseLeave:Connect(function()
                vu25(vu326, {
                    Size = UDim2.new(0, 80, 0, 30)
                })
                vu25(vu321, {
                    Transparency = 0.7
                })
            end)
        end
    end
    if # v294 > 0 then
        local v328 = Instance.new("Frame")
        v328.Size = UDim2.new(1, 0, 0, 28)
        v328.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        v328.Parent = vu282
        vu29(v328, 8)
        local v329 = Instance.new("UIGradient")
        v329.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 120)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 70, 70))
        })
        v329.Rotation = 90
        v329.Parent = v328
        local v330 = Instance.new("TextLabel")
        v330.Text = "DEAD"
        v330.Font = Enum.Font.GothamBold
        v330.TextSize = 13
        v330.TextColor3 = Color3.fromRGB(255, 255, 255)
        v330.Size = UDim2.new(1, - 20, 1, 0)
        v330.Position = UDim2.new(0, 10, 0, 0)
        v330.BackgroundTransparency = 1
        v330.TextXAlignment = Enum.TextXAlignment.Left
        v330.Parent = v328
        local v331, v332, v333 = ipairs(v294)
        while true do
            local vu334
            v333, vu334 = v331(v332, v333)
            if v333 == nil then
                break
            end
            local vu335 = Instance.new("Frame")
            vu335.Size = UDim2.new(1, 0, 0, 45)
            vu335.BackgroundColor3 = vu19.Section
            vu335.Parent = vu282
            vu29(vu335, 8)
            local vu336 = vu35(vu335, Color3.fromRGB(100, 100, 100), 1)
            vu336.Transparency = 0.7
            local vu337 = Instance.new("ImageLabel")
            vu337.Size = UDim2.new(0, 32, 0, 32)
            vu337.Position = UDim2.new(0, 8, 0.5, - 16)
            vu337.BackgroundColor3 = vu19.Main
            vu337.Parent = vu335
            vu29(vu337, 16)
            pcall(function()
                vu337.Image = vu1:GetUserThumbnailAsync(vu334.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            end)
            local v338 = Instance.new("TextLabel")
            v338.Size = UDim2.new(1, - 150, 0, 16)
            v338.Position = UDim2.new(0, 48, 0, 8)
            v338.BackgroundTransparency = 1
            v338.Font = Enum.Font.GothamBold
            v338.TextSize = 12
            v338.TextColor3 = vu19.Text
            v338.Text = vu334.DisplayName
            v338.TextXAlignment = Enum.TextXAlignment.Left
            v338.Parent = vu335
            local vu339 = Instance.new("TextLabel")
            vu339.Size = UDim2.new(1, - 150, 0, 14)
            vu339.Position = UDim2.new(0, 48, 0, 24)
            vu339.BackgroundTransparency = 1
            vu339.Font = Enum.Font.Gotham
            vu339.TextSize = 10
            vu339.TextColor3 = vu19.TextDim
            vu339.Text = "Calculating..."
            vu339.TextXAlignment = Enum.TextXAlignment.Left
            vu339.Parent = vu335
            task.spawn(function()
                while vu335.Parent do
                    if vu334.Character and vu334.Character:FindFirstChild("HumanoidRootPart") then
                        if vu8.Character and vu8.Character:FindFirstChild("HumanoidRootPart") then
                            local v340 = (vu334.Character.HumanoidRootPart.Position - vu8.Character.HumanoidRootPart.Position).Magnitude
                            vu339.Text = "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189 " .. math.floor(v340) .. "m"
                        end
                    else
                        vu339.Text = "\239\191\189\239\191\189 Not spawned"
                    end
                    task.wait(0.5)
                end
            end)
            local vu341 = Instance.new("TextButton")
            vu341.Size = UDim2.new(0, 80, 0, 30)
            vu341.Position = UDim2.new(1, - 88, 0.5, - 15)
            vu341.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            vu341.Text = "TP"
            vu341.TextColor3 = Color3.fromRGB(255, 255, 255)
            vu341.Font = Enum.Font.GothamBold
            vu341.TextSize = 13
            vu341.Parent = vu335
            vu29(vu341, 6)
            local v342 = Instance.new("UIGradient")
            v342.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 120)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))
            })
            v342.Rotation = 45
            v342.Parent = vu341
            vu341.MouseButton1Click:Connect(function()
                if vu334.Character and vu334.Character:FindFirstChild("HumanoidRootPart") then
                    if vu8.Character and vu8.Character:FindFirstChild("HumanoidRootPart") then
                        vu8.Character.HumanoidRootPart.CFrame = vu334.Character.HumanoidRootPart.CFrame
                        vu53("Teleported", "\239\191\189\239\191\189\239\184\143 " .. vu334.DisplayName, 2)
                    end
                else
                    vu53("Error", "Player not spawned!", 2)
                end
            end)
            vu341.MouseEnter:Connect(function()
                vu25(vu341, {
                    Size = UDim2.new(0, 85, 0, 32)
                })
                vu25(vu336, {
                    Transparency = 0.3
                })
            end)
            vu341.MouseLeave:Connect(function()
                vu25(vu341, {
                    Size = UDim2.new(0, 80, 0, 30)
                })
                vu25(vu336, {
                    Transparency = 0.7
                })
            end)
        end
    end
end
vu343()
task.spawn(function()
    while true do
        task.wait(3)
        vu343()
    end
end)
v268:Section("UI Configuration")
v268:Keybind("Toggle UI Key", vu18, function(p344)
    vu18 = p344
    vu53("Keybind Updated", "UI Toggle: " .. p344.Name, 2)
end)
v268:Section("Script Management")
v268:Button("Destroy UI (Unload)", function()
    if vu12 then
        vu12:Disconnect()
    end
    if vu13 then
        vu13:Disconnect()
    end
    vu10.AutoKillEnabled = false
    vu10.AutoCoinCollect = false
    vu10.SpeedEnabled = false
    vu10.Fullbright = false
    vu148()
    vu163()
    vu93()
    vu115()
    local v345, v346, v347 = pairs(vu11)
    while true do
        local v348
        v347, v348 = v345(v346, v347)
        if v347 == nil then
            break
        end
        if v348.Highlight then
            v348.Highlight:Destroy()
        end
        if v348.BillboardGui then
            v348.BillboardGui:Destroy()
        end
        if v348.Box then
            v348.Box:Destroy()
        end
    end
    vu165:Destroy()
    vu53("Noctyra Unloaded", "Script cleaned up successfully!", 3)
end)
wait(1)
vu53("Noctyra Loaded", "Hide or Die | Press K to toggle UI", 5)
