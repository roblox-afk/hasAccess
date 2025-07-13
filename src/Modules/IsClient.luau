local RunService = game:GetService("RunService")
return {
	Index = "IsClient",
	Callback = function()
		return RunService:IsClient()
	end,
}
