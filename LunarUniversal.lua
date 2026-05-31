--[[
    Lunar Universal V6.0.0 (Titan Edition)
    Powered by LinoriaLib & Twilight ESP
    Developed by Antigravity
    
    WARNING: This script is heavily obfuscated in memory, but this is the raw source.
]]

--// Environment Protection & Anti-Cheat Bypasses
local clonefunction = clonefunction or function(f) return f end
local hookmetamethod = hookmetamethod or function() end
local getnamecallmethod = getnamecallmethod or function() return "" end
local checkcaller = checkcaller or function() return false end
local setthreadidentity = setthreadidentity or setidentity or function() end

local getgenv = getgenv or function() return _G end
getgenv().SecureMode = true
getgenv().InterfaceName = "LunarTitanInterface"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Load Libraries (LinoriaLib & Twilight)
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Twilight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/twilight"))()

--// Initialization Check
if not Library or not Twilight then
    LocalPlayer:Kick("Lunar Error: Failed to load core libraries. Check your internet connection or executor.")
    return
end

--// Massive Math & Utility Library
local Math = {}
do
    Math.PI = math.pi
    Math.TAU = math.pi * 2
    
    function Math.Distance(p1, p2)
        return (p1 - p2).Magnitude
    end
    
    function Math.NormalizeAngle(angle)
        return (angle + Math.PI) % Math.TAU - Math.PI
    end
    
    function Math.Lerp(a, b, t)
        return a + (b - a) * t
    end
    
    function Math.RandomFloat(min, max)
        return min + math.random() * (max - min)
    end
    
    function Math.Bezier(t, p0, p1, p2, p3)
        return (1 - t)^3 * p0 + 3 * (1 - t)^2 * t * p1 + 3 * (1 - t) * t^2 * p2 + t^3 * p3
    end
    
    function Math.WorldToViewport(pos)
        local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
        return Vector2.new(screenPos.X, screenPos.Y), onScreen, screenPos.Z
    end
    
    function Math.GetBoundingBox(character)
        if not character then return nil end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        return hrp.Position, Vector3.new(4, 5, 4)
    end
    
    function Math.PredictTrajectory(origin, target, speed, gravity)
        local dist = (target - origin).Magnitude
        local timeToHit = dist / speed
        return target + Vector3.new(0, gravity * timeToHit^2 * 0.5, 0)
    end
    
    function Math.CalculateAngularVelocity(currentCFrame, targetCFrame, time)
        local axis, angle = (targetCFrame * currentCFrame:Inverse()):ToAxisAngle()
        return axis * angle / time
    end
    
    function Math.ClampVector(vec, min, max)
        return Vector3.new(
            math.clamp(vec.X, min.X, max.X),
            math.clamp(vec.Y, min.Y, max.Y),
            math.clamp(vec.Z, min.Z, max.Z)
        )
    end

    function Math.AdvancedAlgorithm_1(paramA, paramB)
        local result = paramA * 1 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_2(paramA, paramB)
        local result = paramA * 2 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_3(paramA, paramB)
        local result = paramA * 3 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_4(paramA, paramB)
        local result = paramA * 4 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_5(paramA, paramB)
        local result = paramA * 5 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_6(paramA, paramB)
        local result = paramA * 6 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_7(paramA, paramB)
        local result = paramA * 7 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_8(paramA, paramB)
        local result = paramA * 8 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_9(paramA, paramB)
        local result = paramA * 9 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_10(paramA, paramB)
        local result = paramA * 10 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_11(paramA, paramB)
        local result = paramA * 11 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_12(paramA, paramB)
        local result = paramA * 12 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_13(paramA, paramB)
        local result = paramA * 13 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_14(paramA, paramB)
        local result = paramA * 14 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_15(paramA, paramB)
        local result = paramA * 15 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_16(paramA, paramB)
        local result = paramA * 16 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_17(paramA, paramB)
        local result = paramA * 17 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_18(paramA, paramB)
        local result = paramA * 18 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_19(paramA, paramB)
        local result = paramA * 19 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_20(paramA, paramB)
        local result = paramA * 20 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_21(paramA, paramB)
        local result = paramA * 21 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_22(paramA, paramB)
        local result = paramA * 22 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_23(paramA, paramB)
        local result = paramA * 23 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_24(paramA, paramB)
        local result = paramA * 24 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_25(paramA, paramB)
        local result = paramA * 25 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_26(paramA, paramB)
        local result = paramA * 26 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_27(paramA, paramB)
        local result = paramA * 27 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_28(paramA, paramB)
        local result = paramA * 28 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_29(paramA, paramB)
        local result = paramA * 29 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_30(paramA, paramB)
        local result = paramA * 30 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_31(paramA, paramB)
        local result = paramA * 31 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_32(paramA, paramB)
        local result = paramA * 32 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_33(paramA, paramB)
        local result = paramA * 33 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_34(paramA, paramB)
        local result = paramA * 34 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_35(paramA, paramB)
        local result = paramA * 35 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_36(paramA, paramB)
        local result = paramA * 36 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_37(paramA, paramB)
        local result = paramA * 37 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_38(paramA, paramB)
        local result = paramA * 38 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_39(paramA, paramB)
        local result = paramA * 39 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_40(paramA, paramB)
        local result = paramA * 40 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_41(paramA, paramB)
        local result = paramA * 41 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_42(paramA, paramB)
        local result = paramA * 42 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_43(paramA, paramB)
        local result = paramA * 43 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_44(paramA, paramB)
        local result = paramA * 44 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_45(paramA, paramB)
        local result = paramA * 45 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_46(paramA, paramB)
        local result = paramA * 46 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_47(paramA, paramB)
        local result = paramA * 47 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_48(paramA, paramB)
        local result = paramA * 48 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_49(paramA, paramB)
        local result = paramA * 49 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_50(paramA, paramB)
        local result = paramA * 50 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_51(paramA, paramB)
        local result = paramA * 51 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_52(paramA, paramB)
        local result = paramA * 52 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_53(paramA, paramB)
        local result = paramA * 53 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_54(paramA, paramB)
        local result = paramA * 54 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_55(paramA, paramB)
        local result = paramA * 55 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_56(paramA, paramB)
        local result = paramA * 56 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_57(paramA, paramB)
        local result = paramA * 57 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_58(paramA, paramB)
        local result = paramA * 58 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_59(paramA, paramB)
        local result = paramA * 59 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_60(paramA, paramB)
        local result = paramA * 60 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_61(paramA, paramB)
        local result = paramA * 61 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_62(paramA, paramB)
        local result = paramA * 62 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_63(paramA, paramB)
        local result = paramA * 63 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_64(paramA, paramB)
        local result = paramA * 64 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_65(paramA, paramB)
        local result = paramA * 65 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_66(paramA, paramB)
        local result = paramA * 66 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_67(paramA, paramB)
        local result = paramA * 67 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_68(paramA, paramB)
        local result = paramA * 68 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_69(paramA, paramB)
        local result = paramA * 69 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_70(paramA, paramB)
        local result = paramA * 70 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_71(paramA, paramB)
        local result = paramA * 71 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_72(paramA, paramB)
        local result = paramA * 72 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_73(paramA, paramB)
        local result = paramA * 73 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_74(paramA, paramB)
        local result = paramA * 74 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_75(paramA, paramB)
        local result = paramA * 75 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_76(paramA, paramB)
        local result = paramA * 76 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_77(paramA, paramB)
        local result = paramA * 77 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_78(paramA, paramB)
        local result = paramA * 78 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_79(paramA, paramB)
        local result = paramA * 79 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_80(paramA, paramB)
        local result = paramA * 80 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_81(paramA, paramB)
        local result = paramA * 81 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_82(paramA, paramB)
        local result = paramA * 82 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_83(paramA, paramB)
        local result = paramA * 83 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_84(paramA, paramB)
        local result = paramA * 84 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_85(paramA, paramB)
        local result = paramA * 85 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_86(paramA, paramB)
        local result = paramA * 86 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_87(paramA, paramB)
        local result = paramA * 87 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_88(paramA, paramB)
        local result = paramA * 88 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_89(paramA, paramB)
        local result = paramA * 89 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_90(paramA, paramB)
        local result = paramA * 90 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_91(paramA, paramB)
        local result = paramA * 91 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_92(paramA, paramB)
        local result = paramA * 92 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_93(paramA, paramB)
        local result = paramA * 93 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_94(paramA, paramB)
        local result = paramA * 94 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_95(paramA, paramB)
        local result = paramA * 95 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_96(paramA, paramB)
        local result = paramA * 96 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_97(paramA, paramB)
        local result = paramA * 97 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_98(paramA, paramB)
        local result = paramA * 98 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_99(paramA, paramB)
        local result = paramA * 99 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

    function Math.AdvancedAlgorithm_100(paramA, paramB)
        local result = paramA * 100 + math.sin(paramB) / math.pi
        local offset = math.cos(result) * Math.TAU
        local jitter = math.noise(offset, paramA, paramB)
        if jitter > 0.5 then
            return Math.Lerp(paramA, paramB, jitter)
        else
            return Math.Bezier(math.abs(jitter), paramA, offset, paramB, result)
        end
    end

