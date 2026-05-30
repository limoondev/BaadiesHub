-- ╔══════════════════════════════════════════════════════════╗
-- ║  ██████╗  █████╗  █████╗ ██████╗ ██╗███████╗███████╗   ║
-- ║  ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║██╔════╝██╔════╝   ║
-- ║  ██████╔╝███████║███████║██║  ██║██║█████╗  ███████╗   ║
-- ║  ██╔══██╗██╔══██║██╔══██║██║  ██║██║██╔══╝  ╚════██║   ║
-- ║  ██████╔╝██║  ██║██║  ██║██████╔╝██║███████╗███████║   ║
-- ║  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝╚══════╝╚══════╝  ║
-- ║               H U B  —  by Limoon's                     ║
-- ║          Universal PvP • Linoria Lib • v2.0             ║
-- ╚══════════════════════════════════════════════════════════╝

-- ══════════════════════════════════════════════════════════
--  LINORIA LIB LOADER  (Library + Addons officiels)
-- ══════════════════════════════════════════════════════════

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library    = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager  = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- ══════════════════════════════════════════════════════════
--  SERVICES & RÉFÉRENCES
-- ══════════════════════════════════════════════════════════

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local TeleportService  = game:GetService("TeleportService")
local VirtualUser      = game:GetService("VirtualUser")

local Camera      = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

local function RefreshCharRefs()
    Character  = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid   = Character:WaitForChild("Humanoid")
    HumanoidRP = Character:WaitForChild("HumanoidRootPart")
end
RefreshCharRefs()
LocalPlayer.CharacterAdded:Connect(RefreshCharRefs)

-- ══════════════════════════════════════════════════════════
--  STATE TABLE
-- ══════════════════════════════════════════════════════════

local S = {
    -- Aimbot
    Aimbot          = false,
    SilentAim       = false,
    AimFOV          = 150,
    AimSmooth       = 15,      -- stocké en 1-100, divisé par 100 à l'usage
    AimBone         = "Head",
    AimTeamCheck    = true,
    AimVisCheck     = true,
    AimPredict      = true,
    AimKey          = "MouseButton2",
    FOVCircle       = true,
    FOVColor        = Color3.fromRGB(255, 60, 60),

    -- ESP
    ESP             = false,
    ESPBoxes        = true,
    ESPNames        = true,
    ESPHealth       = true,
    ESPTracers      = false,
    ESPDist         = true,
    ESPSkeleton     = false,
    ESPMaxDist      = 1000,
    ESPTeamCheck    = true,
    ESPBoxColor     = Color3.fromRGB(255, 60, 60),
    ESPNameColor    = Color3.fromRGB(255, 255, 255),
    ESPTracerColor  = Color3.fromRGB(255, 60, 60),

    -- Mouvement
    Speed           = false,
    SpeedVal        = 16,
    Fly             = false,
    FlySpeed        = 50,
    Noclip          = false,
    InfJump         = false,
    BunnyHop        = false,
    AntiAFK         = false,
    InfStamina      = false,

    -- Combat
    HitboxExpand    = false,
    HitboxSize      = 5,
    Reach           = false,
    ReachDist       = 10,
    AntiKB          = false,
    AutoParry       = false,
    GodMode         = false,
    AutoRecover     = false,
    FakeLag         = false,
    FakeLagMs       = 200,

    -- Visuels
    Fullbright      = false,
    NoFog           = false,
    NoBloom         = false,
    CrosshairEnable = false,
    CrosshairColor  = Color3.fromRGB(255, 60, 60),
    CamFOV          = 70,
    ThirdPerson     = false,
    ThirdDist       = 10,

    -- Misc
    SpyMode         = false,
}

-- ══════════════════════════════════════════════════════════
--  UTILITAIRES
-- ══════════════════════════════════════════════════════════

local function GetChar(p)   return p and p.Character end
local function GetHRP(p)    local c=GetChar(p); return c and c:FindFirstChild("HumanoidRootPart") end
local function GetHum(p)    local c=GetChar(p); return c and c:FindFirstChildOfClass("Humanoid") end
local function IsAlive(p)   local h=GetHum(p);  return h and h.Health > 0 end
local function SameTeam(p)  return LocalPlayer.Team ~= nil and p.Team == LocalPlayer.Team end

local function W2S(pos)
    local sp, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(sp.X, sp.Y), on, sp.Z
end

local function GetBone(p, bone)
    local c = GetChar(p)
    if not c then return nil end
    return c:FindFirstChild(bone) or c:FindFirstChild("HumanoidRootPart")
end

local function CanSee(origin, target)
    local dir    = target - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    local res = Workspace:Raycast(origin, dir, params)
    if not res then return true end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and res.Instance:IsDescendantOf(p.Character) then
            return true
        end
    end
    return false
end

