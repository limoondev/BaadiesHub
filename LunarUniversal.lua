-- ==============================================================================
-- LUNAR UNIVERSAL SCRIPT | THE ZENITH EXPERIENCE
-- Version: 3.0.0
-- Lines: 1500+
-- Built with: Linoria Lib (violin-suzutsuki)
-- ==============================================================================

-- // Wait for the game to finish loading before doing anything
if not game:IsLoaded() then
    game.Loaded:Wait()
end
task.wait(1)

-- // Safe Linoria Lib Loading (correct repo URL)
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- ==========================================
-- =              SERVICES                  =
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- ==========================================
-- =             REFERENCES                 =
-- ==========================================
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- =           STATE VARIABLES              =
-- ==========================================
local WaypointStore = {}
local DeathPosition = nil
local FreecamActive = false
local FreecamStoredCFrame = CFrame.new()
local StickyTarget = nil
local TickCounter = 0
local OriginalGravity = Workspace.Gravity
local OriginalFog = Lighting.FogEnd
local OriginalAmbient = Lighting.Ambient
local OriginalTime = Lighting.ClockTime
local TriggerCooldown = false
local ESPCache = {}
local RadarCache = {}
local ItemESPCache = {}

-- ==========================================
-- =       SAFE DRAWING CONSTRUCTOR         =
-- ==========================================
-- Some executors don't support Drawing API. We create a safe wrapper.
local DrawingSupported = (Drawing ~= nil and Drawing.new ~= nil)

local function NewDrawing(drawingType)
    if not DrawingSupported then
        return setmetatable({}, {__index = function() return function() end end, __newindex = function() end})
    end
    local ok, obj = pcall(Drawing.new, drawingType)
    if ok then return obj end
    return setmetatable({}, {__index = function() return function() end end, __newindex = function() end})
end

-- ==========================================
-- =           DRAWING OBJECTS              =
-- ==========================================
local FOVCircle = NewDrawing("Circle")
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

local TargetLine = NewDrawing("Line")
TargetLine.Thickness = 1
TargetLine.Visible = false

local RadarBackground = NewDrawing("Square")
RadarBackground.Filled = true
RadarBackground.Thickness = 1
RadarBackground.Visible = false

local RadarBorder = NewDrawing("Square")
RadarBorder.Filled = false
RadarBorder.Thickness = 2
RadarBorder.Color = Color3.fromRGB(139, 92, 246)
RadarBorder.Visible = false

local RadarCenter = NewDrawing("Circle")
RadarCenter.Filled = true
RadarCenter.Radius = 3
RadarCenter.Color = Color3.fromRGB(255, 255, 255)
RadarCenter.Visible = false

local DeathMarker = NewDrawing("Circle")
DeathMarker.Filled = true
DeathMarker.Radius = 5
DeathMarker.Color = Color3.fromRGB(255, 0, 0)
DeathMarker.Visible = false

-- ==========================================
-- =        CHAMS CONTAINER (Highlight)     =
-- ==========================================
local ChamsContainer = Instance.new("Folder")
ChamsContainer.Name = "LunarChamsESP"
pcall(function()
    ChamsContainer.Parent = (gethui and gethui()) or game:GetService("CoreGui")
end)

-- ==============================================================================
-- =                        UI WINDOW & TABS                                    =
-- ==============================================================================
local Window = Library:CreateWindow({
    Title = 'Lunar Universal | v3.0',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Self        = Window:AddTab('Self'),
    Players     = Window:AddTab('Players'),
    Visuals     = Window:AddTab('Visuals'),
    Aimbot      = Window:AddTab('Aimbot'),
    TriggerBot  = Window:AddTab('TriggerBot'),
    Radar       = Window:AddTab('Radar'),
    Rage        = Window:AddTab('Rage'),
    Teleport    = Window:AddTab('Teleport'),
    World       = Window:AddTab('World'),
    Misc        = Window:AddTab('Misc'),
    Settings    = Window:AddTab('Settings'),
}

-- ==============================================================================
-- =                          TAB: SELF                                         =
-- ==============================================================================
do
    local LeftBox = Tabs.Self:AddLeftGroupbox('Movement')

    LeftBox:AddToggle('SelfFly', {
        Text = 'Fly',
        Default = false,
        Tooltip = 'Fly around the map using WASD + Space/Shift',
    }):AddKeyPicker('SelfFlyKey', {
        Default = 'F',
        SyncToggleState = true,
        Mode = 'Toggle',
        Text = 'Fly Key',
    })

    LeftBox:AddSlider('SelfFlySpeed', {
        Text = 'Fly Speed',
        Default = 50,
        Min = 10,
        Max = 500,
        Rounding = 0,
        Suffix = ' studs/s',
    })

    LeftBox:AddToggle('SelfNoClip', {
        Text = 'No Clip',
        Default = false,
        Tooltip = 'Walk through walls and obstacles',
    }):AddKeyPicker('SelfNoClipKey', {
        Default = 'N',
        SyncToggleState = true,
        Mode = 'Toggle',
        Text = 'No Clip Key',
    })

    LeftBox:AddToggle('SelfInfJump', {
        Text = 'Infinite Jump',
        Default = false,
        Tooltip = 'Jump infinitely in the air',
    })

    LeftBox:AddToggle('SelfJetPack', {
        Text = 'Jet Pack',
        Default = false,
        Tooltip = 'Hold Space to propel upwards',
    })

    LeftBox:AddToggle('SelfSpeedhack', {
        Text = 'Speedhack',
        Default = false,
    })

    LeftBox:AddSlider('SelfSpeedhackVal', {
        Text = 'Walk Speed',
        Default = 16,
        Min = 16,
        Max = 500,
        Rounding = 0,
    })

    LeftBox:AddToggle('SelfJumpBoost', {
        Text = 'Jump Boost',
        Default = false,
    })

    LeftBox:AddSlider('SelfJumpPower', {
        Text = 'Jump Power',
        Default = 50,
        Min = 50,
        Max = 500,
        Rounding = 0,
    })

    LeftBox:AddToggle('SelfAirSwim', {
        Text = 'Air Swim',
        Default = false,
        Tooltip = 'Swim in the air as if you were underwater',
    })

    -- Right box: Character
    local RightBox = Tabs.Self:AddRightGroupbox('Character')

    RightBox:AddToggle('SelfLongNeck', {
        Text = 'Long Neck (Camera Height)',
        Default = false,
        Tooltip = 'Raises your camera above your head so you can peek over walls',
    })

    RightBox:AddSlider('SelfLongNeckHeight', {
        Text = 'Height',
        Default = 5,
        Min = 1,
        Max = 30,
        Rounding = 1,
    })

    RightBox:AddToggle('SelfWalkFling', {
        Text = 'Walk Fling',
        Default = false,
        Tooltip = 'Rapidly rotate your character to fling players on contact',
    })

    RightBox:AddToggle('SelfGoonAnim', {
        Text = 'Goon Walk (Animation)',
        Default = false,
        Tooltip = 'Plays the Goon animation on your character',
    })
end

-- ==============================================================================
-- =                         TAB: PLAYERS                                       =
-- ==============================================================================
do
    local LeftBox = Tabs.Players:AddLeftGroupbox('Player Selection')

    LeftBox:AddDropdown('PlrSelected', {
        Values = {'None'},
        Default = 1,
        Multi = false,
        Text = 'Select Player',
    })

    LeftBox:AddButton({
        Text = 'Refresh Player List',
        Func = function()
            local list = {'None'}
            for _, v in ipairs(Players:GetPlayers()) do
                if v ~= LocalPlayer then
                    table.insert(list, v.Name)
                end
            end
            Options.PlrSelected:SetValues(list)
            Library:Notify("Player list refreshed!", 2)
        end,
        DoubleClick = false,
    })

    LeftBox:AddToggle('PlrIgnoreFriends', {
        Text = 'Ignore Friends (Aimbot/ESP)',
        Default = false,
        Tooltip = 'Friends will be excluded from aimbot targeting and ESP rendering',
    })

    -- Right box: Actions
    local RightBox = Tabs.Players:AddRightGroupbox('Actions')

    RightBox:AddButton({
        Text = 'Teleport To Player',
        Func = function()
            local target = Players:FindFirstChild(Options.PlrSelected.Value)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:PivotTo(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5))
                    Library:Notify("Teleported to " .. target.Name, 2)
                end
            else
                Library:Notify("Target player not found or dead.", 2)
            end
        end,
        DoubleClick = false,
    })

    RightBox:AddToggle('PlrSpectate', {
        Text = 'Spectate Player',
        Default = false,
    })

    RightBox:AddToggle('PlrLookAt', {
        Text = 'Look At Player',
        Default = false,
    })

    RightBox:AddButton({
        Text = 'Copy Username',
        Func = function()
            if setclipboard and Options.PlrSelected.Value ~= 'None' then
                setclipboard(Options.PlrSelected.Value)
                Library:Notify("Copied: " .. Options.PlrSelected.Value, 2)
            end
        end,
        DoubleClick = false,
    })

    RightBox:AddButton({
        Text = 'Copy User ID',
        Func = function()
            local target = Players:FindFirstChild(Options.PlrSelected.Value)
            if target and setclipboard then
                setclipboard(tostring(target.UserId))
                Library:Notify("Copied ID: " .. tostring(target.UserId), 2)
            end
        end,
        DoubleClick = false,
    })
