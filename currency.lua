-- currency_changer.lua
-- Local executor: Currency override GUI with auto-lock

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ══════════════════════════════
-- CONFIG — edit these
-- ══════════════════════════════
local CONFIG = {
    CurrencyName = "Cash",  -- change to your game's currency stat name
    DefaultValue = 999999,
    Min = 0,
    Max = 999999999,
    UpdateInterval = 0.1,
}

-- ══════════════════════════════
-- STAT RESOLVER
-- ══════════════════════════════
local function findStat()
    local folders = {"leaderstats", "Stats", "Data", "PlayerData", "Currency"}
    for _, name in ipairs(folders) do
        local folder = LocalPlayer:FindFirstChild(name)
        if folder then
            local s = folder:FindFirstChild(CONFIG.CurrencyName)
            if s then return s end
        end
    end
    for _, child in ipairs(LocalPlayer:GetChildren()) do
        local s = child:FindFirstChild(CONFIG.CurrencyName)
        if s then return s end
    end
    return nil
end

-- ══════════════════════════════
-- GUI
-- ══════════════════════════════
local gui = Instance.new("ScreenGui")
gui.Name = "CurrencyGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 190)
frame.Position = UDim2.new(0.5, -130, 0.5, -95)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(50, 160, 100)
stroke.Thickness = 1.5

-- Title
local title = Instance.new("Frame", frame)
title.Size = UDim2.new(1, 0, 0, 34)
title.BackgroundColor3 = Color3.fromRGB(20, 45, 30)
title.BorderSizePixel = 0
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

local titleText = Instance.new("TextLabel", title)
titleText.Size = UDim2.new(1, -10, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "💰 CURRENCY OVERRIDE"
titleText.TextColor3 = Color3.fromRGB(80, 220, 130)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 13
titleText.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", title)
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -30, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

-- Current display
local currentLabel = Instance.new("TextLabel", frame)
currentLabel.Size = UDim2.new(1, -20, 0, 22)
currentLabel.Position = UDim2.new(0, 10, 0, 42)
currentLabel.BackgroundTransparency = 1
currentLabel.Text = "Current: --"
currentLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
currentLabel.Font = Enum.Font.Gotham
currentLabel.TextSize = 12
currentLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Stat name input
local nameLabel = Instance.new("TextLabel", frame)
nameLabel.Size = UDim2.new(1, -20, 0, 18)
nameLabel.Position = UDim2.new(0, 10, 0, 66)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "Stat Name:"
nameLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 12
nameLabel.TextXAlignment = Enum.TextXAlignment.Left

local nameBox = Instance.new("TextBox", frame)
nameBox.Size = UDim2.new(1, -20, 0, 28)
nameBox.Position = UDim2.new(0, 10, 0, 86)
nameBox.BackgroundColor3 = Color3.fromRGB(25, 30, 25)
nameBox.BorderSizePixel = 0
nameBox.Text = CONFIG.CurrencyName
nameBox.TextColor3 = Color3.fromRGB(100, 240, 150)
nameBox.Font = Enum.Font.GothamBold
nameBox.TextSize = 13
nameBox.ClearTextOnFocus = false
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 5)
local ns = Instance.new("UIStroke", nameBox)
ns.Color = Color3.fromRGB(50, 160, 100)
ns.Thickness = 1

-- Amount input
local amountBox = Instance.new("TextBox", frame)
amountBox.Size = UDim2.new(1, -20, 0, 28)
amountBox.Position = UDim2.new(0, 10, 0, 118)
amountBox.BackgroundColor3 = Color3.fromRGB(25, 30, 25)
amountBox.BorderSizePixel = 0
amountBox.Text = tostring(CONFIG.DefaultValue)
amountBox.TextColor3 = Color3.fromRGB(100, 240, 150)
amountBox.Font = Enum.Font.GothamBold
amountBox.TextSize = 13
amountBox.ClearTextOnFocus = false
Instance.new("UICorner", amountBox).CornerRadius = UDim.new(0, 5)
local as = Instance.new("UIStroke", amountBox)
as.Color = Color3.fromRGB(50, 160, 100)
as.Thickness = 1

