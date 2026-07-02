--[[
    Symbol.hit UI Library
    A 1:1 recreation of the Symbol.hit cheat GUI with Theme Changers

    Usage:
        local Symbol = loadstring(library_source)()
        local Window = Symbol:CreateWindow("Symbol.hit | private")

        local CombatTab = Window:CreateTab("combat")
        local VisualsTab = Window:CreateTab("visuals")
        local MiscTab = Window:CreateTab("misc")
        local DesyncTab = Window:CreateTab("desync")
        local SettingsTab = Window:CreateTab("settings")

        -- Theme changers are auto-added to Settings tab
        -- Or manually:
        local ThemeSection = SettingsTab:CreateSection("Theme", "left")
        ThemeSection:CreateColorPicker("Accent Color", Color3.fromRGB(45, 195, 62), function(color)
            Symbol:SetTheme("Custom", {Accent = color})
        end)

        Symbol:SetTheme("Dark") -- preset
        Symbol:SetTheme("Light") -- preset
        Symbol:SetTheme("Custom", {Accent = Color3.fromRGB(255, 0, 0), Background = Color3.fromRGB(0, 0, 0)})
]]

local Symbol = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==================== THEME SYSTEM ====================
local Themes = {
    Default = {
        Background = Color3.fromRGB(22, 22, 22),
        SectionBg = Color3.fromRGB(28, 28, 28),
        Border = Color3.fromRGB(40, 40, 40),
        OuterBorder = Color3.fromRGB(20, 42, 26),
        Text = Color3.fromRGB(155, 155, 153),
        TextBright = Color3.fromRGB(170, 170, 168),
        Accent = Color3.fromRGB(45, 195, 62),
        AccentBright = Color3.fromRGB(49, 196, 63),
        AccentDark = Color3.fromRGB(0, 122, 0),
        AccentGlow = Color3.fromRGB(42, 127, 71),
        SliderFill = Color3.fromRGB(10, 219, 39),
        SliderGlow = Color3.fromRGB(67, 192, 96),
        TabText = Color3.fromRGB(160, 160, 158),
        TabActive = Color3.fromRGB(168, 171, 168),
        TabInactive = Color3.fromRGB(100, 100, 98),
        SectionTitle = Color3.fromRGB(168, 176, 167),
        SectionUnderline = Color3.fromRGB(168, 176, 167),
        DropdownBg = Color3.fromRGB(22, 22, 20),
        DropdownBorder = Color3.fromRGB(58, 58, 56),
        KeybindsBg = Color3.fromRGB(23, 46, 37),
        KeybindsBorder = Color3.fromRGB(59, 81, 68),
        KeybindsTitleBg = Color3.fromRGB(0, 22, 0),
        KeybindsText = Color3.fromRGB(170, 170, 168),
        NameTagBg = Color3.fromRGB(26, 26, 24),
        NameTagBorder = Color3.fromRGB(0, 51, 0),
        NameTagText = Color3.fromRGB(45, 211, 69),
        NameTagTextDim = Color3.fromRGB(92, 142, 98),
        CheckboxBg = Color3.fromRGB(22, 22, 22),
        CheckboxBorder = Color3.fromRGB(40, 40, 40),
        SliderTrack = Color3.fromRGB(42, 57, 42),
        SliderTrackBg = Color3.fromRGB(118, 133, 119),
        White = Color3.fromRGB(255, 255, 255),
        Black = Color3.fromRGB(0, 0, 0),
    },

    Dark = {
        Background = Color3.fromRGB(15, 15, 15),
        SectionBg = Color3.fromRGB(20, 20, 20),
        Border = Color3.fromRGB(35, 35, 35),
        OuterBorder = Color3.fromRGB(10, 10, 10),
        Text = Color3.fromRGB(180, 180, 180),
        TextBright = Color3.fromRGB(200, 200, 200),
        Accent = Color3.fromRGB(100, 100, 100),
        AccentBright = Color3.fromRGB(120, 120, 120),
        AccentDark = Color3.fromRGB(60, 60, 60),
        AccentGlow = Color3.fromRGB(80, 80, 80),
        SliderFill = Color3.fromRGB(100, 100, 100),
        SliderGlow = Color3.fromRGB(120, 120, 120),
        TabText = Color3.fromRGB(150, 150, 150),
        TabActive = Color3.fromRGB(200, 200, 200),
        TabInactive = Color3.fromRGB(100, 100, 100),
        SectionTitle = Color3.fromRGB(200, 200, 200),
        SectionUnderline = Color3.fromRGB(150, 150, 150),
        DropdownBg = Color3.fromRGB(18, 18, 18),
        DropdownBorder = Color3.fromRGB(40, 40, 40),
        KeybindsBg = Color3.fromRGB(18, 18, 18),
        KeybindsBorder = Color3.fromRGB(35, 35, 35),
        KeybindsTitleBg = Color3.fromRGB(10, 10, 10),
        KeybindsText = Color3.fromRGB(180, 180, 180),
        NameTagBg = Color3.fromRGB(18, 18, 18),
        NameTagBorder = Color3.fromRGB(35, 35, 35),
        NameTagText = Color3.fromRGB(150, 150, 150),
        NameTagTextDim = Color3.fromRGB(120, 120, 120),
        CheckboxBg = Color3.fromRGB(15, 15, 15),
        CheckboxBorder = Color3.fromRGB(35, 35, 35),
        SliderTrack = Color3.fromRGB(30, 30, 30),
        SliderTrackBg = Color3.fromRGB(50, 50, 50),
        White = Color3.fromRGB(255, 255, 255),
        Black = Color3.fromRGB(0, 0, 0),
    },

    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        SectionBg = Color3.fromRGB(230, 230, 230),
        Border = Color3.fromRGB(200, 200, 200),
        OuterBorder = Color3.fromRGB(180, 180, 180),
        Text = Color3.fromRGB(60, 60, 60),
        TextBright = Color3.fromRGB(40, 40, 40),
        Accent = Color3.fromRGB(0, 150, 200),
        AccentBright = Color3.fromRGB(0, 170, 220),
        AccentDark = Color3.fromRGB(0, 100, 150),
        AccentGlow = Color3.fromRGB(0, 130, 180),
        SliderFill = Color3.fromRGB(0, 150, 200),
        SliderGlow = Color3.fromRGB(0, 170, 220),
        TabText = Color3.fromRGB(80, 80, 80),
        TabActive = Color3.fromRGB(0, 150, 200),
        TabInactive = Color3.fromRGB(120, 120, 120),
        SectionTitle = Color3.fromRGB(0, 150, 200),
        SectionUnderline = Color3.fromRGB(0, 150, 200),
        DropdownBg = Color3.fromRGB(250, 250, 250),
        DropdownBorder = Color3.fromRGB(200, 200, 200),
        KeybindsBg = Color3.fromRGB(235, 235, 235),
        KeybindsBorder = Color3.fromRGB(200, 200, 200),
        KeybindsTitleBg = Color3.fromRGB(220, 220, 220),
        KeybindsText = Color3.fromRGB(60, 60, 60),
        NameTagBg = Color3.fromRGB(235, 235, 235),
        NameTagBorder = Color3.fromRGB(200, 200, 200),
        NameTagText = Color3.fromRGB(0, 150, 200),
        NameTagTextDim = Color3.fromRGB(0, 120, 170),
        CheckboxBg = Color3.fromRGB(250, 250, 250),
        CheckboxBorder = Color3.fromRGB(200, 200, 200),
        SliderTrack = Color3.fromRGB(200, 200, 200),
        SliderTrackBg = Color3.fromRGB(220, 220, 220),
        White = Color3.fromRGB(255, 255, 255),
        Black = Color3.fromRGB(0, 0, 0),
    },

    Red = {
        Background = Color3.fromRGB(22, 15, 15),
        SectionBg = Color3.fromRGB(30, 20, 20),
        Border = Color3.fromRGB(60, 40, 40),
        OuterBorder = Color3.fromRGB(80, 30, 30),
        Text = Color3.fromRGB(200, 180, 180),
        TextBright = Color3.fromRGB(220, 200, 200),
        Accent = Color3.fromRGB(220, 50, 50),
        AccentBright = Color3.fromRGB(240, 60, 60),
        AccentDark = Color3.fromRGB(150, 30, 30),
        AccentGlow = Color3.fromRGB(200, 40, 40),
        SliderFill = Color3.fromRGB(220, 50, 50),
        SliderGlow = Color3.fromRGB(240, 60, 60),
        TabText = Color3.fromRGB(180, 160, 160),
        TabActive = Color3.fromRGB(220, 50, 50),
        TabInactive = Color3.fromRGB(120, 100, 100),
        SectionTitle = Color3.fromRGB(220, 80, 80),
        SectionUnderline = Color3.fromRGB(220, 50, 50),
        DropdownBg = Color3.fromRGB(25, 18, 18),
        DropdownBorder = Color3.fromRGB(60, 40, 40),
        KeybindsBg = Color3.fromRGB(30, 20, 20),
        KeybindsBorder = Color3.fromRGB(60, 40, 40),
        KeybindsTitleBg = Color3.fromRGB(20, 10, 10),
        KeybindsText = Color3.fromRGB(200, 180, 180),
        NameTagBg = Color3.fromRGB(25, 18, 18),
        NameTagBorder = Color3.fromRGB(80, 30, 30),
        NameTagText = Color3.fromRGB(220, 50, 50),
        NameTagTextDim = Color3.fromRGB(180, 60, 60),
        CheckboxBg = Color3.fromRGB(22, 15, 15),
        CheckboxBorder = Color3.fromRGB(60, 40, 40),
        SliderTrack = Color3.fromRGB(60, 40, 40),
        SliderTrackBg = Color3.fromRGB(80, 60, 60),
        White = Color3.fromRGB(255, 255, 255),
        Black = Color3.fromRGB(0, 0, 0),
    },

    Purple = {
        Background = Color3.fromRGB(18, 15, 22),
        SectionBg = Color3.fromRGB(25, 20, 30),
        Border = Color3.fromRGB(50, 40, 60),
        OuterBorder = Color3.fromRGB(60, 30, 80),
        Text = Color3.fromRGB(200, 190, 210),
        TextBright = Color3.fromRGB(220, 210, 240),
        Accent = Color3.fromRGB(180, 80, 220),
        AccentBright = Color3.fromRGB(200, 100, 240),
        AccentDark = Color3.fromRGB(120, 50, 150),
        AccentGlow = Color3.fromRGB(160, 70, 200),
        SliderFill = Color3.fromRGB(180, 80, 220),
        SliderGlow = Color3.fromRGB(200, 100, 240),
        TabText = Color3.fromRGB(180, 170, 190),
        TabActive = Color3.fromRGB(180, 80, 220),
        TabInactive = Color3.fromRGB(110, 100, 120),
        SectionTitle = Color3.fromRGB(200, 120, 240),
        SectionUnderline = Color3.fromRGB(180, 80, 220),
        DropdownBg = Color3.fromRGB(22, 18, 25),
        DropdownBorder = Color3.fromRGB(50, 40, 60),
        KeybindsBg = Color3.fromRGB(25, 20, 30),
        KeybindsBorder = Color3.fromRGB(50, 40, 60),
        KeybindsTitleBg = Color3.fromRGB(15, 10, 20),
        KeybindsText = Color3.fromRGB(200, 190, 210),
        NameTagBg = Color3.fromRGB(22, 18, 25),
        NameTagBorder = Color3.fromRGB(60, 30, 80),
        NameTagText = Color3.fromRGB(180, 80, 220),
        NameTagTextDim = Color3.fromRGB(150, 70, 180),
        CheckboxBg = Color3.fromRGB(18, 15, 22),
        CheckboxBorder = Color3.fromRGB(50, 40, 60),
        SliderTrack = Color3.fromRGB(50, 40, 60),
        SliderTrackBg = Color3.fromRGB(70, 60, 80),
        White = Color3.fromRGB(255, 255, 255),
        Black = Color3.fromRGB(0, 0, 0),
    },

    Blue = {
        Background = Color3.fromRGB(15, 18, 25),
        SectionBg = Color3.fromRGB(20, 25, 35),
        Border = Color3.fromRGB(40, 50, 70),
        OuterBorder = Color3.fromRGB(30, 50, 80),
        Text = Color3.fromRGB(180, 190, 210),
        TextBright = Color3.fromRGB(200, 210, 240),
        Accent = Color3.fromRGB(50, 130, 240),
        AccentBright = Color3.fromRGB(70, 150, 255),
        AccentDark = Color3.fromRGB(30, 80, 180),
        AccentGlow = Color3.fromRGB(40, 110, 220),
        SliderFill = Color3.fromRGB(50, 130, 240),
        SliderGlow = Color3.fromRGB(70, 150, 255),
        TabText = Color3.fromRGB(160, 170, 190),
        TabActive = Color3.fromRGB(50, 130, 240),
        TabInactive = Color3.fromRGB(100, 110, 130),
        SectionTitle = Color3.fromRGB(80, 160, 255),
        SectionUnderline = Color3.fromRGB(50, 130, 240),
        DropdownBg = Color3.fromRGB(18, 22, 30),
        DropdownBorder = Color3.fromRGB(40, 50, 70),
        KeybindsBg = Color3.fromRGB(20, 25, 35),
        KeybindsBorder = Color3.fromRGB(40, 50, 70),
        KeybindsTitleBg = Color3.fromRGB(10, 15, 25),
        KeybindsText = Color3.fromRGB(180, 190, 210),
        NameTagBg = Color3.fromRGB(18, 22, 30),
        NameTagBorder = Color3.fromRGB(30, 50, 80),
        NameTagText = Color3.fromRGB(50, 130, 240),
        NameTagTextDim = Color3.fromRGB(40, 100, 200),
        CheckboxBg = Color3.fromRGB(15, 18, 25),
        CheckboxBorder = Color3.fromRGB(40, 50, 70),
        SliderTrack = Color3.fromRGB(40, 50, 70),
        SliderTrackBg = Color3.fromRGB(60, 70, 90),
        White = Color3.fromRGB(255, 255, 255),
        Black = Color3.fromRGB(0, 0, 0),
    },

    Orange = {
        Background = Color3.fromRGB(22, 18, 12),
        SectionBg = Color3.fromRGB(30, 25, 18),
        Border = Color3.fromRGB(60, 50, 35),
        OuterBorder = Color3.fromRGB(80, 60, 30),
        Text = Color3.fromRGB(210, 200, 180),
        TextBright = Color3.fromRGB(240, 230, 210),
        Accent = Color3.fromRGB(230, 140, 30),
        AccentBright = Color3.fromRGB(255, 160, 40),
        AccentDark = Color3.fromRGB(180, 100, 20),
        AccentGlow = Color3.fromRGB(210, 120, 25),
        SliderFill = Color3.fromRGB(230, 140, 30),
        SliderGlow = Color3.fromRGB(255, 160, 40),
        TabText = Color3.fromRGB(190, 180, 160),
        TabActive = Color3.fromRGB(230, 140, 30),
        TabInactive = Color3.fromRGB(130, 120, 100),
        SectionTitle = Color3.fromRGB(255, 170, 50),
        SectionUnderline = Color3.fromRGB(230, 140, 30),
        DropdownBg = Color3.fromRGB(25, 20, 15),
        DropdownBorder = Color3.fromRGB(60, 50, 35),
        KeybindsBg = Color3.fromRGB(30, 25, 18),
        KeybindsBorder = Color3.fromRGB(60, 50, 35),
        KeybindsTitleBg = Color3.fromRGB(20, 15, 10),
        KeybindsText = Color3.fromRGB(210, 200, 180),
        NameTagBg = Color3.fromRGB(25, 20, 15),
        NameTagBorder = Color3.fromRGB(80, 60, 30),
        NameTagText = Color3.fromRGB(230, 140, 30),
        NameTagTextDim = Color3.fromRGB(200, 120, 30),
        CheckboxBg = Color3.fromRGB(22, 18, 12),
        CheckboxBorder = Color3.fromRGB(60, 50, 35),
        SliderTrack = Color3.fromRGB(60, 50, 35),
        SliderTrackBg = Color3.fromRGB(80, 70, 50),
        White = Color3.fromRGB(255, 255, 255),
        Black = Color3.fromRGB(0, 0, 0),
    },

    Pink = {
        Background = Color3.fromRGB(22, 15, 18),
        SectionBg = Color3.fromRGB(30, 20, 25),
        Border = Color3.fromRGB(60, 40, 50),
        OuterBorder = Color3.fromRGB(80, 40, 60),
        Text = Color3.fromRGB(210, 190, 200),
        TextBright = Color3.fromRGB(240, 220, 230),
        Accent = Color3.fromRGB(230, 80, 150),
        AccentBright = Color3.fromRGB(255, 100, 170),
        AccentDark = Color3.fromRGB(180, 50, 110),
        AccentGlow = Color3.fromRGB(210, 70, 130),
        SliderFill = Color3.fromRGB(230, 80, 150),
        SliderGlow = Color3.fromRGB(255, 100, 170),
        TabText = Color3.fromRGB(190, 170, 180),
        TabActive = Color3.fromRGB(230, 80, 150),
        TabInactive = Color3.fromRGB(130, 110, 120),
        SectionTitle = Color3.fromRGB(255, 120, 180),
        SectionUnderline = Color3.fromRGB(230, 80, 150),
        DropdownBg = Color3.fromRGB(25, 18, 20),
        DropdownBorder = Color3.fromRGB(60, 40, 50),
        KeybindsBg = Color3.fromRGB(30, 20, 25),
        KeybindsBorder = Color3.fromRGB(60, 40, 50),
        KeybindsTitleBg = Color3.fromRGB(20, 12, 15),
        KeybindsText = Color3.fromRGB(210, 190, 200),
        NameTagBg = Color3.fromRGB(25, 18, 20),
        NameTagBorder = Color3.fromRGB(80, 40, 60),
        NameTagText = Color3.fromRGB(230, 80, 150),
        NameTagTextDim = Color3.fromRGB(200, 70, 130),
        CheckboxBg = Color3.fromRGB(22, 15, 18),
        CheckboxBorder = Color3.fromRGB(60, 40, 50),
        SliderTrack = Color3.fromRGB(60, 40, 50),
        SliderTrackBg = Color3.fromRGB(80, 60, 70),
        White = Color3.fromRGB(255, 255, 255),
        Black = Color3.fromRGB(0, 0, 0),
    },

    Gold = {
        Background = Color3.fromRGB(20, 18, 10),
        SectionBg = Color3.fromRGB(28, 25, 15),
        Border = Color3.fromRGB(55, 50, 30),
        OuterBorder = Color3.fromRGB(70, 60, 25),
        Text = Color3.fromRGB(210, 205, 180),
        TextBright = Color3.fromRGB(240, 235, 210),
        Accent = Color3.fromRGB(220, 190, 50),
        AccentBright = Color3.fromRGB(240, 210, 60),
        AccentDark = Color3.fromRGB(170, 140, 30),
        AccentGlow = Color3.fromRGB(200, 170, 40),
        SliderFill = Color3.fromRGB(220, 190, 50),
        SliderGlow = Color3.fromRGB(240, 210, 60),
        TabText = Color3.fromRGB(190, 185, 160),
        TabActive = Color3.fromRGB(220, 190, 50),
        TabInactive = Color3.fromRGB(120, 115, 90),
        SectionTitle = Color3.fromRGB(240, 210, 70),
        SectionUnderline = Color3.fromRGB(220, 190, 50),
        DropdownBg = Color3.fromRGB(22, 20, 12),
        DropdownBorder = Color3.fromRGB(55, 50, 30),
        KeybindsBg = Color3.fromRGB(28, 25, 15),
        KeybindsBorder = Color3.fromRGB(55, 50, 30),
        KeybindsTitleBg = Color3.fromRGB(18, 15, 8),
        KeybindsText = Color3.fromRGB(210, 205, 180),
        NameTagBg = Color3.fromRGB(22, 20, 12),
        NameTagBorder = Color3.fromRGB(70, 60, 25),
        NameTagText = Color3.fromRGB(220, 190, 50),
        NameTagTextDim = Color3.fromRGB(190, 160, 40),
        CheckboxBg = Color3.fromRGB(20, 18, 10),
        CheckboxBorder = Color3.fromRGB(55, 50, 30),
        SliderTrack = Color3.fromRGB(55, 50, 30),
        SliderTrackBg = Color3.fromRGB(75, 70, 45),
        White = Color3.fromRGB(255, 255, 255),
        Black = Color3.fromRGB(0, 0, 0),
    },
}

