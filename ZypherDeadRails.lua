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

local MainTab = Window:CreateTab("Main Tab", "home")
MainTab:CreateLabel("This is Test version and have a lot of things to fix so join our discord for new or update")

local Button = MainTab:CreateButton({
   Name = "Get Discord Link Here",
   Callback = function()
   setclipboard("https://discord.gg/ere8H6q9") 
   end,
})

local AimSettings = {
    Enabled = false,
    NPC_Aim_Enabled = true,
    FOVSize = 100,
    AimTorso = false,
    NotAimHorse = false,
}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 139, 139)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 60
FOVCircle.Radius = AimSettings.FOVSize
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Position = Vector2.new()

local AimTab = Window:CreateTab("Aimbot", "crosshair")

AimTab:CreateToggle({
    Name = "Enable Aim",
    CurrentValue = AimSettings.Enabled,
    Callback = function(Value)
        AimSettings.Enabled = Value
        FOVCircle.Visible = Value
    end
})

AimTab:CreateSlider({
    Name = "FOV Size",
    Range = {30, 260},
    Increment = 10,
    CurrentValue = AimSettings.FOVSize,
    Callback = function(Value)
        AimSettings.FOVSize = Value
        FOVCircle.Radius = Value
    end
})

AimTab:CreateToggle({
    Name = "Aim Torso",
    CurrentValue = AimSettings.AimTorso,
    Callback = function(Value)
        AimSettings.AimTorso = Value
    end
})