-- Apply button
local applyBtn = Instance.new("TextButton", frame)
applyBtn.Size = UDim2.new(0, 110, 0, 30)
applyBtn.Position = UDim2.new(0, 10, 0, 152)
applyBtn.BackgroundColor3 = Color3.fromRGB(40, 130, 70)
applyBtn.BorderSizePixel = 0
applyBtn.Text = "APPLY"
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 12
Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 6)

-- Auto-lock button
local lockBtn = Instance.new("TextButton", frame)
lockBtn.Size = UDim2.new(0, 120, 0, 30)
lockBtn.Position = UDim2.new(0, 130, 0, 152)
lockBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
lockBtn.BorderSizePixel = 0
lockBtn.Text = "🔓 AUTO: OFF"
lockBtn.TextColor3 = Color3.fromRGB(170, 170, 190)
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 11
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 6)

-- Status
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -20, 0, 18)
status.Position = UDim2.new(0, 10, 0, 168)
status.BackgroundTransparency = 1
status.Text = "Ready."
status.TextColor3 = Color3.fromRGB(100, 200, 120)
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left

-- ══════════════════════════════
-- LOGIC
-- ══════════════════════════════
local autoLock = false
local targetValue = CONFIG.DefaultValue

local function applyStat(value)
    CONFIG.CurrencyName = nameBox.Text ~= "" and nameBox.Text or CONFIG.CurrencyName
    local stat = findStat()
    if not stat then
        status.Text = "⚠ Stat '" .. CONFIG.CurrencyName .. "' not found."
        status.TextColor3 = Color3.fromRGB(255, 160, 60)
        return false
    end
    local clamped = math.clamp(value, CONFIG.Min, CONFIG.Max)
    if stat:IsA("IntValue") or stat:IsA("NumberValue") then
        stat.Value = clamped
    elseif stat:IsA("StringValue") then
        stat.Value = tostring(clamped)
    else
        status.Text = "⚠ Unsupported type: " .. stat.ClassName
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
        return false
    end
    return true
end

applyBtn.MouseButton1Click:Connect(function()
    local v = tonumber(amountBox.Text)
    if not v then
        status.Text = "⚠ Invalid number."
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    targetValue = math.clamp(v, CONFIG.Min, CONFIG.Max)
    if applyStat(targetValue) then
        status.Text = "✔ Set to " .. tostring(targetValue)
        status.TextColor3 = Color3.fromRGB(100, 220, 130)
    end
end)

lockBtn.MouseButton1Click:Connect(function()
    autoLock = not autoLock
    if autoLock then
        lockBtn.Text = "🔒 AUTO: ON"
        lockBtn.BackgroundColor3 = Color3.fromRGB(40, 110, 60)
        status.Text = "Auto-lock active."
        status.TextColor3 = Color3.fromRGB(100, 220, 130)
    else
        lockBtn.Text = "🔓 AUTO: OFF"
        lockBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        status.Text = "Auto-lock off."
        status.TextColor3 = Color3.fromRGB(160, 160, 180)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local elapsed = 0
RunService.Heartbeat:Connect(function(dt)
    elapsed = elapsed + dt
    if elapsed < CONFIG.UpdateInterval then return end
    elapsed = 0

    CONFIG.CurrencyName = nameBox.Text ~= "" and nameBox.Text or CONFIG.CurrencyName
    local stat = findStat()
    if stat then
        currentLabel.Text = "Current: " .. tostring(stat.Value)
    else
        currentLabel.Text = "Current: (not found)"
    end

    if autoLock then
        local v = tonumber(amountBox.Text)
        if v then
            targetValue = math.clamp(v, CONFIG.Min, CONFIG.Max)
            local sv = tonumber(stat and stat.Value)
            if sv ~= targetValue then
                applyStat(targetValue)
            end
        end
    end
end)
