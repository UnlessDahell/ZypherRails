local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "ZypherHub (Dead Rails Ver.Bug-Beta-1)",
   Icon = 0, 
   LoadingTitle = "This is Beta Test Expected For Bug And Unfunctional Options",
   LoadingSubtitle = "by !RENDER , VoxLar, Zypher",
   Theme = "Default", 

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ZypherHubFile", 
      FileName = "DeadRailsZ"
   },
})

local AimSettings = {
    Enabled = false,
    FOV = 100,
    AimPart = "Head",
    IgnoreHorses = true,
    WallCheck = true,
    Hotkey = Enum.KeyCode.Q
}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.Radius = AimSettings.FOV
FOVCircle.Filled = false

local function IsNPC(model)
    return model:FindFirstChild("Humanoid") and not game.Players:GetPlayerFromCharacter(model)
end

local function IsHorse(model)
    return model.Name:lower():find("horse") or model:FindFirstChild("HorseTag")
end

local function IsVisible(targetPart)
    if not AimSettings.WallCheck then return true end
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * 1000
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    return not raycastResult or raycastResult.Instance:IsDescendantOf(targetPart.Parent)
end

local function GetClosestNPC()
    local closest, minDist = nil, AimSettings.FOV
    local camera = workspace.CurrentCamera
    local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    for _, npc in ipairs(workspace:GetDescendants()) do
        if IsNPC(npc) and (not AimSettings.IgnoreHorses or not IsHorse(npc)) then
            local part = npc:FindFirstChild(AimSettings.AimPart) or npc:FindFirstChild("HumanoidRootPart")
            if part and IsVisible(part) then
                local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < minDist then
                        closest = part
                        minDist = dist
                    end
                end
            end
        end
    end
    return closest
end

game:GetService("RunService").RenderStepped:Connect(function()
    FOVCircle.Visible = AimSettings.Enabled
    FOVCircle.Radius = AimSettings.FOV
    FOVCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)

    if AimSettings.Enabled then
        local target = GetClosestNPC()
        if target then
            workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, target.Position)
        end
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == AimSettings.Hotkey and not gameProcessed then
        AimSettings.Enabled = not AimSettings.Enabled
    end
end)

local OutlineSettings = {
    NPCs = false,
    Corpses = false,
    Ores = false,
    Tools = false,
    Items = false,
    ScanInterval = 1
}

local Highlights = {}

local function CreateHighlight(instance, color)
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 1
    highlight.OutlineColor = color
    highlight.Parent = instance
    Highlights[instance] = highlight
end

local function RemoveHighlight(instance)
    if Highlights[instance] then
        Highlights[instance]:Destroy()
        Highlights[instance] = nil
    end
end

local function ShouldHighlight(instance)
    if instance:IsA("Model") then
        if OutlineSettings.NPCs and IsNPC(instance) and not IsHorse(instance) then
            return Color3.fromRGB(255, 50, 50)
        elseif OutlineSettings.Corpses and instance:FindFirstChild("CorpseTag") then
            return Color3.fromRGB(0, 200, 0)
        end
    elseif instance:IsA("BasePart") then
        if OutlineSettings.Ores and instance.Name:lower():find("ore") then
            return Color3.fromRGB(255, 165, 0)
        elseif OutlineSettings.Tools and instance:IsA("Tool") then
            return Color3.fromRGB(0, 150, 255)
        elseif OutlineSettings.Items and (instance.Name:lower():find("item") or instance.Parent.Name:lower():find("item")) then
            return Color3.fromRGB(150, 0, 255)
        end
    end
    return nil
end

local function UpdateOutlines()
    for instance, _ in pairs(Highlights) do
        if not instance or not instance.Parent then
            RemoveHighlight(instance)
        end
    end

    for _, instance in ipairs(workspace:GetDescendants()) do
        local color = ShouldHighlight(instance)
        if color then
            if not Highlights[instance] then
                CreateHighlight(instance, color)
            end
        else
            RemoveHighlight(instance)
        end
    end
end

task.spawn(function()
    while task.wait(OutlineSettings.ScanInterval) do
        if OutlineSettings.NPCs or OutlineSettings.Corpses or OutlineSettings.Ores or OutlineSettings.Tools or OutlineSettings.Items then
            UpdateOutlines()
        else
            for instance, _ in pairs(Highlights) do
                RemoveHighlight(instance)
            end
        end
    end
end)

