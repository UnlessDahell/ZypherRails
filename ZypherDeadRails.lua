local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Zypher Script Loader (.gg/aTNg2Dcw)",
    Icon = 82284779245358,
    LoadingTitle = "Wait until UI load up",
    LoadingSubtitle = "by Sir.Zypher and Eyes Sight",
    Theme = nil,

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Zypher",
        FileName = "Zypher"
    },

    Discord = {
        Enabled = true,
        Invite = "https://discord.gg/aTNg2Dcw",
        RememberJoins = true
    },

    KeySystem = false,
    KeySettings = {
        Title = "none",
        Subtitle = "none",
        Note = "none",
        FileName = "ZTeam",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"nil"},
    }
})

local MainTab = Window:CreateTab("Main Tab", "home")
local Section = MainTab:CreateSection("MainTab Yeah this is Alpha release")

Rayfield:Notify({
    Title = "Zypher Notifying",
    Content = "Please don't forget to join our community server!! (https://discord.gg/p5ynKu5f)",
    Duration = 25,
    Image = 4483362458,
})

local CommunitySection = MainTab:CreateSection("Our Discord Community Server")

local Button4 = MainTab:CreateButton({
    Name = "Discord Link Click to Get Here!",
    Callback = function()
        setclipboard("https://discord.gg/aTNg2Dcw")
    end,
})

local AimTab = Window:CreateTab("Aimbot", "crosshair")
local Section = AimTab:CreateSection("This Tab about Aim more function will be added soon")

local AimSettings = {
    Enabled = false,
    NPC_Aim_Enabled = true,
    FOVSize = 100,
    AimTorso = false,
    AimThroughWalls = false,
}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 139, 139) 
FOVCircle.Thickness = 2
FOVCircle.NumSides = 60
FOVCircle.Radius = AimSettings.FOVSize
FOVCircle.Filled = false
FOVCircle.Visible = false

AimTab:CreateToggle({
    Name = "Enable Aim FOV",
    CurrentValue = AimSettings.Enabled,
    Callback = function(Value)
        AimSettings.Enabled = Value
        FOVCircle.Visible = Value
    end
})

AimTab:CreateSlider({
    Name = "Custom FOV Size",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = AimSettings.FOVSize,
    Callback = function(Value)
        AimSettings.FOVSize = Value
        FOVCircle.Radius = Value
    end
})

AimTab:CreateToggle({
    Name = "Aim NPC Torso",
    CurrentValue = AimSettings.AimTorso,
    Callback = function(Value)
        AimSettings.AimTorso = Value
    end
})

AimTab:CreateToggle({
    Name = "Aim Through Wall",
    CurrentValue = AimSettings.AimThroughWalls,
    Callback = function(Value)
        AimSettings.AimThroughWalls = Value
    end
})

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Q then
        AimSettings.Enabled = not AimSettings.Enabled
        FOVCircle.Visible = AimSettings.Enabled
    end
end)

local function GetClosestNPC()
    local closest, shortestDistance = nil, AimSettings.FOVSize
    local Camera = game.Workspace.CurrentCamera
    local LocalPlayer = game.Players.LocalPlayer

    for _, npc in ipairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and AimSettings.NPC_Aim_Enabled then
            local humanoid = npc:FindFirstChild("Humanoid")
            local part = npc:FindFirstChild("Head") 
            if AimSettings.AimTorso then
                part = npc:FindFirstChild("Torso") or npc:FindFirstChild("HumanoidRootPart") 
            end
            if not part or not humanoid then continue end

            if humanoid.Health <= 0 then
                continue 
            end

            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude

            if distance < shortestDistance and onScreen then
                if not AimSettings.AimThroughWalls then
                    local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).unit * 1000)
                    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})

local AimSettings = {
    Enabled = false,
    NPC_Aim_Enabled = true,
    FOVSize = 100,
    AimTorso = false,
    AimThroughWalls = false,
    AimHorses = false,
}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 139, 139) 
FOVCircle.Thickness = 2
FOVCircle.NumSides = 60
FOVCircle.Radius = AimSettings.FOVSize
FOVCircle.Filled = false
FOVCircle.Visible = false

AimTab:CreateToggle({
    Name = "Enable Aim FOV",
    CurrentValue = AimSettings.Enabled,
    Callback = function(Value)
        AimSettings.Enabled = Value
        FOVCircle.Visible = Value
    end
})

AimTab:CreateSlider({
    Name = "Custom FOV Size",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = AimSettings.FOVSize,
    Callback = function(Value)
        AimSettings.FOVSize = Value
        FOVCircle.Radius = Value
    end
})

AimTab:CreateToggle({
    Name = "Aim NPC Torso",
    CurrentValue = AimSettings.AimTorso,
    Callback = function(Value)
        AimSettings.AimTorso = Value
    end
})

AimTab:CreateToggle({
    Name = "Aim Through Wall",
    CurrentValue = AimSettings.AimThroughWalls,
    Callback = function(Value)
        AimSettings.AimThroughWalls = Value
    end
})