end

-- ==============================================================================
-- =                         TAB: VISUALS                                       =
-- ==============================================================================
do
    local LeftBox = Tabs.Visuals:AddLeftGroupbox('ESP Features')

    LeftBox:AddToggle('ESPEnabled', {
        Text = 'Enable ESP',
        Default = false,
    })

    LeftBox:AddToggle('ESPBox', {
        Text = 'Box',
        Default = false,
    })

    LeftBox:AddToggle('ESPName', {
        Text = 'Name',
        Default = false,
    })

    LeftBox:AddToggle('ESPHealthBar', {
        Text = 'Health Bar',
        Default = false,
    })

    LeftBox:AddToggle('ESPHealthText', {
        Text = 'Health Text',
        Default = false,
    })

    LeftBox:AddToggle('ESPWeapon', {
        Text = 'Current Weapon / Tool',
        Default = false,
    })

    LeftBox:AddToggle('ESPTracers', {
        Text = 'Tracers',
        Default = false,
    })

    LeftBox:AddToggle('ESPDistance', {
        Text = 'Distance',
        Default = false,
    })

    LeftBox:AddToggle('ESPHeadDot', {
        Text = 'Head Dot',
        Default = false,
    })

    -- Right box: Chams & Options
    local RightBox = Tabs.Visuals:AddRightGroupbox('Chams & Options')

    RightBox:AddToggle('ESPChams', {
        Text = 'Player Chams (Highlight)',
        Default = false,
    })

    RightBox:AddLabel('Chams Color'):AddColorPicker('ESPChamsColor', {
        Default = Color3.fromRGB(139, 92, 246),
        Title = 'Chams Fill Color',
    })

    RightBox:AddLabel('Chams Outline'):AddColorPicker('ESPChamsOutline', {
        Default = Color3.fromRGB(255, 255, 255),
        Title = 'Chams Outline Color',
    })

    RightBox:AddSlider('ESPChamsFillTrans', {
        Text = 'Fill Transparency',
        Default = 0.5,
        Min = 0,
        Max = 1,
        Rounding = 1,
    })

    RightBox:AddToggle('ESPTeamCheck', {
        Text = 'Team Check',
        Default = false,
    })

    RightBox:AddSlider('ESPMaxDist', {
        Text = 'Max Distance',
        Default = 5000,
        Min = 100,
        Max = 10000,
        Rounding = 0,
        Suffix = ' studs',
    })

    RightBox:AddLabel('Target Color'):AddColorPicker('ESPTargetColor', {
        Default = Color3.fromRGB(255, 50, 50),
        Title = 'Target Color',
    })

    RightBox:AddLabel('Ally Color'):AddColorPicker('ESPAllyColor', {
        Default = Color3.fromRGB(50, 255, 50),
        Title = 'Ally Color',
    })
end

-- ==============================================================================
-- =                          TAB: AIMBOT                                       =
-- ==============================================================================
do
    local LeftBox = Tabs.Aimbot:AddLeftGroupbox('Main')

    LeftBox:AddToggle('AimEnabled', {
        Text = 'Enable Aimbot',
        Default = false,
    })

    LeftBox:AddDropdown('AimMethod', {
        Values = {'Camera', 'Mouse'},
        Default = 1,
        Multi = false,
        Text = 'Method',
    })

    LeftBox:AddLabel('Aim Key'):AddKeyPicker('AimKey', {
        Default = 'MouseButton2',
        Mode = 'Hold',
        Text = 'Aim Key',
    })

    LeftBox:AddDropdown('AimPart', {
        Values = {'Head', 'HumanoidRootPart', 'UpperTorso', 'LowerTorso'},
        Default = 1,
        Multi = false,
        Text = 'Aim Part',
    })

    LeftBox:AddDropdown('AimPriority', {
        Values = {'Closest to Cursor (FOV)', 'Closest Distance', 'Lowest Health'},
        Default = 1,
        Multi = false,
        Text = 'Priority',
    })

    LeftBox:AddSlider('AimSmoothness', {
        Text = 'Smoothness',
        Default = 5,
        Min = 1,
        Max = 30,
        Rounding = 1,
        Suffix = '',
    })

    LeftBox:AddToggle('AimStickyAim', {
        Text = 'Sticky Aim (Keep Target)',
        Default = false,
    })

    -- Right box: Advanced Settings
    local RightBox = Tabs.Aimbot:AddRightGroupbox('Advanced')

    RightBox:AddToggle('AimPrediction', {
        Text = 'Velocity Prediction',
        Default = false,
        Tooltip = 'Predict where the player will be based on their velocity',
    })

    RightBox:AddSlider('AimPredAmt', {
        Text = 'Prediction Factor',
        Default = 0.165,
        Min = 0,
        Max = 1,
        Rounding = 3,
    })

    RightBox:AddToggle('AimShake', {
        Text = 'Aim Shake (Humanize)',
        Default = false,
    })

    RightBox:AddSlider('AimShakeAmt', {
        Text = 'Shake Intensity',
        Default = 3,
        Min = 1,
        Max = 20,
        Rounding = 0,
    })

    RightBox:AddToggle('AimTeamCheck', {
        Text = 'Team Check',
        Default = false,
    })

    RightBox:AddToggle('AimWallCheck', {
        Text = 'Wall Check (Raycast)',
        Default = false,
        Tooltip = 'Only aim at targets you can see through walls',
    })

    -- FOV Settings
    local FOVBox = Tabs.Aimbot:AddLeftGroupbox('FOV Display')

    FOVBox:AddToggle('AimShowFOV', {
        Text = 'Show FOV Circle',
        Default = false,
    })

    FOVBox:AddSlider('AimFOVSize', {
        Text = 'FOV Size',
        Default = 100,
        Min = 10,
        Max = 800,
        Rounding = 0,
        Suffix = ' px',
    })

    FOVBox:AddLabel('FOV Color'):AddColorPicker('AimFOVColor', {
        Default = Color3.fromRGB(255, 255, 255),
        Title = 'FOV Color',
    })

    FOVBox:AddToggle('AimTargetLine', {
        Text = 'Show Target Line',
        Default = false,
    })