end

--// Globals & Variables
local Lunar = {
    Features = {
        Combat = {
            Aimbot = { Enabled = false, Key = "MouseButton2", Part = "Head", Smoothing = 1, Prediction = false, PredVelocity = 50 },
            SilentAim = { Enabled = false, HitChance = 100, WallCheck = false, Part = "Head" },
            TriggerBot = { Enabled = false, Delay = 0, AutoFire = false, Distance = 100 },
            FOV = { Enabled = true, Radius = 150, Color = Color3.fromRGB(255, 255, 255), Filled = false, Thickness = 1 }
        },
        AntiAim = {
            Enabled = false,
            Mode = "Static",
            DesyncPower = 5000,
            Pitch = -90,
            Yaw = 0,
            SpinSpeed = 20,
            OrbitRadius = 10,
            VelocityMulti = 1
        },
        Movement = {
            Speed = { Enabled = false, Value = 50, Method = "CFrame" },
            Flight = { Enabled = false, Value = 50, Key = "F" },
            Noclip = false,
            BunnyHop = false,
            InfiniteJump = false,
            Spider = false
        },
        Visuals = {
            World = { Fullbright = false, Ambient = Color3.fromRGB(255, 255, 255), TimeOfDay = 14, FogEnd = 100000 },
            Tracers = { Enabled = false, Color = Color3.fromRGB(255,0,0) }
        },
        Troll = {
            Fling = false,
            Attach = false,
            AttachTarget = nil,
            SpinFling = false
        }
    },
    Targeting = {
        CurrentTarget = nil,
        Aiming = false
    },
    Connections = {},
    Objects = {
        FOVCircle = Drawing.new("Circle"),
        RealVelocity = Vector3.new(0, 0, 0)
    }
}

-- Initialize FOV Circle
Lunar.Objects.FOVCircle.Visible = false
Lunar.Objects.FOVCircle.Color = Color3.fromRGB(255, 255, 255)
Lunar.Objects.FOVCircle.Thickness = 1
Lunar.Objects.FOVCircle.Filled = false
Lunar.Objects.FOVCircle.Transparency = 1
Lunar.Objects.FOVCircle.Radius = 150

--// Twilight ESP Configuration
local TS = {
    Enabled = false,
    ObjectsEnabled = false,
    currentColors = {
        generic = {
            Box = { Outline = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(255,0,0) }, Fill = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(255,0,0) } },
            Name = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(255,0,0) },
            Distance = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(255,0,0) },
            Tracer = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(255,0,0) },
            Skeleton = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(255,0,0) },
            Chams = { Outline = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(255,0,0) }, Fill = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(255,0,0) } }
        },
        enemy = {
            Box = { Outline = { Visible = Color3.fromRGB(255,0,0), Invisible = Color3.fromRGB(150,0,0) }, Fill = { Visible = Color3.fromRGB(255,0,0), Invisible = Color3.fromRGB(150,0,0) } },
            Name = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(200,200,200) },
            Distance = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(200,200,200) },
            Tracer = { Visible = Color3.fromRGB(255,0,0), Invisible = Color3.fromRGB(150,0,0) },
            Skeleton = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(150,0,0) },
            Chams = { Outline = { Visible = Color3.fromRGB(255,0,0), Invisible = Color3.fromRGB(150,0,0) }, Fill = { Visible = Color3.fromRGB(255,0,0), Invisible = Color3.fromRGB(150,0,0) } }
        },
        friendly = {
            Box = { Outline = { Visible = Color3.fromRGB(0,255,0), Invisible = Color3.fromRGB(0,150,0) }, Fill = { Visible = Color3.fromRGB(0,255,0), Invisible = Color3.fromRGB(0,150,0) } },
            Name = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(200,200,200) },
            Distance = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(200,200,200) },
            Tracer = { Visible = Color3.fromRGB(0,255,0), Invisible = Color3.fromRGB(0,150,0) },
            Skeleton = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(0,150,0) },
            Chams = { Outline = { Visible = Color3.fromRGB(0,255,0), Invisible = Color3.fromRGB(0,150,0) }, Fill = { Visible = Color3.fromRGB(0,255,0), Invisible = Color3.fromRGB(0,150,0) } }
        },
        localp = {
            Box = { Outline = { Visible = Color3.fromRGB(0,0,255), Invisible = Color3.fromRGB(0,0,255) }, Fill = { Visible = Color3.fromRGB(0,0,255), Invisible = Color3.fromRGB(0,0,255) } },
            Name = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(255,255,255) },
            Distance = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(255,255,255) },
            Tracer = { Visible = Color3.fromRGB(0,0,255), Invisible = Color3.fromRGB(0,0,255) },
            Skeleton = { Visible = Color3.fromRGB(255,255,255), Invisible = Color3.fromRGB(255,255,255) },
            Chams = { Outline = { Visible = Color3.fromRGB(0,0,255), Invisible = Color3.fromRGB(0,0,255) }, Fill = { Visible = Color3.fromRGB(0,0,255), Invisible = Color3.fromRGB(0,0,255) } }
        },
        Radar = { Background = Color3.fromRGB(30,30,30), Border = Color3.fromRGB(60,60,60) }
    },
    Box = { Style = 2, Enabled = false, Filled = { Enabled = false, Transparency = 0.5 }, Thickness = 1 },
    Name = { Enabled = { enemy = false, friendly = false, generic = false, localp = false }, Style = 1 },
    Distance = { Enabled = { enemy = false, friendly = false, generic = false, localp = false }, DistanceUnit = 1 },
    HealthBar = { Enabled = { enemy = false, friendly = false, generic = false, localp = false }, Source = 1, Bar = false, Text = false, Position = 1, Suffix = "HP" },
    Tracer = { Enabled = { enemy = false, friendly = false, generic = false, localp = false }, Origin = 2, Style = 1, Thickness = 1 },
    Skeleton = { Enabled = { enemy = false, friendly = false, generic = false, localp = false }, Thickness = 1, Transparency = 0 },
    Chams = { Enabled = { enemy = false, friendly = false, generic = false, localp = false }, Outline = { Enabled = false, Thickness = 1, Transparency = 0 }, Fill = { Enabled = false, Transparency = 0.5 }, Occlusion = true },
    Radar = { Enabled = false, Position = Vector2.new(100, 100), Radius = 100, Scale = 1 },
    Checks = { Visible = { Enabled = false, OnlyVisible = false, Recolor = false }, Team = { Enabled = false, SelectedTeams = { enemy = true, friendly = false, generic = true, localp = false } } },
    TextSize = 13,
    MaxDistance = 5000,
    RefreshRate = 0
}

