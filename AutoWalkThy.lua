-- Auto Track Walk Script (Clean)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")

-- DATA
local recordedPath = {}
local recording = false
local playing = false
local speed = 16
local loopPath = true

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "AutoTrackGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,360,0,300)
frame.Position = UDim2.new(0.5,-180,0.5,-150)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

-- BUTTON MAKER
local function makeBtn(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0,320,0,35)
	b.Position = UDim2.new(0,20,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local recordBtn = makeBtn("RECORD : OFF", 20)
local playBtn   = makeBtn("PLAY TRACK", 70)
local speedUp   = makeBtn("SPEED +", 120)
local speedDown = makeBtn("SPEED -", 170)
local loopBtn   = makeBtn("LOOP : ON", 220)

-- RECORD TRACK
recordBtn.MouseButton1Click:Connect(function()
	recording = not recording
	recordBtn.Text = recording and "RECORD : ON" or "RECORD : OFF"

	if recording then
		recordedPath = {}
	end
end)

-- SAVE POSISI SAAT RECORD
runService.RenderStepped:Connect(function()
	if recording then
		table.insert(recordedPath, hrp.Position)
	end
end)

-- PLAY TRACK
local function playPath()
	if #recordedPath < 2 then return end
	playing = true
	humanoid.WalkSpeed = speed

	local path = recordedPath

	while playing do
		for i = 1, #path do
			if not playing then break end
			humanoid:MoveTo(path[i])
			humanoid.MoveToFinished:Wait()
		end

		if loopPath then
			for i = #path, 1, -1 do
				if not playing then break end
				humanoid:MoveTo(path[i])
				humanoid.MoveToFinished:Wait()
			end
		else
			break
		end
	end
end

playBtn.MouseButton1Click:Connect(function()
	if playing then
		playing = false
	else
		task.spawn(playPath)
	end
end)

-- SPEED CONTROL
speedUp.MouseButton1Click:Connect(function()
	speed += 2
	humanoid.WalkSpeed = speed
end)

speedDown.MouseButton1Click:Connect(function()
	speed = math.max(6, speed - 2)
	humanoid.WalkSpeed = speed
end)

-- LOOP TOGGLE
loopBtn.MouseButton1Click:Connect(function()
	loopPath = not loopPath
	loopBtn.Text = loopPath and "LOOP : ON" or "LOOP : OFF"
end)