local CurrentTheme = "Default"
local Colors = Themes.Default
local ThemeObjects = {}

local function RegisterThemeObject(object, property, colorKey)
    if not ThemeObjects[colorKey] then
        ThemeObjects[colorKey] = {}
    end
    table.insert(ThemeObjects[colorKey], {Object = object, Property = property})
end

local function UpdateTheme(themeName, customColors)
    local theme = Themes[themeName] or Themes.Default
    if customColors then
        for k, v in pairs(customColors) do
            theme[k] = v
        end
    end

    Colors = theme
    CurrentTheme = themeName

    for colorKey, objects in pairs(ThemeObjects) do
        local color = theme[colorKey]
        if color then
            for _, item in ipairs(objects) do
                pcall(function()
                    item.Object[item.Property] = color
                end)
            end
        end
    end
end

Symbol.Themes = Themes
Symbol.CurrentTheme = function() return CurrentTheme end

function Symbol:SetTheme(themeName, customColors)
    UpdateTheme(themeName, customColors)
end

-- Utility
local function Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    return instance
end

local function Padding(instance, left, top, right, bottom)
    local pad = Create("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        Parent = instance
    })
    return pad
end

local function ListLayout(instance, padding, align)
    local layout = Create("UIListLayout", {
        Padding = UDim.new(0, padding or 0),
        HorizontalAlignment = align or Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = instance
    })
    return layout
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging = false
    local dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ==================== COLOR PICKER COMPONENT ====================