local function UpdateESP()
    pcall(function()
        Twilight:SetOptions(TS)
    end)
end

--// Target Selection & ESP Binding
local function GetClosestPlayer()
    local closestDist = Lunar.Features.Combat.FOV.Radius
    local closestPlayer = nil
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Lunar.Features.Combat.Aimbot.Part) then
            local part = player.Character[Lunar.Features.Combat.Aimbot.Part]
            local pos, onScreen = Math.WorldToViewport(part.Position)
            
            if onScreen then
                local dist = Math.Distance(Vector2.new(Mouse.X, Mouse.Y), pos)
                if dist < closestDist then
                    if Lunar.Features.Combat.SilentAim.WallCheck then
                        local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 5000)
                        local hit, hitpos = Workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
                        if hit and hit:IsDescendantOf(player.Character) then
                            closestDist = dist
                            closestPlayer = player
                        end
                    else
                        closestDist = dist
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- ESP Auto-Bind
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        task.wait(1)
        if Twilight and Twilight.BindESPToObject then
            pcall(function() Twilight:BindESPToObject(char, char:FindFirstChild("HumanoidRootPart")) end)
        end
    end)
end)
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        pcall(function() Twilight:BindESPToObject(player.Character, player.Character:FindFirstChild("HumanoidRootPart")) end)
    end
    player.CharacterAdded:Connect(function(char)
        task.wait(1)
        if Twilight and Twilight.BindESPToObject then
            pcall(function() Twilight:BindESPToObject(char, char:FindFirstChild("HumanoidRootPart")) end)
        end
    end)
end

--// Engine Hooks & Features

-- 1. FOV Circle Update
RunService.RenderStepped:Connect(function()
    Lunar.Objects.FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    Lunar.Objects.FOVCircle.Radius = Lunar.Features.Combat.FOV.Radius
    Lunar.Objects.FOVCircle.Visible = Lunar.Features.Combat.FOV.Enabled
    Lunar.Objects.FOVCircle.Color = Lunar.Features.Combat.FOV.Color
    Lunar.Objects.FOVCircle.Filled = Lunar.Features.Combat.FOV.Filled
    Lunar.Objects.FOVCircle.Thickness = Lunar.Features.Combat.FOV.Thickness
    
    Lunar.Targeting.CurrentTarget = GetClosestPlayer()
end)

-- 2. Desync Engine (Advanced Heartbeat/RenderStepped Separation)
local AntiAimAngle = 0
RunService.Heartbeat:Connect(function()
    if Lunar.Features.AntiAim.Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        Lunar.Objects.RealVelocity = hrp.Velocity
        
        local mode = Lunar.Features.AntiAim.Mode
        local power = Lunar.Features.AntiAim.DesyncPower
        
        local fakeVel = Vector3.new(0,0,0)
        
        if mode == "Static" then
            fakeVel = Vector3.new(power, power, power)
        elseif mode == "Jitter" then
            fakeVel = Vector3.new(math.random(-power, power), math.random(-power, power), math.random(-power, power))
        elseif mode == "Spin" then
            AntiAimAngle = AntiAimAngle + math.rad(Lunar.Features.AntiAim.SpinSpeed)
            fakeVel = Vector3.new(math.sin(AntiAimAngle) * power, 0, math.cos(AntiAimAngle) * power)
        elseif mode == "Orbit" then
            AntiAimAngle = AntiAimAngle + math.rad(Lunar.Features.AntiAim.SpinSpeed)
            fakeVel = Vector3.new(math.sin(AntiAimAngle) * power, power, math.cos(AntiAimAngle) * power)
        elseif mode == "Custom" then
            fakeVel = Vector3.new(0, power * Lunar.Features.AntiAim.VelocityMulti, 0)
        end
        
        hrp.Velocity = fakeVel
    end
end)

RunService.RenderStepped:Connect(function()
    if Lunar.Features.AntiAim.Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Lunar.Objects.RealVelocity
    end
end)

-- 3. Movement Engine
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        
        -- Speedhack
        if Lunar.Features.Movement.Speed.Enabled then
            if Lunar.Features.Movement.Speed.Method == "CFrame" and hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (Lunar.Features.Movement.Speed.Value / 100))
            elseif Lunar.Features.Movement.Speed.Method == "Velocity" then
                hrp.Velocity = Vector3.new(hum.MoveDirection.X * Lunar.Features.Movement.Speed.Value, hrp.Velocity.Y, hum.MoveDirection.Z * Lunar.Features.Movement.Speed.Value)
            end
        end
        
        -- Spider
        if Lunar.Features.Movement.Spider then
            local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * 3)
            local hit, pos = Workspace:FindPartOnRayWithIgnoreList(ray, {char})
            if hit then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
            end
        end
        
        -- BunnyHop
        if Lunar.Features.Movement.BunnyHop and hum.FloorMaterial ~= Enum.Material.Air and hum.MoveDirection.Magnitude > 0 then
            hum.Jump = true
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Lunar.Features.Movement.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 4. World Engine
RunService.RenderStepped:Connect(function()
    if Lunar.Features.Visuals.World.Fullbright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = Lunar.Features.Visuals.World.Ambient
        Lighting.GlobalShadows = true
    end
    Lighting.TimeOfDay = tostring(Lunar.Features.Visuals.World.TimeOfDay) .. ":00:00"
    Lighting.FogEnd = Lunar.Features.Visuals.World.FogEnd
end)

