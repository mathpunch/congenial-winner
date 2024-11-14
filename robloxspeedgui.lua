-- Create a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create the toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "+"
toggleButton.TextScaled = true
toggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Parent = screenGui

-- Create the main frame for the GUI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Text = "Speed Changer"
titleLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextScaled = true
titleLabel.Parent = mainFrame

-- Slider label
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, 0, 0, 30)
sliderLabel.Position = UDim2.new(0, 0, 0, 60)
sliderLabel.Text = "Walk Speed: 16"
sliderLabel.TextColor3 = Color3.new(1, 1, 1)
sliderLabel.BackgroundTransparency = 1
sliderLabel.TextScaled = true
sliderLabel.Parent = mainFrame

-- Textbox for speed adjustment
local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(1, -20, 0, 40)
speedSlider.Position = UDim2.new(0, 10, 0, 100)
speedSlider.Text = "16"
speedSlider.TextColor3 = Color3.new(0, 0, 0)
speedSlider.TextScaled = true
speedSlider.BackgroundColor3 = Color3.new(1, 1, 1)
speedSlider.Parent = mainFrame

-- Apply Button
local applyButton = Instance.new("TextButton")
applyButton.Size = UDim2.new(1, -20, 0, 40)
applyButton.Position = UDim2.new(0, 10, 0, 150)
applyButton.Text = "Apply Speed"
applyButton.TextColor3 = Color3.new(1, 1, 1)
applyButton.TextScaled = true
applyButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
applyButton.Parent = mainFrame

-- Toggle button function with drag detection
local guiVisible = false
local isDraggingToggle = false
local dragStartTime

toggleButton.MouseButton1Down:Connect(function()
    dragStartTime = tick()  -- Start tracking time when button is pressed
end)

toggleButton.MouseButton1Up:Connect(function()
    if not isDraggingToggle and tick() - dragStartTime < 0.2 then  -- Only toggle if not dragging and click was quick
        guiVisible = not guiVisible
        mainFrame.Visible = guiVisible
        toggleButton.Text = guiVisible and "-" or "+"
    end
    isDraggingToggle = false  -- Reset dragging state
end)

-- Function to update speed
local function updateSpeed()
    local player = game.Players.LocalPlayer
    local newSpeed = tonumber(speedSlider.Text)
    
    if newSpeed and player and player.Character and player.Character:FindFirstChild("Humanoid") then
        if newSpeed > 0 and newSpeed <= 9999 then
            player.Character.Humanoid.WalkSpeed = newSpeed
            sliderLabel.Text = "Walk Speed: " .. newSpeed
        else
            sliderLabel.Text = "Enter a value between 16 and 9999"
        end
    end
end

-- Connect the Apply button to update speed
applyButton.MouseButton1Click:Connect(updateSpeed)

-- Enable dragging for the mainFrame (for both mobile and PC)
local draggingMainFrame, dragInputMainFrame, dragStartMainFrame, startPosMainFrame

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMainFrame = true
        dragStartMainFrame = input.Position
        startPosMainFrame = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingMainFrame = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputMainFrame = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInputMainFrame and draggingMainFrame then
        local delta = input.Position - dragStartMainFrame
        mainFrame.Position = UDim2.new(startPosMainFrame.X.Scale, startPosMainFrame.X.Offset + delta.X, startPosMainFrame.Y.Scale, startPosMainFrame.Y.Offset + delta.Y)
    end
end)

-- Enable dragging for the toggleButton
local draggingToggleButton, dragInputToggleButton, dragStartToggleButton, startPosToggleButton

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggleButton = true
        isDraggingToggle = true  -- Set dragging state
        dragStartToggleButton = input.Position
        startPosToggleButton = toggleButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingToggleButton = false
                isDraggingToggle = false  -- Reset dragging state when released
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputToggleButton = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInputToggleButton and draggingToggleButton then
        local delta = input.Position - dragStartToggleButton
        toggleButton.Position = UDim2.new(startPosToggleButton.X.Scale, startPosToggleButton.X.Offset + delta.X, startPosToggleButton.Y.Scale, startPosToggleButton.Y.Offset + delta.Y)
    end
end)