local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.New(parent, text, defaultColor, callback)
    local self = setmetatable({}, ColorPicker)
    self.Value = defaultColor or Color3.fromRGB(45, 195, 62)
    self.Callback = callback or function() end
    self.Open = false

    self.Container = Create("Frame", {
        Name = text:gsub(" ", "") .. "ColorPicker",
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 32),
        ClipsDescendants = false,
    })

    self.Label = Create("TextLabel", {
        Name = "Label",
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 20, 0, 0),
        Font = Enum.Font.SourceSans,
        Text = text,
        TextColor3 = Colors.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    RegisterThemeObject(self.Label, "TextColor3", "Text")

    self.Button = Create("TextButton", {
        Name = "Button",
        Parent = self.Container,
        BackgroundColor3 = self.Value,
        BorderColor3 = Colors.Border,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 60, 0, 16),
        Position = UDim2.new(0, 20, 0, 14),
        Font = Enum.Font.SourceSans,
        Text = "",
        AutoButtonColor = false,
    })
    RegisterThemeObject(self.Button, "BorderColor3", "Border")

    self.HexLabel = Create("TextLabel", {
        Name = "Hex",
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 60, 0, 16),
        Position = UDim2.new(0, 85, 0, 14),
        Font = Enum.Font.SourceSans,
        Text = string.format("#%02X%02X%02X", self.Value.R * 255, self.Value.G * 255, self.Value.B * 255),
        TextColor3 = Colors.TextBright,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    RegisterThemeObject(self.HexLabel, "TextColor3", "TextBright")

    self.PickerFrame = Create("Frame", {
        Name = "PickerFrame",
        Parent = self.Button,
        BackgroundColor3 = Colors.Background,
        BorderColor3 = Colors.Border,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 180, 0, 160),
        Position = UDim2.new(0, 0, 1, 2),
        Visible = false,
        ZIndex = 20,
    })
    RegisterThemeObject(self.PickerFrame, "BackgroundColor3", "Background")
    RegisterThemeObject(self.PickerFrame, "BorderColor3", "Border")

    self.SVFrame = Create("Frame", {
        Name = "SV",
        Parent = self.PickerFrame,
        BackgroundColor3 = Color3.fromHSV(0, 1, 1),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 130, 0, 100),
        Position = UDim2.new(0, 8, 0, 8),
        ZIndex = 20,
    })

    local satGradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Parent = self.SVFrame,
    })

    local valFrame = Create("Frame", {
        Name = "Val",
        Parent = self.SVFrame,
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 20,
    })

    local valGradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Rotation = 90,
        Parent = valFrame,
    })

    self.HueFrame = Create("Frame", {
        Name = "Hue",
        Parent = self.PickerFrame,
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 16, 0, 100),
        Position = UDim2.new(0, 144, 0, 8),
        ZIndex = 20,
    })

    local hueGradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
            ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
            ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
            ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
            ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
        }),
        Rotation = 90,
        Parent = self.HueFrame,
    })

    self.Preview = Create("Frame", {
        Name = "Preview",
        Parent = self.PickerFrame,
        BackgroundColor3 = self.Value,
        BorderColor3 = Colors.Border,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(0, 8, 0, 115),
        ZIndex = 20,
    })
    RegisterThemeObject(self.Preview, "BorderColor3", "Border")

    self.RInput = Create("TextBox", {
        Name = "R",
        Parent = self.PickerFrame,
        BackgroundColor3 = Colors.DropdownBg,
        BorderColor3 = Colors.Border,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 40, 0, 18),
        Position = UDim2.new(0, 65, 0, 115),
        Font = Enum.Font.SourceSans,
        Text = tostring(math.floor(self.Value.R * 255)),
        TextColor3 = Colors.Text,
        TextSize = 11,
        ZIndex = 20,
        ClearTextOnFocus = false,
    })
    RegisterThemeObject(self.RInput, "BackgroundColor3", "DropdownBg")
    RegisterThemeObject(self.RInput, "BorderColor3", "Border")
    RegisterThemeObject(self.RInput, "TextColor3", "Text")

    self.GInput = Create("TextBox", {
        Name = "G",
        Parent = self.PickerFrame,
        BackgroundColor3 = Colors.DropdownBg,
        BorderColor3 = Colors.Border,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 40, 0, 18),
        Position = UDim2.new(0, 110, 0, 115),
        Font = Enum.Font.SourceSans,
        Text = tostring(math.floor(self.Value.G * 255)),
        TextColor3 = Colors.Text,
        TextSize = 11,
        ZIndex = 20,
        ClearTextOnFocus = false,
    })
    RegisterThemeObject(self.GInput, "BackgroundColor3", "DropdownBg")
    RegisterThemeObject(self.GInput, "BorderColor3", "Border")
    RegisterThemeObject(self.GInput, "TextColor3", "Text")

    self.BInput = Create("TextBox", {
        Name = "B",
        Parent = self.PickerFrame,
        BackgroundColor3 = Colors.DropdownBg,
        BorderColor3 = Colors.Border,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 40, 0, 18),
        Position = UDim2.new(0, 155, 0, 115),
        Font = Enum.Font.SourceSans,
        Text = tostring(math.floor(self.Value.B * 255)),
        TextColor3 = Colors.Text,
        TextSize = 11,
        ZIndex = 20,
        ClearTextOnFocus = false,
    })
    RegisterThemeObject(self.BInput, "BackgroundColor3", "DropdownBg")
    RegisterThemeObject(self.BInput, "BorderColor3", "Border")
    RegisterThemeObject(self.BInput, "TextColor3", "Text")

    self.ApplyBtn = Create("TextButton", {
        Name = "Apply",
        Parent = self.PickerFrame,
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 60, 0, 18),
        Position = UDim2.new(0, 8, 0, 138),
        Font = Enum.Font.SourceSansSemibold,
        Text = "Apply",
        TextColor3 = Colors.Black,
        TextSize = 11,
        ZIndex = 20,
        AutoButtonColor = false,
    })
    RegisterThemeObject(self.ApplyBtn, "BackgroundColor3", "Accent")

    self.CancelBtn = Create("TextButton", {
        Name = "Cancel",
        Parent = self.PickerFrame,
        BackgroundColor3 = Colors.Border,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 60, 0, 18),
        Position = UDim2.new(0, 75, 0, 138),
        Font = Enum.Font.SourceSansSemibold,
        Text = "Cancel",
        TextColor3 = Colors.TextBright,
        TextSize = 11,
        ZIndex = 20,
        AutoButtonColor = false,
    })
    RegisterThemeObject(self.CancelBtn, "BackgroundColor3", "Border")
    RegisterThemeObject(self.CancelBtn, "TextColor3", "TextBright")

    local hue, sat, val = 0, 1, 1

    local function UpdateFromHSV()
        local color = Color3.fromHSV(hue, sat, val)
        self.Value = color
        self.Button.BackgroundColor3 = color
        self.Preview.BackgroundColor3 = color
        self.HexLabel.Text = string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
        self.RInput.Text = tostring(math.floor(color.R * 255))
        self.GInput.Text = tostring(math.floor(color.G * 255))
        self.BInput.Text = tostring(math.floor(color.B * 255))
        self.SVFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
    end

    local function UpdateFromRGB()
        local r = math.clamp(tonumber(self.RInput.Text) or 0, 0, 255) / 255
        local g = math.clamp(tonumber(self.GInput.Text) or 0, 0, 255) / 255
        local b = math.clamp(tonumber(self.BInput.Text) or 0, 0, 255) / 255
        local color = Color3.new(r, g, b)
        self.Value = color
        self.Button.BackgroundColor3 = color
        self.Preview.BackgroundColor3 = color
        self.HexLabel.Text = string.format("#%02X%02X%02X", r * 255, g * 255, b * 255)
        hue, sat, val = Color3.toHSV(color)
        self.SVFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
    end

    self.SVFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local absPos = self.SVFrame.AbsolutePosition
            local absSize = self.SVFrame.AbsoluteSize
            local relX = math.clamp((input.Position.X - absPos.X) / absSize.X, 0, 1)
            local relY = math.clamp((input.Position.Y - absPos.Y) / absSize.Y, 0, 1)
            sat = relX
            val = 1 - relY
            UpdateFromHSV()
        end
    end)

    self.SVFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local absPos = self.SVFrame.AbsolutePosition
            local absSize = self.SVFrame.AbsoluteSize
            local relX = math.clamp((input.Position.X - absPos.X) / absSize.X, 0, 1)
            local relY = math.clamp((input.Position.Y - absPos.Y) / absSize.Y, 0, 1)
            sat = relX
            val = 1 - relY
            UpdateFromHSV()
        end
    end)

    self.HueFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local absPos = self.HueFrame.AbsolutePosition
            local absSize = self.HueFrame.AbsoluteSize
            hue = math.clamp((input.Position.Y - absPos.Y) / absSize.Y, 0, 1)
            UpdateFromHSV()
        end
    end)

    self.HueFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local absPos = self.HueFrame.AbsolutePosition
            local absSize = self.HueFrame.AbsoluteSize
            hue = math.clamp((input.Position.Y - absPos.Y) / absSize.Y, 0, 1)
            UpdateFromHSV()
        end
    end)

    self.RInput.FocusLost:Connect(UpdateFromRGB)
    self.GInput.FocusLost:Connect(UpdateFromRGB)
    self.BInput.FocusLost:Connect(UpdateFromRGB)

    self.Button.MouseButton1Click:Connect(function()
        self.Open = not self.Open
        self.PickerFrame.Visible = self.Open
    end)

    self.ApplyBtn.MouseButton1Click:Connect(function()
        self.Open = false
        self.PickerFrame.Visible = false
        self.Callback(self.Value)
    end)

    self.CancelBtn.MouseButton1Click:Connect(function()
        self.Open = false
        self.PickerFrame.Visible = false
    end)

    return self