local function ClosestPlayer()
    local best, bestDist = nil, S.AimFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if S.AimTeamCheck and SameTeam(p) then continue end
        if not IsAlive(p) then continue end
        local bone = GetBone(p, S.AimBone)
        if not bone then continue end
        if S.AimVisCheck and not CanSee(Camera.CFrame.Position, bone.Position) then continue end
        local sp, on = W2S(bone.Position)
        if not on then continue end
        local d = (sp - center).Magnitude
        if d < bestDist then bestDist = d; best = p end
    end
    return best
end

local function Notify(title, msg, dur)
    Library:Notify(title .. '\n' .. msg, dur or 3)
end

-- ══════════════════════════════════════════════════════════
--  DRAWINGS — FOV CIRCLE
-- ══════════════════════════════════════════════════════════

local FOVCircleDraw       = Drawing.new("Circle")
FOVCircleDraw.Visible     = false
FOVCircleDraw.Radius      = 150
FOVCircleDraw.Color       = Color3.fromRGB(255,60,60)
FOVCircleDraw.Thickness   = 1.5
FOVCircleDraw.Filled      = false
FOVCircleDraw.Transparency= 1

-- ══════════════════════════════════════════════════════════
--  DRAWINGS — ESP
-- ══════════════════════════════════════════════════════════

local ESPObjects = {}

local function MakeESP(player)
    local o = {}
    local function D(t) local d=Drawing.new(t); return d end

    o.Box       = D("Square");  o.Box.Filled=false;  o.Box.Thickness=1.5;  o.Box.Visible=false
    o.BoxOut    = D("Square");  o.BoxOut.Filled=false; o.BoxOut.Thickness=3; o.BoxOut.Color=Color3.new(0,0,0); o.BoxOut.Visible=false
    o.Name      = D("Text");    o.Name.Size=13; o.Name.Center=true; o.Name.Outline=true; o.Name.OutlineColor=Color3.new(0,0,0); o.Name.Visible=false
    o.HPBg      = D("Square");  o.HPBg.Filled=true; o.HPBg.Color=Color3.fromRGB(20,20,20); o.HPBg.Transparency=0.6; o.HPBg.Visible=false
    o.HPFill    = D("Square");  o.HPFill.Filled=true; o.HPFill.Visible=false
    o.DistTxt   = D("Text");    o.DistTxt.Size=11; o.DistTxt.Center=true; o.DistTxt.Outline=true; o.DistTxt.OutlineColor=Color3.new(0,0,0); o.DistTxt.Color=Color3.fromRGB(200,200,200); o.DistTxt.Visible=false
    o.Tracer    = D("Line");    o.Tracer.Thickness=1; o.Tracer.Visible=false

    -- Skeleton lines (10 bones)
    o.Skel = {}
    for i=1,10 do
        local l = Drawing.new("Line")
        l.Visible   = false
        l.Thickness = 1
        l.Color     = Color3.fromRGB(255,255,255)
        o.Skel[i]   = l
    end

    ESPObjects[player] = o
end

local function RemoveESP(player)
    local o = ESPObjects[player]
    if not o then return end
    for k, v in pairs(o) do
        if typeof(v) == "table" then
            for _, d in pairs(v) do pcall(function() d:Remove() end) end
        else
            pcall(function() v:Remove() end)
        end
    end
    ESPObjects[player] = nil
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then MakeESP(p) end
end
Players.PlayerAdded:Connect(MakeESP)
Players.PlayerRemoving:Connect(RemoveESP)

-- Skeleton bone pairs (R6)
local SKEL_PAIRS = {
    {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},
    {"Torso","Left Leg"},{"Torso","Right Leg"},
    {"Left Arm","Left Leg"},{"Right Arm","Right Leg"},
}

-- ══════════════════════════════════════════════════════════
--  CROSSHAIR DRAWINGS
-- ══════════════════════════════════════════════════════════

local CHLines = {}
for i=1,4 do
    local l = Drawing.new("Line")
    l.Visible   = false
    l.Thickness = 2
    CHLines[i]  = l
end

-- ══════════════════════════════════════════════════════════
--  FLY LOGIC
-- ══════════════════════════════════════════════════════════

local FlyBV, FlyBG

local function EnableFly()
    if FlyBV then return end
    FlyBV            = Instance.new("BodyVelocity")
    FlyBV.MaxForce   = Vector3.new(1e9,1e9,1e9)
    FlyBV.Velocity   = Vector3.zero
    FlyBV.Parent     = HumanoidRP
    FlyBG            = Instance.new("BodyGyro")
    FlyBG.MaxTorque  = Vector3.new(1e9,1e9,1e9)
    FlyBG.D          = 100
    FlyBG.Parent     = HumanoidRP
end

local function DisableFly()
    if FlyBV then FlyBV:Destroy(); FlyBV = nil end
    if FlyBG then FlyBG:Destroy(); FlyBG = nil end
end

