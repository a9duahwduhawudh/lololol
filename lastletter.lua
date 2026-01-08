local Players = game:GetService("Players")
local LogService = game:GetService("LogService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Configuration
local Config = {
    MinWordLength = 1,
    MaxWordLength = 100,
    AutoTypingEnabled = true,

    TypingProfile = "balanced",

    Profiles = {
        fast     = { MinDelay = 25,  MaxDelay = 55,  PreferMinLen = 3,  PreferMaxLen = 6,  ThinkDelayMin = 200,  ThinkDelayMax = 800  },
        balanced = { MinDelay = 35,  MaxDelay = 75,  PreferMinLen = 4,  PreferMaxLen = 8,  ThinkDelayMin = 400,  ThinkDelayMax = 1200 },
        safe     = { MinDelay = 45,  MaxDelay = 95,  PreferMinLen = 5,  PreferMaxLen = 10, ThinkDelayMin = 600,  ThinkDelayMax = 1600 },
        chaos    = { MinDelay = 20,  MaxDelay = 50,  PreferMinLen = 10, PreferMaxLen = 20, ThinkDelayMin = 100,  ThinkDelayMax = 500  }
    },

    ExtraBackspacesAfterClear = 3,
    PressEnterAfterClear = true,

    PrimarySource = "https://raw.githubusercontent.com/rakkgurame-glitch/word/refs/heads/main/main.txt",
    SecondarySource = "https://raw.githubusercontent.com/rakkgurame-glitch/word/refs/heads/main/second.txt"
}

local PrefixCache = {}
local SecondaryCache = {}
local UsedWords = {}
local PrimaryLoaded = false
local SecondaryLoaded = false
local IsTyping = false
local LastDetectionTime = 0
local DETECTION_COOLDOWN = 0.35

local function SendNotification(text, duration)
    duration = duration or 2
    StarterGui:SetCore("SendNotification", {
        Title = "Noctyra HUB",
        Text = text,
        Duration = duration,
        Icon = "rbxassetid://4483345998"
    })
end

local KeyMap = {
    a = Enum.KeyCode.A, b = Enum.KeyCode.B, c = Enum.KeyCode.C, d = Enum.KeyCode.D,
    e = Enum.KeyCode.E, f = Enum.KeyCode.F, g = Enum.KeyCode.G, h = Enum.KeyCode.H,
    i = Enum.KeyCode.I, j = Enum.KeyCode.J, k = Enum.KeyCode.K, l = Enum.KeyCode.L,
    m = Enum.KeyCode.M, n = Enum.KeyCode.N, o = Enum.KeyCode.O, p = Enum.KeyCode.P,
    q = Enum.KeyCode.Q, r = Enum.KeyCode.R, s = Enum.KeyCode.S, t = Enum.KeyCode.T,
    u = Enum.KeyCode.U, v = Enum.KeyCode.V, w = Enum.KeyCode.W, x = Enum.KeyCode.X,
    y = Enum.KeyCode.Y, z = Enum.KeyCode.Z,
    [" "] = Enum.KeyCode.Space
}

local function TypeWord(prefix, fullWord)
    local profile = Config.Profiles[Config.TypingProfile]
    
    local thinkDelay = math.random(profile.ThinkDelayMin, profile.ThinkDelayMax) / 1000
    task.wait(thinkDelay)

    local vim = VirtualInputManager
    local camera = Workspace.CurrentCamera
    local centerX, centerY = camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2

    for _ = 1, 3 do
        vim:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
        task.wait(0.05)
        vim:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
        task.wait(0.05)
    end

    local remainingText = fullWord:sub(#prefix + 1)
    local typedCharacterCount = 0

    for i = 1, #remainingText do
        local char = remainingText:sub(i, i):lower()

        if KeyMap[char] then
            vim:SendKeyEvent(true, KeyMap[char], false, game)
            task.wait(math.random(profile.MinDelay, profile.MaxDelay) / 1000)
            vim:SendKeyEvent(false, KeyMap[char], false, game)

            local delay = math.random(profile.MinDelay, profile.MaxDelay)
            if typedCharacterCount > 5 then
                delay = delay * 0.85
            end
            task.wait(delay / 1000)

            typedCharacterCount += 1
        end
    end

    task.wait(math.random(80, 150) / 1000)
    vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    task.wait(0.04)
    vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    task.wait(0.1)

    for _ = 1, typedCharacterCount do
        vim:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game)
        task.wait(math.random(profile.MinDelay, profile.MaxDelay) / 1000)
        vim:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
        task.wait(math.random(profile.MinDelay, profile.MaxDelay) / 1000)
    end

    for _ = 1, Config.ExtraBackspacesAfterClear do
        vim:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game)
        task.wait(math.random(25, 45) / 1000)
        vim:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)
        task.wait(math.random(25, 45) / 1000)
    end

    if Config.PressEnterAfterClear then
        task.wait(0.05)
        vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.02)
        vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    end

    IsTyping = false