end

function ColorPicker:Set(color)
    self.Value = color
    self.Button.BackgroundColor3 = color
    self.Preview.BackgroundColor3 = color
    self.HexLabel.Text = string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
    self.RInput.Text = tostring(math.floor(color.R * 255))
    self.GInput.Text = tostring(math.floor(color.G * 255))
    self.BInput.Text = tostring(math.floor(color.B * 255))
    self.Callback(color)
end

-- ==================== CHECKBOX COMPONENT ====================
local Checkbox = {}
Checkbox.__index = Checkbox

function Checkbox.New(parent, text, default, callback)
    local self = setmetatable({}, Checkbox)
    self.Value = default or false
    self.Callback = callback or function() end

    self.Container = Create("Frame", {
        Name = text:gsub(" ", "") .. "Toggle",
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
    })

    self.Box = Create("Frame", {
        Name = "Box",
        Parent = self.Container,
        BackgroundColor3 = Colors.CheckboxBg,
        BorderColor3 = Colors.Border,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0, 4, 0, 4),
    })
    RegisterThemeObject(self.Box, "BackgroundColor3", "CheckboxBg")
    RegisterThemeObject(self.Box, "BorderColor3", "CheckboxBorder")

    self.Check = Create("Frame", {
        Name = "Check",
        Parent = self.Box,
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 6, 0, 6),
        Position = UDim2.new(0, 2, 0, 2),
        Visible = self.Value,
    })
    RegisterThemeObject(self.Check, "BackgroundColor3", "Accent")

    local checkGlow = Create("Frame", {
        Name = "Glow",
        Parent = self.Check,
        BackgroundColor3 = Colors.AccentBright,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.5,
    })
    RegisterThemeObject(checkGlow, "BackgroundColor3", "AccentBright")

    self.Label = Create("TextLabel", {
        Name = "Label",
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        Font = Enum.Font.SourceSans,
        Text = text,
        TextColor3 = Colors.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    RegisterThemeObject(self.Label, "TextColor3", "Text")

    local function Toggle()
        self.Value = not self.Value
        self.Check.Visible = self.Value
        self.Callback(self.Value)
    end

    self.Container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Toggle()
        end
    end)

    self.Box.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Toggle()
        end
    end)

    return self
