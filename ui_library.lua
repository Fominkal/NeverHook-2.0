-- ui_library.lua

local UI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local CoralColor = Color3.fromRGB(255, 170, 180)
local BackgroundColor = Color3.fromRGB(25, 25, 25)
local AccentColor = Color3.fromRGB(40, 40, 40)
local TextColor = Color3.fromRGB(240, 240, 240)

function UI:Create()
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "MinimalistUI"
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = BackgroundColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    Instance.new("UICorner", MainFrame)
    Instance.new("UIStroke", MainFrame).Color = AccentColor

    -- Dragging variables
    local dragging = false
    local dragInput, dragStart, startPos
    local draggingSlider = false

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not draggingSlider then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Tab Bar
    local TabBar = Instance.new("Frame", MainFrame)
    TabBar.Size = UDim2.new(0, 120, 1, 0)
    TabBar.Position = UDim2.new(0, 0, 0, 0)
    TabBar.BackgroundColor3 = AccentColor
    Instance.new("UICorner", TabBar)

    local TabLayout = Instance.new("UIListLayout", TabBar)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    TabLayout.Padding = UDim.new(0, 10)

    local ContentFrame = Instance.new("Frame", MainFrame)
    ContentFrame.Size = UDim2.new(1, -140, 1, -20)
    ContentFrame.Position = UDim2.new(0, 130, 0, 10)
    ContentFrame.BackgroundColor3 = BackgroundColor
    ContentFrame.BorderSizePixel = 0
    Instance.new("UICorner", ContentFrame)

    local Tabs = {}

    local function CreateTab(name)
        local tabButton = Instance.new("TextButton", TabBar)
        tabButton.Size = UDim2.new(1, -10, 0, 30)
        tabButton.BackgroundColor3 = BackgroundColor
        tabButton.BorderSizePixel = 0
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.TextColor3 = TextColor
        tabButton.AutoButtonColor = true

        if name == "ESP" then
            tabButton.Text = ""
            tabButton.BackgroundTransparency = 1
            tabButton.AutoButtonColor = false

            local label = Instance.new("TextLabel", tabButton)
            label.Size = UDim2.new(0, 40, 1, 0)
            label.Position = UDim2.new(0, 5, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = "Visuals</>"
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = TextColor
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextYAlignment = Enum.TextYAlignment.Center

            local Icon = Instance.new("ImageLabel", tabButton)
            Icon.Size = UDim2.new(0, 20, 0, 20)
            Icon.Position = UDim2.new(0, 70, 0.5, -10)
            Icon.BackgroundTransparency = 1
            Icon.Image = "rbxassetid://6034287594"
        else
            tabButton.Text = name
            Instance.new("UICorner", tabButton)
        end

        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = ContentFrame

        local layout = Instance.new("UIListLayout", tabContent)
        layout.Padding = UDim.new(0, 6)
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        Tabs[name] = { Button = tabButton, Content = tabContent }

        tabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                tab.Content.Visible = false
            end
            tabContent.Visible = true
        end)

        return tabContent
    end

    function UI.CreateCheckbox(parent, text, callback)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0, 30, 0, 30)
        container.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(1, -40, 0.90, 0)
        label.Position = UDim2.new(0, 32, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = TextColor
        label.Font = Enum.Font.Gotham
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center

        local box = Instance.new("Frame", container)
        box.Size = UDim2.new(0, 14, 0, 14)
        box.Position = UDim2.new(1, -27, 0.5, -7)
        box.BackgroundTransparency = 1
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

        local stroke = Instance.new("UIStroke", box)
        stroke.Color = CoralColor
        stroke.Thickness = 2

        local fill = Instance.new("Frame", box)
        fill.Size = UDim2.new(1, 0, 1, 0)
        fill.BackgroundColor3 = CoralColor
        fill.BorderSizePixel = 0
        fill.Visible = false
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

        local clickArea = Instance.new("TextButton", box)
        clickArea.Size = UDim2.new(1, 0, 1, 0)
        clickArea.BackgroundTransparency = 1
        clickArea.Text = ""
        clickArea.AutoButtonColor = false

        local state = false
        clickArea.MouseButton1Click:Connect(function()
            state = not state
            fill.Visible = state
            if callback then callback(state) end
        end)
    end

    function UI.CreateSlider(parent, text, min, max, default, callback)
        local frame = Instance.new("Frame", parent)
        frame.Size = UDim2.new(0, 300, 0, 40)
        frame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, 0, 0, 0)
        label.Text = text .. ": " .. default
        label.TextColor3 = TextColor
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left

        local sliderBar = Instance.new("Frame", frame)
        sliderBar.Position = UDim2.new(0, 0, 0, 12)
        sliderBar.Size = UDim2.new(1, 0, 0, 7)
        sliderBar.BackgroundColor3 = AccentColor
        sliderBar.BorderSizePixel = 0
        sliderBar.Active = true
        Instance.new("UICorner", sliderBar)

        local fill = Instance.new("Frame", sliderBar)
        fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
        fill.BackgroundColor3 = CoralColor
        fill.BorderSizePixel = 0
        fill.Name = "Fill"
        Instance.new("UICorner", fill)

        local draggingSlider = false

        local function update(inputX)
            local rel = math.clamp((inputX - sliderBar.AbsolutePosition.X)/sliderBar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            local value = math.floor((min + (max - min) * rel) + 0.5)
            label.Text = text .. ": " .. value
            if callback then callback(value) end
        end

        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingSlider = true
                update(input.Position.X)
            end
        end)

        sliderBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingSlider = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                update(input.Position.X)
            end
        end)
    end

    -- Пример табов и элементов
    local Tab1 = CreateTab("Aimbot")
    UI.CreateCheckbox(Tab1, "Enable Aimbot", function(state)
        print("Aimbot:", state)
    end)
    UI.CreateSlider(Tab1, "Aimbot FOV", 0, 100, 50, function(val)
        print("FOV:", val)
    end)

    local Tab2 = CreateTab("ESP")
    UI.CreateCheckbox(Tab2, "Player ESP", function(state)
        print("ESP:", state)
    end)
    UI.CreateSlider(Tab2, "ESP Distance", 50, 1000, 500, function(val)
        print("ESP Distance:", val)
    end)

    local Tab3 = CreateTab("Binds")
    local label = Instance.new("TextLabel", Tabs["Binds"].Content)
    label.Text = "Press a key to bind"
    label.TextColor3 = TextColor
    label.BackgroundTransparency = 1

    return {
        ScreenGui = ScreenGui,
        Tabs = Tabs
    }
end

return UI