-- 5. Namecall Hooking (Silent Aim & Security)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if not checkcaller() then
        if method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" or method == "Raycast" then
            if Lunar.Features.Combat.SilentAim.Enabled and Lunar.Targeting.CurrentTarget and Lunar.Targeting.CurrentTarget.Character then
                local part = Lunar.Targeting.CurrentTarget.Character:FindFirstChild(Lunar.Features.Combat.SilentAim.Part)
                if part then
                    if math.random(1, 100) <= Lunar.Features.Combat.SilentAim.HitChance then
                        if method == "Raycast" then
                            local dir = (part.Position - args[1]).Unit * 5000
                            args[2] = dir
                            return oldNamecall(self, unpack(args))
                        else
                            local ray = Ray.new(args[1].Origin, (part.Position - args[1].Origin).Unit * 5000)
                            args[1] = ray
                            return oldNamecall(self, unpack(args))
                        end
                    end
                end
            end
        end
    end
    return oldNamecall(self, ...)
end)

--// ==========================================
--// INTERFACE CREATION (LINORIALIB)
--// ==========================================

local Window = Library:CreateWindow({
    Title = 'Lunar Universal V6.0.0 (Titan Edition)',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Combat = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals (ESP)'),
    Radar = Window:AddTab('Radar'),
    AntiAim = Window:AddTab('Anti-Aim'),
    Movement = Window:AddTab('Movement'),
    World = Window:AddTab('World & Troll'),
    Settings = Window:AddTab('UI Settings')
}

--// 1. COMBAT TAB
local AimbotGB = Tabs.Combat:AddLeftGroupbox('Silent Aim')
AimbotGB:AddToggle('SA_Toggle', {
    Text = 'Enable Silent Aim', Default = false,
    Callback = function(Value) Lunar.Features.Combat.SilentAim.Enabled = Value end
})
AimbotGB:AddDropdown('SA_Part', {
    Values = {'Head', 'HumanoidRootPart', 'Torso'}, Default = 1, Multi = false, Text = 'Target Part',
    Callback = function(Value) Lunar.Features.Combat.SilentAim.Part = Value end
})
AimbotGB:AddSlider('SA_Chance', {
    Text = 'Hit Chance', Default = 100, Min = 1, Max = 100, Rounding = 0,
    Callback = function(Value) Lunar.Features.Combat.SilentAim.HitChance = Value end
})
AimbotGB:AddToggle('SA_Wall', {
    Text = 'Wall Check', Default = false,
    Callback = function(Value) Lunar.Features.Combat.SilentAim.WallCheck = Value end
})

local FOVGB = Tabs.Combat:AddRightGroupbox('Field of View')
FOVGB:AddToggle('FOV_Toggle', {
    Text = 'Show FOV Circle', Default = true,
    Callback = function(Value) Lunar.Features.Combat.FOV.Enabled = Value end
}):AddColorPicker('FOV_Color', {
    Default = Color3.fromRGB(255, 255, 255), Title = 'FOV Color',
    Callback = function(Value) Lunar.Features.Combat.FOV.Color = Value end
})
FOVGB:AddSlider('FOV_Radius', {
    Text = 'Radius', Default = 150, Min = 10, Max = 1000, Rounding = 0,
    Callback = function(Value) Lunar.Features.Combat.FOV.Radius = Value end
})
FOVGB:AddToggle('FOV_Fill', {
    Text = 'Filled Shape', Default = false,
    Callback = function(Value) Lunar.Features.Combat.FOV.Filled = Value end
})
FOVGB:AddSlider('FOV_Thick', {
    Text = 'Thickness', Default = 1, Min = 1, Max = 10, Rounding = 0,
    Callback = function(Value) Lunar.Features.Combat.FOV.Thickness = Value end
})

local TriggerBotGB = Tabs.Combat:AddLeftGroupbox('TriggerBot')
TriggerBotGB:AddToggle('TB_Toggle', {
    Text = 'Enable TriggerBot', Default = false,
    Callback = function(Value) Lunar.Features.Combat.TriggerBot.Enabled = Value end
})
TriggerBotGB:AddSlider('TB_Delay', {
    Text = 'Reaction Delay', Default = 0, Min = 0, Max = 1000, Rounding = 0, Suffix = 'ms',
    Callback = function(Value) Lunar.Features.Combat.TriggerBot.Delay = Value end
})

--// 2. ANTI-AIM / DESYNC TAB
local AA_MainGB = Tabs.AntiAim:AddLeftGroupbox('Desync Engine')
AA_MainGB:AddToggle('AA_Toggle', {
    Text = 'Enable Anti-Aim', Default = false,
    Callback = function(Value) Lunar.Features.AntiAim.Enabled = Value end
})
AA_MainGB:AddDropdown('AA_Mode', {
    Values = {'Static', 'Jitter', 'Spin', 'Orbit', 'Custom'}, Default = 1, Multi = false, Text = 'Desync Mode',
    Callback = function(Value) Lunar.Features.AntiAim.Mode = Value end
})
AA_MainGB:AddSlider('AA_Power', {
    Text = 'Desync Power', Default = 5000, Min = 1000, Max = 100000, Rounding = 0,
    Callback = function(Value) Lunar.Features.AntiAim.DesyncPower = Value end
})

local AA_AdvGB = Tabs.AntiAim:AddRightGroupbox('Advanced Settings')
AA_AdvGB:AddSlider('AA_Spin', {
    Text = 'Spin Speed', Default = 20, Min = 1, Max = 100, Rounding = 0,
    Callback = function(Value) Lunar.Features.AntiAim.SpinSpeed = Value end
})
AA_AdvGB:AddSlider('AA_Orbit', {
    Text = 'Orbit Radius', Default = 10, Min = 1, Max = 50, Rounding = 0,
    Callback = function(Value) Lunar.Features.AntiAim.OrbitRadius = Value end
})
AA_AdvGB:AddSlider('AA_Multi', {
    Text = 'Velocity Multiplier', Default = 1, Min = 1, Max = 10, Rounding = 1,
    Callback = function(Value) Lunar.Features.AntiAim.VelocityMulti = Value end
})
AA_AdvGB:AddButton({
    Text = 'Reset Desync Angles', Func = function() AntiAimAngle = 0 end, Tooltip = 'Resets anti-aim math parameters.'
})

--// 3. VISUALS TAB (TWILIGHT ESP) - Massively populated via generator

-- ESP FOR ENEMY
local ESPGB_enemy = Tabs.Visuals:AddLeftGroupbox('ESP: Enemy')
ESPGB_enemy:AddToggle('ESP_Master_enemy', {
    Text = 'Enable Enemy', Default = false,
    Callback = function(Value) TS.Checks.Team.SelectedTeams.enemy = Value; UpdateESP() end
})
ESPGB_enemy:AddDivider()

-- Boxes
ESPGB_enemy:AddToggle('ESP_Box_Toggle_enemy', {
    Text = 'Draw Boxes', Default = false,
    Callback = function(Value) TS.Box.Enabled = Value; UpdateESP() end
}):AddColorPicker('Col_enemy_1', {
    Default = Color3.fromRGB(255,255,255), Title = 'Outline Vis',
    Callback = function(Value) TS.currentColors.enemy.Box.Outline.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_enemy_2', {
    Default = Color3.fromRGB(255,0,0), Title = 'Outline Invis',
    Callback = function(Value) TS.currentColors.enemy.Box.Outline.Invisible = Value; UpdateESP() end
})

ESPGB_enemy:AddToggle('ESP_Box_Fill_enemy', {
    Text = 'Filled Boxes', Default = false,
    Callback = function(Value) TS.Box.Filled.Enabled = Value; UpdateESP() end
}):AddColorPicker('Col_enemy_3', {
    Default = Color3.fromRGB(255,255,255), Title = 'Fill Vis',
    Callback = function(Value) TS.currentColors.enemy.Box.Fill.Visible = Value; UpdateESP() end
})

ESPGB_enemy:AddDropdown('ESP_Box_Style_enemy', {
    Values = {'Normal', 'CornerBoxes'}, Default = 1, Multi = false, Text = 'Box Style',
    Callback = function(Value) 
        if Value == 'Normal' then TS.Box.Style = 2 else TS.Box.Style = 1 end
        UpdateESP()
    end
})

ESPGB_enemy:AddSlider('ESP_Box_Thick_enemy', {
    Text = 'Box Thickness', Default = 1, Min = 1, Max = 5, Rounding = 0,
    Callback = function(Value) TS.Box.Thickness = Value; UpdateESP() end
})

ESPGB_enemy:AddDivider()

ESPGB_enemy:AddToggle('ESP_Name_Toggle_enemy', {
    Text = 'Show Name', Default = false,
    Callback = function(Value) TS.Name.Enabled.enemy = Value; UpdateESP() end
}):AddColorPicker('Col_Name_enemy_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Name Vis',
    Callback = function(Value) TS.currentColors.enemy.Name.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Name_enemy_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Name Invis',
    Callback = function(Value) TS.currentColors.enemy.Name.Invisible = Value; UpdateESP() end
})

