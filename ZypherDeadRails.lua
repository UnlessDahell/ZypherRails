local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Vexis Hub (Dead Rails Ver Beta 1.1)",
   Icon = 0, 
   LoadingTitle = "This is Beta Test Expected For Bug And Unfunctional Options",
   LoadingSubtitle = "by !RENDER , VoxLar, Zypher",
   Theme = "DarkBlue", 

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "VexisHubFile", 
      FileName = "DeadRailsV"
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

-- Aimbot Section
local AimSettings = {
    Enabled = false,
    NPC_Aim_Enabled = true,
    FOVSize = 100,
    AimTorso = false,
    NotAimHorse = true,
    WallCheck = true
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
    Name = "Ignore Horse/Unicorn",
    CurrentValue = AimSettings.NotAimHorse,
    Callback = function(Value)
        AimSettings.NotAimHorse = Value
    end
})

AimTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = AimSettings.WallCheck,
    Callback = function(Value)
        AimSettings.WallCheck = Value
    end
})

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Q then
        AimSettings.Enabled = not AimSettings.Enabled
        FOVCircle.Visible = AimSettings.Enabled
    end
end)

local function isHorseOrUnicorn(npc)
    if not npc then return false end
    return npc:FindFirstChild("Horse") or npc:FindFirstChild("Unicorn") or npc.Name:lower():find("horse") or npc.Name:lower():find("unicorn")
end

local function canSeeTarget(targetPart, camera)
    if not AimSettings.WallCheck then return true end
    
    local origin = camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * 1000
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    if raycastResult then
        local hitPart = raycastResult.Instance
        return hitPart:IsDescendantOf(targetPart.Parent)
    end
    return true
end

local function GetClosestNPC()
    local closest, shortestDistance = nil, AimSettings.FOVSize
    local Camera = game.Workspace.CurrentCamera
    local LocalPlayer = game.Players.LocalPlayer

    for _, npc in ipairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") and AimSettings.NPC_Aim_Enabled then
            if AimSettings.NotAimHorse and isHorseOrUnicorn(npc) then
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

            if distance < shortestDistance and onScreen and canSeeTarget(part, Camera) then
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

-- NoClip Section
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

local VisualTab = Window:CreateTab("VisualTab", "eye")
VisualTab:CreateLabel("Remove for now while Rewriting Please Wait.")

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

NoClipTab:CreateLabel("Press 'F' to toggle NoClip (when button is visible)")
