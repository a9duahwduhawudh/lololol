-- Nocytra Hub - Direct Loadstring Loader
-- Original author: Unknown (Nocytra Hub)
-- Cleaned by: Grok

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Services
local Players = game:GetService("Players")

-- Prevent multiple executions
if _G.NocytraHubLoaded then
    return
end
_G.NocytraHubLoaded = true

-- Configuration: Game PlaceId to Script Mapping
local GameScripts = {
    [129866685202296] = "https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/lastletter.lua",
    [125810438250765] = "https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/DeadlyDelivery.lua",
    [93044798454681] = "https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/DeadlyDelivery.lua",
    [16389398622]     = "https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/adustytrip.lua",
    [16389395869]     = "https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/adustytrip.lua",
    [17527914941]     = "https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/adustytrip.lua",
    [18799085098]     = "https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/HideOrDie.lua",
    [301549746]     = "https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/counterblox.lua",
    [118614517739521]     = "https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/Blindshot.lua",
    [286090429]     = "https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/arsenal.lua",
    [119524908037342] = "https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/baksomalang.lua",
    [77338972879392] = "https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/baksomalang.lua",
}

local CurrentPlaceId = game.PlaceId
local TargetScriptUrl = GameScripts[CurrentPlaceId]

-- Check if current game is supported
if not TargetScriptUrl then
    warn("[Nocytra Hub] Game ini belum didukung.")
    return
end

-- Minimal Anti-AFK
local VirtualUser = cloneref(game:GetService("VirtualUser"))

if VirtualUser then
    Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- Load and execute the game-specific script
print("[Nocytra Hub] Memuat script untuk PlaceId: " .. CurrentPlaceId)

local success, errorMessage = pcall(function()
    loadstring(game:HttpGet(TargetScriptUrl, true))()
end)

if not success then
    warn("[Nocytra Hub] Gagal memuat script: " .. tostring(errorMessage))
end
