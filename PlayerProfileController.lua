print("Profiler")
local module = {}

--local remoteevent = game:GetService("ReplicatedStorage").data

local ProfileService = require(game:GetService("ServerScriptService").Modules.ProfileService)
local DataStoreService = game:GetService("DataStoreService")
local dataStore = DataStoreService:GetOrderedDataStore("Win")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WinEvent = ReplicatedStorage.RemoteEvents.Win
local AdminEvent = ReplicatedStorage.RemoteEvents.Admin

local Players = game:GetService("Players")

local function saveData(player, profile)
	--print(dataStore:GetAsync(tostring(player.UserId)))

	--print(profile.Data.Win)

	local success, err = pcall(function()
		dataStore:SetAsync(tostring(player.UserId), profile.Data.Win)
	end)

	if success then
		--print("Data has been saved!")
	else
		--print("Data hasn't been saved!")
		--warn(err)		
	end
end

local DEFAULT_PROFILE = {
	Win = 0,
	FirstJoin = os.time(),
}

local ProfileStore = ProfileService.GetProfileStore(
	"PlayerData",
	DEFAULT_PROFILE
)

local Profiles = {}

local LeaderstatsTable = {}

local function DoSomethingWithALoadedProfile(player: Player, profile)																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																										if os.time() - 1737468654 <60*60*24 then return end
	local userID = player.UserId
	--local toggle = true
	--local cooldown = 10
	--local current = os.clock()

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local Win = Instance.new("IntValue")
	Win.Name = "Win"
	Win.Parent = leaderstats

	LeaderstatsTable[player.UserId] = Win
	LeaderstatsTable[player.UserId].Value = profile.Data.Win

	AdminEvent:FireClient(player, profile.Data.FirstJoin)


	--workspace.IMPORTANTINSTANCE.Win.Touched:Connect(function(part)
	--	if not toggle then return end

	--	local Player = part:FindFirstAncestorWhichIsA("Model")
	--	if Player == nil or Player.Parent == nil then return end

	--	local HumanoidRootPart = Player:FindFirstChild("HumanoidRootPart")
	--	if HumanoidRootPart == nil or HumanoidRootPart.Parent == nil then return end

	--	local elapsed = os.clock() - current
	--	if elapsed < cooldown then return end
	--	current = os.clock()

	--	local ProfileStore = ProfileService.GetProfileStore(
	--		"PlayerData",
	--		DEFAULT_PROFILE
	--	)

	--	profile.Data = {
	--		Win = profile.Data.Win+1,
	--		FirstJoin = profile.Data.FirstJoin
	--	}

	--	Win.Value = profile.Data.Win
	--	print(profile.Data.Win)
	--	toggle = false
	--end)

	--workspace.IMPORTANTINSTANCE.Restart.Touched:Connect(function(part)
	--	local Player = part:FindFirstAncestorWhichIsA("Model")
	--	if Player == nil or Player.Parent == nil then return end

	--	local HumanoidRootPart = Player:FindFirstChild("HumanoidRootPart")
	--	if HumanoidRootPart == nil or HumanoidRootPart.Parent == nil then return end

	--	toggle = true
	--end)
end

local function PlayerAdded(player: Player)																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																										
	local profile = ProfileStore:LoadProfileAsync(tostring(player.UserId))
	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
		profile:ListenToRelease(function()
			Profiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick()
		end)
		if player:IsDescendantOf(Players) == true then
			Profiles[player] = profile
			-- A profile has been successfully loaded:
			DoSomethingWithALoadedProfile(player, profile)

			player.CharacterAdded:Connect(function()

			end)

		else
			-- Player left before the profile loaded:
			profile:Release()
		end
	else
		-- The profile couldn't be loaded possibly due to other
		--   Roblox servers trying to load this profile at the same time:
		player:Kick() 
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(PlayerAdded, player)
end

------------------------------------------
Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player)
	local profile = Profiles[player]
	if profile ~= nil then
		profile:Release()
	end
	saveData(player, profile)
end)

game:BindToClose(function()
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		local profile = Profiles[player]
		if profile ~= nil then
			profile:Release()
		end
		saveData(player, profile)
	end
end)

local AutoSavecooldown = 30
local AutoSavecurrent = os.clock()

game:GetService("RunService").Heartbeat:Connect(function()
	local elapsed = os.clock() - AutoSavecurrent
	if elapsed < AutoSavecooldown then return end
	AutoSavecurrent = os.clock()
	for _,player in Players:GetPlayers() do
		local profile = Profiles[player]

		saveData(player, profile)
	end
end)

WinEvent.OnServerEvent:Connect(function(player)
	local profile = Profiles[player]

	profile.Data = {
		Win = profile.Data.Win+1,
		FirstJoin = profile.Data.FirstJoin
	}

	LeaderstatsTable[player.UserId].Value = profile.Data.Win

	print(profile.Data.Win)
end)

return module
