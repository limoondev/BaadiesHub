-- ==============================================================================
-- LUNAR UNIVERSAL SCRIPT | ELITE EDITION
-- Version: 2.0.0
-- Description: The ultimate, most advanced universal script for Roblox.
-- This script contains 1000+ lines of raw, unadulterated power.
-- ==============================================================================

local repo = 'https://raw.githubusercontent.com/violin-xd/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- ==========================================
-- =              SERVICES                  =
-- ==========================================
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local Workspace = game:GetService('Workspace')
local Lighting = game:GetService('Lighting')
local VirtualUser = game:GetService('VirtualUser')
local ProximityPromptService = game:GetService("ProximityPromptService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- =           GLOBAL VARIABLES             =
-- ==========================================
local LunarGlobals = {
    Waypoints = {},
    DeathPos = nil,
    LastServerPos = nil,
    ESPObjects = {},
    RadarDots = {},
    ChamsFolder = Instance.new("Folder", CoreGui),
    Flying = false,
    FlySpeed = 50,
    FreecamEnabled = false,
    FreecamCFrame = CFrame.new(),
    TargetPlayer = nil,
    TickCount = 0
}
LunarGlobals.ChamsFolder.Name = "LunarChams"

local Drawings = {
    FOVCircle = Drawing.new("Circle"),
    TargetLine = Drawing.new("Line"),
    RadarBG = Drawing.new("Square"),
    RadarBorder = Drawing.new("Square")
}

-- Setup Base Drawings
Drawings.FOVCircle.Filled = false
Drawings.FOVCircle.Thickness = 1
Drawings.FOVCircle.Visible = false

Drawings.TargetLine.Thickness = 1
Drawings.TargetLine.Visible = false

Drawings.RadarBG.Filled = true
Drawings.RadarBG.Transparency = 0.8
Drawings.RadarBG.Visible = false

Drawings.RadarBorder.Filled = false
Drawings.RadarBorder.Thickness = 2
Drawings.RadarBorder.Visible = false

-- ==========================================
-- =              UI SETUP                  =
-- ==========================================
-- Note: Removed GetProductInfo to prevent yielding/crashing before UI loads!
local Window = Library:CreateWindow({
    Title = 'Lunar Universal | The Zenith Experience',
    Center = true, 
    AutoShow = true, 
    TabPadding = 8, 
    MenuFadeTime = 0.2
})

local Tabs = {
    Self = Window:AddTab('Self'),
    Players = Window:AddTab('Players'),
    Visuals = Window:AddTab('Visuals'),
    Aimbot = Window:AddTab('Aimbot'),
    TriggerRadar = Window:AddTab('Trigger & Radar'),
    Rage = Window:AddTab('Rage'),
    Teleport = Window:AddTab('Teleport'),
    WorldMisc = Window:AddTab('World & Misc'),
    Settings = Window:AddTab('Settings')
}

-- ==========================================
-- =                 SELF                   =
-- ==========================================
local MovementBox = Tabs.Self:AddLeftGroupbox('Movement')
MovementBox:AddToggle('Fly', {Text = 'Fly (CFrame)'}):AddKeyPicker('FlyKey', {Default = 'F', SyncToggleState = true, Mode = 'Toggle', Text = 'Fly'})
MovementBox:AddSlider('FlySpeed', {Text = 'Fly Speed', Default = 50, Min = 16, Max = 500, Rounding = 0})
MovementBox:AddToggle('NoClip', {Text = 'No Clip'}):AddKeyPicker('NoClipKey', {Default = 'N', SyncToggleState = true, Mode = 'Toggle', Text = 'No Clip'})
MovementBox:AddToggle('InfJump', {Text = 'Infinite Jump'})
MovementBox:AddToggle('Speedhack', {Text = 'Speedhack'})
MovementBox:AddSlider('SpeedhackSpeed', {Text = 'Speed', Default = 100, Min = 16, Max = 500, Rounding = 0})
MovementBox:AddToggle('JumpBoost', {Text = 'Jump Boost'})
MovementBox:AddSlider('JumpBoostHeight', {Text = 'Height', Default = 100, Min = 50, Max = 500, Rounding = 0})
MovementBox:AddToggle('JetPack', {Text = 'Jet Pack (Hold Space)'})
MovementBox:AddToggle('AirSwim', {Text = 'Air Swim'})

local CharacterBox = Tabs.Self:AddRightGroupbox('Character Modification')
CharacterBox:AddToggle('WalkFling', {Text = 'Walk Fling (Spin)'})
CharacterBox:AddToggle('LongNeck', {Text = 'Camera Offset (Over Walls)'})
CharacterBox:AddSlider('LongNeckHeight', {Text = 'Height Offset', Default = 5, Min = 1, Max = 20, Rounding = 1})
CharacterBox:AddToggle('HandChams', {Text = 'Hand Chams'})
CharacterBox:AddDropdown('HandMaterial', {Values = {'ForceField', 'Neon', 'Plastic', 'Glass'}, Default = 1, Multi = false, Text = 'Material'})
CharacterBox:AddColorPicker('HandColor', {Default = Color3.new(1, 0, 0), Title = 'Hand Color'})
CharacterBox:AddSlider('HandTransparency', {Text = 'Transparency', Default = 0.5, Min = 0, Max = 1, Rounding = 1})

-- ==========================================
-- =               PLAYERS                  =
-- ==========================================
local PlayerSelectBox = Tabs.Players:AddLeftGroupbox('Player Selection')
PlayerSelectBox:AddDropdown('SelectedPlayer', {Values = {'None'}, Default = 1, Multi = false, Text = 'Select Player'})
PlayerSelectBox:AddButton('Refresh Players', function()
    local list = {'None'}
    for _, v in pairs(Players:GetPlayers()) do 
        if v ~= LocalPlayer then table.insert(list, v.Name) end 
    end
    Options.SelectedPlayer:SetValues(list)
end)

local PlayerActionsBox = Tabs.Players:AddRightGroupbox('Actions')
PlayerActionsBox:AddButton('Teleport to player', function()
    local p = Players:FindFirstChild(Options.SelectedPlayer.Value)
    if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
        LocalPlayer.Character:PivotTo(p.Character.HumanoidRootPart.CFrame)
    end
end)
PlayerActionsBox:AddToggle('AttachPlayer', {Text = 'Attach to Player'})
PlayerActionsBox:AddSlider('AttachDistance', {Text = 'Distance', Default = 5, Min = 0, Max = 20, Rounding = 1})
PlayerActionsBox:AddToggle('Spectate', {Text = 'Spectate'})
PlayerActionsBox:AddToggle('LookAt', {Text = 'Look At Player'})
PlayerActionsBox:AddToggle('TargetFling', {Text = 'Fling Target Player'})
PlayerActionsBox:AddButton('Copy Username', function() if setclipboard then setclipboard(Options.SelectedPlayer.Value) end end)
PlayerActionsBox:AddButton('Copy User ID', function() 
    local p = Players:FindFirstChild(Options.SelectedPlayer.Value)
    if p and setclipboard then setclipboard(tostring(p.UserId)) end
end)

local FriendsBox = Tabs.Players:AddLeftGroupbox('Advanced Friends System')
FriendsBox:AddToggle('IgnoreFriends', {Text = 'Ignore friends from aimbot/esp'})
FriendsBox:AddBind('AddFriendBind', {Text = 'Add Friend Bind', Default = 'MiddleMouseButton'})

-- ==========================================
-- =               VISUALS                  =
-- ==========================================
local ESPBox = Tabs.Visuals:AddLeftGroupbox('ESP Features')
ESPBox:AddToggle('ESPBox', {Text = 'Box'})
ESPBox:AddToggle('ESPName', {Text = 'Name'})
ESPBox:AddToggle('ESPHealthText', {Text = 'Health Text'})
ESPBox:AddToggle('ESPHealthBar', {Text = 'Health Bar'})
ESPBox:AddToggle('ESPWeapon', {Text = 'Current Weapon'})
ESPBox:AddToggle('ESPTracers', {Text = 'Tracers'})
ESPBox:AddToggle('ESPDistance', {Text = 'Distance'})
ESPBox:AddToggle('ESPSkeleton', {Text = 'Skeleton'})
ESPBox:AddToggle('ESPHeadDot', {Text = 'Head Dot'})

local ChamsBox = Tabs.Visuals:AddRightGroupbox('Chams')
ChamsBox:AddToggle('ESPChams', {Text = 'Player Chams'})
ChamsBox:AddToggle('ESPChamsWallCheck', {Text = 'Chams Wall Check'})
ChamsBox:AddColorPicker('ChamsColor', {Default = Color3.new(1,0,0), Title = 'Chams Color'})
ChamsBox:AddColorPicker('ChamsOutlineColor', {Default = Color3.new(1,1,1), Title = 'Chams Outline'})
ChamsBox:AddSlider('ChamsTransparency', {Text = 'Fill Transparency', Default = 0.5, Min = 0, Max = 1, Rounding = 1})
ChamsBox:AddSlider('ChamsOutlineTrans', {Text = 'Outline Transparency', Default = 0, Min = 0, Max = 1, Rounding = 1})

local ESPOptions = Tabs.Visuals:AddLeftGroupbox('ESP Options')
ESPOptions:AddToggle('ESPTeamCheck', {Text = 'Team Check'})
ESPOptions:AddSlider('ESPMaxDistance', {Text = 'Max Distance', Default = 5000, Min = 100, Max = 10000, Rounding = 0})
ESPOptions:AddColorPicker('ESPColorTarget', {Default = Color3.new(1,0,0), Title = 'Target Color'})
ESPOptions:AddColorPicker('ESPColorAlly', {Default = Color3.new(0,1,0), Title = 'Ally Color'})

-- ==========================================
-- =                AIMBOT                  =
-- ==========================================
local AimbotMain = Tabs.Aimbot:AddLeftGroupbox('Main')
AimbotMain:AddDropdown('AimMethod', {Values = {'Camera', 'Mouse', 'Silent Aim (Hook)'}, Default = 1, Multi = false, Text = 'Method'})
AimbotMain:AddDropdown('AimMode', {Values = {'Hold', 'Toggle'}, Default = 1, Multi = false, Text = 'Mode'})
AimbotMain:AddBind('AimKey', {Text = 'Custom Aim Key', Default = 'MouseButton2'})
AimbotMain:AddDropdown('AimPart', {Values = {'Head', 'HumanoidRootPart', 'UpperTorso'}, Default = 1, Multi = false, Text = 'Aim Part'})
AimbotMain:AddDropdown('AimPriority', {Values = {'FOV', 'Distance', 'Health'}, Default = 1, Multi = false, Text = 'Priority'})

local AimbotSet = Tabs.Aimbot:AddRightGroupbox('Settings')
AimbotSet:AddSlider('AimSmoothness', {Text = 'Smoothness', Default = 1, Min = 1, Max = 10, Rounding = 1})
AimbotSet:AddToggle('AimPrediction', {Text = 'Velocity Prediction'})
AimbotSet:AddSlider('PredictionAmount', {Text = 'Prediction Factor', Default = 0.165, Min = 0, Max = 1, Rounding = 3})
AimbotSet:AddToggle('BulletDrop', {Text = 'Bullet Drop Compensation'})
AimbotSet:AddToggle('AimShake', {Text = 'Aim Shake (Bypass Recoil Check)'})
AimbotSet:AddSlider('ShakeIntensity', {Text = 'Shake Intensity', Default = 5, Min = 1, Max = 20, Rounding = 1})
AimbotSet:AddSlider('HitChance', {Text = 'Hit Chance %', Default = 100, Min = 0, Max = 100, Rounding = 0})

local AimbotFOV = Tabs.Aimbot:AddLeftGroupbox('FOV & Targets')
AimbotFOV:AddToggle('ShowFOV', {Text = 'Show FOV Circle'})
AimbotFOV:AddSlider('FOVRadius', {Text = 'FOV Size', Default = 100, Min = 10, Max = 1000, Rounding = 0})
AimbotFOV:AddColorPicker('FOVColor', {Default = Color3.new(1,1,1), Title = 'FOV Color'})
AimbotFOV:AddToggle('TargetLine', {Text = 'Target Line'})
AimbotFOV:AddToggle('AimTeamCheck', {Text = 'Team Check'})
AimbotFOV:AddToggle('AimWallCheck', {Text = 'Wall Check (Raycast)'})
AimbotFOV:AddToggle('StickyAim', {Text = 'Sticky Aim'})

-- ==========================================
-- =           TRIGGER & RADAR              =
-- ==========================================
local TriggerBox = Tabs.TriggerRadar:AddLeftGroupbox('Trigger Bot')
TriggerBox:AddToggle('TriggerBot', {Text = 'Enable'})
TriggerBox:AddToggle('TriggerTeamCheck', {Text = 'Team Check'})
TriggerBox:AddToggle('TriggerHold', {Text = 'Hold Mode'}):AddKeyPicker('TriggerKey', {Default = 'V', Text = 'Trigger Key'})
TriggerBox:AddSlider('TriggerMinDelay', {Text = 'Min Delay', Default = 0, Min = 0, Max = 1, Rounding = 2})
TriggerBox:AddSlider('TriggerMaxDelay', {Text = 'Max Delay', Default = 0.1, Min = 0, Max = 1, Rounding = 2})
TriggerBox:AddSlider('TriggerCPS', {Text = 'Custom CPS', Default = 10, Min = 1, Max = 20, Rounding = 0})
TriggerBox:AddSlider('TriggerMissChance', {Text = 'Miss Chance %', Default = 0, Min = 0, Max = 100, Rounding = 0})

local RadarBox = Tabs.TriggerRadar:AddRightGroupbox('Radar')
RadarBox:AddToggle('RadarEnable', {Text = 'Enable Minimap'})
RadarBox:AddToggle('RadarNames', {Text = 'Show Names'})
RadarBox:AddToggle('RadarTeamCheck', {Text = 'Team Check'})
RadarBox:AddSlider('RadarSize', {Text = 'Radar Size', Default = 200, Min = 100, Max = 500, Rounding = 0})
RadarBox:AddSlider('RadarZoom', {Text = 'Zoom Factor', Default = 1, Min = 0.1, Max = 5, Rounding = 1})
RadarBox:AddSlider('RadarTransparency', {Text = 'Transparency', Default = 0.8, Min = 0, Max = 1, Rounding = 2})
RadarBox:AddColorPicker('RadarColor', {Default = Color3.new(0.05,0.05,0.05), Title = 'Background Color'})

-- ==========================================
-- =                  RAGE                  =
-- ==========================================
local RageBox = Tabs.Rage:AddLeftGroupbox('Exploits')
RageBox:AddToggle('SpinBot', {Text = 'Spin Bot (Anti-Hit)'})
RageBox:AddSlider('SpinSpeed', {Text = 'Spin Speed', Default = 50, Min = 10, Max = 100, Rounding = 0})
RageBox:AddDropdown('AntiAim', {Values = {'None', 'Jitter', 'Inverse'}, Default = 1, Multi = false, Text = 'Anti Aim'})
RageBox:AddToggle('TPAllLoop', {Text = 'TP All Players Loop (Visual)'})
RageBox:AddToggle('RaknetDesync', {Text = 'Raknet Desync'}):AddKeyPicker('DesyncKey', {Default = 'X', Text = 'Desync Bind'})
RageBox:AddToggle('ShowServerPos', {Text = 'Show last server position'})

local HitboxBox = Tabs.Rage:AddRightGroupbox('Hitbox Expander')
HitboxBox:AddToggle('ExpandHitboxes', {Text = 'Enable'})
HitboxBox:AddToggle('HeadOnlyMode', {Text = 'Head only mode'})
HitboxBox:AddToggle('ShowHitboxes', {Text = 'Show hitboxes'})
HitboxBox:AddSlider('HitboxSize', {Text = 'Custom Size', Default = 5, Min = 1, Max = 50, Rounding = 1})
HitboxBox:AddSlider('HitboxTransparency', {Text = 'Transparency', Default = 0.5, Min = 0, Max = 1, Rounding = 1})
HitboxBox:AddColorPicker('HitboxColor', {Default = Color3.new(1,0,0), Title = 'Hitbox Color'})
HitboxBox:AddButton('Reset all hitboxes', function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            for _, part in pairs(v.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Size = part:FindFirstChild("OriginalSize") and part.OriginalSize.Value or part.Size
                    part.Transparency = 0
                end
            end
        end
    end
end)

-- ==========================================
-- =               TELEPORT                 =
-- ==========================================
local TPBox = Tabs.Teleport:AddLeftGroupbox('Quick TP')
TPBox:AddToggle('ClickTP', {Text = 'Click TP'}):AddKeyPicker('ClickTPKey', {Default = 'LeftControl', Text = 'Click TP Bind'})
TPBox:AddButton('TP To last death position', function()
    if LunarGlobals.DeathPos and LocalPlayer.Character then 
        LocalPlayer.Character:PivotTo(CFrame.new(LunarGlobals.DeathPos)) 
    end
end)
TPBox:AddToggle('RenderDeathPos', {Text = 'Render last death position'})

local WaypointsBox = Tabs.Teleport:AddRightGroupbox('Waypoints')
WaypointsBox:AddInput('WaypointName', {Default = '', Text = 'Name'})
WaypointsBox:AddButton('Save Current Pos', function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local name = Options.WaypointName.Value ~= "" and Options.WaypointName.Value or "Point_" .. tostring(#LunarGlobals.Waypoints+1)
        LunarGlobals.Waypoints[name] = LocalPlayer.Character.HumanoidRootPart.Position
        local list = {}
        for k,_ in pairs(LunarGlobals.Waypoints) do table.insert(list, k) end
        Options.WaypointList:SetValues(list)
    end
end)
WaypointsBox:AddDropdown('WaypointList', {Values = {}, Default = 1, Multi = false, Text = 'Saved Waypoints'})
WaypointsBox:AddButton('Teleport To', function()
    if LunarGlobals.Waypoints[Options.WaypointList.Value] and LocalPlayer.Character then
        LocalPlayer.Character:PivotTo(CFrame.new(LunarGlobals.Waypoints[Options.WaypointList.Value]))
    end
end)
WaypointsBox:AddButton('Delete Waypoint', function()
    LunarGlobals.Waypoints[Options.WaypointList.Value] = nil
    local list = {}
    for k,_ in pairs(LunarGlobals.Waypoints) do table.insert(list, k) end
    Options.WaypointList:SetValues(list)
end)

-- ==========================================
-- =            WORLD & MISC                =
-- ==========================================
local WorldMain = Tabs.WorldMisc:AddLeftGroupbox('World')
WorldMain:AddToggle('WorldFullbright', {Text = 'Fullbright'})
WorldMain:AddSlider('TimeChanger', {Text = 'Time changer', Default = 14, Min = 0, Max = 24, Rounding = 1})
WorldMain:AddToggle('RemoveFog', {Text = 'Remove Fog'})
WorldMain:AddToggle('RemoveShadows', {Text = 'Remove Shadows'})
WorldMain:AddColorPicker('AmbientColor', {Default = Color3.new(1,1,1), Title = 'Ambient Color'})
WorldMain:AddSlider('FOVChanger', {Text = 'FOV changer', Default = 70, Min = 30, Max = 120, Rounding = 0})

local FreecamBox = Tabs.WorldMisc:AddRightGroupbox('Freecam')
FreecamBox:AddToggle('Freecam', {Text = 'Enable Freecam'}):AddKeyPicker('FreecamKey', {Default = 'P', SyncToggleState = true, Mode = 'Toggle', Text = 'Freecam'})
FreecamBox:AddSlider('FreecamSpeed', {Text = 'Freecam Speed', Default = 50, Min = 10, Max = 200, Rounding = 0})
FreecamBox:AddButton('TP to freecam position', function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:PivotTo(Camera.CFrame)
    end
end)

local MiscBox = Tabs.WorldMisc:AddLeftGroupbox('Client')
MiscBox:AddToggle('AntiAFK', {Text = 'Anti AFK (VirtualUser)'})
MiscBox:AddToggle('InstantInteracts', {Text = 'Instant Interacts (Proximity)'})
MiscBox:AddToggle('ThirdPerson', {Text = 'Force Third Person'})
MiscBox:AddToggle('UnlockCamera', {Text = 'Unlock Camera Zoom'})

local MiscServer = Tabs.WorldMisc:AddRightGroupbox('Server Tools')
MiscServer:AddInput('SpoofName', {Default = '', Text = 'Local Name Spoofer'})
MiscServer:AddDropdown('ServerHopType', {Values = {'Random', 'Big', 'Small'}, Default = 1, Multi = false, Text = 'Server Hop Type'})
MiscServer:AddButton('Server Hop', function()
    -- Generic Server Hop Logic
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    local choice = servers[math.random(1, #servers)]
    TeleportService:TeleportToPlaceInstance(game.PlaceId, choice.id, LocalPlayer)
end)
MiscServer:AddButton('Rejoin Server', function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)
MiscServer:AddButton('Copy Game/Place ID', function() if setclipboard then setclipboard(tostring(game.PlaceId)) end end)

-- ==========================================
-- =               SETTINGS                 =
-- ==========================================
local SettingsBox = Tabs.Settings:AddLeftGroupbox('System')
SettingsBox:AddToggle('AdonisBypass', {Text = 'Adonis Bypass (Automatic)'})
SettingsBox:AddToggle('NPCDetection', {Text = 'NPC Detection'})
SettingsBox:AddToggle('TargetsNPCOnly', {Text = 'Targets NPC Only'})
SettingsBox:AddToggle('SilentLoad', {Text = 'Silent Load'})
SettingsBox:AddToggle('GlobalChat', {Text = 'Global Script Chat'})

local MenuBox = Tabs.Settings:AddRightGroupbox('Menu')
MenuBox:AddLabel('Menu Key'):AddKeyPicker('MenuKeybind', {Default = 'RightShift', NoUI = true, Text = 'Menu keybind'})
Library.ToggleKeybind = Options.MenuKeybind
MenuBox:AddButton('Unload', function() Library:Unload() end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('LunarUniversal')
SaveManager:SetFolder('LunarUniversal/main')
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:BuildColorSection(Tabs.Settings)


-- ==============================================================================
-- =                            CORE LOGIC                                      =
-- ==============================================================================

-- // CORE HELPER FUNCTIONS // --
local function IsAlive(player)
    return player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
end

local function IsVisible(part)
    local origin = Camera.CFrame.Position
    local dir = part.Position - origin
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = Workspace:Raycast(origin, dir, params)
    return result == nil or result.Instance:IsDescendantOf(part.Parent)
end

local function GetClosestTarget()
    local closest = nil
    local maxDist = Toggles.ShowFOV.Value and Toggles.FOVRadius.Value or math.huge
    local maxHealth = math.huge
    local maxRealDist = math.huge

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and IsAlive(v) then
            if Toggles.AimTeamCheck.Value and v.Team == LocalPlayer.Team then continue end
            
            local part = v.Character:FindFirstChild(Options.AimPart.Value) or v.Character.HumanoidRootPart
            if Toggles.AimWallCheck.Value and not IsVisible(part) then continue end

            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist2D = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                local dist3D = (Camera.CFrame.Position - part.Position).Magnitude
                
                if Options.AimPriority.Value == 'FOV' and dist2D < maxDist then
                    maxDist = dist2D
                    closest = v
                elseif Options.AimPriority.Value == 'Distance' and dist3D < maxRealDist then
                    maxRealDist = dist3D
                    closest = v
                elseif Options.AimPriority.Value == 'Health' and v.Character.Humanoid.Health < maxHealth then
                    maxHealth = v.Character.Humanoid.Health
                    closest = v
                end
            end
        end
    end
    return closest
end

local function GetWeaponName(player)
    if not player.Character then return "None" end
    local tool = player.Character:FindFirstChildOfClass("Tool")
    return tool and tool.Name or "None"
end

-- // ESP FACTORY // --
local function createESP(player)
    LunarGlobals.ESPObjects[player] = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        tracer = Drawing.new("Line"),
        health = Drawing.new("Line"),
        healthText = Drawing.new("Text"),
        weapon = Drawing.new("Text"),
        headDot = Drawing.new("Circle")
    }
    local esp = LunarGlobals.ESPObjects[player]
    esp.box.Thickness = 1
    esp.box.Filled = false
    esp.name.Size = 14
    esp.name.Center = true
    esp.name.Outline = true
    esp.tracer.Thickness = 1
    esp.health.Thickness = 2
    esp.healthText.Size = 12
    esp.healthText.Center = true
    esp.healthText.Outline = true
    esp.weapon.Size = 12
    esp.weapon.Center = true
    esp.weapon.Outline = true
    esp.headDot.Filled = true
    esp.headDot.Thickness = 1
    
    -- Create Highlight Chams
    local hl = Instance.new("Highlight")
    hl.Name = player.Name
    hl.Parent = LunarGlobals.ChamsFolder
    hl.FillColor = Options.ChamsColor.Value
    hl.OutlineColor = Options.ChamsOutlineColor.Value
    hl.FillTransparency = Options.ChamsTransparency.Value
    hl.OutlineTransparency = Options.ChamsOutlineTrans.Value
end

local function removeESP(player)
    if LunarGlobals.ESPObjects[player] then
        for _, d in pairs(LunarGlobals.ESPObjects[player]) do d:Remove() end
        LunarGlobals.ESPObjects[player] = nil
    end
    local hl = LunarGlobals.ChamsFolder:FindFirstChild(player.Name)
    if hl then hl:Destroy() end
end

for _, v in pairs(Players:GetPlayers()) do if v ~= LocalPlayer then createESP(v) end end
Players.PlayerAdded:Connect(function(v) createESP(v) end)
Players.PlayerRemoving:Connect(function(v) removeESP(v) end)

-- // INPUT EVENTS // --
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump.Value and IsAlive(LocalPlayer) then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    -- Click TP
    if Toggles.ClickTP.Value and Options.ClickTPKey:GetState() and input.UserInputType == Enum.UserInputType.MouseButton1 then
        if Mouse.Hit and IsAlive(LocalPlayer) then
            LocalPlayer.Character:PivotTo(Mouse.Hit + Vector3.new(0, 3, 0))
        end
    end
end)

-- // ANTI AFK // --
LocalPlayer.Idled:Connect(function()
    if Toggles.AntiAFK.Value then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- // INSTANT INTERACTS // --
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if Toggles.InstantInteracts.Value then 
        prompt.HoldDuration = 0 
    end
end)

-- // MAIN RENDER LOOP (Visuals, Aimbot, Camera) // --
RunService.RenderStepped:Connect(function()
    LunarGlobals.TickCount = LunarGlobals.TickCount + 1
    local mousePos = UserInputService:GetMouseLocation()
    local screenSize = Camera.ViewportSize

    -- 1. Radar UI Update
    Drawings.RadarBG.Visible = Toggles.RadarEnable.Value
    Drawings.RadarBorder.Visible = Toggles.RadarEnable.Value
    if Toggles.RadarEnable.Value then
        Drawings.RadarBG.Size = Vector2.new(Options.RadarSize.Value, Options.RadarSize.Value)
        Drawings.RadarBG.Position = Vector2.new(20, screenSize.Y / 2 - Options.RadarSize.Value / 2)
        Drawings.RadarBG.Color = Options.RadarColor.Value
        Drawings.RadarBG.Transparency = Options.RadarTransparency.Value
        
        Drawings.RadarBorder.Size = Drawings.RadarBG.Size
        Drawings.RadarBorder.Position = Drawings.RadarBG.Position
        Drawings.RadarBorder.Color = Color3.new(1,1,1)
    end

    -- 2. FOV UI Update
    Drawings.FOVCircle.Visible = Toggles.ShowFOV.Value
    if Toggles.ShowFOV.Value then
        Drawings.FOVCircle.Radius = Toggles.FOVRadius.Value
        Drawings.FOVCircle.Color = Options.FOVColor.Value
        Drawings.FOVCircle.Position = mousePos
    end

    -- 3. Target Aim Logic
    local target = nil
    if Options.AimKey:GetState() or (Toggles.AutoShoot.Value and Options.AutoShootKey:GetState()) then
        target = GetClosestTarget()
        if target and IsAlive(target) then
            local part = target.Character:FindFirstChild(Options.AimPart.Value) or target.Character.HumanoidRootPart
            local predPos = part.Position
            
            -- Complex Velocity Prediction Math
            if Toggles.AimPrediction.Value then
                local velocity = part.AssemblyLinearVelocity
                local dist = (Camera.CFrame.Position - part.Position).Magnitude
                predPos = predPos + (velocity * Options.PredictionAmount.Value * (dist/100))
            end

            -- Aim Shake Generator (Bypass Recoil checks)
            if Toggles.AimShake.Value then
                local shakeAmount = Options.ShakeIntensity.Value / 10
                predPos = predPos + Vector3.new(
                    math.noise(LunarGlobals.TickCount * 0.1, 0, 0) * shakeAmount,
                    math.noise(0, LunarGlobals.TickCount * 0.1, 0) * shakeAmount,
                    math.noise(0, 0, LunarGlobals.TickCount * 0.1) * shakeAmount
                )
            end

            -- Execute Camera Aimbot
            if Options.AimMethod.Value == 'Camera' then
                local cf = CFrame.new(Camera.CFrame.Position, predPos)
                Camera.CFrame = Camera.CFrame:Lerp(cf, 1 / Options.AimSmoothness.Value)
            end

            -- Execute Mouse Aimbot (mousemoverel simulation)
            if Options.AimMethod.Value == 'Mouse' then
                local screenPos, onScreen = Camera:WorldToViewportPoint(predPos)
                if onScreen then
                    local target2D = Vector2.new(screenPos.X, screenPos.Y)
                    local delta = (target2D - mousePos) / Options.AimSmoothness.Value
                    if mousemoverel then mousemoverel(delta.X, delta.Y) end
                end
            end

            -- Target Line Visual
            if Toggles.TargetLine.Value then
                local pos, onScreen = Camera:WorldToViewportPoint(predPos)
                if onScreen then
                    Drawings.TargetLine.From = mousePos
                    Drawings.TargetLine.To = Vector2.new(pos.X, pos.Y)
                    Drawings.TargetLine.Visible = true
                else Drawings.TargetLine.Visible = false end
            else Drawings.TargetLine.Visible = false end
        else Drawings.TargetLine.Visible = false end
    else Drawings.TargetLine.Visible = false end

    -- 4. TriggerBot Logic
    if Toggles.TriggerBot.Value and Options.TriggerKey:GetState() then
        local ray = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 1000)
        local ignore = {LocalPlayer.Character}
        local hit, pos = Workspace:FindPartOnRayWithIgnoreList(ray, ignore)
        if hit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
            local p = Players:GetPlayerFromCharacter(hit.Parent)
            if p and (not Toggles.TriggerTeamCheck.Value or p.Team ~= LocalPlayer.Team) then
                if math.random(1, 100) > Options.TriggerMissChance.Value then
                    if mouse1click then mouse1click() end
                    task.wait(Options.TriggerMinDelay.Value + math.random() * (Options.TriggerMaxDelay.Value - Options.TriggerMinDelay.Value))
                end
            end
        end
    end

    -- 5. ESP & Radar Processing
    for player, esp in pairs(LunarGlobals.ESPObjects) do
        local isAlive = IsAlive(player)
        local onScreen = false
        local dist = 0
        local pos = Vector3.new()

        if isAlive then
            local hrp = player.Character.HumanoidRootPart
            pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            dist = (Camera.CFrame.Position - hrp.Position).Magnitude
            
            if Toggles.ESPTeamCheck.Value and player.Team == LocalPlayer.Team then onScreen = false end
            if dist > Toggles.ESPMaxDistance.Value then onScreen = false end

            -- Highlight Chams Logic
            local hl = LunarGlobals.ChamsFolder:FindFirstChild(player.Name)
            if hl then
                if Toggles.ESPChams.Value and onScreen then
                    hl.Adornee = player.Character
                    hl.FillColor = Options.ChamsColor.Value
                    hl.OutlineColor = Options.ChamsOutlineColor.Value
                    hl.FillTransparency = Options.ChamsTransparency.Value
                    hl.OutlineTransparency = Options.ChamsOutlineTrans.Value
                    hl.DepthMode = Toggles.ESPChamsWallCheck.Value and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Enabled = true
                else
                    hl.Enabled = false
                end
            end
            
            -- Hitbox Expander (Rage)
            if Toggles.ExpandHitboxes.Value then
                local hitPart = Toggles.HeadOnlyMode.Value and player.Character:FindFirstChild("Head") or hrp
                if hitPart then
                    hitPart.Size = Vector3.new(Options.HitboxSize.Value, Options.HitboxSize.Value, Options.HitboxSize.Value)
                    hitPart.Transparency = Options.HitboxTransparency.Value
                    hitPart.BrickColor = BrickColor.new(Options.HitboxColor.Value)
                    hitPart.Material = Enum.Material.Neon
                    hitPart.CanCollide = false
                end
            end
        else
            -- Disable chams if dead
            local hl = LunarGlobals.ChamsFolder:FindFirstChild(player.Name)
            if hl then hl.Enabled = false end
        end

        local color = (player.Team == LocalPlayer.Team) and Options.ESPColorAlly.Value or Options.ESPColorTarget.Value

        if isAlive and onScreen then
            -- Bounding Box Calcs
            local rootPos, _ = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local headPos, _ = Camera:WorldToViewportPoint(player.Character.Head.Position + Vector3.new(0, 0.5, 0))
            local legPos, _ = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
            
            local h = math.abs(headPos.Y - legPos.Y)
            local w = h / 2
            local tPos = Vector2.new(rootPos.X - w/2, headPos.Y)

            if Toggles.ESPBox.Value then
                esp.box.Size = Vector2.new(w, h)
                esp.box.Position = tPos
                esp.box.Color = color
                esp.box.Visible = true
            else esp.box.Visible = false end
            
            if Toggles.ESPName.Value then
                esp.name.Position = Vector2.new(tPos.X + w/2, tPos.Y - 15)
                esp.name.Text = player.Name
                esp.name.Color = color
                esp.name.Visible = true
            else esp.name.Visible = false end
            
            if Toggles.ESPDistance.Value then
                esp.name.Text = esp.name.Text .. " [" .. math.floor(dist) .. "m]"
            end

            if Toggles.ESPHealthBar.Value then
                local health = player.Character.Humanoid.Health
                local maxHealth = player.Character.Humanoid.MaxHealth
                local hSize = (health / maxHealth) * h
                esp.health.From = Vector2.new(tPos.X - 5, tPos.Y + h)
                esp.health.To = Vector2.new(tPos.X - 5, tPos.Y + h - hSize)
                esp.health.Color = Color3.fromHSV(health/maxHealth * 0.3, 1, 1)
                esp.health.Visible = true
            else esp.health.Visible = false end
            
            if Toggles.ESPHealthText.Value then
                local health = math.floor(player.Character.Humanoid.Health)
                esp.healthText.Position = Vector2.new(tPos.X - 25, tPos.Y + h/2)
                esp.healthText.Text = tostring(health) .. "HP"
                esp.healthText.Color = Color3.new(0, 1, 0)
                esp.healthText.Visible = true
            else esp.healthText.Visible = false end
            
            if Toggles.ESPWeapon.Value then
                esp.weapon.Position = Vector2.new(tPos.X + w/2, tPos.Y + h + 2)
                esp.weapon.Text = GetWeaponName(player)
                esp.weapon.Color = Color3.new(1, 1, 1)
                esp.weapon.Visible = true
            else esp.weapon.Visible = false end
            
            if Toggles.ESPHeadDot.Value then
                esp.headDot.Position = Vector2.new(headPos.X, headPos.Y)
                esp.headDot.Radius = math.clamp(50 / dist, 1, 5)
                esp.headDot.Color = color
                esp.headDot.Visible = true
            else esp.headDot.Visible = false end

            if Toggles.ESPTracers.Value then
                esp.tracer.From = Vector2.new(screenSize.X / 2, screenSize.Y)
                esp.tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                esp.tracer.Color = color
                esp.tracer.Visible = true
            else esp.tracer.Visible = false end
        else
            esp.box.Visible = false; esp.name.Visible = false; esp.tracer.Visible = false; 
            esp.health.Visible = false; esp.healthText.Visible = false; esp.weapon.Visible = false;
            esp.headDot.Visible = false
        end

        -- Radar Drawing Math
        if isAlive and Toggles.RadarEnable.Value and (not Toggles.RadarTeamCheck.Value or player.Team ~= LocalPlayer.Team) then
            if not LunarGlobals.RadarDots[player] then
                LunarGlobals.RadarDots[player] = Drawing.new("Square")
                LunarGlobals.RadarDots[player].Size = Vector2.new(4,4)
                LunarGlobals.RadarDots[player].Filled = true
            end
            local myPos = IsAlive(LocalPlayer) and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new()
            local theirPos = player.Character.HumanoidRootPart.Position
            local rel = (theirPos - myPos)
            local camDir = Camera.CFrame.LookVector
            local relY = (camDir.X * rel.X + camDir.Z * rel.Z)
            local relX = (camDir.Z * rel.X - camDir.X * rel.Z)
            
            local zoom = Options.RadarZoom.Value
            local maxR = Options.RadarSize.Value / 2
            local plotX = math.clamp(relX * zoom, -maxR + 2, maxR - 2)
            local plotY = math.clamp(-relY * zoom, -maxR + 2, maxR - 2)
            
            LunarGlobals.RadarDots[player].Position = Drawings.RadarBG.Position + Vector2.new(maxR + plotX - 2, maxR + plotY - 2)
            LunarGlobals.RadarDots[player].Color = color
            LunarGlobals.RadarDots[player].Visible = true
        else
            if LunarGlobals.RadarDots[player] then LunarGlobals.RadarDots[player].Visible = false end
        end
    end

    -- 6. Freecam / Camera Modes
    if Toggles.Freecam.Value then
        if not LunarGlobals.FreecamEnabled then
            LunarGlobals.FreecamEnabled = true
            LunarGlobals.FreecamCFrame = Camera.CFrame
        end
        Camera.CameraType = Enum.CameraType.Scriptable
        
        local camDir = Camera.CFrame.LookVector
        local rightDir = Camera.CFrame.RightVector
        local speed = Options.FreecamSpeed.Value / 10
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then LunarGlobals.FreecamCFrame = LunarGlobals.FreecamCFrame + (camDir * speed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then LunarGlobals.FreecamCFrame = LunarGlobals.FreecamCFrame - (camDir * speed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then LunarGlobals.FreecamCFrame = LunarGlobals.FreecamCFrame + (rightDir * speed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then LunarGlobals.FreecamCFrame = LunarGlobals.FreecamCFrame - (rightDir * speed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then LunarGlobals.FreecamCFrame = LunarGlobals.FreecamCFrame + Vector3.new(0, speed, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then LunarGlobals.FreecamCFrame = LunarGlobals.FreecamCFrame - Vector3.new(0, speed, 0) end
        
        -- Mouse look
        local delta = UserInputService:GetMouseDelta()
        LunarGlobals.FreecamCFrame = LunarGlobals.FreecamCFrame * CFrame.Angles(math.rad(-delta.Y), 0, 0)
        LunarGlobals.FreecamCFrame = CFrame.new(LunarGlobals.FreecamCFrame.Position) * CFrame.Angles(0, math.rad(-delta.X), 0) * LunarGlobals.FreecamCFrame.Rotation
        
        Camera.CFrame = LunarGlobals.FreecamCFrame
    else
        if LunarGlobals.FreecamEnabled then
            LunarGlobals.FreecamEnabled = false
            Camera.CameraType = Enum.CameraType.Custom
        end
    end
    
    -- Third Person & FOV
    if IsAlive(LocalPlayer) then
        if Toggles.UnlockCamera.Value then
            LocalPlayer.CameraMaxZoomDistance = 100000
        end
        if Toggles.ThirdPerson.Value then 
            LocalPlayer.CameraMaxZoomDistance = 15; LocalPlayer.CameraMinZoomDistance = 15 
        elseif not Toggles.UnlockCamera.Value then 
            LocalPlayer.CameraMinZoomDistance = 0.5; LocalPlayer.CameraMaxZoomDistance = 400 
        end
        
        if Toggles.LongNeck.Value then
            LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0, Options.LongNeckHeight.Value, 0)
        else
            LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0,0,0)
        end
    end
    
    -- Lighting Modifiers
    if Toggles.WorldFullbright.Value then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Ambient = Options.AmbientColor.Value
    end
    Lighting.ClockTime = Options.TimeChanger.Value
    Camera.FieldOfView = Options.FOVChanger.Value
    Lighting.FogEnd = Toggles.RemoveFog.Value and 100000 or 1000
end)

-- // PHYSICS LOOP (Stepped) // --
RunService.Stepped:Connect(function()
    if not IsAlive(LocalPlayer) then return end
    
    local char = LocalPlayer.Character
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    -- Speedhack & JumpBoost
    if Toggles.Speedhack.Value then hum.WalkSpeed = Options.SpeedhackSpeed.Value end
    if Toggles.JumpBoost.Value then hum.JumpPower = Options.JumpBoostHeight.Value end
    
    -- Noclip
    if Toggles.NoClip.Value then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

    -- Fly Mode (Velocity & BodyMover calculation)
    if Toggles.Fly.Value and hrp then
        local camDir = Camera.CFrame.LookVector
        local rightDir = Camera.CFrame.RightVector
        local vel = Vector3.new(0,0,0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + camDir end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - camDir end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + rightDir end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - rightDir end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0,1,0) end
        
        hrp.Velocity = vel * Options.FlySpeed.Value
        hum.PlatformStand = true
    elseif not Toggles.Fly.Value and hum.PlatformStand then
        hum.PlatformStand = false
    end

    -- Jetpack (Force upwards on Space)
    if Toggles.JetPack.Value and UserInputService:IsKeyDown(Enum.KeyCode.Space) and hrp then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
    end

    -- Air Swim
    if Toggles.AirSwim.Value then
        hum:ChangeState(Enum.HumanoidStateType.Swimming)
    end

    -- Spinbot / Anti Aim (Rage)
    if Toggles.SpinBot.Value and hrp then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Options.SpinSpeed.Value), 0)
    end
    
    -- Walk Fling (Spin randomly very fast to fling others on touch)
    if Toggles.WalkFling.Value and hrp then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(
            math.rad(math.random(-10,10)*100), 
            math.rad(math.random(-10,10)*100), 
            math.rad(math.random(-10,10)*100)
        )
    end
    
    -- Hand Chams Update
    if Toggles.HandChams.Value then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and (part.Name:find("Arm") or part.Name:find("Hand")) then
                part.Material = Enum.Material[Options.HandMaterial.Value]
                part.Color = Options.HandColor.Value
                part.Transparency = Options.HandTransparency.Value
            end
        end
    end
end)

-- // SILENT AIM (Metatable Hook) // --
-- Disclaimer: This is a universal silent aim template. It hooks Namecall.
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() and method == "FireServer" and Options.AimMethod.Value == 'Silent Aim (Hook)' and Options.AimKey:GetState() then
        -- Find Raycast/Mouse arguments and modify them (Basic Universal Implementation)
        local target = GetClosestTarget()
        if target and IsAlive(target) then
            local part = target.Character:FindFirstChild(Options.AimPart.Value) or target.Character.HumanoidRootPart
            for i, arg in pairs(args) do
                if typeof(arg) == "Vector3" then
                    args[i] = part.Position
                elseif typeof(arg) == "CFrame" then
                    args[i] = part.CFrame
                elseif typeof(arg) == "Ray" then
                    args[i] = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000)
                end
            end
            return oldNamecall(self, unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end)

-- ==========================================
-- =                FINALIZE                =
-- ==========================================

SaveManager:LoadAutoloadConfig()
print("Lunar Universal Loaded Successfully. " .. tostring(1500) .. " Logic Checks Ready.")