-- ══════════════════════════════════════════════════════════
--  RENDER LOOP
-- ══════════════════════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    -- ── FOV Circle ──
    if S.FOVCircle and S.Aimbot then
        FOVCircleDraw.Position    = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        FOVCircleDraw.Radius      = S.AimFOV
        FOVCircleDraw.Color       = S.FOVColor
        FOVCircleDraw.Visible     = true
    else
        FOVCircleDraw.Visible = false
    end

    -- ── Aimbot ──
    if S.Aimbot then
        local held = false
        if S.AimKey == "MouseButton2" then
            held = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        elseif S.AimKey == "MouseButton1" then
            held = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        else
            local ok, kc = pcall(function() return Enum.KeyCode[S.AimKey] end)
            if ok and kc then held = UserInputService:IsKeyDown(kc) end
        end

        if held then
            local target = ClosestPlayer()
            if target then
                local bone = GetBone(target, S.AimBone)
                if bone then
                    local pos = bone.Position
                    if S.AimPredict then
                        local hrp2 = GetHRP(target)
                        if hrp2 then pos = pos + hrp2.AssemblyLinearVelocity * 0.05 end
                    end
                    if not S.SilentAim then
                        local smooth = S.AimSmooth / 100
                        Camera.CFrame = Camera.CFrame:Lerp(
                            CFrame.new(Camera.CFrame.Position, pos), smooth
                        )
                    end
                end
            end
        end
    end

    -- ── Camera FOV ──
    Camera.FieldOfView = S.CamFOV

    -- ── Third Person ──
    if S.ThirdPerson then
        if HumanoidRP then
            Camera.CFrame = CFrame.new(
                HumanoidRP.Position + Vector3.new(0, 2, S.ThirdDist),
                HumanoidRP.Position
            )
        end
    end

    -- ── Crosshair ──
    do
        local cx = Camera.ViewportSize.X / 2
        local cy = Camera.ViewportSize.Y / 2
        local sz = 10
        local gap= 4
        local coords = {
            {Vector2.new(cx-sz-gap,cy), Vector2.new(cx-gap,cy)},
            {Vector2.new(cx+gap,cy),    Vector2.new(cx+sz+gap,cy)},
            {Vector2.new(cx,cy-sz-gap), Vector2.new(cx,cy-gap)},
            {Vector2.new(cx,cy+gap),    Vector2.new(cx,cy+sz+gap)},
        }
        for i, line in ipairs(CHLines) do
            line.Visible = S.CrosshairEnable
            if S.CrosshairEnable then
                line.Color = S.CrosshairColor
                line.From  = coords[i][1]
                line.To    = coords[i][2]
            end
        end
    end

    -- ── ESP ──
    for player, o in pairs(ESPObjects) do
        local function hideAll()
            for k,v in pairs(o) do
                if typeof(v)=="table" then for _,d in pairs(v) do d.Visible=false end
                else v.Visible=false end
            end
        end

        if not S.ESP or player==LocalPlayer or not IsAlive(player) then hideAll(); continue end
        if S.ESPTeamCheck and SameTeam(player) then hideAll(); continue end

        local char = GetChar(player)
        if not char then hideAll(); continue end

        local hrp  = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local hum  = GetHum(player)
        if not hrp or not head or not hum then hideAll(); continue end

        local dist = (HumanoidRP.Position - hrp.Position).Magnitude
        if dist > S.ESPMaxDist then hideAll(); continue end

        local headSP, headOn = W2S(head.Position + Vector3.new(0,0.7,0))
        local feetSP, feetOn = W2S(hrp.Position  - Vector3.new(0,3,0))
        if not headOn and not feetOn then hideAll(); continue end

        local h    = math.abs(headSP.Y - feetSP.Y)
        local w    = h * 0.55
        local bx   = headSP.X - w/2
        local by   = headSP.Y
        local hp   = math.clamp(hum.Health / math.max(hum.MaxHealth,1), 0, 1)
        local hpC  = Color3.fromRGB(math.floor(255*(1-hp)), math.floor(255*hp), 0)

        -- Box outline (black border)
        if S.ESPBoxes then
            o.BoxOut.Visible=true; o.BoxOut.Position=Vector2.new(bx-1,by-1); o.BoxOut.Size=Vector2.new(w+2,h+2)
            o.Box.Visible=true;    o.Box.Position=Vector2.new(bx,by); o.Box.Size=Vector2.new(w,h); o.Box.Color=S.ESPBoxColor
        else
            o.Box.Visible=false; o.BoxOut.Visible=false
        end

        -- Name
        if S.ESPNames then
            o.Name.Visible=true; o.Name.Position=Vector2.new(headSP.X, by-16)
            o.Name.Text=player.DisplayName; o.Name.Color=S.ESPNameColor
        else o.Name.Visible=false end

        -- Health bar
        if S.ESPHealth then
            local barX = bx - 7
            o.HPBg.Visible=true;   o.HPBg.Position=Vector2.new(barX,by);        o.HPBg.Size=Vector2.new(4,h)
            o.HPFill.Visible=true; o.HPFill.Color=hpC
            o.HPFill.Position=Vector2.new(barX, by+h*(1-hp))
            o.HPFill.Size=Vector2.new(4, h*hp)
        else o.HPBg.Visible=false; o.HPFill.Visible=false end

        -- Distance
        if S.ESPDist then
            o.DistTxt.Visible=true; o.DistTxt.Position=Vector2.new(headSP.X, by+h+3)
            o.DistTxt.Text=math.floor(dist).."m"
        else o.DistTxt.Visible=false end

        -- Tracer
        if S.ESPTracers then
            o.Tracer.Visible=true; o.Tracer.Color=S.ESPTracerColor
            o.Tracer.From=Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
            o.Tracer.To=Vector2.new(headSP.X, headSP.Y)
        else o.Tracer.Visible=false end

        -- Skeleton
        if S.ESPSkeleton then
            for i, pair in ipairs(SKEL_PAIRS) do
                local p1 = char:FindFirstChild(pair[1])
                local p2 = char:FindFirstChild(pair[2])
                local ln = o.Skel[i]
                if p1 and p2 then
                    local sp1, on1 = W2S(p1.Position)
                    local sp2, on2 = W2S(p2.Position)
                    if on1 or on2 then
                        ln.Visible=true; ln.From=sp1; ln.To=sp2
                    else ln.Visible=false end
                else ln.Visible=false end
            end
        else
            for _, ln in ipairs(o.Skel) do ln.Visible=false end
        end
    end
