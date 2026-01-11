--// Auto Walk Script by TS
--// Simple, clean, loadstring-ready

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ===== UTIL =====
local function notify(text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "TS Auto Walk",
			Text = text,
			Duration = 2
		})
	end)
end

local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

-- ===== DATA =====
local recording = false
local paused = false
local playing = false
local loopPlay = false

local recordData = {}
local savedRecords = {}

local speedValue = 16

-- ===== UI =====
local gui = Instance.new("ScreenGui")
gui.Name = "TSAutoWalk"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.25, 0.4)
main.Position = UDim2.fromScale(0.05, 0.3)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0.12,0)
title.Text = "TS AUTO WALK"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextScaled = true

local function newBtn(text, y)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(0.9,0,0.1,0)
	b.Position = UDim2.new(0.05,0,y,0)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local btnRecord = newBtn("Record Track", 0.15)
local btnPause  = newBtn("Pause Track", 0.27)
local btnPlay   = newBtn("Start Track", 0.39)
local btnLoop   = newBtn("Loop: OFF", 0.51)
local btnSave   = newBtn("Simpan Record", 0.63)

-- speed
local speedText = Instance.new("TextLabel", main)
speedText.Size = UDim2.new(0.9,0,0.08,0)
speedText.Position = UDim2.new(0.05,0,0.75,0)
speedText.Text = "Speed: 16"
speedText.TextColor3 = Color3.new(1,1,1)
speedText.BackgroundTransparency = 1
speedText.TextScaled = true

local plus = Instance.new("TextButton", main)
plus.Size = UDim2.new(0.43,0,0.08,0)
plus.Position = UDim2.new(0.05,0,0.85,0)
plus.Text = "+"
plus.BackgroundColor3 = Color3.fromRGB(60,60,60)
plus.TextColor3 = Color3.new(1,1,1)

local minus = Instance.new("TextButton", main)
minus.Size = UDim2.new(0.43,0,0.08,0)
minus.Position = UDim2.new(0.52,0,0.85,0)
minus.Text = "-"
minus.BackgroundColor3 = Color3.fromRGB(60,60,60)
minus.TextColor3 = Color3.new(1,1,1)

-- ===== RECORD SYSTEM =====
task.spawn(function()
	while true do
		if recording and not paused then
			local char = getChar()
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if hrp then
				table.insert(recordData, {
					pos = hrp.Position,
					wait = 0.15
				})
			end
		end
		task.wait(0.15)
	end
end)

-- ===== PLAY SYSTEM =====
local function playTrack(data)
	if #data == 0 then return end
	playing = true
	notify("Auto Walk Dimulai | Speed "..speedValue)

	local char = getChar()
	local hum = char:WaitForChild("Humanoid")

	repeat
		for _,v in ipairs(data) do
			if not playing then break end
			hum.WalkSpeed = speedValue
			hum:MoveTo(v.pos)
			hum.MoveToFinished:Wait()
			task.wait(v.wait)
		end
	until not loopPlay or not playing

	hum.WalkSpeed = 16
	playing = false
end

-- ===== BUTTONS =====
btnRecord.MouseButton1Click:Connect(function()
	recordData = {}
	recording = true
	paused = false
	notify("Record Track Aktif")
end)

btnPause.MouseButton1Click:Connect(function()
	if recording then
		paused = not paused
		notify(paused and "Record Di-Pause" or "Record Dilanjutkan")
	end
end)

btnPlay.MouseButton1Click:Connect(function()
	if not playing then
		task.spawn(function()
			playTrack(recordData)
		end)
	end
end)

btnLoop.MouseButton1Click:Connect(function()
	loopPlay = not loopPlay
	btnLoop.Text = loopPlay and "Loop: ON" or "Loop: OFF"
	notify("Loop: "..(loopPlay and "ON" or "OFF"))
end)

btnSave.MouseButton1Click:Connect(function()
	if #recordData > 0 then
		table.insert(savedRecords, recordData)
		notify("Record Disimpan")
	end
end)

plus.MouseButton1Click:Connect(function()
	speedValue += 1
	speedText.Text = "Speed: "..speedValue
	notify("Speed: "..speedValue)
end)

minus.MouseButton1Click:Connect(function()
	speedValue = math.max(5, speedValue - 1)
	speedText.Text = "Speed: "..speedValue
	notify("Speed: "..speedValue)
end)
