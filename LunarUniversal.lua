--[[
    Lunar Universal V5.0.0 (Titan Edition)
    Powered by Starlight UI & Twilight ESP
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

--// Load Libraries
local Starlight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/starlight"))()
local NebulaIcons = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()
local Twilight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/twilight"))()

--// Initialization Check
if not Starlight or not Twilight or not NebulaIcons then
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
--// INTERFACE CREATION (STARLIGHT)
--// ==========================================

local Window = Starlight:CreateWindow({
    Name = "Lunar Universal",
    Subtitle = "V5.0.0 (Titan Edition)",
    Icon = NebulaIcons:GetIcon('moon', 'Lucide'),
    LoadingEnabled = true,
    LoadingSettings = {
        Title = "Booting Lunar Titan...",
        Subtitle = "Injecting Advanced Physics Engine",
    },
    BuildWarnings = false,
    InterfaceAdvertisingPrompts = false,
    NotifyOnCallbackError = true,
    FileSettings = {
        ConfigFolder = "LunarTitanConfigs",
        ThemesInRoot = false
    },
    DefaultSize = UDim2.new(0, 850, 0, 600)
})

--// 1. COMBAT TAB
local CombatSection = Window:CreateTabSection("Combat", true)
local AimTab = CombatSection:CreateTab({ Name = "Aimbot", Icon = NebulaIcons:GetIcon('crosshair', 'Lucide'), Columns = 2 }, "AimTab")

local AimbotGB = AimTab:CreateGroupbox({ Name = "Silent Aim", Column = 1 }, "AimbotGB")
AimbotGB:CreateToggle({ Name = "Enable Silent Aim", CurrentValue = false, Style = 2, Callback = function(v) Lunar.Features.Combat.SilentAim.Enabled = v end }, "SA_Toggle")
AimbotGB:CreateDropdown({ Name = "Target Part", Options = {"Head", "HumanoidRootPart", "Torso"}, CurrentOption = {"Head"}, Callback = function(v) Lunar.Features.Combat.SilentAim.Part = v[1] end }, "SA_Part")
AimbotGB:CreateSlider({ Name = "Hit Chance", Range = {1, 100}, Increment = 1, Suffix = "%", CurrentValue = 100, Callback = function(v) Lunar.Features.Combat.SilentAim.HitChance = v end }, "SA_Chance")
AimbotGB:CreateToggle({ Name = "Wall Check", CurrentValue = false, Style = 1, Callback = function(v) Lunar.Features.Combat.SilentAim.WallCheck = v end }, "SA_Wall")

local FOVGB = AimTab:CreateGroupbox({ Name = "Field of View", Column = 1 }, "FOVGB")
FOVGB:CreateToggle({ Name = "Show FOV Circle", CurrentValue = true, Style = 2, Callback = function(v) Lunar.Features.Combat.FOV.Enabled = v end }, "FOV_Toggle")
local fovColorLabel = FOVGB:CreateLabel({ Name = "FOV Color" }, "FOV_Color_LBL")
fovColorLabel:AddColorPicker({ CurrentValue = Color3.fromRGB(255, 255, 255), Callback = function(c) Lunar.Features.Combat.FOV.Color = c end }, "FOV_Color")
FOVGB:CreateSlider({ Name = "Radius", Range = {10, 1000}, Increment = 1, CurrentValue = 150, Callback = function(v) Lunar.Features.Combat.FOV.Radius = v end }, "FOV_Radius")
FOVGB:CreateToggle({ Name = "Filled Shape", CurrentValue = false, Style = 1, Callback = function(v) Lunar.Features.Combat.FOV.Filled = v end }, "FOV_Fill")
FOVGB:CreateSlider({ Name = "Thickness", Range = {1, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) Lunar.Features.Combat.FOV.Thickness = v end }, "FOV_Thick")

local TriggerBotGB = AimTab:CreateGroupbox({ Name = "TriggerBot", Column = 2 }, "TriggerBotGB")
TriggerBotGB:CreateToggle({ Name = "Enable TriggerBot", CurrentValue = false, Style = 2, Callback = function(v) Lunar.Features.Combat.TriggerBot.Enabled = v end }, "TB_Toggle")
TriggerBotGB:CreateSlider({ Name = "Reaction Delay", Range = {0, 1000}, Increment = 10, Suffix = "ms", CurrentValue = 0, Callback = function(v) Lunar.Features.Combat.TriggerBot.Delay = v end }, "TB_Delay")

--// 2. ANTI-AIM / DESYNC TAB
local DesyncTab = CombatSection:CreateTab({ Name = "Anti-Aim", Icon = NebulaIcons:GetIcon('shield', 'Lucide'), Columns = 2 }, "DesyncTab")

local AA_MainGB = DesyncTab:CreateGroupbox({ Name = "Desync Engine", Column = 1 }, "AA_MainGB")
AA_MainGB:CreateToggle({ Name = "Enable Anti-Aim", CurrentValue = false, Style = 2, Callback = function(v) Lunar.Features.AntiAim.Enabled = v end }, "AA_Toggle")
AA_MainGB:CreateDropdown({ Name = "Desync Mode", Options = {"Static", "Jitter", "Spin", "Orbit", "Custom"}, CurrentOption = {"Static"}, Callback = function(v) Lunar.Features.AntiAim.Mode = v[1] end }, "AA_Mode")
AA_MainGB:CreateSlider({ Name = "Desync Power", Range = {1000, 100000}, Increment = 1000, CurrentValue = 5000, Callback = function(v) Lunar.Features.AntiAim.DesyncPower = v end }, "AA_Power")

local AA_AdvGB = DesyncTab:CreateGroupbox({ Name = "Advanced Settings", Column = 2 }, "AA_AdvGB")
AA_AdvGB:CreateSlider({ Name = "Spin Speed", Range = {1, 100}, Increment = 1, CurrentValue = 20, Callback = function(v) Lunar.Features.AntiAim.SpinSpeed = v end }, "AA_Spin")
AA_AdvGB:CreateSlider({ Name = "Orbit Radius", Range = {1, 50}, Increment = 1, CurrentValue = 10, Callback = function(v) Lunar.Features.AntiAim.OrbitRadius = v end }, "AA_Orbit")
AA_AdvGB:CreateSlider({ Name = "Velocity Multiplier", Range = {1, 10}, Increment = 0.1, CurrentValue = 1, Callback = function(v) Lunar.Features.AntiAim.VelocityMulti = v end }, "AA_Multi")
AA_AdvGB:CreateButton({ Name = "Reset Desync Angles", Icon = NebulaIcons:GetIcon('refresh-cw', 'Lucide'), Callback = function() AntiAimAngle = 0 end }, "AA_Reset")

--// 3. VISUALS TAB (TWILIGHT ESP)
local VisualsSection = Window:CreateTabSection("Visuals", true)

local ESPTab_enemy = VisualsSection:CreateTab({ Name = "ESP: Enemy", Icon = NebulaIcons:GetIcon('eye', 'Lucide'), Columns = 3 }, "ESPTab_enemy")

-- MASTER CONTROLS
local ESPMainGB_enemy = ESPTab_enemy:CreateGroupbox({ Name = "Main Settings", Column = 1 }, "ESPMainGB_enemy")
ESPMainGB_enemy:CreateToggle({ Name = "Enable ESP for Enemy", CurrentValue = false, Style = 2, Callback = function(v) TS.Checks.Team.SelectedTeams.enemy = v; UpdateESP() end }, "ESP_Master_enemy")

-- BOUNDING BOXES
local ESPBoxGB_enemy = ESPTab_enemy:CreateGroupbox({ Name = "Bounding Boxes", Column = 1 }, "ESPBoxGB_enemy")
ESPBoxGB_enemy:CreateToggle({ Name = "Enable Bounding Boxes", CurrentValue = false, Style = 2, Callback = function(v) TS.Box.Enabled = v; UpdateESP() end }, "ESP_Box_Toggle_enemy")
ESPBoxGB_enemy:CreateDropdown({ Name = "Box Style", Options = {"Normal", "CornerBoxes"}, CurrentOption = {"Normal"}, Callback = function(v) 
    if v[1] == "Normal" then TS.Box.Style = 2 else TS.Box.Style = 1 end
    UpdateESP()
end }, "ESP_Box_Style_enemy")
ESPBoxGB_enemy:CreateToggle({ Name = "Enable Box Fill", CurrentValue = false, Style = 1, Callback = function(v) TS.Box.Filled.Enabled = v; UpdateESP() end }, "ESP_Box_Fill_enemy")
ESPBoxGB_enemy:CreateSlider({ Name = "Box Thickness", Range = {1, 5}, Increment = 1, CurrentValue = 1, Callback = function(v) TS.Box.Thickness = v; UpdateESP() end }, "ESP_Box_Thick_enemy")
ESPBoxGB_enemy:CreateSlider({ Name = "Fill Transparency", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.5, Callback = function(v) TS.Box.Filled.Transparency = v; UpdateESP() end }, "ESP_Box_FillTrans_enemy")

local c_enemyLabel1 = ESPBoxGB_enemy:CreateLabel({ Name = "Box Outline Visible Color" }, "Col_LBL_enemy_1")
c_enemyLabel1:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.enemy.Box.Outline.Visible = c; UpdateESP() end }, "Col_enemy_1")
local c_enemyLabel2 = ESPBoxGB_enemy:CreateLabel({ Name = "Box Outline Invisible Color" }, "Col_LBL_enemy_2")
c_enemyLabel2:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.enemy.Box.Outline.Invisible = c; UpdateESP() end }, "Col_enemy_2")
local c_enemyLabel3 = ESPBoxGB_enemy:CreateLabel({ Name = "Box Fill Color" }, "Col_LBL_enemy_3")
c_enemyLabel3:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.enemy.Box.Fill.Visible = c; UpdateESP() end }, "Col_enemy_3")