local NoClipSettings = {
    Enabled = false,
    Hotkey = Enum.KeyCode.F,
    ButtonVisible = true,
    ButtonMovable = false
}

local NoClipButton = Instance.new("TextButton")
NoClipButton.Name = "NoClipToggle"
NoClipButton.Size = UDim2.new(0, 100, 0, 40)
NoClipButton.Position = UDim2.new(0.85, 0, 0.8, 0)
NoClipButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
NoClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipButton.Text = "NoClip: OFF"
NoClipButton.Parent = game.CoreGui:FindFirstChild("Rayfield") or Instance.new("ScreenGui")

local function ToggleNoClip()
    NoClipSettings.Enabled = not NoClipSettings.Enabled
    NoClipButton.Text = NoClipSettings.Enabled and "NoClip: ON" or "NoClip: OFF"
    NoClipButton.BackgroundColor3 = NoClipSettings.Enabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 30, 30)
end

NoClipButton.MouseButton1Click:Connect(ToggleNoClip)

game:GetService("RunService").Stepped:Connect(function()
    if NoClipSettings.Enabled and game.Players.LocalPlayer.Character then
        for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == NoClipSettings.Hotkey and not gameProcessed then
        ToggleNoClip()
    end
end)

local AimTab = Window:CreateTab("Aimbot", "crosshair")
AimTab:CreateToggle({ Name = "Enable Aimbot", CurrentValue = AimSettings.Enabled, Callback = function(v) AimSettings.Enabled = v end })
AimTab:CreateSlider({ Name = "FOV Size", Range = {30, 300}, CurrentValue = AimSettings.FOV, Callback = function(v) AimSettings.FOV = v end })
AimTab:CreateDropdown({ Name = "Aim Part", Options = {"Head", "Torso"}, CurrentOption = AimSettings.AimPart, Callback = function(v) AimSettings.AimPart = v end })
AimTab:CreateToggle({ Name = "Ignore Horses", CurrentValue = AimSettings.IgnoreHorses, Callback = function(v) AimSettings.IgnoreHorses = v end })
AimTab:CreateToggle({ Name = "Wall Check", CurrentValue = AimSettings.WallCheck, Callback = function(v) AimSettings.WallCheck = v end })
AimTab:CreateKeybind({ Name = "Aimbot Hotkey", CurrentKeybind = AimSettings.Hotkey, Callback = function(k) AimSettings.Hotkey = k end })

local VisionTab = Window:CreateTab("Visuals", "eye")
VisionTab:CreateToggle({ Name = "NPC Outlines", CurrentValue = OutlineSettings.NPCs, Callback = function(v) OutlineSettings.NPCs = v end })
VisionTab:CreateToggle({ Name = "Corpse Outlines", CurrentValue = OutlineSettings.Corpses, Callback = function(v) OutlineSettings.Corpses = v end })
VisionTab:CreateToggle({ Name = "Ore Outlines", CurrentValue = OutlineSettings.Ores, Callback = function(v) OutlineSettings.Ores = v end })
VisionTab:CreateToggle({ Name = "Tool Outlines", CurrentValue = OutlineSettings.Tools, Callback = function(v) OutlineSettings.Tools = v end })
VisionTab:CreateToggle({ Name = "Item Outlines", CurrentValue = OutlineSettings.Items, Callback = function(v) OutlineSettings.Items = v end })
VisionTab:CreateSlider({ Name = "Scan Interval", Range = {0.1, 5}, CurrentValue = OutlineSettings.ScanInterval, Callback = function(v) OutlineSettings.ScanInterval = v end })

local NoClipTab = Window:CreateTab("NoClip", "ghost")
NoClipTab:CreateToggle({ Name = "Enable NoClip", CurrentValue = NoClipSettings.Enabled, Callback = function(v) ToggleNoClip() end })
NoClipTab:CreateToggle({ Name = "Show Button", CurrentValue = NoClipSettings.ButtonVisible, Callback = function(v) NoClipButton.Visible = v end })
NoClipTab:CreateToggle({ Name = "Movable Button", CurrentValue = NoClipSettings.ButtonMovable, Callback = function(v) NoClipButton.Draggable = v end })
NoClipTab:CreateKeybind({ Name = "NoClip Hotkey", CurrentKeybind = NoClipSettings.Hotkey, Callback = function(k) NoClipSettings.Hotkey = k end })

Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Dead Rails optimized script activated!",
    Duration = 5
})