end

local function LoadDictionaryFromURL(url)
    local requestFunc = (syn and syn.request) or (http and http.request) or http_request or request
    if not requestFunc then
        return nil, "HTTP request not available"
    end

    local success, response = pcall(function()
        return requestFunc({
            Url = url,
            Method = "GET"
        })
    end)

    if not success or not response then
        return nil, "Failed to fetch from URL"
    end

    local body = typeof(response) == "table" and response.Body or response
    return body, nil
end

local function ProcessDictionaryText(text, targetCache)
    local wordCount = 0
    
    for line in text:gmatch("[^\r\n]+") do
        local word = line:lower():match("^%s*(.-)%s*$")
        if word and #word >= Config.MinWordLength and #word <= Config.MaxWordLength and word:match("^[a-z]+$") then
            for prefixLen = 1, math.min(4, #word) do
                local prefix = word:sub(1, prefixLen)
                targetCache[prefix] = targetCache[prefix] or {}
                table.insert(targetCache[prefix], word)
            end
            wordCount += 1
        end
    end
    
    return wordCount
end

local function LoadPrimaryDictionary()
    SendNotification("Loading primary source...", 2)
    local body, error = LoadDictionaryFromURL(Config.PrimarySource)
    
    if body then
        local wordCount = ProcessDictionaryText(body, PrefixCache)
        PrimaryLoaded = true
        SendNotification("✓ Primary: " .. wordCount .. " words", 3)
    else
        SendNotification("❌ Primary source failed", 3)
        warn("Primary dictionary error: " .. (error or "Unknown"))
    end
end

local function LoadSecondaryDictionary()
    if SecondaryLoaded then return end
    
    SendNotification("Loading backup source...", 2)
    local body, error = LoadDictionaryFromURL(Config.SecondarySource)
    
    if body then
        local wordCount = ProcessDictionaryText(body, SecondaryCache)
        SecondaryLoaded = true
        SendNotification("✓ Backup: " .. wordCount .. " words", 3)
    else
        SendNotification("❌ Backup source failed", 3)
        warn("Secondary dictionary error: " .. (error or "Unknown"))
    end
end

task.spawn(LoadPrimaryDictionary)

local function SelectWord(prefix)
    local profile = Config.Profiles[Config.TypingProfile]
    
    local pool = PrefixCache[prefix]
    
    if not pool or #pool == 0 then
        if not SecondaryLoaded then
            SendNotification("🔄 Loading backup for: " .. prefix:upper(), 2)
            LoadSecondaryDictionary()
        end
        
        pool = SecondaryCache[prefix]
        
        if not pool or #pool == 0 then
            SendNotification("❌ Prefix not found: " .. prefix:upper(), 3)
            return nil
        end
        
        SendNotification("✓ Using backup for: " .. prefix:upper(), 2)
    end
    
    UsedWords[prefix] = UsedWords[prefix] or {}
    
    local preferredWords = {}
    for _, word in ipairs(pool) do
        local wordLength = #word
        if not UsedWords[prefix][word] and wordLength >= profile.PreferMinLen and wordLength <= profile.PreferMaxLen then
            table.insert(preferredWords, word)
        end
    end
    
    local allAvailable = {}
    if #preferredWords == 0 then
        for _, word in ipairs(pool) do
            if not UsedWords[prefix][word] then
                table.insert(allAvailable, word)
            end
        end
    end
    
    local available = #preferredWords > 0 and preferredWords or allAvailable

    if #available == 0 then
        SendNotification("⚠ All words used for: " .. prefix:upper() .. " (Reset needed)", 3)
        return nil
    end

    local idealMinLength = #prefix + profile.PreferMinLen
    local idealMaxLength = #prefix + profile.PreferMaxLen
    local idealLength = math.random(idealMinLength, idealMaxLength)
    
    local scored = {}

    for _, word in ipairs(available) do
        local score = 100 - math.abs(#word - idealLength)
        if #word >= profile.PreferMinLen and #word <= profile.PreferMaxLen then
            score = score + 100
        end
        table.insert(scored, { Word = word, Score = score })
    end

    table.sort(scored, function(a, b) return a.Score > b.Score end)

    local topCount = math.max(1, math.floor(#scored * 0.3))
    local chosen = scored[math.random(1, topCount)].Word
    UsedWords[prefix][chosen] = true

    return chosen
end

LogService.MessageOut:Connect(function(message)
    if not Config.AutoTypingEnabled or IsTyping then return end
    if tick() - LastDetectionTime < DETECTION_COOLDOWN then return end

    local prefix = message:match("Word:%s*([A-Z]+)")
    if prefix then
        LastDetectionTime = tick()
        prefix = prefix:lower()

        local word = SelectWord(prefix)
        if not word then
            SendNotification("✗ No available words for: " .. prefix:upper(), 3)
            return
        end

        IsTyping = true
        task.spawn(TypeWord, prefix, word)
    end
end)

-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Noctyra HUB",
    LoadingTitle = "Noctyra HUB",
    LoadingSubtitle = "by Noctyra",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "NoctyraHUB"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Noctyra HUB",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

-- Create Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- Auto Typing Toggle
local AutoTypingToggle = MainTab:CreateToggle({
    Name = "Auto Typing",
    CurrentValue = Config.AutoTypingEnabled,
    Flag = "AutoTypingToggle",
    Callback = function(Value)
        Config.AutoTypingEnabled = Value
        SendNotification(Value and "Auto-typing ENABLED" or "Auto-typing DISABLED")
    end,
})

-- Profile Dropdown
local ProfileDropdown = MainTab:CreateDropdown({
    Name = "Typing Profile",
    Options = {"fast", "balanced", "safe", "chaos"},
    CurrentOption = {"balanced"},
    MultipleOptions = false,
    Flag = "ProfileDropdown",
    Callback = function(Option)
        local selectedProfile = Option
        if type(Option) == "table" then
            selectedProfile = Option[1] or "balanced"
        end
        Config.TypingProfile = selectedProfile
        SendNotification("Profile: " .. selectedProfile:upper())
    end,
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Min Word Length Slider
local MinLengthSlider = SettingsTab:CreateSlider({
    Name = "Min Word Length",
    Range = {1, 50},
    Increment = 1,
    Suffix = " chars",
    CurrentValue = Config.MinWordLength,
    Flag = "MinLengthSlider",
    Callback = function(Value)
        Config.MinWordLength = Value
    end,
})

-- Max Word Length Slider
local MaxLengthSlider = SettingsTab:CreateSlider({
    Name = "Max Word Length",
    Range = {1, 100},
    Increment = 1,
    Suffix = " chars",
    CurrentValue = Config.MaxWordLength,
    Flag = "MaxLengthSlider",
    Callback = function(Value)
        Config.MaxWordLength = Value
    end,
})

-- Extra Backspaces Slider
local BackspacesSlider = SettingsTab:CreateSlider({
    Name = "Extra Backspaces",
    Range = {0, 10},
    Increment = 1,
    Suffix = " times",
    CurrentValue = Config.ExtraBackspacesAfterClear,
    Flag = "BackspacesSlider",
    Callback = function(Value)
        Config.ExtraBackspacesAfterClear = Value
    end,
})

-- Press Enter Toggle
local EnterToggle = SettingsTab:CreateToggle({
    Name = "Press Enter After Clear",
    CurrentValue = Config.PressEnterAfterClear,
    Flag = "EnterToggle",
    Callback = function(Value)
        Config.PressEnterAfterClear = Value
    end,
})

-- Info Section
local InfoSection = SettingsTab:CreateSection("Information")
local InfoLabel1 = SettingsTab:CreateLabel("Shortcut: Alt+T to toggle")
local InfoLabel2 = SettingsTab:CreateLabel("Version: 2.0")

-- Keybind
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.T and UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
        Config.AutoTypingEnabled = not Config.AutoTypingEnabled
        AutoTypingToggle:Set(Config.AutoTypingEnabled)
        SendNotification(Config.AutoTypingEnabled and "Auto-typing ENABLED" or "Auto-typing DISABLED")
    end
end)

SendNotification("Noctyra HUB Loaded! Alt+T", 4)