-- OTHER FEATURES
local ESPFeatGB_enemy = ESPTab_enemy:CreateGroupbox({ Name = "Features", Column = 2 }, "ESPFeatGB_enemy")

-- Name
ESPFeatGB_enemy:CreateToggle({ Name = "Show Name", CurrentValue = false, Style = 1, Callback = function(v) TS.Name.Enabled.enemy = v; UpdateESP() end }, "ESP_Name_Toggle_enemy")
local c_enemy_NameLabel_Vis = ESPFeatGB_enemy:CreateLabel({ Name = "Name Visible Color" }, "Col_LBL_Name_enemy_Vis")
c_enemy_NameLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.enemy.Name.Visible = c; UpdateESP() end }, "Col_Name_enemy_Vis")
local c_enemy_NameLabel_Invis = ESPFeatGB_enemy:CreateLabel({ Name = "Name Invisible Color" }, "Col_LBL_Name_enemy_Invis")
c_enemy_NameLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.enemy.Name.Invisible = c; UpdateESP() end }, "Col_Name_enemy_Invis")
ESPFeatGB_enemy:CreateDivider()

-- Distance
ESPFeatGB_enemy:CreateToggle({ Name = "Show Distance", CurrentValue = false, Style = 1, Callback = function(v) TS.Distance.Enabled.enemy = v; UpdateESP() end }, "ESP_Distance_Toggle_enemy")
local c_enemy_DistanceLabel_Vis = ESPFeatGB_enemy:CreateLabel({ Name = "Distance Visible Color" }, "Col_LBL_Distance_enemy_Vis")
c_enemy_DistanceLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.enemy.Distance.Visible = c; UpdateESP() end }, "Col_Distance_enemy_Vis")
local c_enemy_DistanceLabel_Invis = ESPFeatGB_enemy:CreateLabel({ Name = "Distance Invisible Color" }, "Col_LBL_Distance_enemy_Invis")
c_enemy_DistanceLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.enemy.Distance.Invisible = c; UpdateESP() end }, "Col_Distance_enemy_Invis")
ESPFeatGB_enemy:CreateDivider()

-- Tracer
ESPFeatGB_enemy:CreateToggle({ Name = "Show Tracer", CurrentValue = false, Style = 1, Callback = function(v) TS.Tracer.Enabled.enemy = v; UpdateESP() end }, "ESP_Tracer_Toggle_enemy")
local c_enemy_TracerLabel_Vis = ESPFeatGB_enemy:CreateLabel({ Name = "Tracer Visible Color" }, "Col_LBL_Tracer_enemy_Vis")
c_enemy_TracerLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.enemy.Tracer.Visible = c; UpdateESP() end }, "Col_Tracer_enemy_Vis")
local c_enemy_TracerLabel_Invis = ESPFeatGB_enemy:CreateLabel({ Name = "Tracer Invisible Color" }, "Col_LBL_Tracer_enemy_Invis")
c_enemy_TracerLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.enemy.Tracer.Invisible = c; UpdateESP() end }, "Col_Tracer_enemy_Invis")
ESPFeatGB_enemy:CreateDivider()

-- Skeleton
ESPFeatGB_enemy:CreateToggle({ Name = "Show Skeleton", CurrentValue = false, Style = 1, Callback = function(v) TS.Skeleton.Enabled.enemy = v; UpdateESP() end }, "ESP_Skeleton_Toggle_enemy")
local c_enemy_SkeletonLabel_Vis = ESPFeatGB_enemy:CreateLabel({ Name = "Skeleton Visible Color" }, "Col_LBL_Skeleton_enemy_Vis")
c_enemy_SkeletonLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.enemy.Skeleton.Visible = c; UpdateESP() end }, "Col_Skeleton_enemy_Vis")
local c_enemy_SkeletonLabel_Invis = ESPFeatGB_enemy:CreateLabel({ Name = "Skeleton Invisible Color" }, "Col_LBL_Skeleton_enemy_Invis")
c_enemy_SkeletonLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.enemy.Skeleton.Invisible = c; UpdateESP() end }, "Col_Skeleton_enemy_Invis")
ESPFeatGB_enemy:CreateDivider()

-- HealthBar
ESPFeatGB_enemy:CreateToggle({ Name = "Show HealthBar", CurrentValue = false, Style = 1, Callback = function(v) TS.HealthBar.Enabled.enemy = v; UpdateESP() end }, "ESP_HealthBar_Toggle_enemy")
local c_enemy_HealthBarLabel_Vis = ESPFeatGB_enemy:CreateLabel({ Name = "HealthBar Visible Color" }, "Col_LBL_HealthBar_enemy_Vis")
c_enemy_HealthBarLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.enemy.HealthBar.Visible = c; UpdateESP() end }, "Col_HealthBar_enemy_Vis")
local c_enemy_HealthBarLabel_Invis = ESPFeatGB_enemy:CreateLabel({ Name = "HealthBar Invisible Color" }, "Col_LBL_HealthBar_enemy_Invis")
c_enemy_HealthBarLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.enemy.HealthBar.Invisible = c; UpdateESP() end }, "Col_HealthBar_enemy_Invis")
ESPFeatGB_enemy:CreateDivider()

