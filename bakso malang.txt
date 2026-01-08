local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Bakso Malang Hub",
   LoadingTitle = "Antigravity Script",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BaksoMalangHub",
      FileName = "Config"
   },
   KeySystem = false, 
})

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- === VARIABLES ===
local Config = {
    ESPEnabled = true,
    MAX_DISTANCE = 235,
    MAX_HEIGHT = 150,
    AutoSit = false,
    InstantInteract = false,
    WalkSpeedRaw = 16,
    WalkSpeedEnabled = false
}

local ActiveAnomalies = {}

-- === 1. TABS ===
local MainTab = Window:CreateTab("Main Features", 4483362458)
local ESPTab = Window:CreateTab("ESP Settings", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)


-- === 2. MAIN FEATURES ===
local MainSection = MainTab:CreateSection("Automation")

local ToggleAutoSit = MainTab:CreateToggle({
   Name = "Auto Sit (When Anomaly Nearby)",
   CurrentValue = false,
   Flag = "AutoSit",
   Callback = function(Value)
       Config.AutoSit = Value
   end,
})

local ButtonBakso = MainTab:CreateButton({
   Name = "Make Instant Bakso",
   Callback = function()
       pcall(function()
            local main = Workspace:WaitForChild("Main")
            local makeBakso = main:WaitForChild("MakeBakso")
            local packaging = makeBakso:WaitForChild("Packaging")
            local promptPart = packaging:WaitForChild("PromptPart")
            local prompt = promptPart:WaitForChild("Prompt")
            fireproximityprompt(prompt)
            Rayfield:Notify({Title = "Success", Content = "Bakso Made!", Duration = 3})
       end)
   end,
})

local ButtonEndShift = MainTab:CreateButton({
   Name = "End Shift (Teleport)",
   Callback = function()
       pcall(function()
            local main = Workspace:WaitForChild("Main")
            local endShift = main:WaitForChild("EndShift")
            local promptPart = endShift:WaitForChild("PromptPart")
            local prompt = promptPart:WaitForChild("Prompt")
            
            -- Teleport to end shift position
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-21, 6, -8))
                task.wait(0.5)
                fireproximityprompt(prompt)
                Rayfield:Notify({Title = "Success", Content = "Shift Ended!", Duration = 3})
            end
       end)
   end,
})


-- === 3. ESP SETTINGS ===
local SectionESP = ESPTab:CreateSection("ESP Controls")

local ToggleESP = ESPTab:CreateToggle({
   Name = "Enable ESP",
   CurrentValue = true,
   Flag = "ESPEnabled", 
   Callback = function(Value)
       Config.ESPEnabled = Value
   end,
})

local SliderDist = ESPTab:CreateSlider({
   Name = "Max Distance",
   Range = {0, 1000},
   Increment = 5,
   Suffix = "Studs",
   CurrentValue = 235,
   Flag = "MaxDist", 
   Callback = function(Value)
       Config.MAX_DISTANCE = Value
   end,
})

local SliderHeight = ESPTab:CreateSlider({
   Name = "Max Height",
   Range = {0, 500},
   Increment = 5,
   Suffix = "Studs",
   CurrentValue = 150,
   Flag = "MaxHeight", 
   Callback = function(Value)
       Config.MAX_HEIGHT = Value
   end,
})

-- === 4. MISC SETTINGS ===
local SectionMisc = MiscTab:CreateSection("Character & World")

local ToggleInstaInteract = MiscTab:CreateToggle({
   Name = "Instant Interact",
   CurrentValue = false,
   Flag = "InstantInteract",
   Callback = function(Value)
       Config.InstantInteract = Value
   end,
})

local ToggleSpeed = MiscTab:CreateToggle({
   Name = "Enable Speed Boost",
   CurrentValue = false,
   Flag = "SpeedEnabled",
   Callback = function(Value)
       Config.WalkSpeedEnabled = Value
   end,
})

local SliderSpeed = MiscTab:CreateSlider({
   Name = "WalkSpeed Amount",
   Range = {16, 100},
   Increment = 1,
   Suffix = "",
   CurrentValue = 16,
   Flag = "SpeedAmount",
   Callback = function(Value)
       Config.WalkSpeedRaw = Value
   end,
})


