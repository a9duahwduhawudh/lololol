local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "NoctyraHub",
    Icon = "rbxassetid://120245531583106",
    Author = "Noctyra",
    Folder = "NoctyraHub",
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true,
})

local MenuKey = "LeftAlt"

local Settings = {
    Combat = {
        Aimbot = {
            Enabled = false,
            AimPart = "Head",
            Keybind = "MouseRight",
            AlwaysOn = false,
            Smoothing = 5,
            Prediction = 0,
            TeamCheck = false,
            WallCheck = false,
            FOV = { Enabled = false, Radius = 100, Color = Color3.fromRGB(255, 255, 255) }
        },
        SilentAim = {
            Enabled = false,
            AimPart = "Head",
            Prediction = 0,
            TeamCheck = false,
            WallCheck = false,
            FOV = { Enabled = false, Radius = 100, Color = Color3.fromRGB(255, 0, 0) }
        },
        AntiAim = {
            Enabled = false,
            Method = "Static",
            Pitch = "Zero",
            ShowVisuals = false,
            ClientSided = false,
            YawOffset = 0, 
            JitterAngle = 45,
            SpinSpeed = 20,
            OrbitRadius = 5,
            OrbitSpeed = 5
        }
    },
    Visuals = {
        World = {
            TimeChanger = false,
            TimeValue = 12,
            Ambience = false,
            AmbienceColor = Color3.fromRGB(255, 255, 255),
            Brightness = false,
            BrightnessValue = 2,
            FOV = false,
            FOVValue = 70,
            ThirdPerson = {
                Enabled = false,
                Distance = 10,
                Keybind = "V"
            },
            AspectRatio = {
                Enabled = false,
                Value = 1
            }
        },
        Viewmodel = {
            Enabled = false,
            X = 0,
            Y = 0,
            Z = 0,
            Pitch = 0,
            Yaw = 0,
            Roll = 0
        },
        Crosshair = {
            Enabled = false,
            Mode = "Default",
            Rainbow = false,
            Color = Color3.fromRGB(0, 255, 140),
            Size = 12,
            Gap = 2,
            Thickness = 1
        },
        ESP = {
            Enabled = false,
            TeamCheck = false,
            Boxes = false,
            HealthBar = false,
            Names = false,
            Distance = false,
            Weapon = false,
            Tracers = false,
            OverrideColors = false,
            Colors = {
                Box = Color3.fromRGB(255, 255, 255),
                Name = Color3.fromRGB(255, 255, 255),
                Distance = Color3.fromRGB(255, 255, 255),
                Weapon = Color3.fromRGB(255, 255, 255),
                Tracer = Color3.fromRGB(255, 255, 255),
            },
            Offscreen = {
                Enabled = false,
                Radius = 150,
                Size = 15,
                Color = Color3.fromRGB(255, 0, 0)
            }
        }
    },
    Misc = {
        SkinUnlocker = false
    },
    Weapons = {
        Enabled = false,
        Ammo = 100,
        Auto = true,
        DMG = 100,
        EquipTime = 0,
        FireRate = 0,
        KillAward = 100,
        StoredAmmo = 100
    }
}

local R15Parts = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}

local function GetColor(type)
    if Settings.Visuals.ESP.OverrideColors then return Settings.Visuals.ESP.Colors[type] else return Color3.new(1, 1, 1) end
end

local function IsKeyDown(bindName)
    if not bindName then return false end
    local KeyMap = {
        ["MouseLeft"] = Enum.UserInputType.MouseButton1,
        ["MouseRight"] = Enum.UserInputType.MouseButton2,
        ["MouseMiddle"] = Enum.UserInputType.MouseButton3,
        ["LeftMouseButton"] = Enum.UserInputType.MouseButton1,
        ["RightMouseButton"] = Enum.UserInputType.MouseButton2
    }
    if KeyMap[bindName] then return UserInputService:IsMouseButtonPressed(KeyMap[bindName]) end
    local success, keyCode = pcall(function() return Enum.KeyCode[bindName] end)
    if success and keyCode then return UserInputService:IsKeyDown(keyCode) end
    return false
end

local function IsTeammate(player)
    if player == LocalPlayer then return true end
    local myState = LocalPlayer:FindFirstChild("PlayerStates")
    local theirState = player:FindFirstChild("PlayerStates")
    if myState and theirState then
        local myTeam = myState:FindFirstChild("Team")
        local theirTeam = theirState:FindFirstChild("Team")
        if myTeam and theirTeam then return myTeam.Value == theirTeam.Value end
    end
    return player.Team == LocalPlayer.Team
end

local function IsVisible(targetPart)
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    local result = Workspace:Raycast(origin, direction, raycastParams)
    return result and result.Instance:IsDescendantOf(targetPart.Parent)
end

local function getEquippedToolName(player, char)
    if not player or not char then return "null" end
    local eq = char:FindFirstChild("EquippedTool") or player:FindFirstChild("EquippedTool")
    if eq then
        if eq:IsA("StringValue") then
            if eq.Value ~= "" then return tostring(eq.Value) end
        elseif eq:IsA("ObjectValue") then
            if eq.Value and eq.Value.Name then return tostring(eq.Value.Name) end
        elseif eq:IsA("Tool") then
            return eq.Name
        end
    end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then return tool.Name end
    return "null"
end

local WeaponsFolder = ReplicatedStorage:WaitForChild("Weapons")
local OriginalWeaponData = {}

local function ApplyWeaponMods()
    if not Settings.Weapons.Enabled then return end
    
    for _, weapon in pairs(WeaponsFolder:GetChildren()) do
        if not OriginalWeaponData[weapon] then
            OriginalWeaponData[weapon] = {}
            if weapon:FindFirstChild("Ammo") then OriginalWeaponData[weapon].Ammo = weapon.Ammo.Value end
            if weapon:FindFirstChild("Auto") then OriginalWeaponData[weapon].Auto = weapon.Auto.Value end
            if weapon:FindFirstChild("DMG") then OriginalWeaponData[weapon].DMG = weapon.DMG.Value end
            if weapon:FindFirstChild("EquipTime") then OriginalWeaponData[weapon].EquipTime = weapon.EquipTime.Value end
            if weapon:FindFirstChild("FireRate") then OriginalWeaponData[weapon].FireRate = weapon.FireRate.Value end
            if weapon:FindFirstChild("KillAward") then OriginalWeaponData[weapon].KillAward = weapon.KillAward.Value end
            if weapon:FindFirstChild("StoredAmmo") then OriginalWeaponData[weapon].StoredAmmo = weapon.StoredAmmo.Value end
            
            local spread = weapon:FindFirstChild("Spread")
            if spread then
                OriginalWeaponData[weapon].Spread = {}
                for _, v in pairs(spread:GetChildren()) do
                    if v:IsA("NumberValue") then OriginalWeaponData[weapon].Spread[v] = v.Value end
                end
            end
        end

        if weapon:FindFirstChild("Ammo") then weapon.Ammo.Value = Settings.Weapons.Ammo end
        if weapon:FindFirstChild("Auto") and weapon.Auto:IsA("BoolValue") then weapon.Auto.Value = Settings.Weapons.Auto end
        if weapon:FindFirstChild("DMG") then weapon.DMG.Value = Settings.Weapons.DMG end
        if weapon:FindFirstChild("EquipTime") then weapon.EquipTime.Value = Settings.Weapons.EquipTime end
        if weapon:FindFirstChild("FireRate") then weapon.FireRate.Value = Settings.Weapons.FireRate end
        if weapon:FindFirstChild("KillAward") then weapon.KillAward.Value = Settings.Weapons.KillAward end
        if weapon:FindFirstChild("StoredAmmo") then weapon.StoredAmmo.Value = Settings.Weapons.StoredAmmo end
        
        local spreadFolder = weapon:FindFirstChild("Spread")
        if spreadFolder then
            for _, v in pairs(spreadFolder:GetChildren()) do
                if v:IsA("NumberValue") then v.Value = 0
                elseif v:IsA("Folder") or v:IsA("Instance") then
                    for _, subV in pairs(v:GetChildren()) do
                        if subV:IsA("NumberValue") then subV.Value = 0 end
                    end
                end
            end
        end
    end
end

local function RestoreWeaponMods()
    for weapon, data in pairs(OriginalWeaponData) do
        if weapon and weapon.Parent then
            if data.Ammo and weapon:FindFirstChild("Ammo") then weapon.Ammo.Value = data.Ammo end
            if data.Auto ~= nil and weapon:FindFirstChild("Auto") then weapon.Auto.Value = data.Auto end
            if data.DMG and weapon:FindFirstChild("DMG") then weapon.DMG.Value = data.DMG end
            if data.EquipTime and weapon:FindFirstChild("EquipTime") then weapon.EquipTime.Value = data.EquipTime end
            if data.FireRate and weapon:FindFirstChild("FireRate") then weapon.FireRate.Value = data.FireRate end
            if data.KillAward and weapon:FindFirstChild("KillAward") then weapon.KillAward.Value = data.KillAward end
            if data.StoredAmmo and weapon:FindFirstChild("StoredAmmo") then weapon.StoredAmmo.Value = data.StoredAmmo end
            
            if data.Spread then
                for valObj, val in pairs(data.Spread) do
                    if valObj and valObj.Parent then valObj.Value = val end
                end
            end
        end
    end
    OriginalWeaponData = {}
end