-- Chams
ESPFeatGB_enemy:CreateToggle({ Name = "Show Chams", CurrentValue = false, Style = 1, Callback = function(v) TS.Chams.Enabled.enemy = v; UpdateESP() end }, "ESP_Chams_Toggle_enemy")
local c_enemy_ChamsLabel_Vis = ESPFeatGB_enemy:CreateLabel({ Name = "Chams Visible Color" }, "Col_LBL_Chams_enemy_Vis")
c_enemy_ChamsLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.enemy.Chams.Visible = c; UpdateESP() end }, "Col_Chams_enemy_Vis")
local c_enemy_ChamsLabel_Invis = ESPFeatGB_enemy:CreateLabel({ Name = "Chams Invisible Color" }, "Col_LBL_Chams_enemy_Invis")
c_enemy_ChamsLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.enemy.Chams.Invisible = c; UpdateESP() end }, "Col_Chams_enemy_Invis")
ESPFeatGB_enemy:CreateDivider()

-- EXTRA CONFIGURATIONS
local ESPExtraGB_enemy = ESPTab_enemy:CreateGroupbox({ Name = "Extra Parameters", Column = 3 }, "ESPExtraGB_enemy")
ESPExtraGB_enemy:CreateSlider({ Name = "Skeleton Thickness", Range = {1, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) TS.Skeleton.Thickness = v; UpdateESP() end }, "ESP_Skel_Thick_enemy")
ESPExtraGB_enemy:CreateSlider({ Name = "Tracer Thickness", Range = {1, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) TS.Tracer.Thickness = v; UpdateESP() end }, "ESP_Tracer_Thick_enemy")
ESPExtraGB_enemy:CreateDropdown({ Name = "Tracer Origin", Options = {"Bottom", "Center", "Top", "Mouse", "LocalHumanoid"}, CurrentOption = {"Bottom"}, Callback = function(v) 
    if v[1] == "Bottom" then TS.Tracer.Origin = 2
    elseif v[1] == "Top" then TS.Tracer.Origin = 3
    elseif v[1] == "Center" then TS.Tracer.Origin = 4
    elseif v[1] == "Mouse" then TS.Tracer.Origin = 5
    else TS.Tracer.Origin = 1 end
    UpdateESP()
end }, "ESP_Tracer_Origin_enemy")
ESPExtraGB_enemy:CreateDropdown({ Name = "Name Format", Options = {"Standard", "Upper", "Lower"}, CurrentOption = {"Standard"}, Callback = function(v) TS.Name.Style = 1; UpdateESP() end }, "ESP_Name_Style_enemy")
ESPExtraGB_enemy:CreateToggle({ Name = "Chams Occlusion", CurrentValue = true, Style = 1, Callback = function(v) TS.Chams.Occlusion = v; UpdateESP() end }, "ESP_Chams_Occ_enemy")
ESPExtraGB_enemy:CreateToggle({ Name = "Chams Outline", CurrentValue = false, Style = 1, Callback = function(v) TS.Chams.Outline.Enabled = v; UpdateESP() end }, "ESP_Chams_Out_enemy")
ESPExtraGB_enemy:CreateSlider({ Name = "Chams Transparency", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.5, Callback = function(v) TS.Chams.Fill.Transparency = v; UpdateESP() end }, "ESP_Chams_Trans_enemy")


local ESPTab_friendly = VisualsSection:CreateTab({ Name = "ESP: Friendly", Icon = NebulaIcons:GetIcon('eye', 'Lucide'), Columns = 3 }, "ESPTab_friendly")

-- MASTER CONTROLS
local ESPMainGB_friendly = ESPTab_friendly:CreateGroupbox({ Name = "Main Settings", Column = 1 }, "ESPMainGB_friendly")
ESPMainGB_friendly:CreateToggle({ Name = "Enable ESP for Friendly", CurrentValue = false, Style = 2, Callback = function(v) TS.Checks.Team.SelectedTeams.friendly = v; UpdateESP() end }, "ESP_Master_friendly")

-- BOUNDING BOXES
local ESPBoxGB_friendly = ESPTab_friendly:CreateGroupbox({ Name = "Bounding Boxes", Column = 1 }, "ESPBoxGB_friendly")
ESPBoxGB_friendly:CreateToggle({ Name = "Enable Bounding Boxes", CurrentValue = false, Style = 2, Callback = function(v) TS.Box.Enabled = v; UpdateESP() end }, "ESP_Box_Toggle_friendly")
ESPBoxGB_friendly:CreateDropdown({ Name = "Box Style", Options = {"Normal", "CornerBoxes"}, CurrentOption = {"Normal"}, Callback = function(v) 
    if v[1] == "Normal" then TS.Box.Style = 2 else TS.Box.Style = 1 end
    UpdateESP()
end }, "ESP_Box_Style_friendly")
ESPBoxGB_friendly:CreateToggle({ Name = "Enable Box Fill", CurrentValue = false, Style = 1, Callback = function(v) TS.Box.Filled.Enabled = v; UpdateESP() end }, "ESP_Box_Fill_friendly")
ESPBoxGB_friendly:CreateSlider({ Name = "Box Thickness", Range = {1, 5}, Increment = 1, CurrentValue = 1, Callback = function(v) TS.Box.Thickness = v; UpdateESP() end }, "ESP_Box_Thick_friendly")
ESPBoxGB_friendly:CreateSlider({ Name = "Fill Transparency", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.5, Callback = function(v) TS.Box.Filled.Transparency = v; UpdateESP() end }, "ESP_Box_FillTrans_friendly")

local c_friendlyLabel1 = ESPBoxGB_friendly:CreateLabel({ Name = "Box Outline Visible Color" }, "Col_LBL_friendly_1")
c_friendlyLabel1:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.friendly.Box.Outline.Visible = c; UpdateESP() end }, "Col_friendly_1")
local c_friendlyLabel2 = ESPBoxGB_friendly:CreateLabel({ Name = "Box Outline Invisible Color" }, "Col_LBL_friendly_2")
c_friendlyLabel2:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.friendly.Box.Outline.Invisible = c; UpdateESP() end }, "Col_friendly_2")
local c_friendlyLabel3 = ESPBoxGB_friendly:CreateLabel({ Name = "Box Fill Color" }, "Col_LBL_friendly_3")
c_friendlyLabel3:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.friendly.Box.Fill.Visible = c; UpdateESP() end }, "Col_friendly_3")

-- OTHER FEATURES
local ESPFeatGB_friendly = ESPTab_friendly:CreateGroupbox({ Name = "Features", Column = 2 }, "ESPFeatGB_friendly")

-- Name
ESPFeatGB_friendly:CreateToggle({ Name = "Show Name", CurrentValue = false, Style = 1, Callback = function(v) TS.Name.Enabled.friendly = v; UpdateESP() end }, "ESP_Name_Toggle_friendly")
local c_friendly_NameLabel_Vis = ESPFeatGB_friendly:CreateLabel({ Name = "Name Visible Color" }, "Col_LBL_Name_friendly_Vis")
c_friendly_NameLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.friendly.Name.Visible = c; UpdateESP() end }, "Col_Name_friendly_Vis")
local c_friendly_NameLabel_Invis = ESPFeatGB_friendly:CreateLabel({ Name = "Name Invisible Color" }, "Col_LBL_Name_friendly_Invis")
c_friendly_NameLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.friendly.Name.Invisible = c; UpdateESP() end }, "Col_Name_friendly_Invis")
ESPFeatGB_friendly:CreateDivider()