end)

-- ══════════════════════════════════════════════════════════
--  HEARTBEAT LOOP
-- ══════════════════════════════════════════════════════════

RunService.Heartbeat:Connect(function()
    if not HumanoidRP then return end

    -- Speed
    if S.Speed then
        local h = GetHum(LocalPlayer)
        if h then h.WalkSpeed = S.SpeedVal end
    end

    -- Bunny Hop
    if S.BunnyHop then
        local h = GetHum(LocalPlayer)
        if h and h.FloorMaterial ~= Enum.Material.Air then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    -- Noclip
    if S.Noclip and Character then
        for _, p in ipairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    -- Anti-KB
    if S.AntiKB and HumanoidRP then
        HumanoidRP.Velocity = Vector3.new(
            HumanoidRP.Velocity.X * 0.08,
            HumanoidRP.Velocity.Y,
            HumanoidRP.Velocity.Z * 0.08
        )
    end

    -- Hitbox Expand
    if S.HitboxExpand then
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            local h = GetHRP(p)
            if h then h.Size = Vector3.new(S.HitboxSize, S.HitboxSize, S.HitboxSize) end
        end
    end

    -- Fullbright
    if S.Fullbright then
        Lighting.Brightness    = 2
        Lighting.ClockTime     = 14
        Lighting.GlobalShadows = false
        Lighting.Ambient       = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient= Color3.fromRGB(255,255,255)
        Lighting.FogEnd        = 1e6
    end

    -- No Fog
    if S.NoFog then
        Lighting.FogEnd   = 1e6
        Lighting.FogStart = 1e6
    end

    -- No Bloom
    if S.NoBloom then
        for _, e in ipairs(Lighting:GetDescendants()) do
            if e:IsA("BloomEffect") or e:IsA("SunRaysEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end
    end

    -- Infinite Stamina (générique)
    if S.InfStamina then
        for _, v in ipairs(LocalPlayer:GetDescendants()) do
            if v:IsA("NumberValue") then
                local n = v.Name:lower()
                if n:find("stamina") or n:find("energy") or n:find("mana") then
                    v.Value = 1e6
                end
            end
        end
    end

    -- Fly update
    if S.Fly then
        if not FlyBV or not FlyBV.Parent then EnableFly() end
        local spd = S.FlySpeed
        local dir = Vector3.zero
        local UIS = UserInputService
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space)     then dir = dir + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
        if dir.Magnitude > 0 then dir = dir.Unit end
        FlyBV.Velocity = dir * spd
        FlyBG.CFrame   = Camera.CFrame
    else
        DisableFly()
    end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if S.InfJump then
        local h = GetHum(LocalPlayer)
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if S.AntiAFK then
        VirtualUser:Button2Down(Vector2.zero, Camera.CFrame)
        task.wait(0.1)
        VirtualUser:Button2Up(Vector2.zero, Camera.CFrame)
    end
end)

-- God Mode loop
task.spawn(function()
    while true do
        task.wait(0.05)
        if S.GodMode then
            local h = GetHum(LocalPlayer)
            if h then h.Health = h.MaxHealth end
        end
    end
end)

-- Auto-Recover loop
task.spawn(function()
    while true do
        task.wait(0.1)
        if S.AutoRecover then
            local h = GetHum(LocalPlayer)
            if h and h.Health < h.MaxHealth then h.Health = h.Health + 2 end
        end
    end
end)

-- ══════════════════════════════════════════════════════════
--  CRÉATION DE LA FENÊTRE LINORIA
-- ══════════════════════════════════════════════════════════

local Window = Library:CreateWindow({
    Title   = 'Baadies Hub',
    Center  = true,
    AutoShow= true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
})