local allSkins = { {'AK47_BloxersClub'}, {'AK47_Bloodboom'}, {'AK47_Clown'}, {'AK47_Code Orange'}, {'AK47_Super Weeb'}, {'AK47_Ghost'}, {'AK47_Gifted'}, {'AK47_Glo'}, {'DesertEagle_TC'}, {'AK47_Hallows'}, {'AK47_Halo'}, {'AK47_Hypersonic'}, {'AK47_Inversion'}, {'AK47_Trinity'}, {'AK47_Maker'}, {'AK47_Mean Green'}, {'AK47_Outlaws'}, {'AK47_Outrunner'}, {'AK47_Patch'}, {'AK47_Plated'}, {'AK47_Precision'}, {'AK47_Quantum'}, {'AK47_Quicktime'}, {'AK47_Scapter'}, {'AK47_Secret Santa'}, {'AK47_Shooting Star'}, {'AK47_Skin Committee'}, {'AK47_Survivor'}, {'AK47_Toxic Nitro'}, {'AK47_Ugly Sweater'}, {'AK47_VAV'}, {'AK47_Variant Camo'}, {'AK47_Yltude'}, {'AUG_Chilly Night'}, {'AUG_Dream Hound'}, {'AUG_Enlisted'}, {'AUG_Graffiti'}, {'AUG_Homestead'}, {'AUG_Maker'}, {'AUG_NightHawk'}, {'AUG_Phoenix'}, {'USP_BloxersClub'}, {'AWP_Abaddon'}, {'AWP_Autumness'}, {'AWP_Blastech'}, {'AWP_Bloodborne'}, {'AWP_Blue'}, {'AWP_Coffin Biter'}, {'AWP_Dark Galaxy'}, {'AWP_Desert Camo'}, {'AWP_Difference'}, {'AWP_Dragon'}, {'AWP_Forever'}, {'AWP_Grepkin'}, {'AWP_Hika'}, {'AWP_Illusion'}, {'AWP_Instinct'}, {'AWP_JTF2'}, {'AWP_Kumanjayi'}, {'AWP_Lunar'}, {'AWP_Nerf'}, {'AWP_Northern Lights'}, {'AWP_Pear Tree'}, {'AWP_Pink Vision'}, {'AWP_Pinkie'}, {'AWP_Quicktime'}, {'AWP_Racer'}, {'AWP_Regina'}, {'AWP_Retroactive'}, {'AWP_Scapter'}, {'AWP_Silence'}, {'AWP_Toxic Nitro'}, {'AWP_Venomus'}, {'AWP_BloxersClub'}, {'Bayonet_Aequalis'}, {'Bayonet_Banner'}, {'Bayonet_Candy Cane'}, {'Bayonet_Consumed'}, {'Bayonet_Cosmos'}, {'Bayonet_Crimson Tiger'}, {'Bayonet_Crow'}, {'Bayonet_Delinquent'}, {'Bayonet_Digital'}, {'Bayonet_Easy-Bake'}, {'Bayonet_Egg Shell'}, {'Bayonet_Festive'}, {'Bayonet_Frozen Dream'}, {'Bayonet_Geo Blade'}, {'Bayonet_Ghastly'}, {'Bayonet_Goo'}, {'Bayonet_Hallows'}, {'Bayonet_Intertwine'}, {'Bayonet_Marbleized'}, {'Bayonet_Mariposa'}, {'Bayonet_Naval'}, {'Bayonet_Neonic'}, {'Bayonet_RSL'}, {'Bayonet_Racer'}, {'Bayonet_Sapphire'}, {'Bayonet_Silent Night'}, {'Bayonet_Splattered'}, {'Bayonet_Stock'}, {'Bayonet_Topaz'}, {'Bayonet_Tropical'}, {'Bayonet_Twitch'}, {'Bayonet_UFO'}, {'Bayonet_Wetland'}, {'Bayonet_Worn'}, {'Bayonet_Wrapped'}, {'Bearded Axe_Beast'}, {'Bearded Axe_Splattered'}, {'Bearded Axe_Stock'}, {'Bizon_Autumic'}, {'Bizon_Festive'}, {'Bizon_Oblivion'}, {'Bizon_Saint Nick'}, {'Bizon_Sergeant'}, {'Bizon_Shattered'}, {'Butterfly Knife_Aurora'}, {'Butterfly Knife_Bloodwidow'}, {'Butterfly Knife_Consumed'}, {'Butterfly Knife_Cosmos'}, {'Butterfly Knife_Crimson Tiger'}, {'Butterfly Knife_Crippled Fade'}, {'Butterfly Knife_Digital'}, {'Butterfly Knife_Egg Shell'}, {'Butterfly Knife_Freedom'}, {'Butterfly Knife_Frozen Dream'}, {'Butterfly Knife_Goo'}, {'Butterfly Knife_Hallows'}, {'Butterfly Knife_Icicle'}, {'Butterfly Knife_Inversion'}, {'Butterfly Knife_Jade Dream'}, {'Butterfly Knife_Marbleized'}, {'Butterfly Knife_Naval'}, {'Butterfly Knife_Neonic'}, {'Butterfly Knife_Reaper'}, {'Butterfly Knife_Ruby'}, {'Butterfly Knife_Scapter'}, {'Butterfly Knife_Splattered'}, {'Butterfly Knife_Stock'}, {'Butterfly Knife_Topaz'}, {'Butterfly Knife_Tropical'}, {'Butterfly Knife_Twitch'}, {'Butterfly Knife_Wetland'}, {'Butterfly Knife_White Boss'}, {'Butterfly Knife_Worn'}, {'Butterfly Knife_Wrapped'}, {'CZ_Designed'}, {'CZ_Festive'}, {'CZ_Holidays'}, {'CZ_Lightning'}, {'CZ_Orange Web'}, {'CZ_Spectre'}, {'Cleaver_Spider'}, {'Cleaver_Splattered'}, {'Cleaver_Stock'}, {'DesertEagle_Cold Truth'}, {'DesertEagle_Cool Blue'}, {'DesertEagle_DropX'}, {'DesertEagle_BloxersClub'}, {'DesertEagle_Grim'}, {'DesertEagle_Heat'}, {'DesertEagle_Honor-bound'}, {'DesertEagle_Independence'}, {'DesertEagle_Krystallos'}, {'DesertEagle_Pumpkin Buster'}, {'DesertEagle_ROLVe'}, {'DesertEagle_Racer'}, {'DesertEagle_Scapter'}, {'DesertEagle_Skin Committee'}, {'DesertEagle_Survivor'}, {'DesertEagle_Weeb'}, {'DesertEagle_Xmas'}, {'DualBerettas_Carbonized'}, {'DualBerettas_Dusty Manor'}, {'DualBerettas_Floral'}, {'DualBerettas_Hexline'}, {'DualBerettas_Neon web'}, {'DesertEagle_Ababa'}, {'DualBerettas_Xmas'}, {'Falchion Knife_Bloodwidow'}, {'Falchion Knife_Chosen'}, {'Falchion Knife_Coal'}, {'Falchion Knife_Consumed'}, {'Falchion Knife_Cosmos'}, {'Falchion Knife_Crimson Tiger'}, {'Falchion Knife_Crippled Fade'}, {'Falchion Knife_Digital'}, {'Falchion Knife_Egg Shell'}, {'Falchion Knife_Festive'}, {'Falchion Knife_Freedom'}, {'Falchion Knife_Goo'}, {'Falchion Knife_Hallows'}, {'Falchion Knife_Inversion'}, {'Falchion Knife_Late Night'}, {'Falchion Knife_Marbleized'}, {'Falchion Knife_Naval'}, {'Falchion Knife_Neonic'}, {'Falchion Knife_Racer'}, {'Falchion Knife_Ruby'}, {'Falchion Knife_Splattered'}, {'Falchion Knife_Stock'}, {'Falchion Knife_Topaz'}, {'Falchion Knife_Toxic Nitro'}, {'Falchion Knife_Tropical'}, {'Falchion Knife_Wetland'}, {'Falchion Knife_Worn'}, {'Falchion Knife_Wrapped'}, {'Falchion Knife_Zombie'}, {'Famas_Abstract'}, {'Famas_Centipede'}, {'Famas_Cogged'}, {'Famas_Goliath'}, {'Famas_Haunted Forest'}, {'Famas_KugaX'}, {'Famas_MK11'}, {'Famas_Medic'}, {'Famas_Redux'}, {'Famas_Shocker'}, {'Famas_Toxic Rain'}, {'Fingerless Glove_Kimura'}, {'Fingerless Glove_Digital'}, {'Fingerless Glove_Patch'}, {'Fingerless Glove_Scapter'}, {'FiveSeven_Autumn Fade'}, {'FiveSeven_Danjo'}, {'FiveSeven_Fluid'}, {'FiveSeven_Gifted'}, {'FiveSeven_Midnight Ride'}, {'FiveSeven_Mr. Anatomy'}, {'FiveSeven_Stigma'}, {'FiveSeven_Sub Zero'}, {'FiveSeven_Summer'}, {'G3SG1_Amethyst'}, {'G3SG1_Autumn'}, {'G3SG1_Foliage'}, {'G3SG1_Hex'}, {'G3SG1_Holly Bound'}, {'G3SG1_Mahogany'}, {'Galil_Frosted'}, {'Galil_Hardware'}, {'Galil_Hardware 2'}, {'Galil_Toxicity'}, {'Galil_Worn'}, {'Glock_Angler'}, {'Glock_Anubis'}, {'Glock_White Sauce'}, {'Glock_Day Dreamer'}, {'Glock_Desert Camo'}, {'Glock_Gravestomper'}, {'Glock_Midnight Tiger'}, {'Glock_Money Maker'}, {'Glock_RSL'}, {'Glock_Rush'}, {'Glock_Scapter'}, {'Glock_Spacedust'}, {'Glock_Tarnish'}, {'Glock_Underwater'}, {'Glock_Wetland'}, {'Gut Knife_Banner'}, {'Gut Knife_Bloodwidow'}, {'Gut Knife_Consumed'}, {'Gut Knife_Cosmos'}, {'Gut Knife_Crimson Tiger'}, {'Gut Knife_Crippled Fade'}, {'Gut Knife_Digital'}, {'Gut Knife_Egg Shell'}, {'Gut Knife_Frozen Dream'}, {'Gut Knife_Geo Blade'}, {'Gut Knife_Goo'}, {'Gut Knife_Hallows'}, {'Gut Knife_Lurker'}, {'Gut Knife_Marbleized'}, {'Gut Knife_Naval'}, {'Gut Knife_Neonic'}, {'Gut Knife_Present'}, {'Gut Knife_Ruby'}, {'Gut Knife_Rusty'}, {'Gut Knife_Splattered'}, {'Gut Knife_Stock'}, {'Gut Knife_Topaz'}, {'Gut Knife_Tropical'}, {'Gut Knife_Wetland'}, {'Gut Knife_Worn'}, {'Gut Knife_Wrapped'}, {'Handwraps_Ghoul Hex'}, {'Handwraps_Green Hex'}, {'Handwraps_Guts'}, {'Handwraps_Mummy'}, {'Handwraps_Orange Hex'}, {'Handwraps_Phantom Hex'}, {'Handwraps_Purple Hex'}, {'Handwraps_Spector Hex'}, {'Handwraps_Toxic Nitro'}, {'Handwraps_Wetland'}, {'Huntsman Knife_Aurora'}, {'Huntsman Knife_Bloodwidow'}, {'Huntsman Knife_Ciro'}, {'Huntsman Knife_Consumed'}, {'Huntsman Knife_Cosmos'}, {'Huntsman Knife_Cozy'}, {'Huntsman Knife_Crimson Tiger'}, {'Huntsman Knife_Crippled Fade'}, {'Huntsman Knife_Digital'}, {'Huntsman Knife_Egg Shell'}, {'Huntsman Knife_Frozen Dream'}, {'Huntsman Knife_Geo Blade'}, {'Huntsman Knife_Glossed'}, {'Huntsman Knife_Goo'}, {'Huntsman Knife_Hallows'}, {'Huntsman Knife_Honor Fade'}, {'Huntsman Knife_Marbleized'}, {'Huntsman Knife_Monster'}, {'Huntsman Knife_Naval'}, {'Huntsman Knife_Ruby'}, {'Huntsman Knife_Splattered'}, {'Huntsman Knife_Stock'}, {'Huntsman Knife_Tropical'}, {'Huntsman Knife_Twitch'}, {'Huntsman Knife_Wetland'}, {'Huntsman Knife_Worn'}, {'Huntsman Knife_Wrapped'}, {'Karambit_Bloodwidow'}, {'Karambit_Ciro'}, {'Karambit_Consumed'}, {'Karambit_Cosmos'}, {'Karambit_Crimson Tiger'}, {'Karambit_Crippled Fade'}, {'Karambit_Death Wish'}, {'Karambit_Digital'}, {'Karambit_Egg Shell'}, {'Karambit_Festive'}, {'Karambit_Frozen Dream'}, {'Karambit_Ghost'}, {'Karambit_Glossed'}, {'Karambit_Gold'}, {'Karambit_Goo'}, {'Karambit_Hallows'}, {'Karambit_Jade Dream'}, {'Karambit_Jester'}, {'Karambit_Lantern'}, {'Karambit_Liberty Camo'}, {'Karambit_Marbleized'}, {'Karambit_Naval'}, {'Karambit_Neonic'}, {'Karambit_Pizza'}, {'Karambit_Quicktime'}, {'Karambit_Racer'}, {'Karambit_Ruby'}, {'Karambit_Scapter'}, {'Karambit_Splattered'}, {'Karambit_Stock'}, {'Karambit_Topaz'}, {'Karambit_Tropical'}, {'Karambit_Twitch'}, {'Karambit_Wetland'}, {'Karambit_Worn'}, {'M249_Aggressor'}, {'M249_P2020'}, {'M249_Spooky'}, {'M249_Wolf'}, {'M4A1_Animatic'}, {'M4A1_Burning'}, {'M4A1_Desert Camo'}, {'M4A1_Heavens Gate'}, {'M4A1_Impulse'}, {'M4A1_Jester'}, {'M4A1_Lunar'}, {'M4A1_Necropolis'}, {'M4A1_Tecnician'}, {'M4A1_Toucan'}, {'M4A1_Wastelander'}, {'M4A4_BOT[S]'}, {'M4A4_Candyskull'}, {'M4A4_Delinquent'}, {'M4A4_Desert Camo'}, {'M4A4_Devil'}, {'M4A4_Endline'}, {'M4A4_Flashy Ride'}, {'M4A4_Ice Cap'}, {'M4A4_Jester'}, {'M4A4_King'}, {'M4A4_Mistletoe'}, {'M4A4_Pinkie'}, {'M4A4_Pinkvision'}, {'M4A4_Pondside'}, {'M4A4_Precision'}, {'M4A4_Quicktime'}, {'M4A4_Racer'}, {'M4A4_RayTrack'}, {'M4A4_Scapter'}, {'M4A4_Stardust'}, {'M4A4_Toy Soldier'}, {'MAC10_Artists Intent'}, {'MAC10_Blaze'}, {'MAC10_Golden Rings'}, {'MAC10_Pimpin'}, {'MAC10_Skeleboney'}, {'MAC10_Toxic'}, {'MAC10_Turbo'}, {'MAC10_Wetland'}, {'MAG7_Bombshell'}, {'MAG7_C4UTION'}, {'MAG7_Frosty'}, {'MAG7_Molten'}, {'MAG7_Outbreak'}, {'MAG7_Striped'}, {'MP7_Calaxian'}, {'MP7_Cogged'}, {'MP7_Goo'}, {'MP7_Holiday'}, {'MP7_Industrial'}, {'MP7_Reindeer'}, {'MP7_Silent Ops'}, {'MP7_Sunshot'}, {'MP9_Blueroyal'}, {'MP9_Cob Web'}, {'MP9_Cookie Man'}, {'MP9_Decked Halls'}, {'MP9_SnowTime'}, {'MP9_Vaporwave'}, {'MP9_Velvita'}, {'MP9_Wilderness'}, {'Negev_Midnightbones'}, {'Negev_Quazar'}, {'Negev_Striped'}, {'Negev_Wetland'}, {'Negev_Winterfell'}, {'Nova_Black Ice'}, {'Nova_Cookie'}, {'Nova_Paradise'}, {'Nova_Sharkesh'}, {'Nova_Starry Night'}, {'Nova_Terraformer'}, {'Nova_Tiger'}, {'P2000_Apathy'}, {'P2000_Camo Dipped'}, {'P2000_Candycorn'}, {'P2000_Comet'}, {'P2000_Dark Beast'}, {'P2000_Golden Age'}, {'P2000_Lunar'}, {'P2000_Pinkie'}, {'P2000_Ruby'}, {'P2000_Silence'}, {'P250_Amber'}, {'P250_Bomber'}, {'P250_Equinox'}, {'P250_Frosted'}, {'P250_Goldish'}, {'P250_Green Web'}, {'P250_Shark'}, {'P250_Solstice'}, {'P250_TC250'}, {'P90_Demon Within'}, {'P90_Elegant'}, {'P90_Krampus'}, {'P90_Northern Lights'}, {'P90_P-Chan'}, {'P90_Pine'}, {'P90_Redcopy'}, {'P90_Skulls'}, {'R8_Exquisite'}, {'R8_Hunter'}, {'R8_Spades'}, {'R8_TG'}, {'R8_Violet'}, {'SG_DropX'}, {'SG_Dummy'}, {'SG_Kitty Cat'}, {'SG_Knighthood'}, {'SG_Magma'}, {'SG_Variant Camo'}, {'SG_Yltude'}, {'SawedOff_Casino'}, {'SawedOff_Colorboom'}, {'SawedOff_Executioner'}, {'SawedOff_Opal'}, {'SawedOff_Opal'}, {'SawedOff_Spooky'}, {'SawedOff_Sullys Blacklight'}, {'Scar_Amethyst'}, {'Scar_Foliage'}, {'Scar_Hex'}, {'Scar_Holly Bound'}, {'Scar_Mahogany'}, {'Scout_Coffin Biter'}, {'Scout_Flowing Mists'}, {'Scout_Hellborn'}, {'Scout_Hot Cocoa'}, {'Scout_Monstruo'}, {'Scout_Neon Regulation'}, {'Scout_Posh'}, {'Scout_Pulse'}, {'Scout_Railgun'}, {'Scout_Theory'}, {'Scout_Xmas'}, {'Sickle_Mummy'}, {'Sickle_Splattered'}, {'Sickle_Stock'}, {'Sports Glove_CottonTail'}, {'Sports Glove_Hallows'}, {'Sports Glove_Hazard'}, {'Sports Glove_Majesty'}, {'Sports Glove_RSL'}, {'Sports Glove_Royal'}, {'Sports Glove_Weeb'}, {'Strapped Glove_Grim'}, {'Strapped Glove_Kringle'}, {'Strapped Glove_Molten'}, {'Strapped Glove_Racer'}, {'Strapped Glove_Wisk'}, {'Tec9_Charger'}, {'Tec9_Gift Wrapped'}, {'Tec9_Ironline'}, {'Tec9_Performer'}, {'Tec9_Phol'}, {'Tec9_Samurai'}, {'Tec9_Skintech'}, {'Tec9_Stocking Stuffer'}, {'UMP_Death Grip'}, {'UMP_Gum Drop'}, {'UMP_Magma'}, {'UMP_Militia Camo'}, {'UMP_Molten'}, {'UMP_Redline'}, {'USP_Crimson'}, {'USP_Dizzy'}, {'USP_Frostbite'}, {'USP_Holiday'}, {'USP_Jade Dream'}, {'USP_Kraken'}, {'USP_Nighttown'}, {'USP_Paradise'}, {'USP_Racing'}, {'USP_Skull'}, {'USP_Unseen'}, {'USP_Worlds Away'}, {'USP_Yellowbelly'}, {'XM_Artic'}, {'XM_Atomic'}, {'XM_Campfire'}, {'XM_Endless Night'}, {'XM_MK11'}, {'XM_Predator'}, {'XM_Red'}, {'XM_Spectrum'}, {'AK47_Godess'}, {'AUG_Mystique'}, {'Fingerless Glove_Spookiness'}, {'SG_Drop-Out'}, {'Karambit_Drop-Out'}, {'Handwraps_MMA'}, {'CZ_Hallow'}, {'MAC10_Scythe'}, {'Handwraps_Drop-Out'}, {'Huntsman Knife_Drop-Out'}, {'MP7_Trauma'}, {'Nova_Tricked'}, {'Famas_Imprisioned'}, {'Falchion Knife_Pumpkin'}, {'AK47_Haunted'}, {'AK47_Scythe'}, {'P90_Argus'}, {'Sports Glove_Pumpkin'}, {'M249_Lantern'}, {'AWP_Darkness'}, {'Sports Glove_Skulls'}, {'Butterfly Knife_Argus'}, {'Karambit_Peppermint'}, {'Huntsman Knife_Spirit'}, {'Gut Knife_Holly'}, {'Falchion Knife_Cocoa'}, {'Butterfly Knife_Snowfall'}, {'Bayonet_Decor'}, {'AK47_NeonLine'}, {'AUG_Soldier'}, {'AWP_Oriental'}, {'Bayonet_Kimura'}, {'Falchion Knife_Kimura'}, {'DesertEagle_Crystal'}, {'SG_Control'}, {'Scout_Darkness'}, {'USP_Survivor'}, {'M4A4_Darkness'}, {'MP9_Control'}, {'Nova_Defective'}, {'Tec9_Seasoned'}, {'Sports Glove_Calamity'}, {'Sports Glove_Twitch'}, {'AK47_Galaxy Corpse'}, {'Gut Knife_Cob Web'}, {'AWP_Grim'}, {'DesertEagle_Blue Fur'}, {'Glock_Hallows'}, {'M4A1_Nightmare'}, {'Huntsman Knife_Spookiness'}, {'Karambit_Cob Web'}, {'Fingerless Glove_Crystal'}, {'Handwraps_Microbes'}, {'Sports Glove_Dead Prey'}, {'Strapped Glove_Cob Web'}, {'MAC10_Devil'}, {'Nova_Oath'}, {'P90_Curse'}, {'P250_Midnight'}, {'UMP_Orbit'}, {'Bayonet_Haunted'}, {'Butterfly Knife_Spooky'}, {'Falchion Knife_Twilight'}, {'M249_Halloween Treats'}, {'Falchion Classic_Late Night'}, {'Voucher_Stock'}, {'Glock_Biotrip'}, {'AK47_Eve'}, {'AK47_Jester'}, {'Sickle Classic_Mummy'}, {'Sickle Classic_Splattered'}, {'Sickle Classic_Stock'}, {'AK47_Ace'}, {'DesertEagle_Glittery'}, {'M4A1_BloxersClub'}, {'P250_BloxersClub'}, {'Bayonet_BloxersClub'}, {'AWP_Weeb'}, {'AUG_Sunsthetic'}, {'DualBerettas_Old Fashioned'}, {'Glock_BloxersClub'}, {'DesertEagle_Guapo'}, {'MAC10_Energy'}, {'DesertEagle_Regal Eclipse'}, {'Scout_Lunar'}, {'FiveSeven_Accelerator'}, {'DualBerettas_Bio-Hive'}, {'SG_NR8'}, {'Galil_Vortex'}, {'USP_Blossom'}, {'Famas_Blossom'}, {'AUG_Equalizer'}, {'MP7-SD_Equalizer'}, {'Sickle_Reaper'}, {'Sickle_Hallows'}, {'Sickle_Hieroglyphs'}, {'Sickle_Psychadelic'}, {'Sickle_Static'}, {'Sickle_Crimson'}, }

