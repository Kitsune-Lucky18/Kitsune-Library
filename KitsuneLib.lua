-- KitsuneLib.lua (Fexed Style + Premium Gate)

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

-- ID Gamepass Premium
local PremiumGamepassID = 12345678 -- ganti dengan ID gamepass kamu

-- Cek apakah player punya gamepass premium
local function HasPremium()
    local success, owns = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, PremiumGamepassID)
    end)
    return success and owns
end

-- Create Window
function KitsuneLib:CreateWindow(config)
    local theme = self.Themes[config.Theme] or self.Themes.Dark

    local gui = Instance.new("ScreenGui")
    gui.Name = "KitsuneHub"
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

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
    function Window:CreateTab(name, iconId, premium)
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
            if premium and not HasPremium() then
                -- kalau tab premium tapi player belum beli
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, PremiumGamepassID)
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

-- Elements (Toggle, Button, Slider, Dropdown, Keybind, Textbox, Notify)
-- sama seperti versi sebelumnya, tinggal diisi ke Section.Frame
