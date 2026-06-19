local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

if _G["MoblieFly.32_Executed"] then
    warn("MoblieFly.32 is already running!")
    return
end
_G["MoblieFly.32_Executed"] = true

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local HRP = character:WaitForChild("HumanoidRootPart")

local flySpeed = 50
local flying = false
local bodyVelocity = Instance.new("BodyVelocity")
local bodyGyro = Instance.new("BodyGyro")

bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)

local Camera = workspace.CurrentCamera
local inputFlags = { forward = false, back = false, left = false, right = false, up = false, down = false }

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoblieFly.32"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local watermarkGui = Instance.new("ScreenGui")
watermarkGui.Name = "110cWatermark"
watermarkGui.ResetOnSpawn = false
watermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
watermarkGui.DisplayOrder = 999
watermarkGui.Parent = player:WaitForChild("PlayerGui")

local watermarkLabel = Instance.new("TextLabel", watermarkGui)
watermarkLabel.AnchorPoint = Vector2.new(0.5, 1)
watermarkLabel.Position = UDim2.new(0.5, 0, 1, -10)
watermarkLabel.Size = UDim2.new(1, -40, 0, 30)
watermarkLabel.BackgroundTransparency = 1
watermarkLabel.Font = Enum.Font.GothamSemibold
watermarkLabel.TextSize = 18
watermarkLabel.TextStrokeTransparency = 0.5
watermarkLabel.RichText = true
watermarkLabel.Text = '<font color="rgb(180, 50, 255)">110c</font>'

local flyControlsContainer = Instance.new("Frame")
flyControlsContainer.Name = "FlyControlsContainer"
flyControlsContainer.Size = UDim2.new(1, 0, 1, 0)
flyControlsContainer.BackgroundTransparency = 1
flyControlsContainer.Parent = screenGui

local dpadSize = UDim2.new(0, 60, 0, 60)

local function createButton(parent, name, text, pos, size)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Text = text
	btn.Size = size
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.BackgroundTransparency = 0.2
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
	return btn
end

local toggleButton = createButton(flyControlsContainer, "ToggleFlyButton", "Fly OFF", UDim2.new(1, -110, 0, 10), UDim2.new(0, 100, 0, 50))
local uiToggleButton = createButton(flyControlsContainer, "UIToggleButton", "Hide UI", UDim2.new(0, 10, 0, 10), UDim2.new(0, 100, 0, 50))

local forwardButton = createButton(flyControlsContainer, "ForwardButton", "↑", UDim2.new(0, 70, 1, -190), dpadSize)
local backButton    = createButton(flyControlsContainer, "BackButton",    "↓", UDim2.new(0, 70, 1, -70),  dpadSize)
local leftButton    = createButton(flyControlsContainer, "LeftButton",    "←", UDim2.new(0, 10, 1, -130), dpadSize)
local rightButton   = createButton(flyControlsContainer, "RightButton",   "→", UDim2.new(0, 130,1, -130), dpadSize)
local upButton      = createButton(flyControlsContainer, "UpButton",      "Up", UDim2.new(1, -110,1, -190), dpadSize)
local downButton    = createButton(flyControlsContainer, "DownButton",    "Down",UDim2.new(1, -110,1, -70),  dpadSize)

local speedBox = Instance.new("TextBox")
speedBox.Name = "SpeedBox"
speedBox.Size = UDim2.new(0, 100, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 70)
speedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.PlaceholderText = "Fly Speed"
speedBox.Text = tostring(flySpeed)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.Parent = flyControlsContainer
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

speedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local newSpeed = tonumber(speedBox.Text)
		if newSpeed and newSpeed >= 0 and newSpeed <= 10000 then
			flySpeed = newSpeed
		else
			speedBox.Text = tostring(flySpeed)
		end
	end
end)

local function startFlying()
	flying = true
	bodyVelocity.Parent = HRP
	bodyGyro.Parent = HRP
	humanoid.PlatformStand = true
	toggleButton.Text = "Fly ON"
end

local function stopFlying()
	flying = false
	bodyVelocity.Parent = nil
	bodyGyro.Parent = nil
	humanoid.PlatformStand = false
	toggleButton.Text = "Fly OFF"
end

toggleButton.MouseButton1Click:Connect(function()
	if flying then stopFlying() else startFlying() end
end)

local function addTouchEvents(button, flagName)
	button.MouseButton1Down:Connect(function() inputFlags[flagName] = true end)
	button.MouseButton1Up:Connect(function() inputFlags[flagName] = false end)
	button.MouseLeave:Connect(function() inputFlags[flagName] = false end)
end

addTouchEvents(forwardButton, "forward")
addTouchEvents(backButton, "back")
addTouchEvents(leftButton, "left")
addTouchEvents(rightButton, "right")
addTouchEvents(upButton, "up")
addTouchEvents(downButton, "down")

local uiVisible = true
uiToggleButton.MouseButton1Click:Connect(function()
	uiVisible = not uiVisible
	for _, btn in pairs(flyControlsContainer:GetChildren()) do
		if btn:IsA("TextButton") and btn ~= uiToggleButton then
			btn.Visible = uiVisible
		end
	end
	speedBox.Visible = uiVisible
	uiToggleButton.Text = uiVisible and "Hide UI" or "Show UI"
end)

player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = newChar:WaitForChild("Humanoid")
	HRP = newChar:WaitForChild("HumanoidRootPart")
	flying = false
end)

RunService.RenderStepped:Connect(function()
	if flying then
		local moveDirection = Vector3.new(0, 0, 0)
		local camCF = Camera.CFrame
		
		if inputFlags.forward then moveDirection += camCF.LookVector end
		if inputFlags.back    then moveDirection -= camCF.LookVector end
		if inputFlags.left    then moveDirection -= camCF.RightVector end
		if inputFlags.right   then moveDirection += camCF.RightVector end
		if inputFlags.up      then moveDirection += Vector3.new(0, 1, 0) end
		if inputFlags.down    then moveDirection -= Vector3.new(0, 1, 0) end
		
		if moveDirection.Magnitude > 0 then
			moveDirection = moveDirection.Unit
		end
		
		bodyVelocity.Velocity = moveDirection * flySpeed
		bodyGyro.CFrame = camCF
	end
end)