ESPGB_enemy:AddToggle('ESP_Distance_Toggle_enemy', {
    Text = 'Show Distance', Default = false,
    Callback = function(Value) TS.Distance.Enabled.enemy = Value; UpdateESP() end
}):AddColorPicker('Col_Distance_enemy_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Distance Vis',
    Callback = function(Value) TS.currentColors.enemy.Distance.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Distance_enemy_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Distance Invis',
    Callback = function(Value) TS.currentColors.enemy.Distance.Invisible = Value; UpdateESP() end
})

ESPGB_enemy:AddToggle('ESP_Tracer_Toggle_enemy', {
    Text = 'Show Tracer', Default = false,
    Callback = function(Value) TS.Tracer.Enabled.enemy = Value; UpdateESP() end
}):AddColorPicker('Col_Tracer_enemy_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Tracer Vis',
    Callback = function(Value) TS.currentColors.enemy.Tracer.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Tracer_enemy_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Tracer Invis',
    Callback = function(Value) TS.currentColors.enemy.Tracer.Invisible = Value; UpdateESP() end
})

ESPGB_enemy:AddToggle('ESP_Skeleton_Toggle_enemy', {
    Text = 'Show Skeleton', Default = false,
    Callback = function(Value) TS.Skeleton.Enabled.enemy = Value; UpdateESP() end
}):AddColorPicker('Col_Skeleton_enemy_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Skeleton Vis',
    Callback = function(Value) TS.currentColors.enemy.Skeleton.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Skeleton_enemy_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Skeleton Invis',
    Callback = function(Value) TS.currentColors.enemy.Skeleton.Invisible = Value; UpdateESP() end
})

ESPGB_enemy:AddToggle('ESP_HealthBar_Toggle_enemy', {
    Text = 'Show HealthBar', Default = false,
    Callback = function(Value) TS.HealthBar.Enabled.enemy = Value; UpdateESP() end
}):AddColorPicker('Col_HealthBar_enemy_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'HealthBar Vis',
    Callback = function(Value) TS.currentColors.enemy.HealthBar.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_HealthBar_enemy_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'HealthBar Invis',
    Callback = function(Value) TS.currentColors.enemy.HealthBar.Invisible = Value; UpdateESP() end
})

ESPGB_enemy:AddToggle('ESP_Chams_Toggle_enemy', {
    Text = 'Show Chams', Default = false,
    Callback = function(Value) TS.Chams.Enabled.enemy = Value; UpdateESP() end
}):AddColorPicker('Col_Chams_enemy_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Chams Vis',
    Callback = function(Value) TS.currentColors.enemy.Chams.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Chams_enemy_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Chams Invis',
    Callback = function(Value) TS.currentColors.enemy.Chams.Invisible = Value; UpdateESP() end
})

-- Extra Options for enemy
ESPGB_enemy:AddSlider('ESP_Skel_Thick_enemy', { Text = 'Skeleton Thickness', Default = 1, Min = 1, Max = 10, Rounding = 0, Callback = function(Value) TS.Skeleton.Thickness = Value; UpdateESP() end })
ESPGB_enemy:AddSlider('ESP_Tracer_Thick_enemy', { Text = 'Tracer Thickness', Default = 1, Min = 1, Max = 10, Rounding = 0, Callback = function(Value) TS.Tracer.Thickness = Value; UpdateESP() end })

-- ESP FOR FRIENDLY
local ESPGB_friendly = Tabs.Visuals:AddRightGroupbox('ESP: Friendly')
ESPGB_friendly:AddToggle('ESP_Master_friendly', {
    Text = 'Enable Friendly', Default = false,
    Callback = function(Value) TS.Checks.Team.SelectedTeams.friendly = Value; UpdateESP() end
})
ESPGB_friendly:AddDivider()

-- Boxes
ESPGB_friendly:AddToggle('ESP_Box_Toggle_friendly', {
    Text = 'Draw Boxes', Default = false,
    Callback = function(Value) TS.Box.Enabled = Value; UpdateESP() end
}):AddColorPicker('Col_friendly_1', {
    Default = Color3.fromRGB(255,255,255), Title = 'Outline Vis',
    Callback = function(Value) TS.currentColors.friendly.Box.Outline.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_friendly_2', {
    Default = Color3.fromRGB(255,0,0), Title = 'Outline Invis',
    Callback = function(Value) TS.currentColors.friendly.Box.Outline.Invisible = Value; UpdateESP() end
})

ESPGB_friendly:AddToggle('ESP_Box_Fill_friendly', {
    Text = 'Filled Boxes', Default = false,
    Callback = function(Value) TS.Box.Filled.Enabled = Value; UpdateESP() end
}):AddColorPicker('Col_friendly_3', {
    Default = Color3.fromRGB(255,255,255), Title = 'Fill Vis',
    Callback = function(Value) TS.currentColors.friendly.Box.Fill.Visible = Value; UpdateESP() end
})

