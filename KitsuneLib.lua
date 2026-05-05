-- KitsuneLib.lua
-- Custom UI Library ala Rayfield tapi versi Kitsune Hub

local KitsuneLib = {}

-- Theme list
KitsuneLib.Themes = {
    Dark = {Background = Color3.fromRGB(30,30,30), Text = Color3.fromRGB(255,255,255)},
    Light = {Background = Color3.fromRGB(240,240,240), Text = Color3.fromRGB(0,0,0)},
    Blood = {Background = Color3.fromRGB(50,0,0), Text = Color3.fromRGB(255,255,255)},
    Ocean = {Background = Color3.fromRGB(0,40,80), Text = Color3.fromRGB(200,230,255)},
    Forest = {Background = Color3.fromRGB(20,60,20), Text = Color3.fromRGB(220,255,220)},
    Cyber = {Background = Color3.fromRGB(10,10,30), Text = Color3.fromRGB(0,255,180)},
}

-- Create Window
function KitsuneLib:CreateWindow(config)
    local Window = {}
    Window.Name = config.Name or "Kitsune Hub"
    Window.Theme = self.Themes[config.Theme] or self.Themes.Dark
    Window.Tabs = {}
    function Window:CreateTab(name)
        local Tab = {Name = name, Sections = {}}
        table.insert(self.Tabs, Tab)
        function Tab:CreateSection(name)
            local Section = {Name = name, Elements = {}}
            table.insert(Tab.Sections, Section)
            return Section
        end
        return Tab
    end
    return Window
end

-- Elements
function KitsuneLib:CreateToggle(section, config)
    local Toggle = {Name = config.Name, State = config.CurrentValue or false}
    function Toggle:Set(value)
        self.State = value
        if config.Callback then config.Callback(value) end
    end
    table.insert(section.Elements, Toggle)
    return Toggle
end

function KitsuneLib:CreateButton(section, config)
    local Button = {Name = config.Name}
    function Button:Click()
        if config.Callback then config.Callback() end
    end
    table.insert(section.Elements, Button)
    return Button
end

function KitsuneLib:CreateSlider(section, config)
    local Slider = {Name = config.Name, Value = config.CurrentValue or config.Range[1]}
    function Slider:Set(value)
        if value >= config.Range[1] and value <= config.Range[2] then
            self.Value = value
            if config.Callback then config.Callback(value) end
        end
    end
    table.insert(section.Elements, Slider)
    return Slider
end

function KitsuneLib:CreateDropdown(section, config)
    local Dropdown = {Name = config.Name, Options = config.Options, Current = config.CurrentOption}
    function Dropdown:Set(option)
        self.Current = option
        if config.Callback then config.Callback(option) end
    end
    table.insert(section.Elements, Dropdown)
    return Dropdown
end

function KitsuneLib:CreateKeybind(section, config)
    local Keybind = {Name = config.Name, Key = config.CurrentKey}
    function Keybind:Set(key)
        self.Key = key
        if config.Callback then config.Callback(key) end
    end
    table.insert(section.Elements, Keybind)
    return Keybind
end

function KitsuneLib:CreateTextbox(section, config)
    local Textbox = {Name = config.Name, Text = ""}
    function Textbox:Set(text)
        self.Text = text
        if config.Callback then config.Callback(text) end
    end
    table.insert(section.Elements, Textbox)
    return Textbox
end

function KitsuneLib:Notify(config)
    print("[Kitsune Hub Notify] "..config.Title..": "..config.Content)
end

return KitsuneLib
