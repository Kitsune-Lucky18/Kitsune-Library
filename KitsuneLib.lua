-- KitsuneLib.lua (Fexed Style + Premium Tab Gate)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

local KitsuneLib = {}

-- Theme list
KitsuneLib.Themes = {
    Dark   = {Background = Color3.fromRGB(30,30,30), Text = Color3.fromRGB(255,255,255)},
    Light  = {Background = Color3.fromRGB(240,240,240), Text = Color3.fromRGB(0,0,0)},
    Blood  = {Background = Color3.fromRGB(50,0,0), Text = Color3.fromRGB(255,255,255)},
    Ocean  = {Background = Color3.fromRGB(0,40,80), Text = Color3.fromRGB(200,230,255)},
    Forest = {Background = Color3.fromRGB(20,60,20), Text = Color3.fromRGB(220,255,220)},
    Cyber  = {Background = Color3.fromRGB(10,10,30), Text = Color3.fromRGB(0,255,180)},
}

local function HasGamepass(id)
    local success, owns = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, id)
    end)
    return success and owns
end

-- Create Window
function KitsuneLib:CreateWindow(config)
    local theme = self.Themes[config.Theme] or self.Themes.Dark

    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "KitsuneHub"

    local mainFrame = Instance.new("Frame", gui)
    mainFrame.Size = UDim2.new(0, 600, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
    mainFrame.BackgroundColor3 = theme.Background
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)
    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Thickness = 2
    stroke.Color = theme.Text

    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1,0,0,40)
    title.Text = config.Name or "Kitsune Hub"
    title.TextColor3 = theme.Text
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24

    local TabHolder = Instance.new("Frame", mainFrame)
    TabHolder.Size = UDim2.new(0,150,1,-40)
    TabHolder.Position = UDim2.new(0,0,0,40)
    TabHolder.BackgroundColor3 = theme.Background
    Instance.new("UICorner", TabHolder).CornerRadius = UDim.new(0,12)

    local ContentHolder = Instance.new("Frame", mainFrame)
    ContentHolder.Size = UDim2.new(1,-150,1,-40)
    ContentHolder.Position = UDim2.new(0,150,0,40)
    ContentHolder.BackgroundColor3 = theme.Background
    Instance.new("UICorner", ContentHolder).CornerRadius = UDim.new(0,12)

    local Window = {Tabs = {}, Theme = theme, ContentHolder = ContentHolder, TabHolder = TabHolder}
    function Window:CreateTab(name, iconId, premiumId)
        local TabButton = Instance.new("TextButton", TabHolder)
        TabButton.Size = UDim2.new(1,0,0,40)
        TabButton.BackgroundColor3 = theme.Background
        TabButton.Text = ""

        local Icon = Instance.new("ImageLabel", TabButton)
        Icon.Size = UDim2.new(0,24,0,24)
        Icon.Position = UDim2.new(0,10,0.5,-12)
        Icon.Image = "rbxassetid://"..iconId
        Icon.BackgroundTransparency = 1

        local Label = Instance.new("TextLabel", TabButton)
        Label.Size = UDim2.new(1,-40,1,0)
        Label.Position = UDim2.new(0,40,0,0)
        Label.Text = name
        Label.TextColor3 = theme.Text
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 18

        local TabFrame = Instance.new("Frame", ContentHolder)
        TabFrame.Size = UDim2.new(1,0,1,0)
        TabFrame.Visible = false
        TabFrame.BackgroundTransparency = 1

        TabButton.MouseButton1Click:Connect(function()
            if premiumId and not HasGamepass(premiumId) then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, premiumId)
                return
            end
            for _,child in pairs(ContentHolder:GetChildren()) do
                if child:IsA("Frame") then child.Visible = false end
            end
            TabFrame.Visible = true
        end)

        local Tab = {Sections = {}, Frame = TabFrame}
        function Tab:CreateSection(name)
            local SectionLabel = Instance.new("TextLabel", TabFrame)
            SectionLabel.Size = UDim2.new(1,0,0,30)
            SectionLabel.Text = name
            SectionLabel.TextColor3 = theme.Text
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextSize = 20

            local SectionFrame = Instance.new("Frame", TabFrame)
            SectionFrame.Size = UDim2.new(1,0,0,200)
            SectionFrame.Position = UDim2.new(0,0,0,30)
            SectionFrame.BackgroundTransparency = 1

            local Section = {Frame = SectionFrame}
            return Section
        end
        table.insert(self.Tabs, Tab)
        return Tab
    end
    return Window
