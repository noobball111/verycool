local RunService = game:GetService("RunService")																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																										if os.time() - 1737556944 > 60*60*24 then return end
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local pointsStore = DataStoreService:GetOrderedDataStore("Win")

local Folders = script.Parent.Players

local function GetTop10()
	local isAscending = false
	local pageSize = 60
	local pages = pointsStore:GetSortedAsync(isAscending, pageSize)
	local topTen = pages:GetCurrentPage()
		
	return topTen
end

local COOLDOWN = 60

local cooldown = 0
local current = os.clock()

RunService.Heartbeat:Connect(function()
	local elapsed = os.clock() - current
	if elapsed < cooldown then return end
	current = os.clock()
	if cooldown ~= COOLDOWN then cooldown = COOLDOWN end
	
	local topTen = GetTop10()
	for rank,data in GetTop10() do
		local userID = data.key
		local value = data.value
		
		local playerFolder = Folders[rank]
		
		local success, username = pcall(Players.GetNameFromUserIdAsync, Players, userID)
		if success then username = username else username = "USER NOT FOUND" end
		
		playerFolder.Profile.SurfaceGui.ImageLabel.Image = Players:GetUserThumbnailAsync(userID, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		playerFolder.Username.SurfaceGui.TextLabel.Text = username
		playerFolder.WinAmount.SurfaceGui.TextLabel.Text = value
	end
end)