-- === LOGIC IMPLEMENTATION ===

-- Entities Lists

local ANOMALY_BLACKLIST = {
    "banaspati", "bolong" , "dukun", "genderuwo", "goblin", "jenglot", "jiangshi", "kuyang", "kuyangfly", "lampor", "mbakkun", "nona", "player", "pocong", "pocongred", "pontianak", "soldier","stare", "suster", "tuyul", "wayang", "wishiknew", "malang", "deathchar", "redpocongdukun", "nenek", "sawit", "fakes", "lorry", "poconglorry", "jinnchief", "pocongalley", "pocongbus", "bus", "kidnapped", "talisman", "npcdukun"
}
-- Helpers
-- Helpers
local function IsVisible(targetPart)
    if not targetPart then return false end
    local origin = Workspace.CurrentCamera.CFrame.Position
    local targetPos = targetPart.Position
    local direction = targetPos - origin
    local distance = direction.Magnitude
    
    -- Filter out the Local Character and the Target Entity completely
    local ignoreList = {LocalPlayer.Character, targetPart:FindFirstAncestorWhichIsA("Model") or targetPart.Parent, Workspace.CurrentCamera}
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = ignoreList

    -- Cast Ray
    local result = Workspace:Raycast(origin, direction, params)
    
    -- "Soft" Visibility Check: Ignore transparent parts or non-collidable parts (small debris)
    while result do
        local hitPart = result.Instance
        local hitMaterial = hitPart.Material
        
        -- Conditions to ignore the obstacle:
        -- 1. High Transparency (Glass, invisible walls)
        -- 2. CanCollide is false (Decoration, small grass)
        -- 3. Is a small part (optional, but checking CanCollide is usually enough)
        if hitPart.Transparency > 0.25 or not hitPart.CanCollide or hitPart.Name == "HumanoidRootPart" then
            -- Add to ignore list and raycast again from hit position
            table.insert(ignoreList, hitPart)
            params.FilterDescendantsInstances = ignoreList
            result = Workspace:Raycast(origin, direction, params)
        else
            -- Hit a solid, visible obstacle
            return false
        end
    end
    
    return true
end

local function GetEntityType(model)
    if Players:GetPlayerFromCharacter(model) then return "PLAYER" end
    local name = model.Name:lower()
    local parent = (model.Parent and model.Parent.Name) or ""
    
    if parent == "Anomalies" or parent == "Entities" or parent == "HorrorEntities" then return "ANOMALY" end
    for _, word in pairs(ANOMALY_BLACKLIST) do if string.find(name, word) then return "ANOMALY" end end

    if model:GetAttribute("IsAnomaly") or model:FindFirstChild("Jumpscare") then return "ANOMALY" end
    if model:FindFirstChild("Humanoid") then return "NPC" end
    return nil
end