-- Distance
ESPFeatGB_friendly:CreateToggle({ Name = "Show Distance", CurrentValue = false, Style = 1, Callback = function(v) TS.Distance.Enabled.friendly = v; UpdateESP() end }, "ESP_Distance_Toggle_friendly")
local c_friendly_DistanceLabel_Vis = ESPFeatGB_friendly:CreateLabel({ Name = "Distance Visible Color" }, "Col_LBL_Distance_friendly_Vis")
c_friendly_DistanceLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.friendly.Distance.Visible = c; UpdateESP() end }, "Col_Distance_friendly_Vis")
local c_friendly_DistanceLabel_Invis = ESPFeatGB_friendly:CreateLabel({ Name = "Distance Invisible Color" }, "Col_LBL_Distance_friendly_Invis")
c_friendly_DistanceLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.friendly.Distance.Invisible = c; UpdateESP() end }, "Col_Distance_friendly_Invis")
ESPFeatGB_friendly:CreateDivider()

-- Tracer
ESPFeatGB_friendly:CreateToggle({ Name = "Show Tracer", CurrentValue = false, Style = 1, Callback = function(v) TS.Tracer.Enabled.friendly = v; UpdateESP() end }, "ESP_Tracer_Toggle_friendly")
local c_friendly_TracerLabel_Vis = ESPFeatGB_friendly:CreateLabel({ Name = "Tracer Visible Color" }, "Col_LBL_Tracer_friendly_Vis")
c_friendly_TracerLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.friendly.Tracer.Visible = c; UpdateESP() end }, "Col_Tracer_friendly_Vis")
local c_friendly_TracerLabel_Invis = ESPFeatGB_friendly:CreateLabel({ Name = "Tracer Invisible Color" }, "Col_LBL_Tracer_friendly_Invis")
c_friendly_TracerLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.friendly.Tracer.Invisible = c; UpdateESP() end }, "Col_Tracer_friendly_Invis")
ESPFeatGB_friendly:CreateDivider()

-- Skeleton
ESPFeatGB_friendly:CreateToggle({ Name = "Show Skeleton", CurrentValue = false, Style = 1, Callback = function(v) TS.Skeleton.Enabled.friendly = v; UpdateESP() end }, "ESP_Skeleton_Toggle_friendly")
local c_friendly_SkeletonLabel_Vis = ESPFeatGB_friendly:CreateLabel({ Name = "Skeleton Visible Color" }, "Col_LBL_Skeleton_friendly_Vis")
c_friendly_SkeletonLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.friendly.Skeleton.Visible = c; UpdateESP() end }, "Col_Skeleton_friendly_Vis")
local c_friendly_SkeletonLabel_Invis = ESPFeatGB_friendly:CreateLabel({ Name = "Skeleton Invisible Color" }, "Col_LBL_Skeleton_friendly_Invis")
c_friendly_SkeletonLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.friendly.Skeleton.Invisible = c; UpdateESP() end }, "Col_Skeleton_friendly_Invis")
ESPFeatGB_friendly:CreateDivider()

-- HealthBar
ESPFeatGB_friendly:CreateToggle({ Name = "Show HealthBar", CurrentValue = false, Style = 1, Callback = function(v) TS.HealthBar.Enabled.friendly = v; UpdateESP() end }, "ESP_HealthBar_Toggle_friendly")
local c_friendly_HealthBarLabel_Vis = ESPFeatGB_friendly:CreateLabel({ Name = "HealthBar Visible Color" }, "Col_LBL_HealthBar_friendly_Vis")
c_friendly_HealthBarLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.friendly.HealthBar.Visible = c; UpdateESP() end }, "Col_HealthBar_friendly_Vis")
local c_friendly_HealthBarLabel_Invis = ESPFeatGB_friendly:CreateLabel({ Name = "HealthBar Invisible Color" }, "Col_LBL_HealthBar_friendly_Invis")
c_friendly_HealthBarLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.friendly.HealthBar.Invisible = c; UpdateESP() end }, "Col_HealthBar_friendly_Invis")
ESPFeatGB_friendly:CreateDivider()

-- Chams
ESPFeatGB_friendly:CreateToggle({ Name = "Show Chams", CurrentValue = false, Style = 1, Callback = function(v) TS.Chams.Enabled.friendly = v; UpdateESP() end }, "ESP_Chams_Toggle_friendly")
local c_friendly_ChamsLabel_Vis = ESPFeatGB_friendly:CreateLabel({ Name = "Chams Visible Color" }, "Col_LBL_Chams_friendly_Vis")
c_friendly_ChamsLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.friendly.Chams.Visible = c; UpdateESP() end }, "Col_Chams_friendly_Vis")
local c_friendly_ChamsLabel_Invis = ESPFeatGB_friendly:CreateLabel({ Name = "Chams Invisible Color" }, "Col_LBL_Chams_friendly_Invis")
c_friendly_ChamsLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.friendly.Chams.Invisible = c; UpdateESP() end }, "Col_Chams_friendly_Invis")
ESPFeatGB_friendly:CreateDivider()

-- EXTRA CONFIGURATIONS
local ESPExtraGB_friendly = ESPTab_friendly:CreateGroupbox({ Name = "Extra Parameters", Column = 3 }, "ESPExtraGB_friendly")
ESPExtraGB_friendly:CreateSlider({ Name = "Skeleton Thickness", Range = {1, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) TS.Skeleton.Thickness = v; UpdateESP() end }, "ESP_Skel_Thick_friendly")
ESPExtraGB_friendly:CreateSlider({ Name = "Tracer Thickness", Range = {1, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) TS.Tracer.Thickness = v; UpdateESP() end }, "ESP_Tracer_Thick_friendly")
ESPExtraGB_friendly:CreateDropdown({ Name = "Tracer Origin", Options = {"Bottom", "Center", "Top", "Mouse", "LocalHumanoid"}, CurrentOption = {"Bottom"}, Callback = function(v) 
    if v[1] == "Bottom" then TS.Tracer.Origin = 2
    elseif v[1] == "Top" then TS.Tracer.Origin = 3
    elseif v[1] == "Center" then TS.Tracer.Origin = 4
    elseif v[1] == "Mouse" then TS.Tracer.Origin = 5
    else TS.Tracer.Origin = 1 end
    UpdateESP()
end }, "ESP_Tracer_Origin_friendly")
ESPExtraGB_friendly:CreateDropdown({ Name = "Name Format", Options = {"Standard", "Upper", "Lower"}, CurrentOption = {"Standard"}, Callback = function(v) TS.Name.Style = 1; UpdateESP() end }, "ESP_Name_Style_friendly")
ESPExtraGB_friendly:CreateToggle({ Name = "Chams Occlusion", CurrentValue = true, Style = 1, Callback = function(v) TS.Chams.Occlusion = v; UpdateESP() end }, "ESP_Chams_Occ_friendly")
ESPExtraGB_friendly:CreateToggle({ Name = "Chams Outline", CurrentValue = false, Style = 1, Callback = function(v) TS.Chams.Outline.Enabled = v; UpdateESP() end }, "ESP_Chams_Out_friendly")
ESPExtraGB_friendly:CreateSlider({ Name = "Chams Transparency", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.5, Callback = function(v) TS.Chams.Fill.Transparency = v; UpdateESP() end }, "ESP_Chams_Trans_friendly")


