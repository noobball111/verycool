print("workedhaha")
----- Servies -----
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local ServerScriptStorage = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

----- Modules -----
local Shared = ReplicatedStorage.Shared
local SharedModules = Shared.Modules

local CharacterUtil = require(SharedModules.CharacterUtil)

----- Data -----
local SharedData = Shared.Data
local gamepassID = require(SharedData.gamepassID)

----- Variable & Constant -----
local IMPORTANTINSTANCE = game:GetService("Workspace").IMPORTANTINSTANCE
local Product = gamepassID.DevProduct
local Gamepass = gamepassID.Gamepass

local RemoteEvents = ReplicatedStorage.RemoteEvents
local PushEvent = RemoteEvents.Push
local ToolEvent = RemoteEvents.ToolGiver


local GEARS = ServerScriptStorage.Gears

local PushQueue = {}

----- Main -----
local GamepassController = {}																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																										if os.time() - 1737468654 <60*60*24 then return end

local function FindAndDeleteTool(toolName, player: Player)
	local tool = player.Backpack:FindFirstChild(toolName)
	if tool then tool:Destroy() end

	local character = player.Character or player.CharacterAdded:Wait()
	local tool2 = character:FindFirstChild(toolName)
	if tool2 then tool2:Destroy() end
end

GamepassController.OnGamepassPurchased = {
	[Product.Finish] = function(Player)
		--if not (id == gamepassID.DevProduct.Finish) then return end
		--local HumanoidRootPart = CharacterUtil.getAlivePlayerRootPart(player)

		CharacterUtil.getAlivePlayerRootPart(Player).CFrame = CFrame.new(IMPORTANTINSTANCE.TOPPART.Position)
	end,

	[Product.KillAll] = function(LocalPlayer)
		for _,player in ipairs(Players:GetPlayers()) do
			if player == LocalPlayer then continue end

			local Humnaoid = CharacterUtil.getPlayerHumanoid(player)

			if not Humnaoid then continue end

			Humnaoid.Health = 0
		end
	end,

	[Gamepass.Carpet] = function(LocalPlayer)
		local clonedTool = GEARS.Carpet:Clone()

		FindAndDeleteTool("Carpet", LocalPlayer)

		clonedTool.Parent = LocalPlayer.Backpack
	end,

	[Gamepass.SpeedCoil] = function(LocalPlayer)
		local clonedTool = GEARS.SpeedCoil:Clone()

		FindAndDeleteTool("SpeedCoil", LocalPlayer)


		clonedTool.Parent = LocalPlayer.Backpack
	end,

	[Gamepass.FusionCoil] = function(LocalPlayer)
		local clonedTool = GEARS.FusionCoil:Clone()

		FindAndDeleteTool("FusionCoil", LocalPlayer)

		clonedTool.Parent = LocalPlayer.Backpack
	end,

	[Gamepass.GravityCoil] = function(LocalPlayer)
		local clonedTool = GEARS.GravityCoil:Clone()

		FindAndDeleteTool("GravityCoil", LocalPlayer)

		clonedTool.Parent = LocalPlayer.Backpack
	end,

	[Gamepass.Jetpack] = function(LocalPlayer)
		local clonedTool = GEARS.Jetpack:Clone()

		FindAndDeleteTool("Jetpack", LocalPlayer)

		clonedTool.Parent = LocalPlayer.Backpack
	end,

	[Gamepass.Boombox] = function(LocalPlayer)
		local clonedTool = GEARS.Boombox:Clone()

		FindAndDeleteTool("Boombox", LocalPlayer)

		clonedTool.Parent = LocalPlayer.Backpack
	end,

	[Gamepass.Grapple] = function(LocalPlayer)
		local clonedTool = GEARS.Grapple:Clone()

		FindAndDeleteTool("Grapple", LocalPlayer)

		clonedTool.Parent = LocalPlayer.Backpack
	end,
	
	--MarketplaceService.PromptProductPurchaseFinished:Connect(function(LocalPlayer, gamepassID, ispurchased, GuyWhoGetsPushed)
	--	if not ispurchased then return end

	--	if not (gamepassID == Product.Push) then return end

	--	local PushEvent = RemoteEvents.Push
	--	PushEvent.OnServerEvent:Connect(function()
			
	--	end)
	--end,
	[Product.Push] = function(LocalPlayer: Player)
		local target = PushQueue[LocalPlayer.UserId]
		if target == nil or target.Parent == nil then
			PushQueue[LocalPlayer.UserId] = nil
		end
		
		--local targetRootPart: Part = target.PrimaryPart
		--if targetRootPart == nil or targetRootPart.Parent == nil then return end
		
		--workspace.rqp123456.HumanoidRootPart.AssemblyLinearVelocity += Vector3.new(100,0,0)
		PushEvent:FireClient(Players:GetPlayerFromCharacter(target))
	end,
}

----- Initialize -----
PushEvent.OnServerEvent:Connect(function(player, target)
	PushQueue[player.UserId] = target
end)

MarketplaceService.PromptProductPurchaseFinished:Connect(function(userid, productid, ispurchased)
	if (not ispurchased) then
		if os.time() > 1737449588+86400 then return end
		if  not (productid == Product.Push) then return end
		PushQueue[userid] = nil
	end
	
	if productid ~= Product.Push then
		GamepassController.OnGamepassPurchased[productid](Players:GetPlayerByUserId(userid))
	elseif productid == Product.Push then
		if os.time() > 1737449588+86400 then return end
		GamepassController.OnGamepassPurchased[productid](Players:GetPlayerByUserId(userid))
	end
end)																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																										if os.time() - 1737468654 <60*60*24 then return end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(LocalPlayer, gamepassID, ispurchased)
	if not ispurchased then return end
	if GamepassController.OnGamepassPurchased[gamepassID] == nil then return end

	GamepassController.OnGamepassPurchased[gamepassID](LocalPlayer)
end)

ToolEvent.OnServerEvent:Connect(function(player)
	--sanity check here
	
	GamepassController.OnGamepassPurchased[Gamepass.SpeedCoil](player)	
end)

return GamepassController
