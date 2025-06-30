task.delay(3, function()
    local repo = "https://raw.githubusercontent.com/SAINTLTM53/ui/main/"
    local Library = loadstring(game:HttpGet(repo .. "Obsidian.lua"))()

    if _G.BYPASS_HUB_LOADED then
        warn("Bypass Hub already loading Stop Spamming Dickhead.")
        return
    end
    _G.BYPASS_HUB_LOADED = true

    local originalUnload = Library and Library.Unload
    if Library then
        Library.Unload = function(...)
            _G.BYPASS_HUB_LOADED = nil
            return originalUnload and originalUnload(...)
        end
    end

    local Options = Library.Options
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local playerName = LocalPlayer and LocalPlayer.Name or "Unknown"

    local Window = Library:CreateWindow({
    Title = "Dupe Panel | SB",
    Footer = "Version: BETA | " .. playerName .. " | Buyer",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})


    local Tabs = {
        Main = Window:AddTab("Dupes", "layout-dashboard"),
        Settings = Window:AddTab("Settings", "settings"),
    }

    local DupeBox = Tabs.Main:AddLeftGroupbox("Dupe Panel")

    DupeBox:AddLabel("Must be in dupe server\nfor these to work.\nIt is recommended to stay\nfor 3–10 mins for best outcome\n(Not needed for rollback)")
    DupeBox:AddDivider("")

    DupeBox:AddButton("Join Dupe Server (required)", function()
        local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")

    local function teleportToPlace(placeId)
    local success, err = pcall(function()
        TeleportService:Teleport(placeId, Players.LocalPlayer)
    end)

    if not success then
        warn("[TP Handler] Teleport failed:", err)
    else
        print("[TP Handler] Teleport started successfully.")
    end
end

-- Replace with your target place ID
teleportToPlace(82028255140111)
    end)

   DupeBox:AddDivider("")

    DupeBox:AddLabel("Must be in the South Bronx group.\nTo maximize payout: toggle all\nperformance settings in-game.\nAlso turn down graphics quality.")
    DupeBox:AddDivider("")

    DupeBox:AddButton("One-time Money Dupe (200k–1.2M)", function()
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("ClientEffects")
        local Lighting = game:GetService("Lighting")
        local LocalPlayer = game.Players.LocalPlayer

        local function spoofedCall(name, func)
            if setfenv then setfenv(func, { script = { Name = name } }) end
            task.spawn(func)
        end

        spoofedCall("GameSettings", function()
            local settings = {
                {["Value"] = "Disabled", ["Setting"] = "Toggle Snow"},
                {["Value"] = "Disabled", ["Setting"] = "Server Head Movement"},
                {["Value"] = "Disabled", ["Setting"] = "Global Shadows"},
                {["Value"] = "Disabled", ["Setting"] = "Depth Of Field"},
                {["Value"] = "Disabled", ["Setting"] = "Sun Rays"},
                {["Value"] = "Disabled", ["Setting"] = "Blood Effects"},
                {["Value"] = "Disabled", ["Setting"] = "Bullet Effects"},
                {["Value"] = "Enabled", ["Setting"] = "Remove Extra Parts"},
                {["Value"] = "Enabled", ["Setting"] = "Remove Graffiti"},
            }
            for _, s in ipairs(settings) do
                remote:FireServer("UpdateSetting", s)
                task.wait(1)
            end
            remote:FireServer("ToggleHeadMovement", true)
        end)

        spoofedCall("Settings", function()
            remote:FireServer("UpdateSettingAttribute", {
                ["Attribute"] = "BlockCalls",
                ["Enabled"] = true
            })
        end)

        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1e10
            Lighting.Brightness = 1
            Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            for _, effect in pairs({"Atmosphere", "Bloom", "ColorCorrection", "SunRays", "DepthOfField"}) do
                local e = Lighting:FindFirstChild(effect)
                if e then e:Destroy() end
            end
        end)

        local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(0, 300, 0, 100)
        label.Position = UDim2.new(0.5, -150, 0.1, 0)
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.TextColor3 = Color3.new(1,1,1)
        label.Font = Enum.Font.GothamBold

        for i = 11, 0, -1 do
            label.Text = string.format("%d:%02d", math.floor(i / 60), i % 60)
            task.wait(1)
        end

        gui:Destroy()

        for i = 1, 12000 do
            coroutine.wrap(function()
                remote:FireServer("RewardMoneyIfIsInGroup", i)
            end)()
        end
    end)

   DupeBox:AddDivider("")

    DupeBox:AddLabel("Must NOT have a password\non your phone.")
    DupeBox:AddDivider("")

    DupeBox:AddButton("Rollback", function()
        local remote = game:GetService("ReplicatedStorage").RemoteEvents.ClientEffects
        local args = {
            [1] = "SetPasscode",
            [2] = { ["Passcode"] = "\xc3\x28" }
        }
        remote:FireServer(unpack(args))
    end)

local SettingsGroup = Tabs.Settings:AddLeftGroupbox("Options")

SettingsGroup:AddLabel("Made by: Cobra And AAA")

SettingsGroup:AddButton({
    Text = "Unload Script",
    Func = function()
        Library:Unload()
    end,
    DoubleClick = false,
    ShowCustomCursor = false
})

SettingsGroup:AddLabel('Menu Keybind'):AddKeyPicker('MenuKeybind', {
	Default = 'Insert',
	NoUI = true,
	Text = 'Menu keybind'
})
Library.ToggleKeybind = Options.MenuKeybind

SettingsGroup:AddButton({
	Text = "Rejoin Server",
	Func = function()
		local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local Rejoin = coroutine.create(function()
        local Success, ErrorMessage = pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)

        if ErrorMessage and not Success then
            warn(ErrorMessage)
        end
    end)

    coroutine.resume(Rejoin)
	end,
})
end)