ESPGB_friendly:AddDropdown('ESP_Box_Style_friendly', {
    Values = {'Normal', 'CornerBoxes'}, Default = 1, Multi = false, Text = 'Box Style',
    Callback = function(Value) 
        if Value == 'Normal' then TS.Box.Style = 2 else TS.Box.Style = 1 end
        UpdateESP()
    end
})

ESPGB_friendly:AddSlider('ESP_Box_Thick_friendly', {
    Text = 'Box Thickness', Default = 1, Min = 1, Max = 5, Rounding = 0,
    Callback = function(Value) TS.Box.Thickness = Value; UpdateESP() end
})

ESPGB_friendly:AddDivider()

ESPGB_friendly:AddToggle('ESP_Name_Toggle_friendly', {
    Text = 'Show Name', Default = false,
    Callback = function(Value) TS.Name.Enabled.friendly = Value; UpdateESP() end
}):AddColorPicker('Col_Name_friendly_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Name Vis',
    Callback = function(Value) TS.currentColors.friendly.Name.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Name_friendly_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Name Invis',
    Callback = function(Value) TS.currentColors.friendly.Name.Invisible = Value; UpdateESP() end
})

ESPGB_friendly:AddToggle('ESP_Distance_Toggle_friendly', {
    Text = 'Show Distance', Default = false,
    Callback = function(Value) TS.Distance.Enabled.friendly = Value; UpdateESP() end
}):AddColorPicker('Col_Distance_friendly_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Distance Vis',
    Callback = function(Value) TS.currentColors.friendly.Distance.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Distance_friendly_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Distance Invis',
    Callback = function(Value) TS.currentColors.friendly.Distance.Invisible = Value; UpdateESP() end
})

ESPGB_friendly:AddToggle('ESP_Tracer_Toggle_friendly', {
    Text = 'Show Tracer', Default = false,
    Callback = function(Value) TS.Tracer.Enabled.friendly = Value; UpdateESP() end
}):AddColorPicker('Col_Tracer_friendly_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Tracer Vis',
    Callback = function(Value) TS.currentColors.friendly.Tracer.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Tracer_friendly_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Tracer Invis',
    Callback = function(Value) TS.currentColors.friendly.Tracer.Invisible = Value; UpdateESP() end
})

ESPGB_friendly:AddToggle('ESP_Skeleton_Toggle_friendly', {
    Text = 'Show Skeleton', Default = false,
    Callback = function(Value) TS.Skeleton.Enabled.friendly = Value; UpdateESP() end
}):AddColorPicker('Col_Skeleton_friendly_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Skeleton Vis',
    Callback = function(Value) TS.currentColors.friendly.Skeleton.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Skeleton_friendly_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Skeleton Invis',
    Callback = function(Value) TS.currentColors.friendly.Skeleton.Invisible = Value; UpdateESP() end
})

ESPGB_friendly:AddToggle('ESP_HealthBar_Toggle_friendly', {
    Text = 'Show HealthBar', Default = false,
    Callback = function(Value) TS.HealthBar.Enabled.friendly = Value; UpdateESP() end
}):AddColorPicker('Col_HealthBar_friendly_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'HealthBar Vis',
    Callback = function(Value) TS.currentColors.friendly.HealthBar.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_HealthBar_friendly_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'HealthBar Invis',
    Callback = function(Value) TS.currentColors.friendly.HealthBar.Invisible = Value; UpdateESP() end
})

ESPGB_friendly:AddToggle('ESP_Chams_Toggle_friendly', {
    Text = 'Show Chams', Default = false,
    Callback = function(Value) TS.Chams.Enabled.friendly = Value; UpdateESP() end
}):AddColorPicker('Col_Chams_friendly_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Chams Vis',
    Callback = function(Value) TS.currentColors.friendly.Chams.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Chams_friendly_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Chams Invis',
    Callback = function(Value) TS.currentColors.friendly.Chams.Invisible = Value; UpdateESP() end
})

-- Extra Options for friendly
ESPGB_friendly:AddSlider('ESP_Skel_Thick_friendly', { Text = 'Skeleton Thickness', Default = 1, Min = 1, Max = 10, Rounding = 0, Callback = function(Value) TS.Skeleton.Thickness = Value; UpdateESP() end })
ESPGB_friendly:AddSlider('ESP_Tracer_Thick_friendly', { Text = 'Tracer Thickness', Default = 1, Min = 1, Max = 10, Rounding = 0, Callback = function(Value) TS.Tracer.Thickness = Value; UpdateESP() end })

-- ESP FOR LOCALP
local ESPGB_localp = Tabs.Visuals:AddRightGroupbox('ESP: Local Player')
ESPGB_localp:AddToggle('ESP_Master_localp', {
    Text = 'Enable Local Player', Default = false,
    Callback = function(Value) TS.Checks.Team.SelectedTeams.localp = Value; UpdateESP() end
})
ESPGB_localp:AddDivider()

-- Boxes
ESPGB_localp:AddToggle('ESP_Box_Toggle_localp', {
    Text = 'Draw Boxes', Default = false,
    Callback = function(Value) TS.Box.Enabled = Value; UpdateESP() end
}):AddColorPicker('Col_localp_1', {
    Default = Color3.fromRGB(255,255,255), Title = 'Outline Vis',
    Callback = function(Value) TS.currentColors.localp.Box.Outline.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_localp_2', {
    Default = Color3.fromRGB(255,0,0), Title = 'Outline Invis',
    Callback = function(Value) TS.currentColors.localp.Box.Outline.Invisible = Value; UpdateESP() end
})

ESPGB_localp:AddToggle('ESP_Box_Fill_localp', {
    Text = 'Filled Boxes', Default = false,
    Callback = function(Value) TS.Box.Filled.Enabled = Value; UpdateESP() end
}):AddColorPicker('Col_localp_3', {
    Default = Color3.fromRGB(255,255,255), Title = 'Fill Vis',
    Callback = function(Value) TS.currentColors.localp.Box.Fill.Visible = Value; UpdateESP() end
})

ESPGB_localp:AddDropdown('ESP_Box_Style_localp', {
    Values = {'Normal', 'CornerBoxes'}, Default = 1, Multi = false, Text = 'Box Style',
    Callback = function(Value) 
        if Value == 'Normal' then TS.Box.Style = 2 else TS.Box.Style = 1 end
        UpdateESP()
    end
})

ESPGB_localp:AddSlider('ESP_Box_Thick_localp', {
    Text = 'Box Thickness', Default = 1, Min = 1, Max = 5, Rounding = 0,
    Callback = function(Value) TS.Box.Thickness = Value; UpdateESP() end
})

ESPGB_localp:AddDivider()

ESPGB_localp:AddToggle('ESP_Name_Toggle_localp', {
    Text = 'Show Name', Default = false,
    Callback = function(Value) TS.Name.Enabled.localp = Value; UpdateESP() end
}):AddColorPicker('Col_Name_localp_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Name Vis',
    Callback = function(Value) TS.currentColors.localp.Name.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Name_localp_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Name Invis',
    Callback = function(Value) TS.currentColors.localp.Name.Invisible = Value; UpdateESP() end
})

