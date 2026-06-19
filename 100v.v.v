local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

if player.PlayerGui:FindFirstChild("100v.v.v") then
    player.PlayerGui:FindFirstChild("100v.v.v"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "100v.v.v"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 165, 0, 185)
Frame.Position = UDim2.new(0.5, -82.5, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 28)
Title.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
Title.Text = "100v"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = Frame

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(0.94, 0, 0, 15)
TargetLabel.Position = UDim2.new(0.03, 0, 0.17, 0)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Target:"
TargetLabel.TextColor3 = Color3.fromRGB(60, 60, 60)
TargetLabel.Font = Enum.Font.SourceSansBold
TargetLabel.TextSize = 13
TargetLabel.Parent = Frame

local TargetBox = Instance.new("TextBox")
TargetBox.Size = UDim2.new(0.94, 0, 0, 22)
TargetBox.Position = UDim2.new(0.03, 0, 0.245, 0)
TargetBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TargetBox.Text = ""
TargetBox.PlaceholderText = "Empty = random"
TargetBox.TextColor3 = Color3.fromRGB(0, 0, 0)
TargetBox.Font = Enum.Font.SourceSans
TargetBox.TextSize = 13
TargetBox.Parent = Frame

local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Size = UDim2.new(0.45, 0, 0, 15)
RadiusLabel.Position = UDim2.new(0.03, 0, 0.39, 0)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Text = "Radius"
RadiusLabel.TextColor3 = Color3.fromRGB(60, 60, 60)
RadiusLabel.Font = Enum.Font.SourceSansBold
RadiusLabel.TextSize = 12
RadiusLabel.Parent = Frame

local RadiusBox = Instance.new("TextBox")
RadiusBox.Size = UDim2.new(0.45, 0, 0, 22)
RadiusBox.Position = UDim2.new(0.03, 0, 0.465, 0)
RadiusBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RadiusBox.Text = "12"
RadiusBox.TextColor3 = Color3.fromRGB(0, 0, 0)
RadiusBox.Font = Enum.Font.SourceSans
RadiusBox.TextSize = 13
RadiusBox.Parent = Frame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.45, 0, 0, 15)
SpeedLabel.Position = UDim2.new(0.52, 0, 0.39, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed"
SpeedLabel.TextColor3 = Color3.fromRGB(60, 60, 60)
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.TextSize = 12
SpeedLabel.Parent = Frame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.45, 0, 0, 22)
SpeedBox.Position = UDim2.new(0.52, 0, 0.465, 0)
SpeedBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.Text = "2.5"
SpeedBox.TextColor3 = Color3.fromRGB(0, 0, 0)
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.TextSize = 13
SpeedBox.Parent = Frame

local function getTarget()
    local input = TargetBox.Text:gsub("%s+", "")
    if input == "" then
        local players = game.Players:GetPlayers()
        if #players > 1 then
            local rand = players[math.random(2, #players)]
            return rand ~= player and rand or nil
        end
        return nil
    end
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and (plr.Name:lower():find(input:lower()) or plr.DisplayName:lower():find(input:lower())) then
            return plr
        end
    end
    return nil
end

local function updateCharacter()
    character = player.Character
    if character then
        humanoid = character:WaitForChild("Humanoid", 2)
        rootPart = character:WaitForChild("HumanoidRootPart", 2)
    end
end

local OrbitButton = Instance.new("TextButton")
OrbitButton.Size = UDim2.new(0.94, 0, 0, 30)
OrbitButton.Position = UDim2.new(0.03, 0, 0.60, 0)
OrbitButton.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
OrbitButton.Text = "Loop Orbit OFF"
OrbitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OrbitButton.Font = Enum.Font.SourceSansBold
OrbitButton.TextSize = 14
OrbitButton.Parent = Frame

local enabled = false
local conn = nil

OrbitButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        OrbitButton.Text = "Loop Orbit ON"
        OrbitButton.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
        
        conn = game:GetService("RunService").Heartbeat:Connect(function()
            if not enabled then return end
            
            local target = getTarget()
            if not target or not target.Character then return end
            
            updateCharacter()
            if not rootPart then return end

            local torso = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
            if not torso then return end

            local time = tick()
            local radius = tonumber(RadiusBox.Text) or 12
            local speed = tonumber(SpeedBox.Text) or 2.5

            local x = torso.Position.X + math.cos(time * speed) * radius
            local z = torso.Position.Z + math.sin(time * speed) * radius
            local y = torso.Position.Y - torso.Size.Y/2 + humanoid.HipHeight + rootPart.Size.Y/2 - 0.1

            rootPart.CFrame = CFrame.new(x, y, z)
        end)
    else
        OrbitButton.Text = "Loop Orbit OFF"
        OrbitButton.BackgroundColor3 = Color3.fromRGB(200, 40, 60)
        if conn then 
            conn:Disconnect() 
            conn = nil 
        end
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(0.6)
    updateCharacter()
end)
