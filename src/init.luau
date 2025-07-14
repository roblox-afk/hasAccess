local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Types = require(script.Types)

type ModuleConfig = Types.ModuleConfig
type AccessConfig = Types.AccessConfig
type GroupConfig = Types.GroupConfig

local HasAccessPrivate = {
	NegatePrefix = "!",
	Modules = {} :: { [string]: ModuleConfig },
	IsVerbose = false,
	Groups = {} :: { [string]: GroupConfig },
}

local function ModuleCall(moduleCall: string, player: Player): boolean
	if moduleCall:len() == 0 then
		warn("[HasAccess]: Received empty string")
		return false
	end

	local splitedString = moduleCall:split(":")
	local module = HasAccessPrivate.Modules[splitedString[1]]
	if not module then
		warn(`[HasAccess]: Received Module Name: {splitedString[1]} has not been registered or does not exist!`)
		return false
	end

	return module.Callback(player, HasAccessPrivate.Groups, table.unpack(splitedString, 2))
end

local HasAccess = {}
HasAccess.__index = HasAccess
function HasAccess:__call(config: AccessConfig, player: Player?): boolean
	assert(
		type(config.RequireAll) == "boolean" or config.RequireAll == nil,
		"[HasAccess] RequireAll needs to be a boolean or nil"
	)

	if RunService:IsClient() then
		player = Players.LocalPlayer
	end

	assert(player and player.ClassName == "Player", "[HasAccess]: No Player Instance Provided in call")
	local requireAll = config.RequireAll or false
	for _, accessParam: string | AccessConfig in ipairs(config) do
		local negate = false
		local result = false
		if typeof(accessParam) == "string" then
			local shouldNegate, remainingString = accessParam:match(`^({HasAccessPrivate.NegatePrefix})(.*)`)
			if shouldNegate then
				negate = true
				accessParam = remainingString
			end

			result = ModuleCall(accessParam, player)
		else
			result = self(accessParam)
		end

		if negate then
			result = not result
		end

		if requireAll and not result then
			return false
		end

		if not requireAll and result then
			return true
		end
	end

	if requireAll then
		return true
	else
		return false
	end
end

function HasAccess:RegisterModule(module: ModuleConfig)
	if HasAccessPrivate.Modules[module.Index] ~= nil then
		error(`[HasAccess]: Module with name: "{module.Index}" already exists!`)
	end

	HasAccessPrivate.Modules[module.Index] = module
	if not HasAccessPrivate.IsVerbose then
		return
	end

	print(`[HasAccess]: Loaded Module: {module.Index}`)
end

function HasAccess:RegisterModulesIn(folder: Folder)
	for _, module in ipairs(folder:GetDescendants()) do
		if not module:IsA("ModuleScript") then
			continue
		end

		HasAccess:RegisterModule(require(module))
	end
end

function HasAccess:RegisterGroup(group: GroupConfig)
	if HasAccessPrivate.Groups[group.Index] ~= nil then
		error(`[HasAccess]: Group with name: "{group.Index}" already exists!`)
	end

	HasAccessPrivate.Groups[group.Index] = group
	if not HasAccessPrivate.IsVerbose then
		return
	end

	print(`[HasAccess]: Loaded Group: {group.Index}`)
end

function HasAccess:RegisterGroupsIn(folder: Folder)
	for _, group in ipairs(folder:GetDescendants()) do
		if not group:IsA("ModuleScript") then
			continue
		end

		HasAccess:RegisterGroup(require(group))
	end
end

function HasAccess:SetVerbose(isVerbose: boolean)
	HasAccessPrivate.IsVerbose = isVerbose
end

HasAccess:RegisterModulesIn(script.Modules)

return setmetatable({}, HasAccess)