AimTab:CreateToggle({
    Name = "Not Aim Horse",
    CurrentValue = AimSettings.NotAimHorse,
    Callback = function(Value)
        AimSettings.NotAimHorse = Value
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
            if AimSettings.NotAimHorse and npc:FindFirstChild("Horse") then
                continue
            end
            if game.Players:GetPlayerFromCharacter(npc) then
                continue
            end

            local humanoid = npc:FindFirstChild("Humanoid")
            local part = npc:FindFirstChild("Head")
            if AimSettings.AimTorso then
                part = npc:FindFirstChild("Torso") or npc:FindFirstChild("HumanoidRootPart")
            end
            if not part or humanoid.Health <= 0 then continue end

            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude

            if distance < shortestDistance and onScreen then
                closest, shortestDistance = npc, distance
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

local outlineSettings = {
    npcColor = Color3.fromRGB(255, 50, 50),
    horseColor = Color3.fromRGB(50, 255, 50),
    corpseColor = Color3.fromRGB(0, 200, 0),
    oreColor = Color3.fromRGB(255, 165, 0),
    toolColor = Color3.fromRGB(0, 150, 255),
    itemColor = Color3.fromRGB(150, 0, 255),
    
    npcEnabled = false,
    corpseEnabled = false,
    oreEnabled = false,
    toolEnabled = false,
    itemEnabled = false,
    
    scanInterval = 1
}

local outlines = {}
local scanActive = false

local function createOutline()
    local outline = Instance.new("Highlight")
    outline.FillTransparency = 1
    outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    return outline
end

local function isPlayer(character)
    task.wait(0.1)
    return character and game.Players:GetPlayerFromCharacter(character) ~= nil
end

local function isHorse(npc)
    task.wait(0.1)
    if not npc then return false end
    return npc.Name:lower():find("horse") ~= nil
        or (npc:FindFirstChild("HorseTag") ~= nil)
end

local function hasOreInParent(instance)
    task.wait(0.1)
    local current = instance
    while current do
        if current.Name:lower():find("ore") then
            return true
        end
        current = current.Parent
    end
    return false
end

local function isTool(instance)
    task.wait(0.1)
    return instance:IsA("Tool") or instance:FindFirstChildWhichIsA("Tool")
end

local function isDeadRailsItem(instance)
    task.wait(0.1)
    if not instance then return false end
    if instance:FindFirstAncestorOfClass("Backpack") then return false end
    
    local name = instance.Name:lower()
    return name:find("item") 
        or name:find("loot")
        or name:find("supply")
        or name:find("resource")
        or instance:FindFirstChild("CanPickUp")
        or instance:FindFirstChild("Draggable")
end

local function shouldOutline(instance)
    task.wait(0.1)
    if not instance or not instance.Parent then return false end
    if instance:IsA("Terrain") or instance:IsA("Camera") then return false end
    
    if outlineSettings.npcEnabled 
       and instance:FindFirstChildWhichIsA("Humanoid") 
       and not isPlayer(instance) then
        return not isCorpse(instance)
    end
    
    if outlineSettings.corpseEnabled and instance:FindFirstChild("CorpseTag") then
        return true
    end
    
    if outlineSettings.oreEnabled and hasOreInParent(instance) then
        return true
    end
    
    if outlineSettings.toolEnabled and isTool(instance) then
        return true
    end
    
    if outlineSettings.itemEnabled and isDeadRailsItem(instance) then
        return true
    end
    
    return false
end

local function applyOutline(instance)
    task.wait(0.1)
    if not shouldOutline(instance) or outlines[instance] then return end
    
    local outline = createOutline()
    
    if instance:FindFirstChild("Corpse") then
        outline.OutlineColor = outlineSettings.corpseColor
    elseif hasOreInParent(instance) then
        outline.OutlineColor = outlineSettings.oreColor
    elseif isTool(instance) then
        outline.OutlineColor = outlineSettings.toolColor
    elseif isDeadRailsItem(instance) then
        outline.OutlineColor = outlineSettings.itemColor
    elseif instance:FindFirstChildWhichIsA("Humanoid") then
        outline.OutlineColor = isHorse(instance) and outlineSettings.horseColor or outlineSettings.npcColor
    end
    
    outline.Parent = instance
    outlines[instance] = outline
end

local function removeOutline(instance)
    task.wait(0.1)
    if outlines[instance] then
        outlines[instance]:Destroy()
        outlines[instance] = nil
    end
end

local function continuousScan()
    while scanActive do
        for _, instance in ipairs(workspace:GetDescendants()) do
            task.spawn(function()
                task.wait(0.1)
                if shouldOutline(instance) then
                    if not outlines[instance] then
                        applyOutline(instance)
                    end
                else
                    if outlines[instance] then
                        removeOutline(instance)
                    end
                end
            end)
        end
        task.wait(outlineSettings.scanInterval)
    end
end

local function startScanning()
    if not scanActive then
        scanActive = true
        task.spawn(continuousScan)
    end
end

local function stopScanning()
    scanActive = false
end

local function updateOutlines()
    task.wait(0.1)
    if outlineSettings.npcEnabled or outlineSettings.corpseEnabled or 
       outlineSettings.oreEnabled or outlineSettings.toolEnabled or 
       outlineSettings.itemEnabled then
        startScanning()
    else
        stopScanning()
        for instance, outline in pairs(outlines) do
            task.spawn(function()
                removeOutline(instance)
            end)
        end
        outlines = {}
    end
end

local VisualTab = Window:CreateTab("Visual Tab", "eye")
local ToggleSection = VisualTab:CreateSection("Outline Toggles")
VisualTab:CreateLabel("All Outlines Still In Dev And Unoptimized So Yeah")

local NPCsToggle = MainTab:CreateToggle({
    Name = "NPC Outlines",
    CurrentValue = outlineSettings.npcEnabled,
    Flag = "NPCsToggle",
    Callback = function(Value)
        task.wait(0.1)
        outlineSettings.npcEnabled = Value
        updateOutlines()
    end,
})

local CorpsesToggle = VisualTab:CreateToggle({
    Name = "Corpse Outlines",
    CurrentValue = outlineSettings.corpseEnabled,
    Flag = "CorpsesToggle",
    Callback = function(Value)
        task.wait(0.1)
        outlineSettings.corpseEnabled = Value
        updateOutlines()
    end,
})

local OreToggle = VisualTab:CreateToggle({
    Name = "Ore Outlines",
    CurrentValue = outlineSettings.oreEnabled,
    Flag = "OreToggle",
    Callback = function(Value)
        task.wait(0.1)
        outlineSettings.oreEnabled = Value
        updateOutlines()
    end,
})

local ToolsToggle = VisualTab:CreateToggle({
    Name = "Tool Outlines",
    CurrentValue = outlineSettings.toolEnabled,
    Flag = "ToolsToggle",
    Callback = function(Value)
        task.wait(0.1)
        outlineSettings.toolEnabled = Value
        updateOutlines()
    end,
})

local ItemsToggle = VisualTab:CreateToggle({
    Name = "Item Outlines",
    CurrentValue = outlineSettings.itemEnabled,
    Flag = "ItemsToggle",
    Callback = function(Value)
        task.wait(0.1)
        outlineSettings.itemEnabled = Value
        updateOutlines()
    end,
})

local ScanSlider = VisualTab:CreateSlider({
    Name = "Scan Interval (seconds)",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = outlineSettings.scanInterval,
    Flag = "ScanInterval",
    Callback = function(Value)
        task.wait(0.1)
        outlineSettings.scanInterval = Value
    end,
})

workspace.DescendantAdded:Connect(function(instance)
    task.spawn(function()
        task.wait(0.1)
        if shouldOutline(instance) then
            applyOutline(instance)
        end
    end)
end)

workspace.DescendantRemoving:Connect(function(instance)
    task.spawn(function()
        task.wait(0.1)
        removeOutline(instance)
    end)
end)

task.defer(function()
    task.wait(0.1)
    updateOutlines()
    Rayfield:Notify({
        Title = "Outline System Ready",
        Content = "Continuous scanning with refresh activated!",
        Duration = 3,
        Image = nil,
    })
end)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local running = false
local buttonVisible = false
local buttonMovable = false
local dragging = false
local dragInput, dragStart, startPos

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoClipButtonUI"
screenGui.Parent = game.CoreGui
screenGui.Enabled = false

local button = Instance.new("TextButton")
button.Name = "NoClipToggleButton"
button.Parent = screenGui
button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(0.85, 0, 0.8, 0)
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "NoClip: OFF"
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.BorderSizePixel = 1
button.BorderColor3 = Color3.fromRGB(60, 60, 60)
button.AutoButtonColor = true
button.ZIndex = 10
button.Active = true
button.Draggable = false

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = button

local function updateInput(input)
    local delta = input.Position - dragStart
    button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and buttonMovable then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging and buttonMovable then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging and buttonMovable then
        updateInput(input)
    end
end)

local function NoClipLoop()
    if not char then return end
    
    while running and char and char:FindFirstChild("Humanoid") do
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
        game:GetService("RunService").Stepped:Wait()
    end
end

local function ToggleNoClip()
    running = not running
    button.Text = running and "NoClip: ON" or "NoClip: OFF"
    button.BackgroundColor3 = running and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 30, 30)
    
    if running then
        char = player.Character or player.CharacterAdded:Wait()
        coroutine.wrap(NoClipLoop)()
    end