local extra = { applied = false, isUnlockedFlag = false }
local client = nil
pcall(function() client = getsenv(LocalPlayer.PlayerGui.Client) end)

local function applyUnlock()
    if extra.applied then return end
    if not LocalPlayer or not client then return end

    local mt = getrawmetatable(game)
    extra.mt = mt
    setreadonly(mt, false)
    extra.oldNamecall = mt.__namecall
    extra.isUnlockedFlag = false

    extra.clientInventory = client.CurrentInventory
    client.CurrentInventory = allSkins

    local skinFolder = LocalPlayer:FindFirstChild("SkinFolder")
    if skinFolder then
        local tFolder = skinFolder:FindFirstChild("TFolder")
        local ctFolder = skinFolder:FindFirstChild("CTFolder")
        if tFolder and ctFolder then
            extra.restoreT = tFolder:Clone()
            extra.restoreCT = ctFolder:Clone()
            local TClone = tFolder:Clone()
            local CTClone = ctFolder:Clone()
            tFolder:Destroy()
            ctFolder:Destroy()
            TClone.Parent = skinFolder
            CTClone.Parent = skinFolder
        end
    end
    extra.applied = true
end

local function restoreUnlock()
    if not extra.applied then return end
    if extra.clientInventory ~= nil and client then client.CurrentInventory = extra.clientInventory end
    local skinFolder = LocalPlayer:FindFirstChild("SkinFolder")
    if skinFolder then
        local curT = skinFolder:FindFirstChild("TFolder")
        local curCT = skinFolder:FindFirstChild("CTFolder")
        if curT then curT:Destroy() end
        if curCT then curCT:Destroy() end
        if extra.restoreT then extra.restoreT.Parent = skinFolder end
        if extra.restoreCT then extra.restoreCT.Parent = skinFolder end
    end
    extra.applied = false
    extra.isUnlockedFlag = false