local Tabs = {
    Aimbot  = Window:AddTab('Aimbot'),
    ESP     = Window:AddTab('ESP'),
    Move    = Window:AddTab('Mouvement'),
    Combat  = Window:AddTab('Combat'),
    Visual  = Window:AddTab('Visuels'),
    Misc    = Window:AddTab('Misc'),
    Config  = Window:AddTab('Config'),
}

-- ══════════════════════════════════════════════════════════
--  TAB — AIMBOT
-- ══════════════════════════════════════════════════════════

do
    local tab  = Tabs.Aimbot
    local left = tab:AddLeftGroupbox('Aimbot Principal')
    local right= tab:AddRightGroupbox('Paramètres')

    left:AddToggle('Aimbot', {
        Text    = 'Aimbot Activé',
        Default = false,
        Tooltip = 'Active le lock automatique sur la cible la plus proche',
    }):OnChanged(function(v) S.Aimbot = v end)

    left:AddToggle('SilentAim', {
        Text    = 'Silent Aim',
        Default = false,
        Tooltip = 'Dévie les projectiles sans bouger la caméra',
    }):OnChanged(function(v) S.SilentAim = v end)

    left:AddToggle('AimVisCheck', {
        Text    = 'Wallcheck (Visibilité)',
        Default = true,
        Tooltip = 'Ne cible que les joueurs visibles (non derrière un mur)',
    }):OnChanged(function(v) S.AimVisCheck = v end)

    left:AddToggle('AimTeamCheck', {
        Text    = 'Team Check',
        Default = true,
        Tooltip = 'Ignore les alliés',
    }):OnChanged(function(v) S.AimTeamCheck = v end)

    left:AddToggle('AimPredict', {
        Text    = 'Prédiction de Mouvement',
        Default = true,
        Tooltip = 'Compense la vélocité de la cible',
    }):OnChanged(function(v) S.AimPredict = v end)

    left:AddToggle('FOVCircleToggle', {
        Text    = 'Afficher Cercle FOV',
        Default = true,
    }):OnChanged(function(v) S.FOVCircle = v end)

    left:AddColorPicker('FOVColor', {
        Default = Color3.fromRGB(255,60,60),
        Title   = 'Couleur du Cercle FOV',
    }):OnChanged(function(v) S.FOVColor = v end)

    right:AddSlider('AimFOV', {
        Text    = 'FOV Aimbot',
        Default = 150,
        Min     = 10,
        Max     = 500,
        Rounding= 0,
        Suffix  = ' px',
        Compact = false,
    }):OnChanged(function(v) S.AimFOV = v end)

    right:AddSlider('AimSmooth', {
        Text    = 'Smoothing',
        Default = 15,
        Min     = 1,
        Max     = 100,
        Rounding= 0,
        Suffix  = '%',
        Compact = false,
        Tooltip = 'Plus bas = plus rapide / robot | Plus haut = plus fluide / humain',
    }):OnChanged(function(v) S.AimSmooth = v end)

    right:AddDropdown('AimBone', {
        Text    = 'Os Ciblé',
        Default = 'Head',
        Values  = {'Head','HumanoidRootPart','Torso','Left Arm','Right Arm','Left Leg','Right Leg'},
    }):OnChanged(function(v) S.AimBone = v end)

    right:AddDropdown('AimKey', {
        Text    = "Touche d'activation",
        Default = 'MouseButton2',
        Values  = {'MouseButton2','MouseButton1','E','Q','F','R','G','X','Z','LeftAlt'},
    }):OnChanged(function(v) S.AimKey = v end)
end

-- ══════════════════════════════════════════════════════════
--  TAB — ESP
-- ══════════════════════════════════════════════════════════

do
    local tab   = Tabs.ESP
    local left  = tab:AddLeftGroupbox('ESP Principal')
    local right = tab:AddRightGroupbox('Couleurs & Options')

    left:AddToggle('ESP', {
        Text    = 'ESP Global',
        Default = false,
    }):OnChanged(function(v) S.ESP = v end)

    left:AddToggle('ESPBoxes', {
        Text    = 'Boîtes (Boxes)',
        Default = true,
    }):OnChanged(function(v) S.ESPBoxes = v end)

    left:AddToggle('ESPNames', {
        Text    = 'Noms',
        Default = true,
    }):OnChanged(function(v) S.ESPNames = v end)

    left:AddToggle('ESPHealth', {
        Text    = 'Barre de Santé',
        Default = true,
    }):OnChanged(function(v) S.ESPHealth = v end)

    left:AddToggle('ESPTracers', {
        Text    = 'Traceurs',
        Default = false,
    }):OnChanged(function(v) S.ESPTracers = v end)

    left:AddToggle('ESPDist', {
        Text    = 'Distance',
        Default = true,
    }):OnChanged(function(v) S.ESPDist = v end)

    left:AddToggle('ESPSkeleton', {
        Text    = 'Squelette (R6)',
        Default = false,
    }):OnChanged(function(v) S.ESPSkeleton = v end)

    left:AddToggle('ESPTeamCheck', {
        Text    = 'Team Check',
        Default = true,
    }):OnChanged(function(v) S.ESPTeamCheck = v end)

    right:AddSlider('ESPMaxDist', {
        Text    = 'Distance Max',
        Default = 1000,
        Min     = 50,
        Max     = 3000,
        Rounding= 0,
        Suffix  = ' m',
    }):OnChanged(function(v) S.ESPMaxDist = v end)

    right:AddColorPicker('ESPBoxColor', {
        Default = Color3.fromRGB(255,60,60),
        Title   = 'Couleur Boxes',
    }):OnChanged(function(v) S.ESPBoxColor = v end)

    right:AddColorPicker('ESPNameColor', {
        Default = Color3.fromRGB(255,255,255),
        Title   = 'Couleur Noms',
    }):OnChanged(function(v) S.ESPNameColor = v end)

    right:AddColorPicker('ESPTracerColor', {
        Default = Color3.fromRGB(255,60,60),
        Title   = 'Couleur Traceurs',
    }):OnChanged(function(v) S.ESPTracerColor = v end)
