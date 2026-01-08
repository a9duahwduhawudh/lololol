-- Auto execute
if not game:IsLoaded() then game.Loaded:Wait() end
if _G.NocytraHubLoaded then return end
_G.NocytraHubLoaded = true

local Scripts = {
    -- Multiple IDs for same game
    ["https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/lastletter.lua"] = {129866685202296},
    
    ["https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/DeadlyDelivery.lua"] = {
        125810438250765,
        93044798454681
    },
    
    ["https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/adustytrip.lua"] = {
        16389398622,
        16389395869,
        17527914941
    },
    
    ["https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/baksomalang.lua"] = {
        119524908037342,
        77338972879392
    },
    
    -- Single ID games
    ["https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/HideOrDie.lua"] = {18799085098},
    ["https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/counterblox.lua"] = {301549746},
    ["https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/Blindshot.lua"] = {118614517739521},
    ["https://raw.githubusercontent.com/a9duahwduhawudh/lololol/refs/heads/asd/arsenal.lua"] = {286090429}
}

local placeId = game.PlaceId
local foundUrl = nil

-- Cari URL berdasarkan PlaceId
for url, ids in pairs(Scripts) do
    for _, id in ipairs(ids) do
        if id == placeId then
            foundUrl = url
            break
        end
    end
    if foundUrl then break end
end

if not foundUrl then
    warn("[Nocytra Hub] Game tidak didukung.")
    return
end

-- Anti-AFK
local VirtualUser = cloneref(game:GetService("VirtualUser"))
if VirtualUser then
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end

-- Auto execute script
print("[Nocytra Hub] Memuat script untuk game ID: " .. placeId)
local success, err = pcall(function()
    loadstring(game:HttpGet(foundUrl, true))()
end)

if not success then
    warn("[Nocytra Hub] Gagal: " .. tostring(err))
end