end

local function GetTarget(config)
    local closest = nil
    local maxDistSq = config.FOV.Radius * config.FOV.Radius
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if config.TeamCheck and IsTeammate(player) then continue end

            local part = player.Character:FindFirstChild(config.AimPart)
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distSq = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude ^ 2
                    
                    if config.FOV.Enabled and distSq > (config.FOV.Radius * config.FOV.Radius) then continue end
                    if config.WallCheck and not IsVisible(part) then continue end

                    if distSq < maxDistSq then
                        maxDistSq = distSq
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

local function GetClosestEnemyForAA()
    local closest = nil
    local maxDist = 9999
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if IsTeammate(player) then continue end
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < maxDist then maxDist = dist; closest = player.Character.HumanoidRootPart end
        end
    end
    return closest
end

local SilentAimTarget = nil
local CachedRay = nil

local ok_mt, MT = pcall(getrawmetatable, game)
if ok_mt and MT then
    setreadonly(MT, false)
    local OldNC = MT.__namecall
    local OldIDX = MT.__index
    local OldNewIDX = MT.__newindex

    MT.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if Settings.Misc.SkinUnlocker and extra.applied then
            if method == "InvokeServer" and tostring(self) == "Hugh" then return end
            if method == "FireServer" then
                if args[1] == LocalPlayer.UserId then return end
                if string.len(tostring(self)) == 38 then
                    if not extra.isUnlockedFlag then
                        extra.isUnlockedFlag = true
                        for i, v in pairs(allSkins) do
                            local doSkip = false
                            for _, v2 in pairs(args[1] or {}) do
                                if v[1] == v2[1] then doSkip = true; break end
                            end
                            if not doSkip then table.insert(args[1], v) end
                        end
                    end
                    return
                end
                if tostring(self) == "DataEvent" and args[1] and args[1][4] then
                    local part = args[1][4][1]
                    if type(part) == "string" then
                        local currentSkin = string.split(part, "_")[2]
                        if args[1][2] == "Both" then
                            LocalPlayer["SkinFolder"]["CTFolder"][args[1][3]].Value = currentSkin
                            LocalPlayer["SkinFolder"]["TFolder"][args[1][3]].Value = currentSkin
                        else
                            LocalPlayer["SkinFolder"][args[1][2] .. "Folder"][args[1][3]].Value = currentSkin
                        end
                    end
                end
            end
        end
        if method == "SetPrimaryPartCFrame" then
            if Settings.Visuals.Viewmodel.Enabled then
                -- Uncomment the line below to see what objects are calling this method
                -- print("[NoctyraHub] Method called on: " .. tostring(self) .. " | Parent: " .. tostring(self.Parent))
                
                if self.Name:find("Arms") and self.Parent == Camera then
                     local s = Settings.Visuals.Viewmodel
                     local success, err = pcall(function()
                         args[1] = args[1] * CFrame.new(s.X, s.Y, s.Z) * CFrame.Angles(math.rad(s.Pitch), math.rad(s.Yaw), math.rad(s.Roll))
                     end)
                     if not success then warn("[NoctyraHub] Math Error: " .. err) end
                     -- print("[NoctyraHub] SUCCESS: Modified CFrame for " .. self.Name)
                     return OldNC(self, unpack(args))
                end
            end
        end

        if not checkcaller() and Settings.Combat.SilentAim.Enabled and SilentAimTarget then
            if method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" then
                if CachedRay then
                    args[1] = CachedRay
                    return OldNC(self, unpack(args))
                end
            elseif method == "Raycast" then
                local origin = args[1]
                local predPos = SilentAimTarget.Position
                if Settings.Combat.SilentAim.Prediction > 0 then
                    predPos = predPos + (SilentAimTarget.AssemblyLinearVelocity * Settings.Combat.SilentAim.Prediction)
                end
                local direction = (predPos - origin).Unit * 1000
                args[2] = direction
                return OldNC(self, unpack(args))
            end
        end

        return OldNC(self, ...)
    end)

    MT.__index = newcclosure(function(self, key)
        if not checkcaller() and self == Mouse and Settings.Combat.SilentAim.Enabled and SilentAimTarget then
            if key == "Hit" then
                local predPos = SilentAimTarget.Position
                if Settings.Combat.SilentAim.Prediction > 0 then
                    predPos = predPos + (SilentAimTarget.AssemblyLinearVelocity * Settings.Combat.SilentAim.Prediction)
                end
                return CFrame.new(predPos)
            elseif key == "Target" then
                return SilentAimTarget
            end
        end
        return OldIDX(self, key)
    end)

    MT.__newindex = newcclosure(function(self, key, value)
        if not checkcaller() and self == Camera and key == "CFrame" and Settings.Visuals.World.AspectRatio.Enabled then
            value = value * CFrame.new(0, 0, 0, 1, 0, 0, 0, Settings.Visuals.World.AspectRatio.Value, 0, 0, 0, 1)
        end
        return OldNewIDX(self, key, value)
    end)

    setreadonly(MT, true)