end

button.MouseButton1Click:Connect(ToggleNoClip)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F and buttonVisible then
        ToggleNoClip()
    end
end)

player.CharacterAdded:Connect(function(newChar)
    char = newChar
    if running then
        coroutine.wrap(NoClipLoop)()
    end
end)

local NoClipTab = Window:CreateTab("NoClip", "annoyed")

local ButtonToggle = NoClipTab:CreateToggle({
    Name = "Show NoClip Button",
    CurrentValue = buttonVisible,
    Callback = function(value)
        buttonVisible = value
        screenGui.Enabled = buttonVisible
    end
})

local MovableToggle = NoClipTab:CreateToggle({
    Name = "Make Button Movable",
    CurrentValue = buttonMovable,
    Callback = function(value)
        buttonMovable = value
        button.Draggable = value
    end
})

local NoClipToggle = NoClipTab:CreateToggle({
    Name = "Enable NoClip",
    CurrentValue = running,
    Callback = function(value)
        running = value
        button.Text = running and "NoClip: ON" or "NoClip: OFF"
        button.BackgroundColor3 = running and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 30, 30)
        
        if running then
            char = player.Character or player.CharacterAdded:Wait()
            coroutine.wrap(NoClipLoop)()
        end
    end
})

Tab:CreateLabel("Press 'F' to toggle NoClip (when button is visible)")