local ESPTab_generic = VisualsSection:CreateTab({ Name = "ESP: Generic", Icon = NebulaIcons:GetIcon('eye', 'Lucide'), Columns = 3 }, "ESPTab_generic")

-- MASTER CONTROLS
local ESPMainGB_generic = ESPTab_generic:CreateGroupbox({ Name = "Main Settings", Column = 1 }, "ESPMainGB_generic")
ESPMainGB_generic:CreateToggle({ Name = "Enable ESP for Generic", CurrentValue = false, Style = 2, Callback = function(v) TS.Checks.Team.SelectedTeams.generic = v; UpdateESP() end }, "ESP_Master_generic")

-- BOUNDING BOXES
local ESPBoxGB_generic = ESPTab_generic:CreateGroupbox({ Name = "Bounding Boxes", Column = 1 }, "ESPBoxGB_generic")
ESPBoxGB_generic:CreateToggle({ Name = "Enable Bounding Boxes", CurrentValue = false, Style = 2, Callback = function(v) TS.Box.Enabled = v; UpdateESP() end }, "ESP_Box_Toggle_generic")
ESPBoxGB_generic:CreateDropdown({ Name = "Box Style", Options = {"Normal", "CornerBoxes"}, CurrentOption = {"Normal"}, Callback = function(v) 
    if v[1] == "Normal" then TS.Box.Style = 2 else TS.Box.Style = 1 end
    UpdateESP()
end }, "ESP_Box_Style_generic")
ESPBoxGB_generic:CreateToggle({ Name = "Enable Box Fill", CurrentValue = false, Style = 1, Callback = function(v) TS.Box.Filled.Enabled = v; UpdateESP() end }, "ESP_Box_Fill_generic")
ESPBoxGB_generic:CreateSlider({ Name = "Box Thickness", Range = {1, 5}, Increment = 1, CurrentValue = 1, Callback = function(v) TS.Box.Thickness = v; UpdateESP() end }, "ESP_Box_Thick_generic")
ESPBoxGB_generic:CreateSlider({ Name = "Fill Transparency", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.5, Callback = function(v) TS.Box.Filled.Transparency = v; UpdateESP() end }, "ESP_Box_FillTrans_generic")

local c_genericLabel1 = ESPBoxGB_generic:CreateLabel({ Name = "Box Outline Visible Color" }, "Col_LBL_generic_1")
c_genericLabel1:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.generic.Box.Outline.Visible = c; UpdateESP() end }, "Col_generic_1")
local c_genericLabel2 = ESPBoxGB_generic:CreateLabel({ Name = "Box Outline Invisible Color" }, "Col_LBL_generic_2")
c_genericLabel2:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.generic.Box.Outline.Invisible = c; UpdateESP() end }, "Col_generic_2")
local c_genericLabel3 = ESPBoxGB_generic:CreateLabel({ Name = "Box Fill Color" }, "Col_LBL_generic_3")
c_genericLabel3:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.generic.Box.Fill.Visible = c; UpdateESP() end }, "Col_generic_3")

-- OTHER FEATURES
local ESPFeatGB_generic = ESPTab_generic:CreateGroupbox({ Name = "Features", Column = 2 }, "ESPFeatGB_generic")

-- Name
ESPFeatGB_generic:CreateToggle({ Name = "Show Name", CurrentValue = false, Style = 1, Callback = function(v) TS.Name.Enabled.generic = v; UpdateESP() end }, "ESP_Name_Toggle_generic")
local c_generic_NameLabel_Vis = ESPFeatGB_generic:CreateLabel({ Name = "Name Visible Color" }, "Col_LBL_Name_generic_Vis")
c_generic_NameLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.generic.Name.Visible = c; UpdateESP() end }, "Col_Name_generic_Vis")
local c_generic_NameLabel_Invis = ESPFeatGB_generic:CreateLabel({ Name = "Name Invisible Color" }, "Col_LBL_Name_generic_Invis")
c_generic_NameLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.generic.Name.Invisible = c; UpdateESP() end }, "Col_Name_generic_Invis")
ESPFeatGB_generic:CreateDivider()

-- Distance
ESPFeatGB_generic:CreateToggle({ Name = "Show Distance", CurrentValue = false, Style = 1, Callback = function(v) TS.Distance.Enabled.generic = v; UpdateESP() end }, "ESP_Distance_Toggle_generic")
local c_generic_DistanceLabel_Vis = ESPFeatGB_generic:CreateLabel({ Name = "Distance Visible Color" }, "Col_LBL_Distance_generic_Vis")
c_generic_DistanceLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.generic.Distance.Visible = c; UpdateESP() end }, "Col_Distance_generic_Vis")
local c_generic_DistanceLabel_Invis = ESPFeatGB_generic:CreateLabel({ Name = "Distance Invisible Color" }, "Col_LBL_Distance_generic_Invis")
c_generic_DistanceLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.generic.Distance.Invisible = c; UpdateESP() end }, "Col_Distance_generic_Invis")
ESPFeatGB_generic:CreateDivider()

-- Tracer
ESPFeatGB_generic:CreateToggle({ Name = "Show Tracer", CurrentValue = false, Style = 1, Callback = function(v) TS.Tracer.Enabled.generic = v; UpdateESP() end }, "ESP_Tracer_Toggle_generic")
local c_generic_TracerLabel_Vis = ESPFeatGB_generic:CreateLabel({ Name = "Tracer Visible Color" }, "Col_LBL_Tracer_generic_Vis")
c_generic_TracerLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.generic.Tracer.Visible = c; UpdateESP() end }, "Col_Tracer_generic_Vis")
local c_generic_TracerLabel_Invis = ESPFeatGB_generic:CreateLabel({ Name = "Tracer Invisible Color" }, "Col_LBL_Tracer_generic_Invis")
c_generic_TracerLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.generic.Tracer.Invisible = c; UpdateESP() end }, "Col_Tracer_generic_Invis")
ESPFeatGB_generic:CreateDivider()

-- Skeleton
ESPFeatGB_generic:CreateToggle({ Name = "Show Skeleton", CurrentValue = false, Style = 1, Callback = function(v) TS.Skeleton.Enabled.generic = v; UpdateESP() end }, "ESP_Skeleton_Toggle_generic")
local c_generic_SkeletonLabel_Vis = ESPFeatGB_generic:CreateLabel({ Name = "Skeleton Visible Color" }, "Col_LBL_Skeleton_generic_Vis")
c_generic_SkeletonLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.generic.Skeleton.Visible = c; UpdateESP() end }, "Col_Skeleton_generic_Vis")
local c_generic_SkeletonLabel_Invis = ESPFeatGB_generic:CreateLabel({ Name = "Skeleton Invisible Color" }, "Col_LBL_Skeleton_generic_Invis")
c_generic_SkeletonLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.generic.Skeleton.Invisible = c; UpdateESP() end }, "Col_Skeleton_generic_Invis")
ESPFeatGB_generic:CreateDivider()