AimTab:CreateToggle({
    Name = "Aim at Horses",
    CurrentValue = AimSettings.AimHorses,
    Callback = function(Value)
        AimSettings.AimHorses = Value
    end
})

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Q then
        AimSettings.Enabled = not AimSettings.Enabled
        FOVCircle.Visible = AimSettings.Enabled
    end
end)

local function GetClosestNPC()
    local closest, shortestDistance = nil, AimSettings.FOVSize
    local Camera = game.Workspace.CurrentCamera
    local LocalPlayer = game.Players.LocalPlayer

    for _, npc in ipairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and AimSettings.NPC_Aim_Enabled then
            if game.Players:GetPlayerFromCharacter(npc) then continue end
            if not AimSettings.AimHorses and npc.Name:lower():find("horse") then continue end

            local humanoid = npc:FindFirstChild("Humanoid")
            local part = npc:FindFirstChild("Head") 
            if AimSettings.AimTorso then
                part = npc:FindFirstChild("Torso") or npc:FindFirstChild("HumanoidRootPart") 
            end
            if not part or not humanoid then continue end

            if humanoid.Health <= 0 then
                continue 
            end

            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude

            if distance < shortestDistance and onScreen then
                if not AimSettings.AimThroughWalls then
                    local ray = Ray.new(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).unit * 1000)
                    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})

                    if hit and hit:IsDescendantOf(npc) then
                        closest, shortestDistance = npc, distance
                    end
                else
                    closest, shortestDistance = npc, distance
                end
            end
        end
    end
    return closest
end

game:GetService("RunService").RenderStepped:Connect(function()
    if not AimSettings.Enabled then return end

    local Camera = game.Workspace.CurrentCamera
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    local target = GetClosestNPC()

    if target then
        local part = target:FindFirstChild("Head") 
        if AimSettings.AimTorso then
            part = target:FindFirstChild("Torso") or target:FindFirstChild("HumanoidRootPart")
        end
        if part then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
        end
    end
end)

Rayfield:LoadConfiguration()

local VisualTab = Window:CreateTab("Visual", "eye")
local Section = VisualTab:CreateSection("Due the down time of pastebin.com and 80% of process is save in pastebin.com here is Alpha version then")

local Highlights = {
    Guns = false,
    Ammo = false,
    Armor = false
}

local function applyItemHighlight(item)
    if not item:IsA("Model") then return end

    local existingHighlight = item:FindFirstChild("Item_Highlight")
    if existingHighlight then existingHighlight:Destroy() end

    local highlight = Instance.new("Highlight")
    highlight.Name = "Item_Highlight"
    highlight.Parent = item
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0

    local itemName = item.Name:lower()

    if (itemName:find("ammo") or itemName:find("bullet")) and Highlights.Ammo then
        highlight.FillColor = Color3.fromRGB(255, 255, 255) 
    elseif (itemName:find("gun") or itemName:find("rifle") or itemName:find("pistol") or itemName:find("shotgun")) and Highlights.Guns then
        highlight.FillColor = Color3.fromRGB(0, 0, 255) 
    elseif itemName:find("armor") and Highlights.Armor then
        highlight.FillColor = Color3.fromRGB(0, 0, 255) 
    else
        highlight:Destroy() 
    end
end

local function updateAllItems()
    for _, item in pairs(workspace:GetChildren()) do
        applyItemHighlight(item)
    end
end

workspace.ChildAdded:Connect(function(obj)
    task.wait(0.1)
    applyItemHighlight(obj)
end)

VisualTab:CreateToggle({
    Name = "Highlight Guns",
    CurrentValue = false,
    Callback = function(value)
        Highlights.Guns = value
        updateAllItems()
    end
})

VisualTab:CreateToggle({
    Name = "Highlight Ammo",
    CurrentValue = false,
    Callback = function(value)
        Highlights.Ammo = value
        updateAllItems()
    end
})

VisualTab:CreateToggle({
    Name = "Highlight Armor",
    CurrentValue = false,
    Callback = function(value)
        Highlights.Armor = value
        updateAllItems()
    end
})

local function HighlightItems()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            if obj:FindFirstChild("Item") and not obj:FindFirstChild("Weapon") and not obj:FindFirstChild("Ammo") and not obj:FindFirstChild("Armor") then
                if not highlightedItems[obj] then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = obj
                    highlight.FillColor = highlightColor
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlightedItems[obj] = highlight
                end
            end
        end
    end
end

local function RemoveHighlights()
    for obj, highlight in pairs(highlightedItems) do
        if highlight then
            highlight:Destroy()
        end
    end
    highlightedItems = {} 
end

local ToggleHighlight = VisualTab:CreateToggle({
    Name = "Highlight Items",
    CurrentValue = false,
    Flag = "ItemHighlight",
    Callback = function(Value)
        itemHighlightEnabled = Value
        if itemHighlightEnabled then
            HighlightItems()
        else
            RemoveHighlights()
        end
    end
})

local ColorPicker = VisualTab:CreateColorPicker({
    Name = "Highlight Color",
    Color = highlightColor,
    Flag = "HighlightColor",
    Callback = function(Color)
        highlightColor = Color 
        if itemHighlightEnabled then
            RemoveHighlights()
            HighlightItems() 
        end
    end
})

Rayfield:LoadConfiguration() 