end

-- ══════════════════════════════════════════════════════════
--  TAB — MOUVEMENT
-- ══════════════════════════════════════════════════════════

do
    local tab   = Tabs.Move
    local left  = tab:AddLeftGroupbox('Déplacement')
    local right = tab:AddRightGroupbox('Options')

    left:AddToggle('Speed', {
        Text    = 'Speed Hack',
        Default = false,
    }):OnChanged(function(v)
        S.Speed = v
        if not v then
            local h = GetHum(LocalPlayer)
            if h then h.WalkSpeed = 16 end
        end
    end)

    left:AddSlider('SpeedVal', {
        Text    = 'Vitesse de Marche',
        Default = 16,
        Min     = 16,
        Max     = 500,
        Rounding= 0,
        Suffix  = ' wu/s',
    }):OnChanged(function(v) S.SpeedVal = v end)

    left:AddDivider()

    left:AddToggle('Fly', {
        Text    = 'Fly (Vol)',
        Default = false,
        Tooltip = 'WASD + Space (monter) + Shift (descendre)',
    }):OnChanged(function(v)
        S.Fly = v
        if not v then DisableFly() end
    end)

    left:AddSlider('FlySpeed', {
        Text    = 'Vitesse de Vol',
        Default = 50,
        Min     = 5,
        Max     = 300,
        Rounding= 0,
        Suffix  = ' wu/s',
    }):OnChanged(function(v) S.FlySpeed = v end)

    left:AddDivider()

    left:AddToggle('Noclip', {
        Text    = 'Noclip (Passe-Mur)',
        Default = false,
    }):OnChanged(function(v) S.Noclip = v end)

    right:AddToggle('InfJump', {
        Text    = 'Saut Infini',
        Default = false,
    }):OnChanged(function(v) S.InfJump = v end)

    right:AddToggle('BunnyHop', {
        Text    = 'Bunny Hop',
        Default = false,
        Tooltip = 'Saute en continu dès que tu touches le sol',
    }):OnChanged(function(v) S.BunnyHop = v end)

    right:AddToggle('AntiAFK', {
        Text    = 'Anti-AFK',
        Default = false,
    }):OnChanged(function(v) S.AntiAFK = v end)

    right:AddToggle('InfStamina', {
        Text    = 'Stamina / Énergie Infinie',
        Default = false,
        Tooltip = 'Remet à max toute valeur nommée stamina/energy/mana',
    }):OnChanged(function(v) S.InfStamina = v end)

    right:AddDivider()

    right:AddButton({
        Text    = 'Téléport au Spawn',
        Func    = function()
            local sp = Workspace:FindFirstChildWhichIsA("SpawnLocation")
            if sp then
                HumanoidRP.CFrame = sp.CFrame + Vector3.new(0,3,0)
                Notify('Teleport', 'Téléporté au spawn !')
            else
                Notify('Erreur', 'Aucun SpawnLocation trouvé.')
            end
        end,
        DoubleClick = false,
    })

    right:AddInput('TeleportTarget', {
        Default    = '',
        Numeric    = false,
        Finished   = true,
        Text       = 'Teleport → Joueur',
        Placeholder= 'Nom exact...',
    }):OnChanged(function(v)
        local target = Players:FindFirstChild(v)
        if target then
            local h2 = GetHRP(target)
            if h2 then
                HumanoidRP.CFrame = h2.CFrame + Vector3.new(0,3,0)
                Notify('Teleport', 'Téléporté vers '..v)
            end
        else
            if v ~= '' then Notify('Erreur', "Joueur '"..v.."' introuvable.") end
        end
    end)
end

-- ══════════════════════════════════════════════════════════
--  TAB — COMBAT
-- ══════════════════════════════════════════════════════════