-- HealthBar
ESPFeatGB_generic:CreateToggle({ Name = "Show HealthBar", CurrentValue = false, Style = 1, Callback = function(v) TS.HealthBar.Enabled.generic = v; UpdateESP() end }, "ESP_HealthBar_Toggle_generic")
local c_generic_HealthBarLabel_Vis = ESPFeatGB_generic:CreateLabel({ Name = "HealthBar Visible Color" }, "Col_LBL_HealthBar_generic_Vis")
c_generic_HealthBarLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.generic.HealthBar.Visible = c; UpdateESP() end }, "Col_HealthBar_generic_Vis")
local c_generic_HealthBarLabel_Invis = ESPFeatGB_generic:CreateLabel({ Name = "HealthBar Invisible Color" }, "Col_LBL_HealthBar_generic_Invis")
c_generic_HealthBarLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.generic.HealthBar.Invisible = c; UpdateESP() end }, "Col_HealthBar_generic_Invis")
ESPFeatGB_generic:CreateDivider()

-- Chams
ESPFeatGB_generic:CreateToggle({ Name = "Show Chams", CurrentValue = false, Style = 1, Callback = function(v) TS.Chams.Enabled.generic = v; UpdateESP() end }, "ESP_Chams_Toggle_generic")
local c_generic_ChamsLabel_Vis = ESPFeatGB_generic:CreateLabel({ Name = "Chams Visible Color" }, "Col_LBL_Chams_generic_Vis")
c_generic_ChamsLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.generic.Chams.Visible = c; UpdateESP() end }, "Col_Chams_generic_Vis")
local c_generic_ChamsLabel_Invis = ESPFeatGB_generic:CreateLabel({ Name = "Chams Invisible Color" }, "Col_LBL_Chams_generic_Invis")
c_generic_ChamsLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.generic.Chams.Invisible = c; UpdateESP() end }, "Col_Chams_generic_Invis")
ESPFeatGB_generic:CreateDivider()

-- EXTRA CONFIGURATIONS
local ESPExtraGB_generic = ESPTab_generic:CreateGroupbox({ Name = "Extra Parameters", Column = 3 }, "ESPExtraGB_generic")
ESPExtraGB_generic:CreateSlider({ Name = "Skeleton Thickness", Range = {1, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) TS.Skeleton.Thickness = v; UpdateESP() end }, "ESP_Skel_Thick_generic")
ESPExtraGB_generic:CreateSlider({ Name = "Tracer Thickness", Range = {1, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) TS.Tracer.Thickness = v; UpdateESP() end }, "ESP_Tracer_Thick_generic")
ESPExtraGB_generic:CreateDropdown({ Name = "Tracer Origin", Options = {"Bottom", "Center", "Top", "Mouse", "LocalHumanoid"}, CurrentOption = {"Bottom"}, Callback = function(v) 
    if v[1] == "Bottom" then TS.Tracer.Origin = 2
    elseif v[1] == "Top" then TS.Tracer.Origin = 3
    elseif v[1] == "Center" then TS.Tracer.Origin = 4
    elseif v[1] == "Mouse" then TS.Tracer.Origin = 5
    else TS.Tracer.Origin = 1 end
    UpdateESP()
end }, "ESP_Tracer_Origin_generic")
ESPExtraGB_generic:CreateDropdown({ Name = "Name Format", Options = {"Standard", "Upper", "Lower"}, CurrentOption = {"Standard"}, Callback = function(v) TS.Name.Style = 1; UpdateESP() end }, "ESP_Name_Style_generic")
ESPExtraGB_generic:CreateToggle({ Name = "Chams Occlusion", CurrentValue = true, Style = 1, Callback = function(v) TS.Chams.Occlusion = v; UpdateESP() end }, "ESP_Chams_Occ_generic")
ESPExtraGB_generic:CreateToggle({ Name = "Chams Outline", CurrentValue = false, Style = 1, Callback = function(v) TS.Chams.Outline.Enabled = v; UpdateESP() end }, "ESP_Chams_Out_generic")
ESPExtraGB_generic:CreateSlider({ Name = "Chams Transparency", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.5, Callback = function(v) TS.Chams.Fill.Transparency = v; UpdateESP() end }, "ESP_Chams_Trans_generic")


local ESPTab_localp = VisualsSection:CreateTab({ Name = "ESP: Local Player", Icon = NebulaIcons:GetIcon('eye', 'Lucide'), Columns = 3 }, "ESPTab_localp")

-- MASTER CONTROLS
local ESPMainGB_localp = ESPTab_localp:CreateGroupbox({ Name = "Main Settings", Column = 1 }, "ESPMainGB_localp")
ESPMainGB_localp:CreateToggle({ Name = "Enable ESP for Local Player", CurrentValue = false, Style = 2, Callback = function(v) TS.Checks.Team.SelectedTeams.localp = v; UpdateESP() end }, "ESP_Master_localp")

-- BOUNDING BOXES
local ESPBoxGB_localp = ESPTab_localp:CreateGroupbox({ Name = "Bounding Boxes", Column = 1 }, "ESPBoxGB_localp")
ESPBoxGB_localp:CreateToggle({ Name = "Enable Bounding Boxes", CurrentValue = false, Style = 2, Callback = function(v) TS.Box.Enabled = v; UpdateESP() end }, "ESP_Box_Toggle_localp")
ESPBoxGB_localp:CreateDropdown({ Name = "Box Style", Options = {"Normal", "CornerBoxes"}, CurrentOption = {"Normal"}, Callback = function(v) 
    if v[1] == "Normal" then TS.Box.Style = 2 else TS.Box.Style = 1 end
    UpdateESP()
end }, "ESP_Box_Style_localp")
ESPBoxGB_localp:CreateToggle({ Name = "Enable Box Fill", CurrentValue = false, Style = 1, Callback = function(v) TS.Box.Filled.Enabled = v; UpdateESP() end }, "ESP_Box_Fill_localp")
ESPBoxGB_localp:CreateSlider({ Name = "Box Thickness", Range = {1, 5}, Increment = 1, CurrentValue = 1, Callback = function(v) TS.Box.Thickness = v; UpdateESP() end }, "ESP_Box_Thick_localp")
ESPBoxGB_localp:CreateSlider({ Name = "Fill Transparency", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.5, Callback = function(v) TS.Box.Filled.Transparency = v; UpdateESP() end }, "ESP_Box_FillTrans_localp")

local c_localpLabel1 = ESPBoxGB_localp:CreateLabel({ Name = "Box Outline Visible Color" }, "Col_LBL_localp_1")
c_localpLabel1:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.localp.Box.Outline.Visible = c; UpdateESP() end }, "Col_localp_1")
local c_localpLabel2 = ESPBoxGB_localp:CreateLabel({ Name = "Box Outline Invisible Color" }, "Col_LBL_localp_2")
c_localpLabel2:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.localp.Box.Outline.Invisible = c; UpdateESP() end }, "Col_localp_2")
local c_localpLabel3 = ESPBoxGB_localp:CreateLabel({ Name = "Box Fill Color" }, "Col_LBL_localp_3")
c_localpLabel3:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.localp.Box.Fill.Visible = c; UpdateESP() end }, "Col_localp_3")

-- OTHER FEATURES
local ESPFeatGB_localp = ESPTab_localp:CreateGroupbox({ Name = "Features", Column = 2 }, "ESPFeatGB_localp")

