local RunService = game:GetService("RunService")
return {
	Index = "IsServer",
	Callback = function()
		return RunService:IsServer()
	end,
}