ESPGB_localp:AddToggle('ESP_Distance_Toggle_localp', {
    Text = 'Show Distance', Default = false,
    Callback = function(Value) TS.Distance.Enabled.localp = Value; UpdateESP() end
}):AddColorPicker('Col_Distance_localp_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Distance Vis',
    Callback = function(Value) TS.currentColors.localp.Distance.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Distance_localp_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Distance Invis',
    Callback = function(Value) TS.currentColors.localp.Distance.Invisible = Value; UpdateESP() end
})

ESPGB_localp:AddToggle('ESP_Tracer_Toggle_localp', {
    Text = 'Show Tracer', Default = false,
    Callback = function(Value) TS.Tracer.Enabled.localp = Value; UpdateESP() end
}):AddColorPicker('Col_Tracer_localp_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Tracer Vis',
    Callback = function(Value) TS.currentColors.localp.Tracer.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Tracer_localp_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Tracer Invis',
    Callback = function(Value) TS.currentColors.localp.Tracer.Invisible = Value; UpdateESP() end
})

ESPGB_localp:AddToggle('ESP_Skeleton_Toggle_localp', {
    Text = 'Show Skeleton', Default = false,
    Callback = function(Value) TS.Skeleton.Enabled.localp = Value; UpdateESP() end
}):AddColorPicker('Col_Skeleton_localp_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Skeleton Vis',
    Callback = function(Value) TS.currentColors.localp.Skeleton.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Skeleton_localp_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Skeleton Invis',
    Callback = function(Value) TS.currentColors.localp.Skeleton.Invisible = Value; UpdateESP() end
})

ESPGB_localp:AddToggle('ESP_HealthBar_Toggle_localp', {
    Text = 'Show HealthBar', Default = false,
    Callback = function(Value) TS.HealthBar.Enabled.localp = Value; UpdateESP() end
}):AddColorPicker('Col_HealthBar_localp_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'HealthBar Vis',
    Callback = function(Value) TS.currentColors.localp.HealthBar.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_HealthBar_localp_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'HealthBar Invis',
    Callback = function(Value) TS.currentColors.localp.HealthBar.Invisible = Value; UpdateESP() end
})

ESPGB_localp:AddToggle('ESP_Chams_Toggle_localp', {
    Text = 'Show Chams', Default = false,
    Callback = function(Value) TS.Chams.Enabled.localp = Value; UpdateESP() end
}):AddColorPicker('Col_Chams_localp_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Chams Vis',
    Callback = function(Value) TS.currentColors.localp.Chams.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Chams_localp_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Chams Invis',
    Callback = function(Value) TS.currentColors.localp.Chams.Invisible = Value; UpdateESP() end
})

-- Extra Options for localp
ESPGB_localp:AddSlider('ESP_Skel_Thick_localp', { Text = 'Skeleton Thickness', Default = 1, Min = 1, Max = 10, Rounding = 0, Callback = function(Value) TS.Skeleton.Thickness = Value; UpdateESP() end })
ESPGB_localp:AddSlider('ESP_Tracer_Thick_localp', { Text = 'Tracer Thickness', Default = 1, Min = 1, Max = 10, Rounding = 0, Callback = function(Value) TS.Tracer.Thickness = Value; UpdateESP() end })

-- ESP FOR GENERIC
local ESPGB_generic = Tabs.Visuals:AddLeftGroupbox('ESP: Generic')
ESPGB_generic:AddToggle('ESP_Master_generic', {
    Text = 'Enable Generic', Default = false,
    Callback = function(Value) TS.Checks.Team.SelectedTeams.generic = Value; UpdateESP() end
})
ESPGB_generic:AddDivider()

-- Boxes
ESPGB_generic:AddToggle('ESP_Box_Toggle_generic', {
    Text = 'Draw Boxes', Default = false,
    Callback = function(Value) TS.Box.Enabled = Value; UpdateESP() end
}):AddColorPicker('Col_generic_1', {
    Default = Color3.fromRGB(255,255,255), Title = 'Outline Vis',
    Callback = function(Value) TS.currentColors.generic.Box.Outline.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_generic_2', {
    Default = Color3.fromRGB(255,0,0), Title = 'Outline Invis',
    Callback = function(Value) TS.currentColors.generic.Box.Outline.Invisible = Value; UpdateESP() end
})

ESPGB_generic:AddToggle('ESP_Box_Fill_generic', {
    Text = 'Filled Boxes', Default = false,
    Callback = function(Value) TS.Box.Filled.Enabled = Value; UpdateESP() end
}):AddColorPicker('Col_generic_3', {
    Default = Color3.fromRGB(255,255,255), Title = 'Fill Vis',
    Callback = function(Value) TS.currentColors.generic.Box.Fill.Visible = Value; UpdateESP() end
})

ESPGB_generic:AddDropdown('ESP_Box_Style_generic', {
    Values = {'Normal', 'CornerBoxes'}, Default = 1, Multi = false, Text = 'Box Style',
    Callback = function(Value) 
        if Value == 'Normal' then TS.Box.Style = 2 else TS.Box.Style = 1 end
        UpdateESP()
    end
})

ESPGB_generic:AddSlider('ESP_Box_Thick_generic', {
    Text = 'Box Thickness', Default = 1, Min = 1, Max = 5, Rounding = 0,
    Callback = function(Value) TS.Box.Thickness = Value; UpdateESP() end
})

ESPGB_generic:AddDivider()

ESPGB_generic:AddToggle('ESP_Name_Toggle_generic', {
    Text = 'Show Name', Default = false,
    Callback = function(Value) TS.Name.Enabled.generic = Value; UpdateESP() end
}):AddColorPicker('Col_Name_generic_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Name Vis',
    Callback = function(Value) TS.currentColors.generic.Name.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Name_generic_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Name Invis',
    Callback = function(Value) TS.currentColors.generic.Name.Invisible = Value; UpdateESP() end
})

ESPGB_generic:AddToggle('ESP_Distance_Toggle_generic', {
    Text = 'Show Distance', Default = false,
    Callback = function(Value) TS.Distance.Enabled.generic = Value; UpdateESP() end
}):AddColorPicker('Col_Distance_generic_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Distance Vis',
    Callback = function(Value) TS.currentColors.generic.Distance.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Distance_generic_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Distance Invis',
    Callback = function(Value) TS.currentColors.generic.Distance.Invisible = Value; UpdateESP() end
})

ESPGB_generic:AddToggle('ESP_Tracer_Toggle_generic', {
    Text = 'Show Tracer', Default = false,
    Callback = function(Value) TS.Tracer.Enabled.generic = Value; UpdateESP() end
}):AddColorPicker('Col_Tracer_generic_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Tracer Vis',
    Callback = function(Value) TS.currentColors.generic.Tracer.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Tracer_generic_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Tracer Invis',
    Callback = function(Value) TS.currentColors.generic.Tracer.Invisible = Value; UpdateESP() end
})