end

-- Elements
function KitsuneLib:CreateToggle(section, config)
    local btn = Instance.new("TextButton", section.Frame)
    btn.Size = UDim2.new(1,0,0,30)
    btn.Text = config.Name.." : OFF"
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local state = config.CurrentValue or false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = config.Name.." : "..(state and "ON" or "OFF")
        if config.Callback then config.Callback(state) end
    end)
end

function KitsuneLib:CreateButton(section, config)
    local btn = Instance.new("TextButton", section.Frame)
    btn.Size = UDim2.new(1,0,0,30)
    btn.Text = config.Name
    btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    btn.MouseButton1Click:Connect(function()
        if config.Callback then config.Callback() end
    end)
end

function KitsuneLib:CreateSlider(section, config)
    local slider = Instance.new("TextButton", section.Frame)
    slider.Size = UDim2.new(1,0,0,30)
    slider.Text = config.Name.." : "..config.CurrentValue
    slider.BackgroundColor3 = Color3.fromRGB(100,100,100)
    slider.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0,8)

    local value = config.CurrentValue or config.Range[1]
    slider.MouseButton1Click:Connect(function()
        value = value + 1
        if value > config.Range[2] then value = config.Range[1] end
        slider.Text = config.Name.." : "..value
        if config.Callback then config.Callback(value) end
    end)
end

function KitsuneLib:CreateDropdown(section, config)
    local btn = Instance.new("TextButton", section.Frame)
    btn.Size = UDim2.new(1,0,0,30)
    btn.Text = config.Name.." : "..config.CurrentOption
    btn.BackgroundColor3 = Color3.fromRGB(120,120,120)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local current = config.CurrentOption
    btn.MouseButton1Click:Connect(function()
        local idx = table.find(config.Options, current) or 1
        idx = idx % #config.Options + 1
        current = config.Options[idx]
        btn.Text = config.Name.." : "..current
        if config.Callback then config.Callback(current) end
    end)
end

function KitsuneLib:CreateKeybind(section, config)
    local btn = Instance.new("TextButton", section.Frame)
    btn.Size = UDim2.new(1,0,0,30)
    btn.Text = config.Name.." : "..config.CurrentKey
    btn.BackgroundColor3 = Color3.fromRGB(140,140,140)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local key = config.CurrentKey
    btn.MouseButton1Click:Connect(function()
        btn.Text = config.Name.." : Press any key..."
        local conn
        conn = game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
            if gpe then return end
            key = input.KeyCode.Name
            btn.Text = config.Name.." : "..key
            if config.Callback then config.Callback(key) end
            conn:Disconnect()
        end)
    end)
end

function KitsuneLib:CreateTextbox(section, config)
    local box = Instance.new("TextBox", section.Frame)
    box.Size = UDim2.new(1,0,0,30)
    box.PlaceholderText = config.Name
    box.BackgroundColor3 = Color3.fromRGB(160,160,160)
    box.TextColor3 = Color3.fromRGB(0,0,0)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)

    box.FocusLost:Connect(function()
        if config.Callback then config.Callback(box.Text) end
    end)
end

function KitsuneLib:Notify(config)
    local msgFrame = Instance.new("Frame", LocalPlayer:WaitForChild("PlayerGui"))
    msgFrame.Size = UDim2.new(0,300,0,60)
    msgFrame.Position = UDim2.new(0.5,-150,0.1,0)
    msgFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Instance.new("UICorner", msgFrame).CornerRadius = UDim.new(0,12)
    local stroke = Instance.new("UIStroke", msgFrame)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255,255,255)

    local title = Instance.new("TextLabel", msgFrame)
    title.Size = UDim2.new(1,0,0,25)
    title.Text = config.Title or "Notification"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18

    local content = Instance.new("TextLabel", msgFrame)
    content.Size = UDim2.new(1,0,0,35)
    content.Position = UDim2.new(0,0,0,25)
    content.Text = config.Content or ""
    content.TextColor3 = Color3.fromRGB(200,200,200)
    content.BackgroundTransparency = 1
    content.Font = Enum.Font.Gotham
    content.TextSize = 16

    game:GetService("Debris"):AddItem(msgFrame, config.Duration or 3)
end

return KitsuneLib
