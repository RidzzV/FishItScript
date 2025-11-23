-- Fish It! Script | UI Main File by RidzzV

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "Fish It! | By RidzzV",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FishConfig",
    IntroEnabled = true,
    IntroText = "Fish It! Script",
    IntroIcon = "rbxassetid://4483345998",
    Icon = "rbxassetid://4483345998"
})

OrionLib:MakeNotification({
    Name = "Script Loaded!",
    Content = "Enjoy using your script!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

local CreditsTab = Window:MakeTab({Name = "Credits", Icon = "rbxassetid://4483345998"})
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})
local TpTab = Window:MakeTab({Name = "Teleports", Icon = "rbxassetid://4483345998"})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998"})

local MainSection = MainTab:AddSection({Name = "Auto Farms"})
local TpSection = TpTab:AddSection({Name = "Locations"})
local MiscSection = MiscTab:AddSection({Name = "Extra Features"})

getgenv().autoFarmEnabled = false
getgenv().coralFarmEnabled = false
getgenv().depthsFarmEnabled = false
local platform = nil

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        getgenv().autoFarmEnabled = false
        getgenv().coralFarmEnabled = false
        getgenv().depthsFarmEnabled = false
        if platform then platform:Destroy() platform = nil end

        OrionLib:MakeNotification({
            Name = "Auto Farm Disabled",
            Content = "Press any autofarm button to enable again",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
end)

local function CreatePlatform()
    if platform then platform:Destroy() end
    platform = Instance.new("Part")
    platform.Size = Vector3.new(5, 1, 5)
    platform.Anchored = true
    platform.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0,3,0)
    platform.Parent = workspace
end

local function Farm(positionCFrame, flagName)
    spawn(function()
        while getgenv()[flagName] do
            CreatePlatform()
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            hrp.CFrame = positionCFrame
            platform.Position = hrp.Position - Vector3.new(0,3,0)
            mouse1click()
            task.wait()
        end
    end)
end

-- AUTO FARMS
MainSection:AddToggle({
    Name = "Autofarm Kohana",
    Default = false,
    Callback = function(state)
        getgenv().autoFarmEnabled = state
        if state then
            OrionLib:MakeNotification({Name="Kohana Farm", Content="Starting", Image="rbxassetid://4483345998", Time=3})
            Farm(CFrame.new(-759.09, 24.30, 429.12), "autoFarmEnabled")
        else
            if platform then platform:Destroy() platform = nil end
        end
    end
})

MainSection:AddToggle({
    Name = "Autofarm Coral Reefs",
    Default = false,
    Callback = function(state)
        getgenv().coralFarmEnabled = state
        if state then
            OrionLib:MakeNotification({Name="Coral Farm", Content="Starting", Image="rbxassetid://4483345998", Time=3})
            Farm(CFrame.new(-3222.68, 9.97, 1898.06), "coralFarmEnabled")
        else
            if platform then platform:Destroy() platform = nil end
        end
    end
})

MainSection:AddToggle({
    Name = "Autofarm Depths",
    Default = false,
    Callback = function(state)
        getgenv().depthsFarmEnabled = state
        if state then
            OrionLib:MakeNotification({Name="Depths Farm", Content="Starting", Image="rbxassetid://4483345998", Time=3})
            Farm(CFrame.new(3239.96, -1298.21, 1353.69), "depthsFarmEnabled")
        else
            if platform then platform:Destroy() platform = nil end
        end
    end
})

-- TELEPORTS
local locations = {
    ["Starter Island"] = CFrame.new(23.43, 4.62, 2868.34),
    ["Kohana Island"] = CFrame.new(-842.87, 55.50, 146.21),
    ["Kohana Volcano"] = CFrame.new(-606.58, 59.00, 105.82),
    ["Coral Reefs"] = CFrame.new(-2853.76, 47.49, 1988.13),
    ["The Depths"] = CFrame.new(2002.47, 12.10, 1385.32),
    ["Altar Enchant"] = CFrame.new(3177.32, -1302.72, 1427.37)
}

for name, cf in pairs(locations) do
    TpSection:AddButton({
        Name = "Teleport to " .. name,
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cf
            OrionLib:MakeNotification({
                Name = "Teleported",
                Content = "Teleported to " .. name,
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    })
end

-- MISC
MiscSection:AddButton({
    Name = "Load Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        OrionLib:MakeNotification({
            Name = "Loaded",
            Content = "Infinite Yield loaded successfully",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

MiscSection:AddToggle({
    Name = "Auto Collect Items",
    Default = false,
    Callback = function(state)
        getgenv().autoCollect = state
        spawn(function()
            while getgenv().autoCollect do
                for _,v in pairs(workspace:GetChildren()) do
                    if v:IsA("Tool") and v:FindFirstChild("Handle") then
                        v.Handle.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    end
                end
                task.wait()
            end
        end)
    end
})

MiscSection:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})