else
    warn("Metatable hooks failed!")
end

local AA_Variables = { RealCFrame = CFrame.new(), FakeCFrame = CFrame.new(), SpinAngle = 0, OrbitAngle = 0, VisualParts = {}, OriginalNeckC0 = nil }

local function CleanupGhost()
    for _, data in pairs(AA_Variables.VisualParts) do if data.Clone then data.Clone:Destroy() end end
    AA_Variables.VisualParts = {}
end

local function UpdateGhost(cframe)
    if (not Settings.Combat.AntiAim.ShowVisuals and not Settings.Combat.AntiAim.ClientSided) or Settings.Combat.AntiAim.ClientSided or not LocalPlayer.Character then CleanupGhost(); return end
    local char = LocalPlayer.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if #AA_Variables.VisualParts == 0 then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local clone = part:Clone()
                clone.Parent = Workspace; clone.Anchored = true; clone.CanCollide = false; clone.Transparency = 0.6; clone.Color = Color3.fromRGB(100, 100, 255); clone.Material = Enum.Material.ForceField
                for _, child in pairs(clone:GetDescendants()) do if child:IsA("JointInstance") or child:IsA("Script") then child:Destroy() end end
                table.insert(AA_Variables.VisualParts, {Clone = clone, Original = part})
            end
        end
    end
    for _, data in pairs(AA_Variables.VisualParts) do
        if data.Original and data.Original.Parent then
            local relative = root.CFrame:ToObjectSpace(data.Original.CFrame)
            data.Clone.CFrame = cframe * relative
        else data.Clone:Destroy() end
    end
end

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local neck = char and char:FindFirstChild("Neck", true)

    if not Settings.Combat.AntiAim.Enabled then
        if AA_Variables.OriginalNeckC0 and neck then neck.C0 = AA_Variables.OriginalNeckC0; AA_Variables.OriginalNeckC0 = nil end
        CleanupGhost()
        return
    end
    if not root then return end
    if neck and not AA_Variables.OriginalNeckC0 then AA_Variables.OriginalNeckC0 = neck.C0 end
    AA_Variables.RealCFrame = root.CFrame

    local _, camY, _ = Camera.CFrame:ToEulerAnglesYXZ()
    local baseAngle = camY
    local yawBaseMode = Settings.Combat.AntiAim.YawBase
    if yawBaseMode == "0" then baseAngle = camY
    elseif yawBaseMode == "180" then baseAngle = camY + math.rad(180)
    elseif yawBaseMode == "90" then baseAngle = camY + math.rad(-90)
    elseif yawBaseMode == "-90" then baseAngle = camY + math.rad(90)
    elseif yawBaseMode == "At Players" then
        local target = GetClosestEnemyForAA()
        if target then baseAngle = CFrame.lookAt(root.Position, Vector3.new(target.Position.X, root.Position.Y, target.Position.Z)).Rotation.Y end
    end

    local methodOffset = CFrame.new()
    local method = Settings.Combat.AntiAim.Method
    if method == "Jitter" then
        local angle = math.random() > 0.5 and Settings.Combat.AntiAim.JitterAngle or -Settings.Combat.AntiAim.JitterAngle
        methodOffset = CFrame.Angles(0, math.rad(angle), 0)
    elseif method == "Spin" then
        AA_Variables.SpinAngle = AA_Variables.SpinAngle + Settings.Combat.AntiAim.SpinSpeed
        methodOffset = CFrame.Angles(0, math.rad(AA_Variables.SpinAngle), 0)
    elseif method == "Orbit" then
        AA_Variables.OrbitAngle = AA_Variables.OrbitAngle + (Settings.Combat.AntiAim.OrbitSpeed * 0.1)
        local radius = Settings.Combat.AntiAim.OrbitRadius
        methodOffset = CFrame.new(math.cos(math.rad(AA_Variables.OrbitAngle)) * radius, 0, math.sin(math.rad(AA_Variables.OrbitAngle)) * radius)
    end

    local finalYaw = baseAngle + math.rad(Settings.Combat.AntiAim.YawOffset)
    AA_Variables.FakeCFrame = CFrame.new(root.Position) * CFrame.Angles(0, finalYaw, 0) * methodOffset
    root.CFrame = AA_Variables.FakeCFrame
    
    if not Settings.Combat.AntiAim.ClientSided then UpdateGhost(AA_Variables.FakeCFrame) else CleanupGhost() end

    if neck and AA_Variables.OriginalNeckC0 then
        local pitchMode = Settings.Combat.AntiAim.Pitch
        if pitchMode == "Zero" then neck.C0 = AA_Variables.OriginalNeckC0
        elseif pitchMode == "Up" then neck.C0 = CFrame.new(AA_Variables.OriginalNeckC0.Position) * CFrame.Angles(math.rad(90), 0, 0)
        elseif pitchMode == "Down" then neck.C0 = CFrame.new(AA_Variables.OriginalNeckC0.Position) * CFrame.Angles(math.rad(-90), 0, 0)
        end
    end

    if not Settings.Combat.AntiAim.ClientSided then RunService.RenderStepped:Wait(); root.CFrame = AA_Variables.RealCFrame end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if Settings.Visuals.World.TimeChanger then Lighting.ClockTime = Settings.Visuals.World.TimeValue end
        if Settings.Visuals.World.Ambience then Lighting.Ambient = Settings.Visuals.World.AmbienceColor; Lighting.OutdoorAmbient = Settings.Visuals.World.AmbienceColor end
        if Settings.Visuals.World.Brightness then Lighting.Brightness = Settings.Visuals.World.BrightnessValue end
    end
end)

local CrosshairDrawings = { Lines = {}, Hooks = {}, Circle = Drawing.new("Circle"), Square = Drawing.new("Square") }
for i = 1, 4 do table.insert(CrosshairDrawings.Lines, Drawing.new("Line")); table.insert(CrosshairDrawings.Hooks, Drawing.new("Line")) end

local function UpdateCrosshair()
    local s = Settings.Visuals.Crosshair
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, d in pairs(CrosshairDrawings.Lines) do d.Visible = false end
    for _, d in pairs(CrosshairDrawings.Hooks) do d.Visible = false end
    CrosshairDrawings.Circle.Visible = false; CrosshairDrawings.Square.Visible = false

    if s.Enabled then
        local size, gap, thick, color = s.Size, s.Gap, s.Thickness, s.Color
        if s.Rainbow then color = Color3.fromHSV(tick() % 5 / 5, 1, 1) end

        if s.Mode == "Default" or s.Mode == "Swastika" then
            local offsets = {{Vector2.new(0, -gap-size), Vector2.new(0, -gap)}, {Vector2.new(0, gap), Vector2.new(0, gap+size)}, {Vector2.new(-gap-size, 0), Vector2.new(-gap, 0)}, {Vector2.new(gap, 0), Vector2.new(gap+size, 0)}}
            for i, line in ipairs(CrosshairDrawings.Lines) do line.Visible = true; line.From = center + offsets[i][1]; line.To = center + offsets[i][2]; line.Thickness = thick; line.Color = color end
            if s.Mode == "Swastika" then
                CrosshairDrawings.Hooks[1].Visible = true; CrosshairDrawings.Hooks[1].From = center + Vector2.new(0, -gap-size); CrosshairDrawings.Hooks[1].To = center + Vector2.new(size, -gap-size)
                CrosshairDrawings.Hooks[2].Visible = true; CrosshairDrawings.Hooks[2].From = center + Vector2.new(0, gap+size); CrosshairDrawings.Hooks[2].To = center + Vector2.new(-size, gap+size)
                CrosshairDrawings.Hooks[3].Visible = true; CrosshairDrawings.Hooks[3].From = center + Vector2.new(-gap-size, 0); CrosshairDrawings.Hooks[3].To = center + Vector2.new(-gap-size, -size)
                CrosshairDrawings.Hooks[4].Visible = true; CrosshairDrawings.Hooks[4].From = center + Vector2.new(gap+size, 0); CrosshairDrawings.Hooks[4].To = center + Vector2.new(gap+size, size)
                for _, hook in pairs(CrosshairDrawings.Hooks) do hook.Thickness = thick; hook.Color = color end
            end
        elseif s.Mode == "Circle" then
            CrosshairDrawings.Circle.Visible = true; CrosshairDrawings.Circle.Position = center; CrosshairDrawings.Circle.Radius = size; CrosshairDrawings.Circle.Thickness = thick; CrosshairDrawings.Circle.Color = color; CrosshairDrawings.Circle.Filled = false
        elseif s.Mode == "Square" then
            CrosshairDrawings.Square.Visible = true; CrosshairDrawings.Square.Size = Vector2.new(size * 2, size * 2); CrosshairDrawings.Square.Position = center - Vector2.new(size, size); CrosshairDrawings.Square.Thickness = thick; CrosshairDrawings.Square.Color = color; CrosshairDrawings.Square.Filled = false
        end
    end
end