end

-- ==============================================================================
-- =                        TAB: TRIGGERBOT                                     =
-- ==============================================================================
do
    local LeftBox = Tabs.TriggerBot:AddLeftGroupbox('Trigger Bot')

    LeftBox:AddToggle('TrigEnabled', {
        Text = 'Enable Trigger Bot',
        Default = false,
        Tooltip = 'Automatically fires when an enemy is under your crosshair',
    })

    LeftBox:AddLabel('Hold Key'):AddKeyPicker('TrigKey', {
        Default = 'V',
        Mode = 'Hold',
        Text = 'Trigger Hold Key',
    })

    LeftBox:AddToggle('TrigTeamCheck', {
        Text = 'Team Check',
        Default = true,
    })

    LeftBox:AddSlider('TrigMinDelay', {
        Text = 'Min Delay',
        Default = 0.05,
        Min = 0,
        Max = 1,
        Rounding = 2,
        Suffix = 's',
    })

    LeftBox:AddSlider('TrigMaxDelay', {
        Text = 'Max Delay',
        Default = 0.15,
        Min = 0,
        Max = 1,
        Rounding = 2,
        Suffix = 's',
    })

    LeftBox:AddSlider('TrigMissChance', {
        Text = 'Miss Chance',
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Suffix = '%',
    })
end

-- ==============================================================================
-- =                          TAB: RADAR                                        =
-- ==============================================================================
do
    local LeftBox = Tabs.Radar:AddLeftGroupbox('Radar Settings')

    LeftBox:AddToggle('RadarEnabled', {
        Text = 'Enable Minimap Radar',
        Default = false,
    })

    LeftBox:AddToggle('RadarShowNames', {
        Text = 'Show Names on Radar',
        Default = false,
    })

    LeftBox:AddToggle('RadarTeamCheck', {
        Text = 'Team Check',
        Default = false,
    })

    LeftBox:AddSlider('RadarSize', {
        Text = 'Radar Size',
        Default = 200,
        Min = 100,
        Max = 500,
        Rounding = 0,
        Suffix = 'px',
    })

    LeftBox:AddSlider('RadarZoom', {
        Text = 'Zoom Factor',
        Default = 1,
        Min = 0.1,
        Max = 5,
        Rounding = 1,
    })

    LeftBox:AddSlider('RadarTransparency', {
        Text = 'Background Opacity',
        Default = 0.7,
        Min = 0,
        Max = 1,
        Rounding = 1,
    })

    LeftBox:AddLabel('Radar Background'):AddColorPicker('RadarBGColor', {
        Default = Color3.fromRGB(15, 15, 25),
        Title = 'Radar Background Color',
    })
end