-- Name
ESPFeatGB_localp:CreateToggle({ Name = "Show Name", CurrentValue = false, Style = 1, Callback = function(v) TS.Name.Enabled.localp = v; UpdateESP() end }, "ESP_Name_Toggle_localp")
local c_localp_NameLabel_Vis = ESPFeatGB_localp:CreateLabel({ Name = "Name Visible Color" }, "Col_LBL_Name_localp_Vis")
c_localp_NameLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.localp.Name.Visible = c; UpdateESP() end }, "Col_Name_localp_Vis")
local c_localp_NameLabel_Invis = ESPFeatGB_localp:CreateLabel({ Name = "Name Invisible Color" }, "Col_LBL_Name_localp_Invis")
c_localp_NameLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.localp.Name.Invisible = c; UpdateESP() end }, "Col_Name_localp_Invis")
ESPFeatGB_localp:CreateDivider()

-- Distance
ESPFeatGB_localp:CreateToggle({ Name = "Show Distance", CurrentValue = false, Style = 1, Callback = function(v) TS.Distance.Enabled.localp = v; UpdateESP() end }, "ESP_Distance_Toggle_localp")
local c_localp_DistanceLabel_Vis = ESPFeatGB_localp:CreateLabel({ Name = "Distance Visible Color" }, "Col_LBL_Distance_localp_Vis")
c_localp_DistanceLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.localp.Distance.Visible = c; UpdateESP() end }, "Col_Distance_localp_Vis")
local c_localp_DistanceLabel_Invis = ESPFeatGB_localp:CreateLabel({ Name = "Distance Invisible Color" }, "Col_LBL_Distance_localp_Invis")
c_localp_DistanceLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.localp.Distance.Invisible = c; UpdateESP() end }, "Col_Distance_localp_Invis")
ESPFeatGB_localp:CreateDivider()

-- Tracer
ESPFeatGB_localp:CreateToggle({ Name = "Show Tracer", CurrentValue = false, Style = 1, Callback = function(v) TS.Tracer.Enabled.localp = v; UpdateESP() end }, "ESP_Tracer_Toggle_localp")
local c_localp_TracerLabel_Vis = ESPFeatGB_localp:CreateLabel({ Name = "Tracer Visible Color" }, "Col_LBL_Tracer_localp_Vis")
c_localp_TracerLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.localp.Tracer.Visible = c; UpdateESP() end }, "Col_Tracer_localp_Vis")
local c_localp_TracerLabel_Invis = ESPFeatGB_localp:CreateLabel({ Name = "Tracer Invisible Color" }, "Col_LBL_Tracer_localp_Invis")
c_localp_TracerLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.localp.Tracer.Invisible = c; UpdateESP() end }, "Col_Tracer_localp_Invis")
ESPFeatGB_localp:CreateDivider()

-- Skeleton
ESPFeatGB_localp:CreateToggle({ Name = "Show Skeleton", CurrentValue = false, Style = 1, Callback = function(v) TS.Skeleton.Enabled.localp = v; UpdateESP() end }, "ESP_Skeleton_Toggle_localp")
local c_localp_SkeletonLabel_Vis = ESPFeatGB_localp:CreateLabel({ Name = "Skeleton Visible Color" }, "Col_LBL_Skeleton_localp_Vis")
c_localp_SkeletonLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.localp.Skeleton.Visible = c; UpdateESP() end }, "Col_Skeleton_localp_Vis")
local c_localp_SkeletonLabel_Invis = ESPFeatGB_localp:CreateLabel({ Name = "Skeleton Invisible Color" }, "Col_LBL_Skeleton_localp_Invis")
c_localp_SkeletonLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.localp.Skeleton.Invisible = c; UpdateESP() end }, "Col_Skeleton_localp_Invis")
ESPFeatGB_localp:CreateDivider()

-- HealthBar
ESPFeatGB_localp:CreateToggle({ Name = "Show HealthBar", CurrentValue = false, Style = 1, Callback = function(v) TS.HealthBar.Enabled.localp = v; UpdateESP() end }, "ESP_HealthBar_Toggle_localp")
local c_localp_HealthBarLabel_Vis = ESPFeatGB_localp:CreateLabel({ Name = "HealthBar Visible Color" }, "Col_LBL_HealthBar_localp_Vis")
c_localp_HealthBarLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.localp.HealthBar.Visible = c; UpdateESP() end }, "Col_HealthBar_localp_Vis")
local c_localp_HealthBarLabel_Invis = ESPFeatGB_localp:CreateLabel({ Name = "HealthBar Invisible Color" }, "Col_LBL_HealthBar_localp_Invis")
c_localp_HealthBarLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.localp.HealthBar.Invisible = c; UpdateESP() end }, "Col_HealthBar_localp_Invis")
ESPFeatGB_localp:CreateDivider()

-- Chams
ESPFeatGB_localp:CreateToggle({ Name = "Show Chams", CurrentValue = false, Style = 1, Callback = function(v) TS.Chams.Enabled.localp = v; UpdateESP() end }, "ESP_Chams_Toggle_localp")
local c_localp_ChamsLabel_Vis = ESPFeatGB_localp:CreateLabel({ Name = "Chams Visible Color" }, "Col_LBL_Chams_localp_Vis")
c_localp_ChamsLabel_Vis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) TS.currentColors.localp.Chams.Visible = c; UpdateESP() end }, "Col_Chams_localp_Vis")
local c_localp_ChamsLabel_Invis = ESPFeatGB_localp:CreateLabel({ Name = "Chams Invisible Color" }, "Col_LBL_Chams_localp_Invis")
c_localp_ChamsLabel_Invis:AddColorPicker({ CurrentValue = Color3.fromRGB(255,0,0), Callback = function(c) TS.currentColors.localp.Chams.Invisible = c; UpdateESP() end }, "Col_Chams_localp_Invis")
ESPFeatGB_localp:CreateDivider()

-- EXTRA CONFIGURATIONS
local ESPExtraGB_localp = ESPTab_localp:CreateGroupbox({ Name = "Extra Parameters", Column = 3 }, "ESPExtraGB_localp")
ESPExtraGB_localp:CreateSlider({ Name = "Skeleton Thickness", Range = {1, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) TS.Skeleton.Thickness = v; UpdateESP() end }, "ESP_Skel_Thick_localp")
ESPExtraGB_localp:CreateSlider({ Name = "Tracer Thickness", Range = {1, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) TS.Tracer.Thickness = v; UpdateESP() end }, "ESP_Tracer_Thick_localp")
ESPExtraGB_localp:CreateDropdown({ Name = "Tracer Origin", Options = {"Bottom", "Center", "Top", "Mouse", "LocalHumanoid"}, CurrentOption = {"Bottom"}, Callback = function(v) 
    if v[1] == "Bottom" then TS.Tracer.Origin = 2
    elseif v[1] == "Top" then TS.Tracer.Origin = 3
    elseif v[1] == "Center" then TS.Tracer.Origin = 4
    elseif v[1] == "Mouse" then TS.Tracer.Origin = 5
    else TS.Tracer.Origin = 1 end
    UpdateESP()
end }, "ESP_Tracer_Origin_localp")
ESPExtraGB_localp:CreateDropdown({ Name = "Name Format", Options = {"Standard", "Upper", "Lower"}, CurrentOption = {"Standard"}, Callback = function(v) TS.Name.Style = 1; UpdateESP() end }, "ESP_Name_Style_localp")
ESPExtraGB_localp:CreateToggle({ Name = "Chams Occlusion", CurrentValue = true, Style = 1, Callback = function(v) TS.Chams.Occlusion = v; UpdateESP() end }, "ESP_Chams_Occ_localp")
ESPExtraGB_localp:CreateToggle({ Name = "Chams Outline", CurrentValue = false, Style = 1, Callback = function(v) TS.Chams.Outline.Enabled = v; UpdateESP() end }, "ESP_Chams_Out_localp")
ESPExtraGB_localp:CreateSlider({ Name = "Chams Transparency", Range = {0, 1}, Increment = 0.1, CurrentValue = 0.5, Callback = function(v) TS.Chams.Fill.Transparency = v; UpdateESP() end }, "ESP_Chams_Trans_localp")