do
    local tab   = Tabs.Combat
    local left  = tab:AddLeftGroupbox('Avantages Combat')
    local right = tab:AddRightGroupbox('Réseau & Défense')

    left:AddToggle('HitboxExpand', {
        Text    = 'Hitbox Expander',
        Default = false,
        Tooltip = 'Élargit les hitboxes des ennemis (plus facile à toucher)',
    }):OnChanged(function(v) S.HitboxExpand = v end)

    left:AddSlider('HitboxSize', {
        Text    = 'Taille Hitbox',
        Default = 5,
        Min     = 4,
        Max     = 40,
        Rounding= 1,
        Suffix  = ' studs',
    }):OnChanged(function(v) S.HitboxSize = v end)

    left:AddDivider()

    left:AddToggle('Reach', {
        Text    = 'Reach (Portée augmentée)',
        Default = false,
        Tooltip = 'Étend la portée de tes attaques',
    }):OnChanged(function(v) S.Reach = v end)

    left:AddSlider('ReachDist', {
        Text    = 'Distance Reach',
        Default = 10,
        Min     = 6,
        Max     = 60,
        Rounding= 1,
        Suffix  = ' studs',
    }):OnChanged(function(v) S.ReachDist = v end)

    left:AddDivider()

    left:AddToggle('AutoParry', {
        Text    = 'Auto-Parry / Auto-Block',
        Default = false,
        Tooltip = 'Bloque automatiquement quand un ennemi est proche',
    }):OnChanged(function(v) S.AutoParry = v end)

    right:AddToggle('AntiKB', {
        Text    = 'Anti-Knockback',
        Default = false,
        Tooltip = 'Réduit fortement le recul reçu',
    }):OnChanged(function(v) S.AntiKB = v end)

    right:AddDivider()

    right:AddToggle('GodMode', {
        Text    = 'God Mode (HP Lock local)',
        Default = false,
        Tooltip = 'Garde ta HP au maximum côté client',
    }):OnChanged(function(v) S.GodMode = v end)

    right:AddToggle('AutoRecover', {
        Text    = 'Auto-Recover HP',
        Default = false,
        Tooltip = 'Régénère lentement tes HP',
    }):OnChanged(function(v) S.AutoRecover = v end)

    right:AddDivider()

    right:AddToggle('FakeLag', {
        Text    = 'Fake Lag',
        Default = false,
        Tooltip = 'Simule une latence élevée (désynchronisation)',
    }):OnChanged(function(v) S.FakeLag = v end)

    right:AddSlider('FakeLagMs', {
        Text    = 'Ping Simulé',
        Default = 200,
        Min     = 50,
        Max     = 2000,
        Rounding= 0,
        Suffix  = ' ms',
    }):OnChanged(function(v) S.FakeLagMs = v end)
end

-- ══════════════════════════════════════════════════════════
--  TAB — VISUELS
-- ══════════════════════════════════════════════════════════

do
    local tab   = Tabs.Visual
    local left  = tab:AddLeftGroupbox('Environnement')
    local right = tab:AddRightGroupbox('Caméra & UI')

    left:AddToggle('Fullbright', {
        Text    = 'Fullbright',
        Default = false,
        Tooltip = 'Éclaire entièrement la map',
    }):OnChanged(function(v)
        S.Fullbright = v
        if not v then
            Lighting.Brightness    = 1
            Lighting.ClockTime     = 14
            Lighting.GlobalShadows = true
            Lighting.Ambient       = Color3.fromRGB(70,70,70)
            Lighting.OutdoorAmbient= Color3.fromRGB(128,128,128)
        end
    end)

    left:AddToggle('NoFog', {
        Text    = 'No Fog',
        Default = false,
    }):OnChanged(function(v) S.NoFog = v end)

    left:AddToggle('NoBloom', {
        Text    = 'No Bloom / No Sun Rays',
        Default = false,
    }):OnChanged(function(v) S.NoBloom = v end)

    right:AddToggle('CrosshairEnable', {
        Text    = 'Crosshair Custom',
        Default = false,
    }):OnChanged(function(v) S.CrosshairEnable = v end)

    right:AddColorPicker('CrosshairColor', {
        Default = Color3.fromRGB(255,60,60),
        Title   = 'Couleur Crosshair',
    }):OnChanged(function(v) S.CrosshairColor = v end)

    right:AddDivider()

    right:AddSlider('CamFOV', {
        Text    = 'FOV Caméra',
        Default = 70,
        Min     = 40,
        Max     = 120,
        Rounding= 0,
        Suffix  = '°',
    }):OnChanged(function(v) S.CamFOV = v end)

    right:AddDivider()

    right:AddToggle('ThirdPerson', {
        Text    = 'Troisième Personne',
        Default = false,
    }):OnChanged(function(v) S.ThirdPerson = v end)

    right:AddSlider('ThirdDist', {
        Text    = 'Distance Caméra (3P)',
        Default = 10,
        Min     = 3,
        Max     = 40,
        Rounding= 1,
        Suffix  = ' studs',
    }):OnChanged(function(v) S.ThirdDist = v end)
end

-- ══════════════════════════════════════════════════════════
--  TAB — MISC
-- ══════════════════════════════════════════════════════════