-- ==============================================================================
-- =                            TAB: RAGE                                       =
-- ==============================================================================
do
    local LeftBox = Tabs.Rage:AddLeftGroupbox('Anti-Hit Exploits')

    LeftBox:AddToggle('RageSpinBot', {
        Text = 'Spin Bot',
        Default = false,
        Tooltip = 'Rapidly rotate your character to make you harder to hit',
    })

    LeftBox:AddSlider('RageSpinSpeed', {
        Text = 'Spin Speed',
        Default = 30,
        Min = 5,
        Max = 100,
        Rounding = 0,
    })

    -- Right box: Hitbox Expander
    local RightBox = Tabs.Rage:AddRightGroupbox('Hitbox Expander')

    RightBox:AddToggle('RageHitboxEnabled', {
        Text = 'Enable Hitbox Expander',
        Default = false,
    })

    RightBox:AddToggle('RageHitboxHeadOnly', {
        Text = 'Head Only Mode',
        Default = false,
    })

    RightBox:AddToggle('RageHitboxShow', {
        Text = 'Show Hitboxes (Visible)',
        Default = false,
    })

    RightBox:AddSlider('RageHitboxSize', {
        Text = 'Hitbox Size',
        Default = 5,
        Min = 1,
        Max = 50,
        Rounding = 1,
        Suffix = ' studs',
    })

    RightBox:AddLabel('Hitbox Color'):AddColorPicker('RageHitboxColor', {
        Default = Color3.fromRGB(255, 0, 0),
        Title = 'Hitbox Color',
    })

    RightBox:AddButton({
        Text = 'Reset All Hitboxes',
        Func = function()
            for _, v in ipairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character then
                    for _, part in ipairs(v.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 0
                            part.CanCollide = true
                        end
                    end
                end
            end
            Library:Notify("All hitboxes reset.", 2)
        end,
        DoubleClick = true,
    })
end

-- ==============================================================================
-- =                         TAB: TELEPORT                                      =
-- ==============================================================================
do
    local LeftBox = Tabs.Teleport:AddLeftGroupbox('Quick Teleport')

    LeftBox:AddToggle('TPClickTP', {
        Text = 'Click Teleport',
        Default = false,
        Tooltip = 'Hold the bind key and click to teleport to mouse position',
    }):AddKeyPicker('TPClickTPKey', {
        Default = 'LeftControl',
        Mode = 'Hold',
        Text = 'Click TP Bind',
    })

    LeftBox:AddButton({
        Text = 'TP to Last Death Position',
        Func = function()
            if DeathPosition and LocalPlayer.Character then
                LocalPlayer.Character:PivotTo(CFrame.new(DeathPosition))
                Library:Notify("Teleported to death position.", 2)
            else
                Library:Notify("No death position recorded yet.", 2)
            end
        end,
        DoubleClick = false,
    })

    LeftBox:AddToggle('TPRenderDeath', {
        Text = 'Show Death Position Marker',
        Default = false,
    })

    -- Right box: Waypoints
    local RightBox = Tabs.Teleport:AddRightGroupbox('Waypoints System')

    RightBox:AddInput('TPWaypointName', {
        Default = '',
        Numeric = false,
        Finished = false,
        Text = 'Waypoint Name',
        Placeholder = 'Enter name...',
    })

    RightBox:AddButton({
        Text = 'Save Current Position',
        Func = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local name = Options.TPWaypointName.Value
                if name == '' then name = "Waypoint_" .. tostring(#WaypointStore + 1) end
                WaypointStore[name] = LocalPlayer.Character.HumanoidRootPart.Position
                local list = {}
                for k in pairs(WaypointStore) do table.insert(list, k) end
                Options.TPWaypointSelect:SetValues(list)
                Library:Notify("Saved waypoint: " .. name, 2)
            end
        end,
        DoubleClick = false,
    })

    RightBox:AddDropdown('TPWaypointSelect', {
        Values = {},
        Default = 1,
        Multi = false,
        Text = 'Saved Waypoints',
    })

    RightBox:AddButton({
        Text = 'Teleport to Waypoint',
        Func = function()
            local selected = Options.TPWaypointSelect.Value
            if WaypointStore[selected] and LocalPlayer.Character then
                LocalPlayer.Character:PivotTo(CFrame.new(WaypointStore[selected]))
                Library:Notify("Teleported to: " .. selected, 2)
            end
        end,
        DoubleClick = false,
    })

    RightBox:AddButton({
        Text = 'Delete Selected Waypoint',
        Func = function()
            local selected = Options.TPWaypointSelect.Value
            WaypointStore[selected] = nil
            local list = {}
            for k in pairs(WaypointStore) do table.insert(list, k) end
            Options.TPWaypointSelect:SetValues(list)
            Library:Notify("Deleted: " .. tostring(selected), 2)
        end,
        DoubleClick = true,
    })
end

-- ==============================================================================
-- =                          TAB: WORLD                                        =
-- ==============================================================================
do
    local LeftBox = Tabs.World:AddLeftGroupbox('Lighting & Environment')

    LeftBox:AddToggle('WorldFullbright', {
        Text = 'Fullbright',
        Default = false,
    })

    LeftBox:AddSlider('WorldTime', {
        Text = 'Time of Day',
        Default = 14,
        Min = 0,
        Max = 24,
        Rounding = 1,
    })

    LeftBox:AddToggle('WorldRemoveFog', {
        Text = 'Remove Fog',
        Default = false,
    })

    LeftBox:AddToggle('WorldRemoveShadows', {
        Text = 'Remove Shadows',
        Default = false,
    })

    LeftBox:AddLabel('Ambient Color'):AddColorPicker('WorldAmbient', {
        Default = Color3.fromRGB(255, 255, 255),
        Title = 'Custom Ambient Color',
    })

    LeftBox:AddSlider('WorldGravity', {
        Text = 'Gravity',
        Default = 196,
        Min = 0,
        Max = 500,
        Rounding = 0,
    })

    -- Right box: Freecam
    local RightBox = Tabs.World:AddRightGroupbox('Freecam')

    RightBox:AddToggle('WorldFreecam', {
        Text = 'Freecam',
        Default = false,
        Tooltip = 'Detach camera and fly freely. WASD to move, Space/Shift for up/down.',
    }):AddKeyPicker('WorldFreecamKey', {
        Default = 'P',
        SyncToggleState = true,
        Mode = 'Toggle',
        Text = 'Freecam Key',
    })

    RightBox:AddSlider('WorldFreecamSpeed', {
        Text = 'Freecam Speed',
        Default = 1,
        Min = 0.1,
        Max = 10,
        Rounding = 1,
    })

    RightBox:AddButton({
        Text = 'TP Character to Freecam Position',
        Func = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:PivotTo(Camera.CFrame)
                Library:Notify("Teleported to freecam position.", 2)
            end
        end,
        DoubleClick = false,
    })

    RightBox:AddSlider('WorldFOV', {
        Text = 'Camera FOV',
        Default = 70,
        Min = 30,
        Max = 120,
        Rounding = 0,
    })
end

-- ==============================================================================
-- =                           TAB: MISC                                        =
-- ==============================================================================
do
    local LeftBox = Tabs.Misc:AddLeftGroupbox('Client Utilities')

    LeftBox:AddToggle('MiscAntiAFK', {
        Text = 'Anti AFK',
        Default = false,
        Tooltip = 'Prevents Roblox from kicking you for being idle',
    })

    LeftBox:AddToggle('MiscInstantInteract', {
        Text = 'Instant Interacts (ProximityPrompt)',
        Default = false,
        Tooltip = 'Removes hold time on all proximity prompts',
    })

    LeftBox:AddToggle('MiscUnlockCamera', {
        Text = 'Unlock Camera Zoom',
        Default = false,
    })

    LeftBox:AddToggle('MiscThirdPerson', {
        Text = 'Force Third Person',
        Default = false,
    })

    LeftBox:AddToggle('MiscNoFallDmg', {
        Text = 'No Fall Damage',
        Default = false,
        Tooltip = 'Prevents fall damage by resetting fall state',
    })

    -- Right box: Server Tools
    local RightBox = Tabs.Misc:AddRightGroupbox('Server Tools')

    RightBox:AddButton({
        Text = 'Rejoin Server',
        Func = function()
            Library:Notify("Rejoining...", 2)
            task.wait(0.5)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end,
        DoubleClick = true,
    })

    RightBox:AddButton({
        Text = 'Server Hop (Random)',
        Func = function()
            Library:Notify("Finding a new server...", 2)
            pcall(function()
                local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
                local data = HttpService:JSONDecode(game:HttpGet(url)).data
                local validServers = {}
                for _, s in ipairs(data) do
                    if s.id ~= game.JobId and s.playing < s.maxPlayers then
                        table.insert(validServers, s)
                    end
                end
                if #validServers > 0 then
                    local choice = validServers[math.random(1, #validServers)]
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, choice.id, LocalPlayer)
                else
                    Library:Notify("No available servers found.", 2)
                end
            end)
        end,
        DoubleClick = true,
    })

    RightBox:AddButton({
        Text = 'Copy Place ID',
        Func = function()
            if setclipboard then
                setclipboard(tostring(game.PlaceId))
                Library:Notify("Copied Place ID: " .. tostring(game.PlaceId), 2)
            end
        end,
        DoubleClick = false,
    })

    RightBox:AddButton({
        Text = 'Copy Job ID',
        Func = function()
            if setclipboard then
                setclipboard(tostring(game.JobId))
                Library:Notify("Copied Job ID!", 2)
            end
        end,
        DoubleClick = false,
    })
end

-- ==============================================================================
-- =                         TAB: SETTINGS                                      =
-- ==============================================================================
do
    local LeftBox = Tabs.Settings:AddLeftGroupbox('Menu Settings')

    LeftBox:AddLabel('Menu Keybind'):AddKeyPicker('SettingsMenuKey', {
        Default = 'RightShift',
        NoUI = true,
        Text = 'Menu Toggle Key',
    })
    Library.ToggleKeybind = Options.SettingsMenuKey

    LeftBox:AddButton({
        Text = 'Unload Script',
        Func = function() Library:Unload() end,
        DoubleClick = true,
    })

    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({'SettingsMenuKey'})
    ThemeManager:SetFolder('LunarUniversal')
    SaveManager:SetFolder('LunarUniversal/main')
    SaveManager:BuildConfigSection(Tabs.Settings)
    ThemeManager:ApplyToTab(Tabs.Settings)
end

-- ==============================================================================
-- =                                                                            =
-- =                      CORE LOGIC ENGINE                                     =
-- =                                                                            =
-- ==============================================================================

-- ==========================================
-- =          HELPER FUNCTIONS              =
-- ==========================================

local function IsAlive(player)
    if not player then return false end
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.Health <= 0 then return false end
    return true
end

local function IsFriend(player)
    if not Toggles.PlrIgnoreFriends.Value then return false end
    local success, result = pcall(function()
        return LocalPlayer:IsFriendsWith(player.UserId)
    end)
    return success and result
end

local function IsTeammate(player)
    if not player.Team or not LocalPlayer.Team then return false end
    return player.Team == LocalPlayer.Team
end

local function IsVisibleRaycast(targetPart)
    if not targetPart then return false end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = Workspace:Raycast(origin, direction, params)
    if result == nil then return true end
    if result.Instance:IsDescendantOf(targetPart.Parent) then return true end
    return false
end

local function GetWeaponName(player)
    if not player.Character then return "None" end
    local tool = player.Character:FindFirstChildOfClass("Tool")
    if tool then return tool.Name end
    return "None"
end

local function GetAimTarget()
    local bestTarget = nil
    local bestScore = math.huge

    -- Sticky Aim: keep locking on the same target if alive
    if Toggles.AimStickyAim.Value and StickyTarget and IsAlive(StickyTarget) then
        local part = StickyTarget.Character:FindFirstChild(Options.AimPart.Value)
        if part then
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then return StickyTarget end
        end
    end

    for _, v in ipairs(Players:GetPlayers()) do
        if v == LocalPlayer then continue end
        if not IsAlive(v) then continue end
        if IsFriend(v) then continue end
        if Toggles.AimTeamCheck.Value and IsTeammate(v) then continue end

        local aimPartName = Options.AimPart.Value
        local part = v.Character:FindFirstChild(aimPartName) or v.Character:FindFirstChild("HumanoidRootPart")
        if not part then continue end

        if Toggles.AimWallCheck.Value and not IsVisibleRaycast(part) then continue end

        local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        local mousePos = UserInputService:GetMouseLocation()
        local dist2D = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
        local dist3D = (Camera.CFrame.Position - part.Position).Magnitude

        -- FOV Check
        if Toggles.AimShowFOV.Value and dist2D > Options.AimFOVSize.Value then continue end

        local score = dist2D
        local priority = Options.AimPriority.Value
        if priority == 'Closest Distance' then
            score = dist3D
        elseif priority == 'Lowest Health' then
            score = v.Character.Humanoid.Health
        end

        if score < bestScore then
            bestScore = score
            bestTarget = v
        end
    end

    StickyTarget = bestTarget
    return bestTarget
end

-- ==========================================
-- =          ESP OBJECT FACTORY            =
-- ==========================================

local function CreateESPForPlayer(player)
    if ESPCache[player] then return end

    local esp = {}
    esp.box = NewDrawing("Square")
    esp.box.Thickness = 1
    esp.box.Filled = false

    esp.name = NewDrawing("Text")
    esp.name.Size = 14
    esp.name.Center = true
    esp.name.Outline = true

    esp.healthBar = NewDrawing("Line")
    esp.healthBar.Thickness = 2

    esp.healthBarBG = NewDrawing("Line")
    esp.healthBarBG.Thickness = 4
    esp.healthBarBG.Color = Color3.fromRGB(30, 30, 30)

    esp.healthText = NewDrawing("Text")
    esp.healthText.Size = 12
    esp.healthText.Center = false
    esp.healthText.Outline = true

    esp.weapon = NewDrawing("Text")
    esp.weapon.Size = 12
    esp.weapon.Center = true
    esp.weapon.Outline = true

    esp.tracer = NewDrawing("Line")
    esp.tracer.Thickness = 1

    esp.headDot = NewDrawing("Circle")
    esp.headDot.Filled = true
    esp.headDot.Thickness = 1

    esp.distance = NewDrawing("Text")
    esp.distance.Size = 12
    esp.distance.Center = true
    esp.distance.Outline = true

    -- Highlight (Chams)
    local hlOk, hl = pcall(function()
        local h = Instance.new("Highlight")
        h.Name = "Chams_" .. player.Name
        h.Enabled = false
        h.Parent = ChamsContainer
        return h
    end)
    esp.highlight = hlOk and hl or nil

    ESPCache[player] = esp
end

local function DestroyESPForPlayer(player)
    local esp = ESPCache[player]
    if not esp then return end

    pcall(function() esp.box:Remove() end)
    pcall(function() esp.name:Remove() end)
    pcall(function() esp.healthBar:Remove() end)
    pcall(function() esp.healthBarBG:Remove() end)
    pcall(function() esp.healthText:Remove() end)
    pcall(function() esp.weapon:Remove() end)
    pcall(function() esp.tracer:Remove() end)
    pcall(function() esp.headDot:Remove() end)
    pcall(function() esp.distance:Remove() end)
    if esp.highlight then pcall(function() esp.highlight:Destroy() end) end

    ESPCache[player] = nil
end

local function HideAllESP(esp)
    esp.box.Visible = false
    esp.name.Visible = false
    esp.healthBar.Visible = false
    esp.healthBarBG.Visible = false
    esp.healthText.Visible = false
    esp.weapon.Visible = false
    esp.tracer.Visible = false
    esp.headDot.Visible = false
    esp.distance.Visible = false
    if esp.highlight then esp.highlight.Enabled = false end
end

-- Initialize ESP for all current players
for _, v in ipairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then CreateESPForPlayer(v) end
end

Players.PlayerAdded:Connect(function(v)
    CreateESPForPlayer(v)
end)

Players.PlayerRemoving:Connect(function(v)
    DestroyESPForPlayer(v)
    if RadarCache[v] then
        pcall(function() RadarCache[v]:Remove() end)
        RadarCache[v] = nil
    end
end)

-- ==========================================
-- =        DEATH POSITION TRACKING         =
-- ==========================================
LocalPlayer.CharacterRemoving:Connect(function(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then DeathPosition = hrp.Position end
end)

-- ==========================================
-- =         INFINITE JUMP HANDLER          =
-- ==========================================
UserInputService.JumpRequest:Connect(function()
    if Toggles.SelfInfJump.Value and IsAlive(LocalPlayer) then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ==========================================
-- =         CLICK TP INPUT HANDLER         =
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if Toggles.TPClickTP.Value and Options.TPClickTPKey:GetState() then
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if Mouse.Hit and IsAlive(LocalPlayer) then
                LocalPlayer.Character:PivotTo(Mouse.Hit + Vector3.new(0, 3, 0))
            end
        end
    end
end)

-- ==========================================
-- =            ANTI AFK HANDLER            =
-- ==========================================
LocalPlayer.Idled:Connect(function()
    if Toggles.MiscAntiAFK.Value then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- ==========================================
-- =       INSTANT INTERACT HANDLER         =
-- ==========================================
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if Toggles.MiscInstantInteract.Value then
        prompt.HoldDuration = 0
    end
end)

-- ==========================================
-- =       NO FALL DAMAGE HANDLER           =
-- ==========================================
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 10)
    if hum then
        hum.StateChanged:Connect(function(_, newState)
            if Toggles.MiscNoFallDmg.Value and newState == Enum.HumanoidStateType.Freefall then
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
        end)
    end
end)

-- ==============================================================================
-- =                   MAIN RENDER LOOP (Every Frame)                           =
-- ==============================================================================
RunService.RenderStepped:Connect(function(deltaTime)
    TickCounter = TickCounter + 1
    local mousePos = UserInputService:GetMouseLocation()
    local screenSize = Camera.ViewportSize
    local myAlive = IsAlive(LocalPlayer)

    -- ===== FOV CIRCLE =====
    if Toggles.AimShowFOV.Value then
        FOVCircle.Visible = true
        FOVCircle.Radius = Options.AimFOVSize.Value
        FOVCircle.Color = Options.AimFOVColor.Value
        FOVCircle.Position = mousePos
    else
        FOVCircle.Visible = false
    end

    -- ===== AIMBOT =====
    local currentTarget = nil
    if Toggles.AimEnabled.Value and Options.AimKey:GetState() then
        currentTarget = GetAimTarget()
        if currentTarget and IsAlive(currentTarget) then
            local aimPartName = Options.AimPart.Value
            local part = currentTarget.Character:FindFirstChild(aimPartName) or currentTarget.Character:FindFirstChild("HumanoidRootPart")

            if part then
                local targetPos = part.Position

                -- Velocity prediction
                if Toggles.AimPrediction.Value then
                    local vel = part.AssemblyLinearVelocity
                    local dist3D = (Camera.CFrame.Position - part.Position).Magnitude
                    targetPos = targetPos + (vel * Options.AimPredAmt.Value * (dist3D / 500))
                end

                -- Aim shake (humanize movement)
                if Toggles.AimShake.Value then
                    local intensity = Options.AimShakeAmt.Value / 50
                    targetPos = targetPos + Vector3.new(
                        math.sin(TickCounter * 0.3) * intensity,
                        math.cos(TickCounter * 0.4) * intensity * 0.5,
                        math.sin(TickCounter * 0.5) * intensity
                    )
                end

                -- Camera method
                if Options.AimMethod.Value == 'Camera' then
                    local desiredCF = CFrame.new(Camera.CFrame.Position, targetPos)
                    local smoothFactor = 1 / Options.AimSmoothness.Value
                    Camera.CFrame = Camera.CFrame:Lerp(desiredCF, smoothFactor)
                end

                -- Mouse method
                if Options.AimMethod.Value == 'Mouse' then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
                    if onScreen and mousemoverel then
                        local target2D = Vector2.new(screenPos.X, screenPos.Y)
                        local delta = (target2D - mousePos) / Options.AimSmoothness.Value
                        mousemoverel(delta.X, delta.Y)
                    end
                end

                -- Target line
                if Toggles.AimTargetLine.Value then
                    local linePos, lineOnScreen = Camera:WorldToViewportPoint(targetPos)
                    if lineOnScreen then
                        TargetLine.From = mousePos
                        TargetLine.To = Vector2.new(linePos.X, linePos.Y)
                        TargetLine.Color = Color3.fromRGB(255, 50, 50)
                        TargetLine.Visible = true
                    else
                        TargetLine.Visible = false
                    end
                else
                    TargetLine.Visible = false
                end
            end
        else
            TargetLine.Visible = false
        end
    else
        TargetLine.Visible = false
    end

    -- ===== TRIGGERBOT =====
    if Toggles.TrigEnabled.Value and Options.TrigKey:GetState() and not TriggerCooldown then
        local origin = Camera.CFrame.Position
        local direction = Camera.CFrame.LookVector * 1000
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {LocalPlayer.Character}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local result = Workspace:Raycast(origin, direction, params)
        if result and result.Instance then
            local hitChar = result.Instance:FindFirstAncestorOfClass("Model")
            if hitChar then
                local hitPlayer = Players:GetPlayerFromCharacter(hitChar)
                if hitPlayer and hitPlayer ~= LocalPlayer then
                    local shouldShoot = true
                    if Toggles.TrigTeamCheck.Value and IsTeammate(hitPlayer) then shouldShoot = false end
                    if math.random(1, 100) <= Options.TrigMissChance.Value then shouldShoot = false end

                    if shouldShoot then
                        TriggerCooldown = true
                        local delay = Options.TrigMinDelay.Value + math.random() * (Options.TrigMaxDelay.Value - Options.TrigMinDelay.Value)
                        task.delay(delay, function()
                            if mouse1click then mouse1click() end
                            TriggerCooldown = false
                        end)
                    end
                end
            end
        end
    end

    -- ===== ESP RENDERING =====
    for player, esp in pairs(ESPCache) do
        if not Toggles.ESPEnabled.Value or not IsAlive(player) then
            HideAllESP(esp)
            continue
        end

        local char = player.Character
        local hrp = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        local head = char:FindFirstChild("Head")

        local pos3D, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        local dist3D = (Camera.CFrame.Position - hrp.Position).Magnitude

        -- Team check
        if Toggles.ESPTeamCheck.Value and IsTeammate(player) then
            HideAllESP(esp)
            continue
        end

        -- Friend check
        if IsFriend(player) then
            HideAllESP(esp)
            continue
        end

        -- Distance check
        if dist3D > Options.ESPMaxDist.Value then
            HideAllESP(esp)
            continue
        end

        if not onScreen then
            HideAllESP(esp)
            continue
        end

        -- Compute bounding box from head and feet
        local color = IsTeammate(player) and Options.ESPAllyColor.Value or Options.ESPTargetColor.Value
        local headPos3D = head and Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0)) or pos3D
        local feetPos3D = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

        local boxH = math.abs(headPos3D.Y - feetPos3D.Y)
        local boxW = boxH / 2
        local boxTopLeft = Vector2.new(pos3D.X - boxW / 2, headPos3D.Y)

        -- BOX
        if Toggles.ESPBox.Value then
            esp.box.Size = Vector2.new(boxW, boxH)
            esp.box.Position = boxTopLeft
            esp.box.Color = color
            esp.box.Visible = true
        else esp.box.Visible = false end

        -- NAME
        if Toggles.ESPName.Value then
            esp.name.Position = Vector2.new(pos3D.X, boxTopLeft.Y - 16)
            esp.name.Text = player.Name
            esp.name.Color = color
            esp.name.Visible = true
        else esp.name.Visible = false end

        -- DISTANCE
        if Toggles.ESPDistance.Value then
            esp.distance.Position = Vector2.new(pos3D.X, boxTopLeft.Y + boxH + 2)
            esp.distance.Text = "[" .. math.floor(dist3D) .. "m]"
            esp.distance.Color = Color3.fromRGB(200, 200, 200)
            esp.distance.Visible = true
        else esp.distance.Visible = false end

        -- HEALTH BAR (Vertical bar on the left side of the box)
        if Toggles.ESPHealthBar.Value then
            local health = hum.Health
            local maxHealth = hum.MaxHealth
            local ratio = math.clamp(health / maxHealth, 0, 1)
            local barX = boxTopLeft.X - 6

            esp.healthBarBG.From = Vector2.new(barX, boxTopLeft.Y)
            esp.healthBarBG.To = Vector2.new(barX, boxTopLeft.Y + boxH)
            esp.healthBarBG.Visible = true

            esp.healthBar.From = Vector2.new(barX, boxTopLeft.Y + boxH * (1 - ratio))
            esp.healthBar.To = Vector2.new(barX, boxTopLeft.Y + boxH)
            esp.healthBar.Color = Color3.fromHSV(ratio * 0.33, 1, 1)
            esp.healthBar.Visible = true
        else
            esp.healthBar.Visible = false
            esp.healthBarBG.Visible = false
        end

        -- HEALTH TEXT
        if Toggles.ESPHealthText.Value then
            esp.healthText.Position = Vector2.new(boxTopLeft.X - 30, boxTopLeft.Y + boxH / 2 - 6)
            esp.healthText.Text = tostring(math.floor(hum.Health))
            esp.healthText.Color = Color3.fromHSV(math.clamp(hum.Health / hum.MaxHealth, 0, 1) * 0.33, 1, 1)
            esp.healthText.Visible = true
        else esp.healthText.Visible = false end

        -- WEAPON
        if Toggles.ESPWeapon.Value then
            esp.weapon.Position = Vector2.new(pos3D.X, boxTopLeft.Y + boxH + (Toggles.ESPDistance.Value and 16 or 2))
            esp.weapon.Text = GetWeaponName(player)
            esp.weapon.Color = Color3.fromRGB(255, 200, 100)
            esp.weapon.Visible = true
        else esp.weapon.Visible = false end

        -- TRACERS
        if Toggles.ESPTracers.Value then
            esp.tracer.From = Vector2.new(screenSize.X / 2, screenSize.Y)
            esp.tracer.To = Vector2.new(pos3D.X, boxTopLeft.Y + boxH)
            esp.tracer.Color = color
            esp.tracer.Visible = true
        else esp.tracer.Visible = false end

        -- HEAD DOT
        if Toggles.ESPHeadDot.Value and head then
            local headScreenPos = Camera:WorldToViewportPoint(head.Position)
            esp.headDot.Position = Vector2.new(headScreenPos.X, headScreenPos.Y)
            esp.headDot.Radius = math.clamp(80 / dist3D, 1, 6)
            esp.headDot.Color = color
            esp.headDot.Visible = true
        else esp.headDot.Visible = false end

        -- CHAMS (Highlight)
        if esp.highlight then
            if Toggles.ESPChams.Value then
                esp.highlight.Adornee = char
                esp.highlight.FillColor = Options.ESPChamsColor.Value
                esp.highlight.OutlineColor = Options.ESPChamsOutline.Value
                esp.highlight.FillTransparency = Options.ESPChamsFillTrans.Value
                esp.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                esp.highlight.Enabled = true
            else
                esp.highlight.Enabled = false
            end
        end
    end

    -- ===== RADAR =====
    if Toggles.RadarEnabled.Value and myAlive then
        local radarSize = Options.RadarSize.Value
        local radarPos = Vector2.new(20, screenSize.Y / 2 - radarSize / 2)

        RadarBackground.Size = Vector2.new(radarSize, radarSize)
        RadarBackground.Position = radarPos
        RadarBackground.Color = Options.RadarBGColor.Value
        RadarBackground.Transparency = Options.RadarTransparency.Value
        RadarBackground.Visible = true

        RadarBorder.Size = Vector2.new(radarSize, radarSize)
        RadarBorder.Position = radarPos
        RadarBorder.Visible = true

        RadarCenter.Position = radarPos + Vector2.new(radarSize / 2, radarSize / 2)
        RadarCenter.Visible = true

        local myPos = LocalPlayer.Character.HumanoidRootPart.Position
        local camLook = Camera.CFrame.LookVector

        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if not IsAlive(player) then
                if RadarCache[player] then RadarCache[player].Visible = false end
                continue
            end
            if Toggles.RadarTeamCheck.Value and IsTeammate(player) then
                if RadarCache[player] then RadarCache[player].Visible = false end
                continue
            end

            if not RadarCache[player] then
                RadarCache[player] = NewDrawing("Circle")
                RadarCache[player].Filled = true
                RadarCache[player].Radius = 3
            end

            local theirPos = player.Character.HumanoidRootPart.Position
            local rel = (theirPos - myPos)
            local zoom = Options.RadarZoom.Value
            local maxR = radarSize / 2

            -- Rotate relative position by camera direction
            local forward = Vector2.new(camLook.X, camLook.Z).Unit
            local right = Vector2.new(-forward.Y, forward.X)
            local relFlat = Vector2.new(rel.X, rel.Z)
            local dotForward = relFlat:Dot(forward)
            local dotRight = relFlat:Dot(right)

            local plotX = math.clamp(dotRight * zoom, -maxR + 4, maxR - 4)
            local plotY = math.clamp(-dotForward * zoom, -maxR + 4, maxR - 4)

            local dotPos = radarPos + Vector2.new(maxR + plotX, maxR + plotY)
            local dotColor = IsTeammate(player) and Options.ESPAllyColor.Value or Options.ESPTargetColor.Value

            RadarCache[player].Position = dotPos
            RadarCache[player].Color = dotColor
            RadarCache[player].Visible = true
        end
    else
        RadarBackground.Visible = false
        RadarBorder.Visible = false
        RadarCenter.Visible = false
        for _, dot in pairs(RadarCache) do dot.Visible = false end
    end

    -- ===== DEATH POSITION MARKER =====
    if Toggles.TPRenderDeath.Value and DeathPosition then
        local deathScreen, deathOnScreen = Camera:WorldToViewportPoint(DeathPosition)
        if deathOnScreen then
            DeathMarker.Position = Vector2.new(deathScreen.X, deathScreen.Y)
            DeathMarker.Visible = true
        else DeathMarker.Visible = false end
    else DeathMarker.Visible = false end

    -- ===== FREECAM =====
    if Toggles.WorldFreecam.Value then
        if not FreecamActive then
            FreecamActive = true
            FreecamStoredCFrame = Camera.CFrame
        end
        Camera.CameraType = Enum.CameraType.Scriptable

        local speed = Options.WorldFreecamSpeed.Value
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
        Camera.CFrame = Camera.CFrame + dir * speed
    else
        if FreecamActive then
            FreecamActive = false
            Camera.CameraType = Enum.CameraType.Custom
        end
    end

    -- ===== SPECTATE =====
    if Toggles.PlrSpectate.Value then
        local target = Players:FindFirstChild(Options.PlrSelected.Value)
        if target and IsAlive(target) then
            Camera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
        end
    elseif myAlive then
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end

    -- ===== CAMERA / WORLD SETTINGS =====
    if myAlive then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        -- Long Neck
        if Toggles.SelfLongNeck.Value then
            hum.CameraOffset = Vector3.new(0, Options.SelfLongNeckHeight.Value, 0)
        else
            hum.CameraOffset = Vector3.new(0, 0, 0)
        end

        -- Third person
        if Toggles.MiscThirdPerson.Value then
            LocalPlayer.CameraMaxZoomDistance = 15
            LocalPlayer.CameraMinZoomDistance = 15
        elseif Toggles.MiscUnlockCamera.Value then
            LocalPlayer.CameraMaxZoomDistance = 100000
        else
            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = 400
        end
    end

    -- Lighting
    if Toggles.WorldFullbright.Value then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
    end

    Lighting.ClockTime = Options.WorldTime.Value
    Camera.FieldOfView = Options.WorldFOV.Value
    Workspace.Gravity = Options.WorldGravity.Value
    Lighting.FogEnd = Toggles.WorldRemoveFog.Value and 1e8 or OriginalFog

    if Toggles.WorldRemoveShadows.Value then
        Lighting.GlobalShadows = false
    end
end)