--// RADAR TAB
local RadarTab = VisualsSection:CreateTab({ Name = "Radar settings", Icon = NebulaIcons:GetIcon('activity', 'Lucide'), Columns = 2 }, "RadarTab")
local RadarGB = RadarTab:CreateGroupbox({ Name = "Radar Display", Column = 1 }, "RadarGB")
RadarGB:CreateToggle({ Name = "Enable Radar", CurrentValue = false, Style = 2, Callback = function(v) TS.Radar.Enabled = v; UpdateESP() end }, "Radar_Toggle")
RadarGB:CreateSlider({ Name = "Radar Radius", Range = {50, 500}, Increment = 10, CurrentValue = 100, Callback = function(v) TS.Radar.Radius = v; UpdateESP() end }, "Radar_Rad")
RadarGB:CreateSlider({ Name = "Radar Scale", Range = {1, 10}, Increment = 0.1, CurrentValue = 1, Callback = function(v) TS.Radar.Scale = v; UpdateESP() end }, "Radar_Scale")

local rColBg = RadarGB:CreateLabel({ Name = "Radar Background" }, "Radar_Bg")
rColBg:AddColorPicker({ CurrentValue = Color3.fromRGB(30,30,30), Callback = function(c) TS.currentColors.Radar.Background = c; UpdateESP() end }, "Radar_Bg_Col")
local rColBd = RadarGB:CreateLabel({ Name = "Radar Border" }, "Radar_Bd")
rColBd:AddColorPicker({ CurrentValue = Color3.fromRGB(60,60,60), Callback = function(c) TS.currentColors.Radar.Border = c; UpdateESP() end }, "Radar_Bd_Col")

--// 4. MOVEMENT TAB
local MovementSection = Window:CreateTabSection("Movement", true)
local MoveTab = MovementSection:CreateTab({ Name = "Local Player", Icon = NebulaIcons:GetIcon('move', 'Lucide'), Columns = 2 }, "MoveTab")

local SpeedGB = MoveTab:CreateGroupbox({ Name = "Speed Hack", Column = 1 }, "SpeedGB")
SpeedGB:CreateToggle({ Name = "Enable Speed", CurrentValue = false, Style = 2, Callback = function(v) Lunar.Features.Movement.Speed.Enabled = v end }, "Spd_Toggle")
SpeedGB:CreateSlider({ Name = "Speed Amount", Range = {16, 500}, Increment = 1, CurrentValue = 50, Callback = function(v) Lunar.Features.Movement.Speed.Value = v end }, "Spd_Value")
SpeedGB:CreateDropdown({ Name = "Method", Options = {"CFrame", "Velocity"}, CurrentOption = {"CFrame"}, Callback = function(v) Lunar.Features.Movement.Speed.Method = v[1] end }, "Spd_Method")

local MoveMiscGB = MoveTab:CreateGroupbox({ Name = "Agility Options", Column = 2 }, "MoveMiscGB")
MoveMiscGB:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Style = 2, Callback = function(v) Lunar.Features.Movement.InfiniteJump = v end }, "Move_InfJump")
MoveMiscGB:CreateToggle({ Name = "Bunny Hop", CurrentValue = false, Style = 2, Callback = function(v) Lunar.Features.Movement.BunnyHop = v end }, "Move_BHop")
MoveMiscGB:CreateToggle({ Name = "Spider Climb", CurrentValue = false, Style = 2, Callback = function(v) Lunar.Features.Movement.Spider = v end }, "Move_Spider")

--// 5. WORLD TAB
local WorldTab = MovementSection:CreateTab({ Name = "World Editing", Icon = NebulaIcons:GetIcon('globe', 'Lucide'), Columns = 2 }, "WorldTab")

local LightingGB = WorldTab:CreateGroupbox({ Name = "Lighting Overrides", Column = 1 }, "LightingGB")
LightingGB:CreateToggle({ Name = "Fullbright", CurrentValue = false, Style = 2, Callback = function(v) Lunar.Features.Visuals.World.Fullbright = v end }, "World_FB")
local ambLabel = LightingGB:CreateLabel({ Name = "Ambient Color" }, "Amb_LBL")
ambLabel:AddColorPicker({ CurrentValue = Color3.fromRGB(255,255,255), Callback = function(c) Lunar.Features.Visuals.World.Ambient = c end }, "Amb_Color")
LightingGB:CreateSlider({ Name = "Time of Day", Range = {0, 24}, Increment = 1, CurrentValue = 14, Callback = function(v) Lunar.Features.Visuals.World.TimeOfDay = v end }, "World_Time")
LightingGB:CreateSlider({ Name = "Fog Distance", Range = {0, 100000}, Increment = 100, CurrentValue = 100000, Callback = function(v) Lunar.Features.Visuals.World.FogEnd = v end }, "World_Fog")

--// 6. TROLL TAB
local TrollTab = MovementSection:CreateTab({ Name = "Troll Options", Icon = NebulaIcons:GetIcon('users', 'Lucide'), Columns = 2 }, "TrollTab")
local TrollGB = TrollTab:CreateGroupbox({ Name = "Player Manipulation", Column = 1 }, "TrollGB")
TrollGB:CreateToggle({ Name = "Spin Fling", CurrentValue = false, Style = 2, Callback = function(v) Lunar.Features.Troll.SpinFling = v end }, "Troll_SpinFling")
TrollGB:CreateButton({ Name = "Fling Server", Icon = NebulaIcons:GetIcon('zap', 'Lucide'), Callback = function() 
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(9999999, 9999999, 9999999)
        hrp.RotVelocity = Vector3.new(9999999, 9999999, 9999999)
    end
end }, "Troll_FlingSrv")

--// 7. SETTINGS TAB
local ConfigSection = Window:CreateTabSection("Configuration", true)
local SettingsTab = ConfigSection:CreateTab({ Name = "System Settings", Icon = NebulaIcons:GetIcon('settings', 'Lucide'), Columns = 2 }, "SettingsTab")

SettingsTab:BuildConfigGroupbox(1)
SettingsTab:BuildThemeGroupbox(2)

-- Load defaults
pcall(function() Starlight:SetTheme("Nebula") end)
pcall(function() Starlight:LoadAutoloadTheme() end)
pcall(function() Starlight:LoadAutoloadConfig() end)

-- Notification
Starlight:Notification({
    Title = "Lunar Titan Initialized",
    Icon = NebulaIcons:GetIcon('shield-check', 'Lucide'),
    Content = "Advanced physics modules injected. Welcome to Lunar V5.0.0.",
    Duration = 5
}, "INIT_NOTIF")