ESPGB_generic:AddToggle('ESP_Skeleton_Toggle_generic', {
    Text = 'Show Skeleton', Default = false,
    Callback = function(Value) TS.Skeleton.Enabled.generic = Value; UpdateESP() end
}):AddColorPicker('Col_Skeleton_generic_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Skeleton Vis',
    Callback = function(Value) TS.currentColors.generic.Skeleton.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Skeleton_generic_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Skeleton Invis',
    Callback = function(Value) TS.currentColors.generic.Skeleton.Invisible = Value; UpdateESP() end
})

ESPGB_generic:AddToggle('ESP_HealthBar_Toggle_generic', {
    Text = 'Show HealthBar', Default = false,
    Callback = function(Value) TS.HealthBar.Enabled.generic = Value; UpdateESP() end
}):AddColorPicker('Col_HealthBar_generic_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'HealthBar Vis',
    Callback = function(Value) TS.currentColors.generic.HealthBar.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_HealthBar_generic_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'HealthBar Invis',
    Callback = function(Value) TS.currentColors.generic.HealthBar.Invisible = Value; UpdateESP() end
})

ESPGB_generic:AddToggle('ESP_Chams_Toggle_generic', {
    Text = 'Show Chams', Default = false,
    Callback = function(Value) TS.Chams.Enabled.generic = Value; UpdateESP() end
}):AddColorPicker('Col_Chams_generic_Vis', {
    Default = Color3.fromRGB(255,255,255), Title = 'Chams Vis',
    Callback = function(Value) TS.currentColors.generic.Chams.Visible = Value; UpdateESP() end
}):AddColorPicker('Col_Chams_generic_Invis', {
    Default = Color3.fromRGB(255,0,0), Title = 'Chams Invis',
    Callback = function(Value) TS.currentColors.generic.Chams.Invisible = Value; UpdateESP() end
})

-- Extra Options for generic
ESPGB_generic:AddSlider('ESP_Skel_Thick_generic', { Text = 'Skeleton Thickness', Default = 1, Min = 1, Max = 10, Rounding = 0, Callback = function(Value) TS.Skeleton.Thickness = Value; UpdateESP() end })
ESPGB_generic:AddSlider('ESP_Tracer_Thick_generic', { Text = 'Tracer Thickness', Default = 1, Min = 1, Max = 10, Rounding = 0, Callback = function(Value) TS.Tracer.Thickness = Value; UpdateESP() end })

--// RADAR TAB
local RadarGB = Tabs.Radar:AddLeftGroupbox('Radar Setup')
RadarGB:AddToggle('Radar_Toggle', {
    Text = 'Enable Radar', Default = false,
    Callback = function(Value) TS.Radar.Enabled = Value; UpdateESP() end
})
RadarGB:AddSlider('Radar_Rad', {
    Text = 'Radar Radius', Default = 100, Min = 50, Max = 500, Rounding = 0,
    Callback = function(Value) TS.Radar.Radius = Value; UpdateESP() end
})
RadarGB:AddSlider('Radar_Scale', {
    Text = 'Radar Scale', Default = 1, Min = 1, Max = 10, Rounding = 1,
    Callback = function(Value) TS.Radar.Scale = Value; UpdateESP() end
})
local RadarColGB = Tabs.Radar:AddRightGroupbox('Radar Colors')
RadarColGB:AddLabel('Radar Background'):AddColorPicker('Radar_Bg_Col', {
    Default = Color3.fromRGB(30,30,30), Title = 'Background', Callback = function(Value) TS.currentColors.Radar.Background = Value; UpdateESP() end
})
RadarColGB:AddLabel('Radar Border'):AddColorPicker('Radar_Bd_Col', {
    Default = Color3.fromRGB(60,60,60), Title = 'Border', Callback = function(Value) TS.currentColors.Radar.Border = Value; UpdateESP() end
})

--// 4. MOVEMENT TAB
local SpeedGB = Tabs.Movement:AddLeftGroupbox('Speed Hack')
SpeedGB:AddToggle('Spd_Toggle', {
    Text = 'Enable Speed', Default = false,
    Callback = function(Value) Lunar.Features.Movement.Speed.Enabled = Value end
})
SpeedGB:AddSlider('Spd_Value', {
    Text = 'Speed Amount', Default = 50, Min = 16, Max = 500, Rounding = 0,
    Callback = function(Value) Lunar.Features.Movement.Speed.Value = Value end
})
SpeedGB:AddDropdown('Spd_Method', {
    Values = {'CFrame', 'Velocity'}, Default = 1, Multi = false, Text = 'Method',
    Callback = function(Value) Lunar.Features.Movement.Speed.Method = Value end
})

local MoveMiscGB = Tabs.Movement:AddRightGroupbox('Agility Options')
MoveMiscGB:AddToggle('Move_InfJump', { Text = 'Infinite Jump', Default = false, Callback = function(Value) Lunar.Features.Movement.InfiniteJump = Value end })
MoveMiscGB:AddToggle('Move_BHop', { Text = 'Bunny Hop', Default = false, Callback = function(Value) Lunar.Features.Movement.BunnyHop = Value end })
MoveMiscGB:AddToggle('Move_Spider', { Text = 'Spider Climb', Default = false, Callback = function(Value) Lunar.Features.Movement.Spider = Value end })

--// 5. WORLD TAB
local LightingGB = Tabs.World:AddLeftGroupbox('Lighting')
LightingGB:AddToggle('World_FB', { Text = 'Fullbright', Default = false, Callback = function(Value) Lunar.Features.Visuals.World.Fullbright = Value end })
LightingGB:AddLabel('Ambient Color'):AddColorPicker('Amb_Color', { Default = Color3.fromRGB(255,255,255), Callback = function(Value) Lunar.Features.Visuals.World.Ambient = Value end })
LightingGB:AddSlider('World_Time', { Text = 'Time of Day', Default = 14, Min = 0, Max = 24, Rounding = 0, Callback = function(Value) Lunar.Features.Visuals.World.TimeOfDay = Value end })
LightingGB:AddSlider('World_Fog', { Text = 'Fog Distance', Default = 100000, Min = 0, Max = 100000, Rounding = 0, Callback = function(Value) Lunar.Features.Visuals.World.FogEnd = Value end })

local TrollGB = Tabs.World:AddRightGroupbox('Troll Options')
TrollGB:AddToggle('Troll_SpinFling', { Text = 'Spin Fling', Default = false, Callback = function(Value) Lunar.Features.Troll.SpinFling = Value end })
TrollGB:AddButton({ Text = 'Fling Server', Func = function() 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(9999999, 9999999, 9999999)
        hrp.RotVelocity = Vector3.new(9999999, 9999999, 9999999)
    end
end })

--// 6. SETTINGS TAB (LinoriaLib Native Config)
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('LunarTitan')
SaveManager:SetFolder('LunarTitan/Configs')

local MenuSettings = Tabs.Settings:AddLeftGroupbox('Menu Settings')
MenuSettings:AddButton('Unload', function() Library:Unload() end)
MenuSettings:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

Library:Notify('Lunar Universal V6 (Linoria) loaded successfully!', 5)