end

function Checkbox:Set(value)
    self.Value = value
    self.Check.Visible = value
    self.Callback(value)
end

-- ==================== DROPDOWN COMPONENT ====================
local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.New(parent, text, options, callback)
    local self = setmetatable({}, Dropdown)
    self.Options = options or {}
    self.Selected = options[1] or ""
    self.Callback = callback or function() end
    self.Open = false

    self.Container = Create("Frame", {
        Name = text:gsub(" ", "") .. "Dropdown",
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 32),
        ClipsDescendants = false,
    })

    self.Label = Create("TextLabel", {
        Name = "Label",
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 20, 0, 0),
        Font = Enum.Font.SourceSans,
        Text = text,
        TextColor3 = Colors.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    RegisterThemeObject(self.Label, "TextColor3", "Text")

    self.Button = Create("TextButton", {
        Name = "Button",
        Parent = self.Container,
        BackgroundColor3 = Colors.DropdownBg,
        BorderColor3 = Colors.DropdownBorder,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 120, 0, 16),
        Position = UDim2.new(0, 20, 0, 14),
        Font = Enum.Font.SourceSans,
        Text = self.Selected,
        TextColor3 = Colors.TextBright,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
    })
    RegisterThemeObject(self.Button, "BackgroundColor3", "DropdownBg")
    RegisterThemeObject(self.Button, "BorderColor3", "DropdownBorder")
    RegisterThemeObject(self.Button, "TextColor3", "TextBright")

    Padding(self.Button, 4, 0, 0, 0)

    self.Arrow = Create("TextLabel", {
        Name = "Arrow",
        Parent = self.Button,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 12, 1, 0),
        Position = UDim2.new(1, -14, 0, 0),
        Font = Enum.Font.SourceSans,
        Text = "+",
        TextColor3 = Colors.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Center,
    })
    RegisterThemeObject(self.Arrow, "TextColor3", "Text")

    self.DropFrame = Create("Frame", {
        Name = "DropFrame",
        Parent = self.Button,
        BackgroundColor3 = Colors.DropdownBg,
        BorderColor3 = Colors.DropdownBorder,
        BorderSizePixel = 1,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        Visible = false,
        ClipsDescendants = true,
        ZIndex = 10,
    })
    RegisterThemeObject(self.DropFrame, "BackgroundColor3", "DropdownBg")
    RegisterThemeObject(self.DropFrame, "BorderColor3", "DropdownBorder")

    local dropList = ListLayout(self.DropFrame, 0)

    self.OptionButtons = {}
    for i, option in ipairs(self.Options) do
        local btn = Create("TextButton", {
            Name = option,
            Parent = self.DropFrame,
            BackgroundColor3 = Colors.DropdownBg,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 16),
            Font = Enum.Font.SourceSans,
            Text = option,
            TextColor3 = Colors.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 10,
            AutoButtonColor = false,
        })
        RegisterThemeObject(btn, "BackgroundColor3", "DropdownBg")
        RegisterThemeObject(btn, "TextColor3", "Text")

        Padding(btn, 4, 0, 0, 0)

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end)

        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Colors.DropdownBg
        end)

        btn.MouseButton1Click:Connect(function()
            self.Selected = option
            self.Button.Text = option
            self.DropFrame.Visible = false
            self.Open = false
            self.Arrow.Text = "+"
            self.Callback(option)
        end)

        table.insert(self.OptionButtons, btn)
    end

    self.Button.MouseButton1Click:Connect(function()
        self.Open = not self.Open
        self.DropFrame.Visible = self.Open
        self.Arrow.Text = self.Open and "-" or "+"
        if self.Open then
            self.DropFrame.Size = UDim2.new(1, 0, 0, #self.Options * 16)
        end
    end)

    return self
end

function Dropdown:Set(value)
    self.Selected = value
    self.Button.Text = value
    self.Callback(value)
end

-- ==================== SLIDER COMPONENT ====================
local Slider = {}
Slider.__index = Slider

function Slider.New(parent, text, min, max, default, callback)
    local self = setmetatable({}, Slider)
    self.Min = min or 0
    self.Max = max or 1
    self.Value = default or self.Min
    self.Callback = callback or function() end
    self.Dragging = false

    self.Container = Create("Frame", {
        Name = text:gsub(" ", "") .. "Slider",
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 28),
    })

    self.Label = Create("TextLabel", {
        Name = "Label",
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 20, 0, 0),
        Font = Enum.Font.SourceSans,
        Text = text,
        TextColor3 = Colors.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    RegisterThemeObject(self.Label, "TextColor3", "Text")

    self.Track = Create("Frame", {
        Name = "Track",
        Parent = self.Container,
        BackgroundColor3 = Colors.SliderTrack,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 140, 0, 4),
        Position = UDim2.new(0, 20, 0, 18),
    })
    RegisterThemeObject(self.Track, "BackgroundColor3", "SliderTrack")

    local trackBorder = Create("Frame", {
        Name = "Border",
        Parent = self.Track,
        BackgroundColor3 = Colors.SliderTrackBg,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.7,
        ZIndex = 0,
    })
    trackBorder.Size = UDim2.new(1, 4, 1, 4)
    trackBorder.Position = UDim2.new(0, -2, 0, -2)
    RegisterThemeObject(trackBorder, "BackgroundColor3", "SliderTrackBg")

    self.Fill = Create("Frame", {
        Name = "Fill",
        Parent = self.Track,
        BackgroundColor3 = Colors.SliderFill,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0),
    })
    RegisterThemeObject(self.Fill, "BackgroundColor3", "SliderFill")

    local fillGlow = Create("Frame", {
        Name = "Glow",
        Parent = self.Fill,
        BackgroundColor3 = Colors.SliderGlow,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.3,
    })
    fillGlow.Size = UDim2.new(1, 4, 1, 4)
    fillGlow.Position = UDim2.new(0, -2, 0, -2)
    RegisterThemeObject(fillGlow, "BackgroundColor3", "SliderGlow")

    self.ValueLabel = Create("TextLabel", {
        Name = "Value",
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 40, 0, 14),
        Position = UDim2.new(0, 168, 0, 12),
        Font = Enum.Font.SourceSans,
        Text = tostring(self.Value),
        TextColor3 = Colors.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    RegisterThemeObject(self.ValueLabel, "TextColor3", "Text")

    local function UpdateValue(input)
        local pos = math.clamp((input.Position.X - self.Track.AbsolutePosition.X) / self.Track.AbsoluteSize.X, 0, 1)
        self.Value = self.Min + (pos * (self.Max - self.Min))
        self.Value = math.floor(self.Value * 100) / 100
        self.Fill.Size = UDim2.new(pos, 0, 1, 0)
        self.ValueLabel.Text = tostring(self.Value)
        self.Callback(self.Value)
    end

    self.Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = true
            UpdateValue(input)
        end
    end)

    self.Track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if self.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateValue(input)
        end
    end)

    local pos = (self.Value - self.Min) / (self.Max - self.Min)
    self.Fill.Size = UDim2.new(pos, 0, 1, 0)
    self.ValueLabel.Text = tostring(self.Value)

    return self
