-- Kitsune Library (Clean + Premium UI)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")
local UIS = game:GetService("UserInputService")

local KitsuneLib = {}

-- THEMES
KitsuneLib.Themes = {
    Dark = {BG = Color3.fromRGB(20,20,25), Card = Color3.fromRGB(30,30,35), Text = Color3.fromRGB(255,255,255)},
    Kitsune = {BG = Color3.fromRGB(15,15,20), Card = Color3.fromRGB(35,20,20), Text = Color3.fromRGB(255,120,80)}
}

-- GAMEPASS CHECK
local function HasGamepass(id)
    local success, owns = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, id)
    end)
    return success and owns
end

-- DRAG SYSTEM
local function MakeDraggable(frame)
    local dragging, dragInput, startPos, startFramePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = input.Position
            startFramePos = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startPos
            frame.Position = startFramePos + UDim2.new(0, delta.X, 0, delta.Y)
        end
    end)
end

-- CREATE WINDOW
function KitsuneLib:CreateWindow(config)
    local theme = self.Themes[config.Theme] or self.Themes.Dark

    local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    gui.Name = "KitsuneHub"

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 620, 0, 380)
    main.Position = UDim2.new(0.5, -310, 0.5, -190)
    main.BackgroundColor3 = theme.BG
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

    MakeDraggable(main)

    -- TITLE
    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1,0,0,40)
    title.Text = config.Name or "Kitsune Hub"
    title.BackgroundTransparency = 1
    title.TextColor3 = theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22

    -- TAB HOLDER
    local tabHolder = Instance.new("Frame", main)
    tabHolder.Size = UDim2.new(0,150,1,-40)
    tabHolder.Position = UDim2.new(0,0,0,40)
    tabHolder.BackgroundColor3 = theme.Card
    Instance.new("UICorner", tabHolder)

    local tabLayout = Instance.new("UIListLayout", tabHolder)
    tabLayout.Padding = UDim.new(0,5)

    -- CONTENT
    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1,-150,1,-40)
    content.Position = UDim2.new(0,150,0,40)
    content.BackgroundColor3 = theme.BG

    local Window = {}

    function Window:CreateTab(name, iconId, premiumId)
        local btn = Instance.new("TextButton", tabHolder)
        btn.Size = UDim2.new(1,0,0,40)
        btn.Text = "   "..name
        btn.TextColor3 = theme.Text
        btn.BackgroundColor3 = theme.Card
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16

        local tabFrame = Instance.new("ScrollingFrame", content)
        tabFrame.Size = UDim2.new(1,0,1,0)
        tabFrame.CanvasSize = UDim2.new(0,0,0,0)
        tabFrame.ScrollBarThickness = 4
        tabFrame.Visible = false
        tabFrame.BackgroundTransparency = 1

        local layout = Instance.new("UIListLayout", tabFrame)
        layout.Padding = UDim.new(0,10)

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabFrame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
        end)

        btn.MouseButton1Click:Connect(function()
            if premiumId and not HasGamepass(premiumId) then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, premiumId)
                return
            end

            for _,v in pairs(content:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end

            tabFrame.Visible = true
        end)

        local Tab = {}

        function Tab:CreateSection(name)
            local section = Instance.new("Frame", tabFrame)
            section.Size = UDim2.new(1,-10,0,200)
            section.BackgroundColor3 = theme.Card
            Instance.new("UICorner", section)

            local pad = Instance.new("UIPadding", section)
            pad.PaddingTop = UDim.new(0,10)
            pad.PaddingLeft = UDim.new(0,10)

            local list = Instance.new("UIListLayout", section)
            list.Padding = UDim.new(0,8)

            local label = Instance.new("TextLabel", section)
            label.Size = UDim2.new(1,0,0,20)
            label.Text = name
            label.TextColor3 = theme.Text
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold

            return {Frame = section}
        end

        return Tab
    end

    return Window
end

-- ELEMENTS

function KitsuneLib:CreateButton(sec, cfg)
    local b = Instance.new("TextButton", sec.Frame)
    b.Size = UDim2.new(1,0,0,35)
    b.Text = cfg.Name
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", b)

    b.MouseButton1Click:Connect(function()
        if cfg.Callback then cfg.Callback() end
    end)
end

function KitsuneLib:CreateToggle(sec, cfg)
    local state = cfg.CurrentValue or false

    local b = Instance.new("TextButton", sec.Frame)
    b.Size = UDim2.new(1,0,0,35)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Instance.new("UICorner", b)

    local function update()
        b.Text = cfg.Name.." : "..(state and "ON" or "OFF")
    end
    update()

    b.MouseButton1Click:Connect(function()
        state = not state
        update()
        if cfg.Callback then cfg.Callback(state) end
    end)
end

function KitsuneLib:CreateSlider(sec, cfg)
    local value = cfg.CurrentValue or cfg.Range[1]

    local b = Instance.new("TextButton", sec.Frame)
    b.Size = UDim2.new(1,0,0,35)
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Instance.new("UICorner", b)

    local function update()
        b.Text = cfg.Name.." : "..value
    end
    update()

    b.MouseButton1Click:Connect(function()
        value += 1
        if value > cfg.Range[2] then value = cfg.Range[1] end
        update()
        if cfg.Callback then cfg.Callback(value) end
    end)
end

function KitsuneLib:Notify(cfg)
    local f = Instance.new("Frame", LocalPlayer.PlayerGui)
    f.Size = UDim2.new(0,300,0,60)
    f.Position = UDim2.new(0.5,-150,0.1,0)
    f.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Instance.new("UICorner", f)

    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1,0,0,25)
    t.Text = cfg.Title
    t.TextColor3 = Color3.fromRGB(255,255,255)
    t.BackgroundTransparency = 1

    local c = Instance.new("TextLabel", f)
    c.Size = UDim2.new(1,0,0,35)
    c.Position = UDim2.new(0,0,0,25)
    c.Text = cfg.Content
    c.TextColor3 = Color3.fromRGB(200,200,200)
    c.BackgroundTransparency = 1

    game:GetService("Debris"):AddItem(f, cfg.Duration or 3)
end

return KitsuneLib
