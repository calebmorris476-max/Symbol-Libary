--[[
    Symbol.hit UI Library
    A 1:1 recreation of the Symbol.hit cheat GUI

    Usage:
        local Symbol = loadstring(library_source)()
        local Window = Symbol:CreateWindow("Symbol.hit | private")

        local CombatTab = Window:CreateTab("combat")
        local VisualsTab = Window:CreateTab("visuals")
        local MiscTab = Window:CreateTab("misc")
        local DesyncTab = Window:CreateTab("desync")
        local SettingsTab = Window:CreateTab("settings")

        -- Sections
        local CombatSection = CombatTab:CreateSection("Combat")
        local StuffSection = CombatTab:CreateSection("Stuff")
        local TargetingSection = CombatTab:CreateSection("Targeting")

        -- Elements
        local SilentAim = CombatSection:CreateToggle("Silent Aim", false, function(Value)
            print("Silent Aim:", Value)
        end)

        local RezikMode = CombatSection:CreateDropdown("Rezik Mode", {"Velocity"}, function(Value)
            print("Rezik Mode:", Value)
        end)

        local AimPart = CombatSection:CreateDropdown("Aim Part", {"Head"}, function(Value)
            print("Aim Part:", Value)
        end)

        local PredX = CombatSection:CreateSlider("Prediction X/Z", 0, 1, 0.13, function(Value)
            print("Prediction X/Z:", Value)
        end)

        local PredY = CombatSection:CreateSlider("Prediction Y", 0, 1, 0.13, function(Value)
            print("Prediction Y:", Value)
        end)

        local AutoShoot = CombatSection:CreateToggle("Auto Shoot", false, function(Value)
            print("Auto Shoot:", Value)
        end)

        local AutoShootMode = CombatSection:CreateDropdown("Auto Shoot Mode", {"Manual"}, function(Value)
            print("Auto Shoot Mode:", Value)
        end)

        local AutoStomp = CombatSection:CreateToggle("Auto Stomp", false, function(Value)
            print("Auto Stomp:", Value)
        end)

        local StompDelay = CombatSection:CreateSlider("Stomp Sync Delay", 0, 1, 0.8, function(Value)
            print("Stomp Sync Delay:", Value)
        end)

        local ViewTarget = CombatSection:CreateToggle("View Target", false, function(Value)
            print("View Target:", Value)
        end)

        -- Stuff Section
        local AutoReload = StuffSection:CreateToggle("Auto Reload", false, function(Value)
            print("Auto Reload:", Value)
        end)

        local OverrideHide = StuffSection:CreateToggle("Override Hide On Unavailable", false, function(Value)
            print("Override Hide:", Value)
        end)

        local MultiGuns = StuffSection:CreateToggle("Multi Guns", false, function(Value)
            print("Multi Guns:", Value)
        end)

        local FakeposV1 = StuffSection:CreateToggle("Fakepos V1", false, function(Value)
            print("Fakepos V1:", Value)
        end)

        local FakeposV2 = StuffSection:CreateToggle("Fakepos V2", false, function(Value)
            print("Fakepos V2:", Value)
        end)

        -- Notifications
        local NotifEnabled = StuffSection:CreateToggle("Enabled", false, function(Value)
            print("Notifications:", Value)
        end)

        local NotifMode = StuffSection:CreateDropdown("Select, Hit", {"On"}, function(Value)
            print("Notif Mode:", Value)
        end)

        -- Targeting Section
        local TargetingEnabled = TargetingSection:CreateToggle("Enabled", false, function(Value)
            print("Targeting:", Value)
        end)

        local AutoSelect = TargetingSection:CreateToggle("Auto Select", false, function(Value)
            print("Auto Select:", Value)
        end)

        local FilterBy = TargetingSection:CreateDropdown("Filter Targets By", {"Nearest To Mouse"}, function(Value)
            print("Filter:", Value)
        end)

        local Checks = TargetingSection:CreateDropdown("Checks", {""}, function(Value)
            print("Checks:", Value)
        end)

        local UseFov = TargetingSection:CreateToggle("Use Fov", false, function(Value)
            print("Use Fov:", Value)
        end)

        local FovSize = TargetingSection:CreateSlider("Fov Size", 0, 500, 100, function(Value)
            print("Fov Size:", Value)
        end)

        -- Keybinds
        Window:AddKeybind("Z", "target", function() end)
        Window:AddKeybind("C", "speedhack", function() end)
        Window:AddKeybind("X", "flyhack", function() end)
        Window:AddKeybind("INS", "menu", function() end)

        -- Toggle UI
        Window:Toggle(true) -- Show
]]

local Symbol = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Color Palette (extracted from screenshots)
local Colors = {
    Background = Color3.fromRGB(22, 22, 22),
    SectionBg = Color3.fromRGB(28, 28, 28),
    Border = Color3.fromRGB(40, 40, 40),
    OuterBorder = Color3.fromRGB(20, 42, 26),
    Text = Color3.fromRGB(155, 155, 153),
    TextBright = Color3.fromRGB(170, 170, 168),
    Green = Color3.fromRGB(45, 195, 62),
    GreenBright = Color3.fromRGB(49, 196, 63),
    GreenDark = Color3.fromRGB(0, 122, 0),
    GreenGlow = Color3.fromRGB(42, 127, 71),
    GreenSlider = Color3.fromRGB(10, 219, 39),
    GreenSliderGlow = Color3.fromRGB(67, 192, 96),
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
}

-- Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    return instance
end

local function RoundCorner(instance, radius)
    local corner = Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 0),
        Parent = instance
    })
    return corner
end

local function Stroke(instance, color, thickness)
    local stroke = Create("UIStroke", {
        Color = color or Colors.Border,
        Thickness = thickness or 1,
        Parent = instance
    })
    return stroke
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

-- Draggable functionality
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

    self.Check = Create("Frame", {
        Name = "Check",
        Parent = self.Box,
        BackgroundColor3 = Colors.Green,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 6, 0, 6),
        Position = UDim2.new(0, 2, 0, 2),
        Visible = self.Value,
    })

    -- Add glow effect to check
    local checkGlow = Create("Frame", {
        Name = "Glow",
        Parent = self.Check,
        BackgroundColor3 = Colors.GreenBright,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.5,
    })

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

    -- Interaction
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

    self.Track = Create("Frame", {
        Name = "Track",
        Parent = self.Container,
        BackgroundColor3 = Colors.SliderTrack,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 140, 0, 4),
        Position = UDim2.new(0, 20, 0, 18),
    })

    -- Track border/glow
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

    self.Fill = Create("Frame", {
        Name = "Fill",
        Parent = self.Track,
        BackgroundColor3 = Colors.GreenSlider,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0),
    })

    -- Fill glow
    local fillGlow = Create("Frame", {
        Name = "Glow",
        Parent = self.Fill,
        BackgroundColor3 = Colors.GreenSliderGlow,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 0.3,
    })
    fillGlow.Size = UDim2.new(1, 4, 1, 4)
    fillGlow.Position = UDim2.new(0, -2, 0, -2)

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

    -- Set initial
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

    -- Underline
    self.Underline = Create("Frame", {
        Name = "Underline",
        Parent = self.Container,
        BackgroundColor3 = Colors.SectionUnderline,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -10, 0, 1),
        Position = UDim2.new(0, 5, 0, 18),
    })

    self.Content = Create("Frame", {
        Name = "Content",
        Parent = self.Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 0),
        Position = UDim2.new(0, 5, 0, 22),
        AutomaticSize = Enum.AutomaticSize.Y,
    })

    ListLayout(self.Content, 2)

    -- Update container size when content changes
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

    self.Underline = Create("Frame", {
        Name = "Underline",
        Parent = self.Button,
        BackgroundColor3 = Colors.Green,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        Visible = false,
    })

    self.Content = Create("Frame", {
        Name = name .. "Content",
        Parent = window.ContentFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false,
    })

    -- Two column layout
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

    self.TitleBar = Create("Frame", {
        Name = "TitleBar",
        Parent = self.Container,
        BackgroundColor3 = Colors.KeybindsTitleBg,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 16),
    })

    self.Title = Create("TextLabel", {
        Name = "Title",
        Parent = self.TitleBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.SourceSansSemibold,
        Text = "keybinds",
        TextColor3 = Colors.Green,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Center,
    })

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
        TextColor3 = Colors.Green,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

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

    table.insert(self.Keybinds, {Key = key, Action = action, Callback = callback})

    -- Listen for key
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

    -- ScreenGui
    self.Gui = Create("ScreenGui", {
        Name = "SymbolHitUI",
        Parent = game.CoreGui or LocalPlayer:WaitForChild("PlayerGui"),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })

    -- Main Frame
    self.Main = Create("Frame", {
        Name = "Main",
        Parent = self.Gui,
        BackgroundColor3 = Colors.Background,
        BorderColor3 = Colors.OuterBorder,
        BorderSizePixel = 1,
        Size = UDim2.new(0, 510, 0, 652),
        Position = UDim2.new(0.5, -255, 0.5, -326),
    })

    Stroke(self.Main, Colors.OuterBorder, 1)

    -- Title Bar ("Symbol.hit" at top center)
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
        TextColor3 = Colors.Green,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    -- Tab Bar
    self.TabBar = Create("Frame", {
        Name = "TabBar",
        Parent = self.Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 28),
        Position = UDim2.new(0, 10, 0, 20),
    })

    local tabList = ListLayout(self.TabBar, 0, Enum.HorizontalAlignment.Left)

    -- Content Frame
    self.ContentFrame = Create("Frame", {
        Name = "Content",
        Parent = self.Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -55),
        Position = UDim2.new(0, 10, 0, 50),
    })

    -- Name Tag (top right)
    self.NameTag = NameTag.New(self.Main, title or "Symbol.hit | private")

    -- Keybinds Panel (top left)
    self.Keybinds = KeybindsPanel.New(self.Gui)

    -- Draggable
    MakeDraggable(self.Main, self.TitleBar)

    -- Toggle with Insert key
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