end

function Slider:Set(value)
    self.Value = math.clamp(value, self.Min, self.Max)
    local pos = (self.Value - self.Min) / (self.Max - self.Min)
    self.Fill.Size = UDim2.new(pos, 0, 1, 0)
    self.ValueLabel.Text = tostring(self.Value)
    self.Callback(self.Value)
end

-- ==================== SECTION COMPONENT ====================
local Section = {}
Section.__index = Section

function Section.New(parent, title)
    local self = setmetatable({}, Section)

    self.Container = Create("Frame", {
        Name = title:gsub(" ", "") .. "Section",
        Parent = parent,
        BackgroundColor3 = Colors.SectionBg,
        BorderColor3 = Colors.Border,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 230, 0, 50),
        AutomaticSize = Enum.AutomaticSize.Y,
    })
    RegisterThemeObject(self.Container, "BackgroundColor3", "SectionBg")
    RegisterThemeObject(self.Container, "BorderColor3", "Border")

    self.Title = Create("TextLabel", {
        Name = "Title",
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 18),
        Position = UDim2.new(0, 5, 0, 2),
        Font = Enum.Font.SourceSansSemibold,
        Text = "-" .. title,
        TextColor3 = Colors.SectionTitle,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    RegisterThemeObject(self.Title, "TextColor3", "SectionTitle")

    self.Underline = Create("Frame", {
        Name = "Underline",
        Parent = self.Container,
        BackgroundColor3 = Colors.SectionUnderline,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -10, 0, 1),
        Position = UDim2.new(0, 5, 0, 18),
    })
    RegisterThemeObject(self.Underline, "BackgroundColor3", "SectionUnderline")

    self.Content = Create("Frame", {
        Name = "Content",
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 0),
        Position = UDim2.new(0, 5, 0, 22),
        AutomaticSize = Enum.AutomaticSize.Y,
    })

    ListLayout(self.Content, 2)

    self.Content:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self.Container.Size = UDim2.new(0, 230, 0, self.Content.AbsoluteSize.Y + 28)
    end)

    return self