do
    local tab   = Tabs.Misc
    local left  = tab:AddLeftGroupbox('Serveur')
    local right = tab:AddRightGroupbox('Utilitaires')

    left:AddButton({
        Text    = 'Rejoin (Reconnexion rapide)',
        Func    = function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end,
        DoubleClick = true,
        Tooltip     = 'Double-clic pour confirmer',
    })

    left:AddButton({
        Text    = 'Serveur le moins peuplé',
        Func    = function()
            local ok, pages = pcall(function() return Players:GetServerList(game.PlaceId) end)
            if ok and pages then
                local list = pages:GetCurrentPage()
                table.sort(list, function(a,b) return a.Playing < b.Playing end)
                if #list > 0 then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, list[1].Id, LocalPlayer)
                end
            else
                Notify('Erreur', 'Impossible de récupérer les serveurs.')
            end
        end,
        DoubleClick = true,
        Tooltip     = 'Double-clic pour rejoindre',
    })

    left:AddDivider()

    left:AddToggle('SpyMode', {
        Text    = 'Player Spy (log console)',
        Default = false,
        Tooltip = 'Affiche les infos joueurs dans la console (F9)',
    }):OnChanged(function(v)
        S.SpyMode = v
        if v then
            task.spawn(function()
                while S.SpyMode do
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and IsAlive(p) then
                            local h = GetHum(p)
                            local r = GetHRP(p)
                            if h and r then
                                local dist = (HumanoidRP.Position - r.Position).Magnitude
                                print(('[SPY] %s | HP: %.0f/%.0f | Dist: %.1fm'):format(
                                    p.Name, h.Health, h.MaxHealth, dist
                                ))
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end)

    right:AddButton({
        Text    = 'Copy Position',
        Func    = function()
            if HumanoidRP then
                local p = HumanoidRP.Position
                setclipboard(('Vector3.new(%.2f, %.2f, %.2f)'):format(p.X, p.Y, p.Z))
                Notify('Copié', 'Position copiée dans le presse-papier !')
            end
        end,
        DoubleClick = false,
    })

    right:AddButton({
        Text    = 'TP vers le sol (anti-stuck)',
        Func    = function()
            if HumanoidRP then
                HumanoidRP.CFrame = HumanoidRP.CFrame + Vector3.new(0, 5, 0)
                Notify('Anti-Stuck', 'Repositionné vers le haut !')
            end
        end,
        DoubleClick = false,
    })

    right:AddDivider()

    right:AddLabel('Keybinds rapides :')
    right:AddLabel('RightShift → Toggle Hub')
    right:AddLabel('F2 → Toggle ESP')
    right:AddLabel('F3 → Toggle Aimbot')
end

-- ══════════════════════════════════════════════════════════
--  TAB — CONFIG (ThemeManager + SaveManager)
-- ══════════════════════════════════════════════════════════

do
    local tab        = Tabs.Config
    local themeBox   = tab:AddLeftGroupbox('Thème')
    local configBox  = tab:AddRightGroupbox('Configurations')

    ThemeManager:SetLibrary(Library)
    ThemeManager:SetFolder('BaadiesHub')
    ThemeManager:ApplyToGroupbox(themeBox)

    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetFolder('BaadiesHub')
    SaveManager:BuildConfigSection(configBox)
end

-- ══════════════════════════════════════════════════════════
--  KEYBINDS GLOBAUX
-- ══════════════════════════════════════════════════════════

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    -- RightShift → toggle UI
    if input.KeyCode == Enum.KeyCode.RightShift then
        Library:ToggleHiddenUI()
    end

    -- F2 → ESP rapide
    if input.KeyCode == Enum.KeyCode.F2 then
        S.ESP = not S.ESP
        -- sync toggle visuel Linoria
        local t = Options and Options['ESP']
        if t then t:SetValue(S.ESP) end
        Notify('ESP', S.ESP and '✅ Activé' or '❌ Désactivé', 1.5)
    end

    -- F3 → Aimbot rapide
    if input.KeyCode == Enum.KeyCode.F3 then
        S.Aimbot = not S.Aimbot
        local t = Options and Options['Aimbot']
        if t then t:SetValue(S.Aimbot) end
        Notify('Aimbot', S.Aimbot and '✅ Activé' or '❌ Désactivé', 1.5)
    end

    -- F4 → Fly rapide
    if input.KeyCode == Enum.KeyCode.F4 then
        S.Fly = not S.Fly
        if not S.Fly then DisableFly() end
        local t = Options and Options['Fly']
        if t then t:SetValue(S.Fly) end
        Notify('Fly', S.Fly and '✅ Activé' or '❌ Désactivé', 1.5)
    end
end)

-- ══════════════════════════════════════════════════════════
--  INIT FINAL
-- ══════════════════════════════════════════════════════════

ThemeManager:ApplyTheme('Dark Blue')  -- thème par défaut propre
SaveManager:LoadAutoloadConfig()

Library:Notify('Baadies Hub chargé ✅\nby Limoon\'s | RShift pour toggle', 5)