local ESP_Cache = {}
local function CreateDrawing(type, properties) local drawing = Drawing.new(type); for k, v in pairs(properties) do drawing[k] = v end; return drawing end
local function RemoveESP(player) if ESP_Cache[player] then for _, drawing in pairs(ESP_Cache[player]) do drawing:Remove() end; ESP_Cache[player] = nil end end
local function AddESP(player)
    if player == LocalPlayer then return end
    ESP_Cache[player] = {
        Box = CreateDrawing("Square", {Thickness = 1, Filled = false, Transparency = 1, ZIndex = 2}),
        BoxOutline = CreateDrawing("Square", {Thickness = 3, Filled = false, Transparency = 0.5, Color = Color3.new(0,0,0), ZIndex = 1}),
        HealthBarOutline = CreateDrawing("Square", {Thickness = 1, Filled = true, Transparency = 1, Color = Color3.new(0,0,0), ZIndex = 1}),
        HealthBar = CreateDrawing("Square", {Thickness = 1, Filled = true, Transparency = 1, ZIndex = 2}),
        Tracer = CreateDrawing("Line", {Thickness = 1, Transparency = 1}),
        Name = CreateDrawing("Text", {Size = 13, Center = true, Outline = true, Transparency = 1}),
        Distance = CreateDrawing("Text", {Size = 12, Center = true, Outline = true, Transparency = 1}),
        Weapon = CreateDrawing("Text", {Size = 12, Center = true, Outline = true, Transparency = 1}),
        Arrow = CreateDrawing("Triangle", {Thickness = 1, Filled = true, Transparency = 1, ZIndex = 3})
    }
end
for _, player in pairs(Players:GetPlayers()) do AddESP(player) end
Players.PlayerAdded:Connect(AddESP); Players.PlayerRemoving:Connect(RemoveESP)

local function HideAllESP()
    for _, drawings in pairs(ESP_Cache) do for _, d in pairs(drawings) do d.Visible = false end end
end

local function GetOffscreenPosition(position, radius)
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local objectSpace = Camera.CFrame:PointToObjectSpace(position)
    local angle = math.atan2(-objectSpace.Y, objectSpace.X)
    return Vector2.new(screenCenter.X + math.cos(angle) * radius, screenCenter.Y + math.sin(angle) * radius), angle
end

local FOVCircle = Drawing.new("Circle"); FOVCircle.Thickness = 1; FOVCircle.Filled = false
local SilentFOVCircle = Drawing.new("Circle"); SilentFOVCircle.Thickness = 1; SilentFOVCircle.Filled = false

RunService.RenderStepped:Connect(function()
    if Settings.Combat.Aimbot.Enabled then
        local isAiming = IsKeyDown(Settings.Combat.Aimbot.Keybind)
        if isAiming then
            local target = GetTarget(Settings.Combat.Aimbot)
            if target then
                local currentCF = Camera.CFrame
                local targetCF = CFrame.new(currentCF.Position, target.Position)
                local smooth = Settings.Combat.Aimbot.Smoothing; if smooth < 1 then smooth = 1 end
                
                local newCFrame = currentCF:Lerp(targetCF, 1 / smooth)
                
                if Settings.Visuals.World.AspectRatio.Enabled then
                    newCFrame = newCFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, Settings.Visuals.World.AspectRatio.Value, 0, 0, 0, 1)
                end
                
                Camera.CFrame = newCFrame
            end
        end
    end

    SilentAimTarget = nil
    CachedRay = nil
    if Settings.Combat.SilentAim.Enabled then
        SilentAimTarget = GetTarget(Settings.Combat.SilentAim)
        if SilentAimTarget then
            local predPos = SilentAimTarget.Position
            if Settings.Combat.SilentAim.Prediction > 0 then
                predPos = predPos + (SilentAimTarget.AssemblyLinearVelocity * Settings.Combat.SilentAim.Prediction)
            end
            local direction = (predPos - Camera.CFrame.Position).Unit * 1000
            CachedRay = Ray.new(Camera.CFrame.Position, direction)
        end
    end

    if Settings.Combat.Aimbot.Enabled and Settings.Combat.Aimbot.FOV.Enabled then
        FOVCircle.Visible = true; FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2); FOVCircle.Radius = Settings.Combat.Aimbot.FOV.Radius; FOVCircle.Color = Settings.Combat.Aimbot.FOV.Color
    else FOVCircle.Visible = false end

    if Settings.Combat.SilentAim.Enabled and Settings.Combat.SilentAim.FOV.Enabled then
        SilentFOVCircle.Visible = true; SilentFOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2); SilentFOVCircle.Radius = Settings.Combat.SilentAim.FOV.Radius; SilentFOVCircle.Color = Settings.Combat.SilentAim.FOV.Color
    else SilentFOVCircle.Visible = false end

    if Settings.Visuals.World.FOV then Camera.FieldOfView = Settings.Visuals.World.FOVValue end
    
    if Settings.Visuals.World.ThirdPerson.Enabled then
        LocalPlayer.CameraMaxZoomDistance = Settings.Visuals.World.ThirdPerson.Distance
        LocalPlayer.CameraMinZoomDistance = Settings.Visuals.World.ThirdPerson.Distance
    end

    UpdateCrosshair()

    if not Settings.Visuals.ESP.Enabled and not Settings.Visuals.ESP.Offscreen.Enabled then
        HideAllESP()
    else
        for player, drawings in pairs(ESP_Cache) do
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChild("Humanoid")
            local onTeam = IsTeammate(player)

            if character and rootPart and humanoid and humanoid.Health > 0 and not onTeam then
                local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

                if onScreen and Settings.Visuals.ESP.Enabled then
                    drawings.Arrow.Visible = false 
                    local rootPos = rootPart.Position
                    local headPos = rootPos + Vector3.new(0, 2, 0)
                    local legPos = rootPos - Vector3.new(0, 3, 0)
                    local height = math.abs(Camera:WorldToViewportPoint(headPos).Y - Camera:WorldToViewportPoint(legPos).Y)
                    local width = height / 2
                    local boxPos = Vector2.new(vector.X - width / 2, vector.Y - height / 2)
                    local boxSize = Vector2.new(width, height)

                    if Settings.Visuals.ESP.Boxes then
                        drawings.Box.Visible = true; drawings.Box.Size = boxSize; drawings.Box.Position = boxPos; drawings.Box.Color = GetColor("Box")
                        drawings.BoxOutline.Visible = true; drawings.BoxOutline.Size = boxSize; drawings.BoxOutline.Position = boxPos
                    else drawings.Box.Visible = false; drawings.BoxOutline.Visible = false end

                    if Settings.Visuals.ESP.HealthBar then
                        local hp = math.clamp(humanoid.Health, 0, humanoid.MaxHealth)
                        local maxHp = humanoid.MaxHealth; if maxHp <= 0 then maxHp = 100 end
                        local hpPercent = hp / maxHp
                        local barHeight = height * hpPercent
                        drawings.HealthBarOutline.Visible = true; drawings.HealthBarOutline.Size = Vector2.new(4, height); drawings.HealthBarOutline.Position = Vector2.new(boxPos.X - 6, boxPos.Y)
                        drawings.HealthBar.Visible = true; drawings.HealthBar.Size = Vector2.new(2, barHeight); drawings.HealthBar.Position = Vector2.new(boxPos.X - 5, boxPos.Y + (height - barHeight)); drawings.HealthBar.Color = Color3.fromHSV(hpPercent * 0.3, 1, 1)
                    else drawings.HealthBar.Visible = false; drawings.HealthBarOutline.Visible = false end

                    if Settings.Visuals.ESP.Tracers then
                        drawings.Tracer.Visible = true; drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); drawings.Tracer.To = Vector2.new(vector.X, vector.Y + height/2); drawings.Tracer.Color = GetColor("Tracer")
                    else drawings.Tracer.Visible = false end

                    if Settings.Visuals.ESP.Names then
                        drawings.Name.Visible = true; drawings.Name.Text = player.Name; drawings.Name.Position = Vector2.new(vector.X, boxPos.Y - 16); drawings.Name.Color = GetColor("Name")
                    else drawings.Name.Visible = false end

                    local bottomOffset = 0
                    if Settings.Visuals.ESP.Distance then
                        local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPos).Magnitude)
                        drawings.Distance.Visible = true; drawings.Distance.Text = tostring(dist) .. "m"; drawings.Distance.Position = Vector2.new(vector.X, boxPos.Y + height + 2); drawings.Distance.Color = GetColor("Distance")
                        bottomOffset = bottomOffset + 14
                    else drawings.Distance.Visible = false end

                    if Settings.Visuals.ESP.Weapon then
                        local weaponText = getEquippedToolName(player, character)
                        drawings.Weapon.Visible = true; drawings.Weapon.Text = weaponText; drawings.Weapon.Position = Vector2.new(vector.X, boxPos.Y + height + 2 + bottomOffset); drawings.Weapon.Color = GetColor("Weapon")
                    else drawings.Weapon.Visible = false end

                elseif not onScreen and Settings.Visuals.ESP.Offscreen.Enabled then
                    drawings.Box.Visible = false; drawings.BoxOutline.Visible = false; drawings.HealthBar.Visible = false; drawings.HealthBarOutline.Visible = false; drawings.Tracer.Visible = false; drawings.Name.Visible = false; drawings.Distance.Visible = false; drawings.Weapon.Visible = false
                    local centerPos, angle = GetOffscreenPosition(rootPart.Position, Settings.Visuals.ESP.Offscreen.Radius)
                    local size = Settings.Visuals.ESP.Offscreen.Size
                    local p1 = Vector2.new(centerPos.X + math.cos(angle) * size, centerPos.Y + math.sin(angle) * size)
                    local p2 = Vector2.new(centerPos.X + math.cos(angle + 2.5) * (size/1.5), centerPos.Y + math.sin(angle + 2.5) * (size/1.5))
                    local p3 = Vector2.new(centerPos.X + math.cos(angle - 2.5) * (size/1.5), centerPos.Y + math.sin(angle - 2.5) * (size/1.5))
                    drawings.Arrow.Visible = true; drawings.Arrow.PointA = p1; drawings.Arrow.PointB = p2; drawings.Arrow.PointC = p3; drawings.Arrow.Color = Settings.Visuals.ESP.Offscreen.Color
                else
                    for _, d in pairs(drawings) do d.Visible = false end
                end
            else
                for _, d in pairs(drawings) do d.Visible = false end
            end
        end
    end