end

function Section:CreateToggle(text, default, callback)
    return Checkbox.New(self.Content, text, default, callback)
end

function Section:CreateDropdown(text, options, callback)
    return Dropdown.New(self.Content, text, options, callback)
end

function Section:CreateSlider(text, min, max, default, callback)
    return Slider.New(self.Content, text, min, max, default, callback)
end

function Section:CreateColorPicker(text, default, callback)
    return ColorPicker.New(self.Content, text, default, callback)
end

-- ==================== TAB COMPONENT ====================
local Tab = {}
Tab.__index = Tab

function Tab.New(parent, name, window)
    local self = setmetatable({}, Tab)
    self.Name = name
    self.Window = window
    self.Sections = {}

    self.Button = Create("TextButton", {
        Name = name .. "Tab",
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 70, 0, 24),
        Font = Enum.Font.SourceSans,
        Text = name,
        TextColor3 = Colors.TabInactive,
        TextSize = 13,
        AutoButtonColor = false,
    })
    RegisterThemeObject(self.Button, "TextColor3", "TabInactive")

    self.Underline = Create("Frame", {
        Name = "Underline",
        Parent = self.Button,
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        Visible = false,
    })
    RegisterThemeObject(self.Underline, "BackgroundColor3", "Accent")

    self.Content = Create("Frame", {
        Name = name .. "Content",
        Parent = window.ContentFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false,
    })

    self.LeftColumn = Create("Frame", {
        Name = "Left",
        Parent = self.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 240, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
    })

    self.RightColumn = Create("Frame", {
        Name = "Right",
        Parent = self.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 240, 1, 0),
        Position = UDim2.new(0, 255, 0, 0),
    })

    ListLayout(self.LeftColumn, 8)
    ListLayout(self.RightColumn, 8)

    self.Button.MouseButton1Click:Connect(function()
        self.Window:SelectTab(self)
    end)

    return self
end

function Tab:CreateSection(title, column)
    column = column or "left"
    local parent = column == "left" and self.LeftColumn or self.RightColumn
    local section = Section.New(parent, title)
    table.insert(self.Sections, section)
    return section
end

function Tab:Show()
    self.Content.Visible = true
    self.Button.TextColor3 = Colors.TabActive
    self.Underline.Visible = true
end