local function ShouldShow(model)
    -- Prioritize Head as it's usually higher and less obstructed
    local part = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
    if not part or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end
    
    -- Check Visibility
    if not IsVisible(part) then return false end

    local dist = (part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local height = part.Position.Y
    return dist <= Config.MAX_DISTANCE and height <= Config.MAX_HEIGHT and height >= -20
end

local function AddESP(model)
    if model:FindFirstChild("BALANCE_ESP_TAG") or model == LocalPlayer.Character then return end
    local entityType = GetEntityType(model)
    if not entityType then return end

    -- Track Anomalies
    if entityType == "ANOMALY" then
        if not table.find(ActiveAnomalies, model) then
            table.insert(ActiveAnomalies, model)
        end
    end

    local bill = Instance.new("BillboardGui")
    bill.Name = "BALANCE_ESP_TAG"
    bill.Parent = model
    bill.Size = UDim2.new(0, 250, 0, 70)
    bill.StudsOffset = Vector3.new(0, 4, 0)
    bill.AlwaysOnTop = true
    bill.Adornee = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart

    local text = Instance.new("TextLabel", bill)
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(1,0,1,0)
    text.Font = Enum.Font.GothamBold
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.new(0,0,0)
    text.TextSize = 22

    task.spawn(function()
        while model and model.Parent do
            if Config.ESPEnabled and ShouldShow(model) then
                bill.Enabled = true
                local part = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model.PrimaryPart
                if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude
                    if entityType == "PLAYER" then
                        text.Text = "PLAYER\n" .. math.floor(dist) .. "m"
                        text.TextColor3 = Color3.fromRGB(80, 180, 255)
                    elseif entityType == "ANOMALY" then
                        -- Change Name to specific model Name
                        text.Text = string.upper(model.Name) .. "\n" .. math.floor(dist) .. "m"
                        text.TextColor3 = Color3.fromRGB(255, 30, 30)
                    else 
                        -- Also specific name for NPCs
                        text.Text = string.upper(model.Name) .. "\n" .. math.floor(dist) .. "m"
                        text.TextColor3 = Color3.fromRGB(50, 255, 100)
                    end
                end
            else
                bill.Enabled = false
            end
            task.wait(0.15)
        end
        bill:Destroy()
        
        -- Cleanup Tracking
        if entityType == "ANOMALY" then
            local idx = table.find(ActiveAnomalies, model)
            if idx then table.remove(ActiveAnomalies, idx) end
        end
    end)
end

-- ESP Init
for _, v in ipairs(Workspace:GetDescendants()) do if v:IsA("Model") then task.spawn(AddESP, v) end end
Workspace.DescendantAdded:Connect(function(v) if v:IsA("Model") then task.wait(1.2) if v.Parent then task.spawn(AddESP, v) end end end)


-- === BACKGROUND LOOPS (Auto Sit, Interact, Speed) ===
local LastInteractCheck = 0

RunService.Heartbeat:Connect(function()
    -- Speed
    if Config.WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.WalkSpeedRaw
    end

    -- Instant Interact (Throttled)
    if Config.InstantInteract then
        if tick() - LastInteractCheck > 0.5 then
            LastInteractCheck = tick()
            for _, prompt in pairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    prompt.HoldDuration = 0
                end
            end
        end
    end

    -- Auto Sit
    if Config.AutoSit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        -- Check for nearby anomaly using Cached List
        local anomalyNearby = false
        
        for _, obj in pairs(ActiveAnomalies) do
            if obj and obj.Parent and obj:FindFirstChild("HumanoidRootPart") then
                 local objHrp = obj.HumanoidRootPart
                 local distance = (hrp.Position - objHrp.Position).Magnitude
                 if distance < 200 then
                     -- Check Visibility for Auto Sit
                     if IsVisible(objHrp) then
                        anomalyNearby = true
                        break
                     end
                 end
            end
        end
        
        -- Chair Positions (from known locations)
        local ChairPositions = {
            Vector3.new(-2, 4, -2),
            Vector3.new(-2, 4, -8),
            Vector3.new(-2, 4, -11),
            Vector3.new(5, 4, -2),
            Vector3.new(5, 4, -8),
            Vector3.new(5, 4, -11)
        }

        if anomalyNearby and humanoid and not humanoid.Sit then
            -- Find closest chair
            local targetPos = nil
            local minChairDist = math.huge
            
            for _, pos in ipairs(ChairPositions) do
                local dist = (hrp.Position - pos).Magnitude
                if dist < minChairDist then
                    minChairDist = dist
                    targetPos = pos
                end
            end

            -- Teleport and Sit
            if targetPos then
                hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0)) -- Teleport slightly above
                task.wait(0.1)
                humanoid.Sit = true
            else
                -- Fallback if no chair found nearby
                humanoid.Sit = true
            end
        end
    end
end)

-- === 5. HOTKEYS ===
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.R then
       pcall(function()
            local main = Workspace:WaitForChild("Main")
            local makeBakso = main:WaitForChild("MakeBakso")
            local packaging = makeBakso:WaitForChild("Packaging")
            local promptPart = packaging:WaitForChild("PromptPart")
            local prompt = promptPart:WaitForChild("Prompt")
            fireproximityprompt(prompt)
            Rayfield:Notify({Title = "Success", Content = "Bakso Made (Hotkey R)!", Duration = 2})
       end)
    end
end)

Rayfield:Notify({
   Title = "Loaded",
   Content = "Bakso Malang Hub Ready!",
   Duration = 5,
   Image = 4483362458,
})