end)

local CombatTab = Window:Tab({ Title = "Combat", Icon = "sword" })
local VisualsTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "box" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- [[ COMBAT TAB ]]
local AimbotSection = CombatTab:Section("Aimbot")
AimbotSection:Toggle({ Name = "Enable Aimbot", Value = Settings.Combat.Aimbot.Enabled, Callback = function(v) Settings.Combat.Aimbot.Enabled = v end })
AimbotSection:Dropdown({ Name = "Aim Part", Items = R15Parts, Value = Settings.Combat.Aimbot.AimPart, Callback = function(v) Settings.Combat.Aimbot.AimPart = v end })
AimbotSection:Slider({ Name = "Smoothing", Min = 1, Max = 20, Value = Settings.Combat.Aimbot.Smoothing, Callback = function(v) Settings.Combat.Aimbot.Smoothing = v end })
AimbotSection:Toggle({ Name = "Team Check", Value = Settings.Combat.Aimbot.TeamCheck, Callback = function(v) Settings.Combat.Aimbot.TeamCheck = v end })
AimbotSection:Toggle({ Name = "Wall Check", Value = Settings.Combat.Aimbot.WallCheck, Callback = function(v) Settings.Combat.Aimbot.WallCheck = v end })
AimbotSection:Toggle({ Name = "Always On", Value = Settings.Combat.Aimbot.AlwaysOn, Callback = function(v) Settings.Combat.Aimbot.AlwaysOn = v end })
AimbotSection:Keybind({ Name = "Aim Key", Value = "MouseButton2", Callback = function(v) Settings.Combat.Aimbot.Keybind = v end })

local AimFOVSection = CombatTab:Section("Aimbot FOV")
AimFOVSection:Toggle({ Name = "Draw FOV", Value = Settings.Combat.Aimbot.FOV.Enabled, Callback = function(v) Settings.Combat.Aimbot.FOV.Enabled = v end })
AimFOVSection:Slider({ Name = "Radius", Min = 10, Max = 800, Value = Settings.Combat.Aimbot.FOV.Radius, Callback = function(v) Settings.Combat.Aimbot.FOV.Radius = v end })
AimFOVSection:Colorpicker({ Name = "Color", Value = Settings.Combat.Aimbot.FOV.Color, Callback = function(v) Settings.Combat.Aimbot.FOV.Color = v end })

local SilentSection = CombatTab:Section("Silent Aim")
SilentSection:Toggle({ Name = "Enable Silent Aim", Value = Settings.Combat.SilentAim.Enabled, Callback = function(v) Settings.Combat.SilentAim.Enabled = v end })
SilentSection:Dropdown({ Name = "Aim Part", Items = R15Parts, Value = Settings.Combat.SilentAim.AimPart, Callback = function(v) Settings.Combat.SilentAim.AimPart = v end })
SilentSection:Slider({ Name = "Prediction", Min = 0, Max = 1, Step = 0.01, Value = Settings.Combat.SilentAim.Prediction, Callback = function(v) Settings.Combat.SilentAim.Prediction = v end })
SilentSection:Toggle({ Name = "Team Check", Value = Settings.Combat.SilentAim.TeamCheck, Callback = function(v) Settings.Combat.SilentAim.TeamCheck = v end })
SilentSection:Toggle({ Name = "Wall Check", Value = Settings.Combat.SilentAim.WallCheck, Callback = function(v) Settings.Combat.SilentAim.WallCheck = v end })

local SilentFOVSection = CombatTab:Section("Silent Aim FOV")
SilentFOVSection:Toggle({ Name = "Draw FOV", Value = Settings.Combat.SilentAim.FOV.Enabled, Callback = function(v) Settings.Combat.SilentAim.FOV.Enabled = v end })
SilentFOVSection:Slider({ Name = "Radius", Min = 10, Max = 800, Value = Settings.Combat.SilentAim.FOV.Radius, Callback = function(v) Settings.Combat.SilentAim.FOV.Radius = v end })
SilentFOVSection:Colorpicker({ Name = "Color", Value = Settings.Combat.SilentAim.FOV.Color, Callback = function(v) Settings.Combat.SilentAim.FOV.Color = v end })

local AASection = CombatTab:Section("Anti-Aim")
AASection:Toggle({ Name = "Enable Anti-Aim", Value = Settings.Combat.AntiAim.Enabled, Callback = function(v) Settings.Combat.AntiAim.Enabled = v; if not v then CleanupGhost() end end })
AASection:Dropdown({ Name = "Method", Items = {"Static", "Jitter", "Spin", "Orbit"}, Value = Settings.Combat.AntiAim.Method, Callback = function(v) Settings.Combat.AntiAim.Method = v end })
AASection:Dropdown({ Name = "Yaw Base", Items = {"Camera", "0", "90", "180", "-90", "At Players"}, Value = Settings.Combat.AntiAim.YawBase, Callback = function(v) Settings.Combat.AntiAim.YawBase = v end })
AASection:Dropdown({ Name = "Pitch", Items = {"Zero", "Up", "Down"}, Value = Settings.Combat.AntiAim.Pitch, Callback = function(v) Settings.Combat.AntiAim.Pitch = v end })
AASection:Toggle({ Name = "Show Ghost", Value = Settings.Combat.AntiAim.ShowVisuals, Callback = function(v) Settings.Combat.AntiAim.ShowVisuals = v; if not v then CleanupGhost() end end })
AASection:Toggle({ Name = "Client Sided", Value = Settings.Combat.AntiAim.ClientSided, Callback = function(v) Settings.Combat.AntiAim.ClientSided = v end })
AASection:Slider({ Name = "Yaw Offset", Min = -180, Max = 180, Value = Settings.Combat.AntiAim.YawOffset, Callback = function(v) Settings.Combat.AntiAim.YawOffset = v end })
AASection:Slider({ Name = "Jitter Angle", Min = 10, Max = 180, Value = Settings.Combat.AntiAim.JitterAngle, Callback = function(v) Settings.Combat.AntiAim.JitterAngle = v end })
AASection:Slider({ Name = "Spin Speed", Min = 1, Max = 100, Value = Settings.Combat.AntiAim.SpinSpeed, Callback = function(v) Settings.Combat.AntiAim.SpinSpeed = v end })
AASection:Slider({ Name = "Orbit Radius", Min = 1, Max = 20, Value = Settings.Combat.AntiAim.OrbitRadius, Callback = function(v) Settings.Combat.AntiAim.OrbitRadius = v end })
AASection:Slider({ Name = "Orbit Speed", Min = 1, Max = 50, Value = Settings.Combat.AntiAim.OrbitSpeed, Callback = function(v) Settings.Combat.AntiAim.OrbitSpeed = v end })


-- [[ VISUALS TAB ]]
local ESPSection = VisualsTab:Section("ESP General")
ESPSection:Toggle({ Name = "Enable ESP", Value = Settings.Visuals.ESP.Enabled, Callback = function(v) Settings.Visuals.ESP.Enabled = v end })
ESPSection:Toggle({ Name = "Boxes", Value = Settings.Visuals.ESP.Boxes, Callback = function(v) Settings.Visuals.ESP.Boxes = v end })
ESPSection:Toggle({ Name = "Health Bar", Value = Settings.Visuals.ESP.HealthBar, Callback = function(v) Settings.Visuals.ESP.HealthBar = v end })
ESPSection:Toggle({ Name = "Names", Value = Settings.Visuals.ESP.Names, Callback = function(v) Settings.Visuals.ESP.Names = v end })
ESPSection:Toggle({ Name = "Distance", Value = Settings.Visuals.ESP.Distance, Callback = function(v) Settings.Visuals.ESP.Distance = v end })
ESPSection:Toggle({ Name = "Weapon", Value = Settings.Visuals.ESP.Weapon, Callback = function(v) Settings.Visuals.ESP.Weapon = v end })
ESPSection:Toggle({ Name = "Tracers", Value = Settings.Visuals.ESP.Tracers, Callback = function(v) Settings.Visuals.ESP.Tracers = v end })
ESPSection:Toggle({ Name = "Team Check", Value = Settings.Visuals.ESP.TeamCheck, Callback = function(v) Settings.Visuals.ESP.TeamCheck = v end })

local OffscreenSection = VisualsTab:Section("Offscreen ESP")
OffscreenSection:Toggle({ Name = "Enabled", Value = Settings.Visuals.ESP.Offscreen.Enabled, Callback = function(v) Settings.Visuals.ESP.Offscreen.Enabled = v end })
OffscreenSection:Slider({ Name = "Radius", Min = 50, Max = 500, Value = Settings.Visuals.ESP.Offscreen.Radius, Callback = function(v) Settings.Visuals.ESP.Offscreen.Radius = v end })
OffscreenSection:Slider({ Name = "Size", Min = 5, Max = 30, Value = Settings.Visuals.ESP.Offscreen.Size, Callback = function(v) Settings.Visuals.ESP.Offscreen.Size = v end })
OffscreenSection:Colorpicker({ Name = "Color", Value = Settings.Visuals.ESP.Offscreen.Color, Callback = function(v) Settings.Visuals.ESP.Offscreen.Color = v end })

local ESPColorSection = VisualsTab:Section("ESP Colors")
ESPColorSection:Toggle({ Name = "Override Colors", Value = Settings.Visuals.ESP.OverrideColors, Callback = function(v) Settings.Visuals.ESP.OverrideColors = v end })
ESPColorSection:Colorpicker({ Name = "Box Color", Value = Settings.Visuals.ESP.Colors.Box, Callback = function(v) Settings.Visuals.ESP.Colors.Box = v end })
ESPColorSection:Colorpicker({ Name = "Name Color", Value = Settings.Visuals.ESP.Colors.Name, Callback = function(v) Settings.Visuals.ESP.Colors.Name = v end })
ESPColorSection:Colorpicker({ Name = "Distance Color", Value = Settings.Visuals.ESP.Colors.Distance, Callback = function(v) Settings.Visuals.ESP.Colors.Distance = v end })
ESPColorSection:Colorpicker({ Name = "Weapon Color", Value = Settings.Visuals.ESP.Colors.Weapon, Callback = function(v) Settings.Visuals.ESP.Colors.Weapon = v end })
ESPColorSection:Colorpicker({ Name = "Tracer Color", Value = Settings.Visuals.ESP.Colors.Tracer, Callback = function(v) Settings.Visuals.ESP.Colors.Tracer = v end })