function Tab:Hide()
    self.Content.Visible = false
    self.Button.TextColor3 = Colors.TabInactive
    self.Underline.Visible = false
end

-- ==================== KEYBINDS PANEL ====================
local KeybindsPanel = {}
KeybindsPanel.__index = KeybindsPanel

function KeybindsPanel.New(parent)
    local self = setmetatable({}, KeybindsPanel)
    self.Keybinds = {}

    self.Container = Create("Frame", {
        Name = "KeybindsPanel",
        Parent = parent,
        BackgroundColor3 = Colors.KeybindsBg,
        BorderColor3 = Colors.KeybindsBorder,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 167, 0, 91),
        Position = UDim2.new(0, 10, 0, 10),
    })
    RegisterThemeObject(self.Container, "BackgroundColor3", "KeybindsBg")
    RegisterThemeObject(self.Container, "BorderColor3", "KeybindsBorder")

    self.TitleBar = Create("Frame", {
        Name = "TitleBar",
        Parent = self.Container,
        BackgroundColor3 = Colors.KeybindsTitleBg,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 16),
    })
    RegisterThemeObject(self.TitleBar, "BackgroundColor3", "KeybindsTitleBg")

    self.Title = Create("TextLabel", {
        Name = "Title",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.SourceSansSemibold,
        Text = "keybinds",
        TextColor3 = Colors.Accent,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Center,
    })
    RegisterThemeObject(self.Title, "TextColor3", "Accent")

    self.Content = Create("Frame", {
        Name = "Content",
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, -22),
        Position = UDim2.new(0, 5, 0, 18),
    })

    ListLayout(self.Content, 2)

    return self
end

function KeybindsPanel:AddKeybind(key, action, callback)
    local row = Create("Frame", {
        Name = action .. "Row",
        Parent = self.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
    })

    local keyLabel = Create("TextLabel", {
        Name = "Key",
        Parent = row,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 50, 1, 0),
        Font = Enum.Font.SourceSans,
        Text = "[" .. key:upper() .. "]",
        TextColor3 = Colors.Accent,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    RegisterThemeObject(keyLabel, "TextColor3", "Accent")

    local actionLabel = Create("TextLabel", {
        Name = "Action",
        Parent = row,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -55, 1, 0),
        Position = UDim2.new(0, 55, 0, 0),
        Font = Enum.Font.SourceSans,
        Text = action .. " (toggle)",
        TextColor3 = Colors.KeybindsText,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    RegisterThemeObject(actionLabel, "TextColor3", "KeybindsText")

    table.insert(self.Keybinds, {Key = key, Action = action, Callback = callback})

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode.Name:upper() == key:upper() then
            callback()
        end
    end)
end

-- ==================== NAME TAG ====================
local NameTag = {}
NameTag.__index = NameTag

function NameTag.New(parent, text)
    local self = setmetatable({}, NameTag)

    self.Container = Create("Frame", {
        Name = "NameTag",
        Parent = parent,
        BackgroundColor3 = Colors.NameTagBg,
        BorderColor3 = Colors.NameTagBorder,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 131, 0, 24),
        Position = UDim2.new(1, -141, 0, 10),
    })
    RegisterThemeObject(self.Container, "BackgroundColor3", "NameTagBg")
    RegisterThemeObject(self.Container, "BorderColor3", "NameTagBorder")

    self.Label = Create("TextLabel", {
        Name = "Label",
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.SourceSansSemibold,
        Text = text,
        TextColor3 = Colors.NameTagText,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Center,
    })
    RegisterThemeObject(self.Label, "TextColor3", "NameTagText")

    return self
end

-- ==================== MAIN WINDOW ====================
local Window = {}
Window.__index = Window

function Window.New(title)
    local self = setmetatable({}, Window)
    self.Tabs = {}
    self.ActiveTab = nil
    self.Visible = true

    self.Gui = Create("ScreenGui", {
        Name = "SymbolHitUI",
        Parent = game.CoreGui or LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })

    self.Main = Create("Frame", {
        Name = "Main",
        Parent = self.Gui,
        BackgroundColor3 = Colors.Background,
        BorderColor3 = Colors.OuterBorder,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 510, 0, 652),
        Position = UDim2.new(0.5, -255, 0.5, -326),
    })
    RegisterThemeObject(self.Main, "BackgroundColor3", "Background")
    RegisterThemeObject(self.Main, "BorderColor3", "OuterBorder")

    local mainStroke = Create("UIStroke", {
        Color = Colors.OuterBorder,
        Thickness = 1,
        Parent = self.Main,
    })
    RegisterThemeObject(mainStroke, "Color", "OuterBorder")

    self.TitleBar = Create("Frame", {
        Name = "TitleBar",
        Parent = self.Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
    })

    self.Title = Create("TextLabel", {
        Name = "Title",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.SourceSansSemibold,
        Text = "Symbol.hit",
        TextColor3 = Colors.Accent,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Center,
    })
    RegisterThemeObject(self.Title, "TextColor3", "Accent")

    self.TabBar = Create("Frame", {
        Name = "TabBar",
        Parent = self.Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 28),
        Position = UDim2.new(0, 10, 0, 20),
    })

    local tabList = ListLayout(self.TabBar, 0, Enum.HorizontalAlignment.Left)

    self.ContentFrame = Create("Frame", {
        Name = "Content",
        Parent = self.Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -55),
        Position = UDim2.new(0, 10, 0, 50),
    })

    self.NameTag = NameTag.New(self.Main, title or "Symbol.hit | private")
    self.Keybinds = KeybindsPanel.New(self.Gui)

    MakeDraggable(self.Main, self.TitleBar)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
            self:Toggle()
        end
    end)

    return self
end

function Window:CreateTab(name)
    local tab = Tab.New(self.TabBar, name, self)
    table.insert(self.Tabs, tab)

    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end

    return tab
end

function Window:SelectTab(tab)
    if self.ActiveTab then
        self.ActiveTab:Hide()
    end
    self.ActiveTab = tab
    tab:Show()
end

function Window:AddKeybind(key, action, callback)
    self.Keybinds:AddKeybind(key, action, callback)
end

function Window:Toggle(show)
    if show ~= nil then
        self.Visible = show
    else
        self.Visible = not self.Visible
    end
    self.Main.Visible = self.Visible
    self.Keybinds.Container.Visible = self.Visible
    self.NameTag.Container.Visible = self.Visible
end

function Window:Destroy()
    self.Gui:Destroy()
end

-- ==================== SYMBOL LIBRARY ====================
function Symbol:CreateWindow(title)
    return Window.New(title)
end

return Symbol