-- ==============================================================================
-- =                   PHYSICS LOOP (Stepped, 60hz)                             =
-- ==============================================================================
RunService.Stepped:Connect(function()
    if not IsAlive(LocalPlayer) then return end

    local char = LocalPlayer.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    -- ===== SPEEDHACK =====
    if Toggles.SelfSpeedhack.Value then
        hum.WalkSpeed = Options.SelfSpeedhackVal.Value
    end

    -- ===== JUMP BOOST =====
    if Toggles.SelfJumpBoost.Value then
        hum.JumpPower = Options.SelfJumpPower.Value
        hum.UseJumpPower = true
    end

    -- ===== NOCLIP =====
    if Toggles.SelfNoClip.Value then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- ===== FLY =====
    if Toggles.SelfFly.Value then
        local camLook = Camera.CFrame.LookVector
        local camRight = Camera.CFrame.RightVector
        local velocity = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity = velocity + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then velocity = velocity - Vector3.new(0, 1, 0) end

        hrp.Velocity = velocity * Options.SelfFlySpeed.Value
        hum.PlatformStand = true
    else
        if hum.PlatformStand then
            hum.PlatformStand = false
        end
    end

    -- ===== JETPACK =====
    if Toggles.SelfJetPack.Value and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 60, hrp.Velocity.Z)
    end

    -- ===== AIR SWIM =====
    if Toggles.SelfAirSwim.Value then
        hum:ChangeState(Enum.HumanoidStateType.Swimming)
    end

    -- ===== SPIN BOT =====
    if Toggles.RageSpinBot.Value then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Options.RageSpinSpeed.Value), 0)
    end

    -- ===== WALK FLING =====
    if Toggles.SelfWalkFling.Value then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(
            math.rad(math.random(-180, 180)),
            math.rad(math.random(-180, 180)),
            math.rad(math.random(-180, 180))
        )
        hrp.Velocity = hrp.Velocity * 1.5
    end

    -- ===== GOON ANIMATION =====
    if Toggles.SelfGoonAnim.Value then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:AdjustSpeed(3)
            end
        end
    end

    -- ===== HITBOX EXPANDER =====
    if Toggles.RageHitboxEnabled.Value then
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and IsAlive(v) then
                if Toggles.AimTeamCheck.Value and IsTeammate(v) then continue end

                local targetChar = v.Character
                local expandPart

                if Toggles.RageHitboxHeadOnly.Value then
                    expandPart = targetChar:FindFirstChild("Head")
                else
                    expandPart = targetChar:FindFirstChild("HumanoidRootPart")
                end

                if expandPart then
                    expandPart.Size = Vector3.new(
                        Options.RageHitboxSize.Value,
                        Options.RageHitboxSize.Value,
                        Options.RageHitboxSize.Value
                    )
                    expandPart.CanCollide = false

                    if Toggles.RageHitboxShow.Value then
                        expandPart.Transparency = 0.5
                        expandPart.Material = Enum.Material.Neon
                        expandPart.BrickColor = BrickColor.new(Options.RageHitboxColor.Value)
                    else
                        expandPart.Transparency = 1
                    end
                end
            end
        end
    end

    -- ===== LOOK AT PLAYER =====
    if Toggles.PlrLookAt.Value then
        local target = Players:FindFirstChild(Options.PlrSelected.Value)
        if target and IsAlive(target) then
            hrp.CFrame = CFrame.new(hrp.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- ==============================================================================
-- =                          CLEANUP ON UNLOAD                                 =
-- ==============================================================================
Library:OnUnload(function()
    Library.Unloaded = true

    -- Remove all Drawing objects
    pcall(function() FOVCircle:Remove() end)
    pcall(function() TargetLine:Remove() end)
    pcall(function() RadarBackground:Remove() end)
    pcall(function() RadarBorder:Remove() end)
    pcall(function() RadarCenter:Remove() end)
    pcall(function() DeathMarker:Remove() end)

    -- Remove all ESP drawings
    for player, esp in pairs(ESPCache) do
        DestroyESPForPlayer(player)
    end

    -- Remove all radar dots
    for _, dot in pairs(RadarCache) do
        pcall(function() dot:Remove() end)
    end

    -- Remove chams container
    pcall(function() ChamsContainer:Destroy() end)

    -- Restore original values
    Workspace.Gravity = OriginalGravity
    Lighting.FogEnd = OriginalFog
    Lighting.Ambient = OriginalAmbient
    Lighting.ClockTime = OriginalTime
    Lighting.GlobalShadows = true

    -- Restore character
    if IsAlive(LocalPlayer) then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.PlatformStand = false
        hum.CameraOffset = Vector3.new(0, 0, 0)
        Camera.CameraType = Enum.CameraType.Custom
        LocalPlayer.CameraMinZoomDistance = 0.5
        LocalPlayer.CameraMaxZoomDistance = 400
    end
end)

-- ==============================================================================
-- =                        LOAD SAVED CONFIG                                   =
-- ==============================================================================
pcall(function() SaveManager:LoadAutoloadConfig() end)

Library:Notify("Lunar Universal v3.0 loaded successfully!", 5)