local WorldSection = VisualsTab:Section("World")
WorldSection:Toggle({ Name = "Time Changer", Value = Settings.Visuals.World.TimeChanger, Callback = function(v) Settings.Visuals.World.TimeChanger = v end })
WorldSection:Slider({ Name = "Clock Time", Min = 0, Max = 24, Value = Settings.Visuals.World.TimeValue, Callback = function(v) Settings.Visuals.World.TimeValue = v end })
WorldSection:Toggle({ Name = "Ambience", Value = Settings.Visuals.World.Ambience, Callback = function(v) Settings.Visuals.World.Ambience = v end })
WorldSection:Colorpicker({ Name = "Ambience Color", Value = Settings.Visuals.World.AmbienceColor, Callback = function(v) Settings.Visuals.World.AmbienceColor = v end })
WorldSection:Toggle({ Name = "Brightness", Value = Settings.Visuals.World.Brightness, Callback = function(v) Settings.Visuals.World.Brightness = v end })
WorldSection:Slider({ Name = "Brightness Value", Min = 0, Max = 10, Step = 0.1, Value = Settings.Visuals.World.BrightnessValue, Callback = function(v) Settings.Visuals.World.BrightnessValue = v end })
WorldSection:Toggle({ Name = "FOV Changer", Value = Settings.Visuals.World.FOV, Callback = function(v) Settings.Visuals.World.FOV = v end })
WorldSection:Slider({ Name = "Field of View", Min = 30, Max = 120, Value = Settings.Visuals.World.FOVValue, Callback = function(v) Settings.Visuals.World.FOVValue = v end })
WorldSection:Toggle({ Name = "Aspect Ratio", Value = Settings.Visuals.World.AspectRatio.Enabled, Callback = function(v) Settings.Visuals.World.AspectRatio.Enabled = v end })
WorldSection:Slider({ Name = "Aspect Ratio Value", Min = 0, Max = 1, Step = 0.01, Value = Settings.Visuals.World.AspectRatio.Value, Callback = function(v) Settings.Visuals.World.AspectRatio.Value = v end })


local ThirdPersonSection = VisualsTab:Section("Third Person")
local ThirdPersonToggle = ThirdPersonSection:Toggle({ Name = "Enabled", Value = Settings.Visuals.World.ThirdPerson.Enabled, Callback = function(v)
    Settings.Visuals.World.ThirdPerson.Enabled = v
    if not v then
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 128
    end
end })
ThirdPersonSection:Slider({ Name = "Distance", Min = 0, Max = 50, Value = Settings.Visuals.World.ThirdPerson.Distance, Callback = function(v) Settings.Visuals.World.ThirdPerson.Distance = v end })
ThirdPersonSection:Keybind({ Name = "Toggle Key", Value = Settings.Visuals.World.ThirdPerson.Keybind, Callback = function(v) Settings.Visuals.World.ThirdPerson.Keybind = v end })

local VMSection = VisualsTab:Section("Viewmodel")
VMSection:Toggle({ Name = "Enable Viewmodel", Value = Settings.Visuals.Viewmodel.Enabled, Callback = function(v) Settings.Visuals.Viewmodel.Enabled = v end })
VMSection:Slider({ Name = "X Offset", Min = -5, Max = 5, Step = 0.1, Value = Settings.Visuals.Viewmodel.X, Callback = function(v) Settings.Visuals.Viewmodel.X = v end })
VMSection:Slider({ Name = "Y Offset", Min = -5, Max = 5, Step = 0.1, Value = Settings.Visuals.Viewmodel.Y, Callback = function(v) Settings.Visuals.Viewmodel.Y = v end })
VMSection:Slider({ Name = "Z Offset", Min = -5, Max = 5, Step = 0.1, Value = Settings.Visuals.Viewmodel.Z, Callback = function(v) Settings.Visuals.Viewmodel.Z = v end })
VMSection:Slider({ Name = "Pitch", Min = -180, Max = 180, Value = Settings.Visuals.Viewmodel.Pitch, Callback = function(v) Settings.Visuals.Viewmodel.Pitch = v end })
VMSection:Slider({ Name = "Yaw", Min = -180, Max = 180, Value = Settings.Visuals.Viewmodel.Yaw, Callback = function(v) Settings.Visuals.Viewmodel.Yaw = v end })
VMSection:Slider({ Name = "Roll", Min = -180, Max = 180, Value = Settings.Visuals.Viewmodel.Roll, Callback = function(v) Settings.Visuals.Viewmodel.Roll = v end })

local CrosshairSection = VisualsTab:Section("Crosshair")
CrosshairSection:Toggle({ Name = "Enable Crosshair", Value = Settings.Visuals.Crosshair.Enabled, Callback = function(v) Settings.Visuals.Crosshair.Enabled = v end })
CrosshairSection:Dropdown({ Name = "Mode", Items = {"Default", "Swastika", "Circle", "Square"}, Value = Settings.Visuals.Crosshair.Mode, Callback = function(v) Settings.Visuals.Crosshair.Mode = v end })
CrosshairSection:Toggle({ Name = "Rainbow", Value = Settings.Visuals.Crosshair.Rainbow, Callback = function(v) Settings.Visuals.Crosshair.Rainbow = v end })
CrosshairSection:Slider({ Name = "Size", Min = 1, Max = 50, Value = Settings.Visuals.Crosshair.Size, Callback = function(v) Settings.Visuals.Crosshair.Size = v end })
CrosshairSection:Slider({ Name = "Gap", Min = 0, Max = 20, Value = Settings.Visuals.Crosshair.Gap, Callback = function(v) Settings.Visuals.Crosshair.Gap = v end })
CrosshairSection:Slider({ Name = "Thickness", Min = 1, Max = 5, Value = Settings.Visuals.Crosshair.Thickness, Callback = function(v) Settings.Visuals.Crosshair.Thickness = v end })
CrosshairSection:Colorpicker({ Name = "Color", Value = Settings.Visuals.Crosshair.Color, Callback = function(v) Settings.Visuals.Crosshair.Color = v end })


-- [[ MISC TAB ]]
local ExtraSection = MiscTab:Section("Extra")
ExtraSection:Toggle({ Name = "Unlock All Skins", Value = Settings.Misc.SkinUnlocker, Callback = function(state)
    Settings.Misc.SkinUnlocker = state
    if state then applyUnlock() else restoreUnlock() end
end })

local WeaponModsSection = MiscTab:Section("Weapon Mods")
WeaponModsSection:Toggle({ Name = "Enable Weapon Mods", Value = Settings.Weapons.Enabled, Callback = function(v)
    Settings.Weapons.Enabled = v
    if v then ApplyWeaponMods() else RestoreWeaponMods() end
end })
WeaponModsSection:Slider({ Name = "Ammo", Min = 0, Max = 100, Value = Settings.Weapons.Ammo, Callback = function(v) Settings.Weapons.Ammo = v; if Settings.Weapons.Enabled then ApplyWeaponMods() end end })
WeaponModsSection:Toggle({ Name = "Auto", Value = Settings.Weapons.Auto, Callback = function(v) Settings.Weapons.Auto = v; if Settings.Weapons.Enabled then ApplyWeaponMods() end end })
WeaponModsSection:Slider({ Name = "Damage", Min = 0, Max = 100, Value = Settings.Weapons.DMG, Callback = function(v) Settings.Weapons.DMG = v; if Settings.Weapons.Enabled then ApplyWeaponMods() end end })
WeaponModsSection:Slider({ Name = "Equip Time", Min = 0, Max = 100, Step = 0.1, Value = Settings.Weapons.EquipTime, Callback = function(v) Settings.Weapons.EquipTime = v; if Settings.Weapons.Enabled then ApplyWeaponMods() end end })
WeaponModsSection:Slider({ Name = "Fire Rate", Min = 0, Max = 10, Step = 0.1, Value = Settings.Weapons.FireRate, Callback = function(v) Settings.Weapons.FireRate = v; if Settings.Weapons.Enabled then ApplyWeaponMods() end end })
WeaponModsSection:Slider({ Name = "Kill Award", Min = 0, Max = 100, Value = Settings.Weapons.KillAward, Callback = function(v) Settings.Weapons.KillAward = v; if Settings.Weapons.Enabled then ApplyWeaponMods() end end })
WeaponModsSection:Slider({ Name = "Stored Ammo", Min = 0, Max = 100, Value = Settings.Weapons.StoredAmmo, Callback = function(v) Settings.Weapons.StoredAmmo = v; if Settings.Weapons.Enabled then ApplyWeaponMods() end end })

-- [[ SETTINGS TAB ]]
local MenuSettings = SettingsTab:Section("Menu Settings")
MenuSettings:Keybind({ Name = "Menu Key", Value = MenuKey, Callback = function(v) MenuKey = v end })

local function ToggleThirdPerson()
    if ThirdPersonToggle.SetValue then
         ThirdPersonToggle:SetValue(not Settings.Visuals.World.ThirdPerson.Enabled)
    else
        -- Fallback if library API is different
        local v = not Settings.Visuals.World.ThirdPerson.Enabled
        Settings.Visuals.World.ThirdPerson.Enabled = v
        if not v then
            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = 128
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and IsKeyDown(Settings.Visuals.World.ThirdPerson.Keybind) then
        ToggleThirdPerson()
    end
end)

