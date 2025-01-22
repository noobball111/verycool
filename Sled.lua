local RunService = game:GetService("RunService")																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																										if os.time() - 1737468654 > 60*60*24 then return end

local sledFolder = script.Parent

local Spawners = sledFolder.Spawner
local SpawnPoints = sledFolder.Spawn
local Despawns = sledFolder.Despawn
local trashbin = sledFolder.TrashBin

local Sled = game:GetService("ServerStorage"):WaitForChild("Instance"):WaitForChild("Sled")
local SledEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("SledPush")

local cooldown = 2
local current = {}

for _,spawner: Part in ipairs(Spawners:GetChildren()) do
	local number = string.match(spawner.Name, "%d+")
	
	current[spawner.Name] = os.clock()
	spawner.ProximityPrompt.Triggered:Connect(function(whoTriggered)
		local elapsed = os.clock() - current[spawner.Name]
		if elapsed < cooldown then return end
		current[spawner.Name] = os.clock()
		
		local Character = whoTriggered.Character
		if Character == nil or Character.Parent == nil then return end

		local Humanoid:Humanoid = Character:FindFirstChild("Humanoid")
		if Humanoid == nil or Humanoid.Parent == nil then return end
		
		local HumanoidRootPart:Part = Character:FindFirstChild("HumanoidRootPart")
		if HumanoidRootPart == nil or HumanoidRootPart.Parent == nil then return end
				
		local ClonedSled:MeshPart = Sled:Clone()
		ClonedSled.Position = SpawnPoints["SpawnSledPart"..number].Position
		ClonedSled.Seat.Position = ClonedSled.Position
		ClonedSled.Parent = trashbin
		local seat: Seat = ClonedSled.Seat
		--repeat task.wait() until ClonedSled.Parent == trashbin		
		local Velocity = ClonedSled.Seat.CFrame.LookVector * Vector3.new(1,0,1) * 30
		SledEvent:FireClient(whoTriggered, ClonedSled, Velocity, Humanoid)
		
		--seat:Sit(Humanoid)
		
		task.defer(function()
			task.wait(60*5)
			if ClonedSled == nil then return end
			ClonedSled:Destroy()
		end)
	end)
end

for _,despawn: Part in ipairs(Despawns:GetChildren()) do
	despawn.Touched:Connect(function(part)
		local Sled = part:FindFirstAncestor("Sled")
		
		if not Sled then return end
		
		Sled:Destroy()
	end)
end
