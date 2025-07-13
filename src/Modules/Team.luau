local Teams = game:GetService("Teams")
return {
	Index = "Team",
	Callback = function(player: Player, _groups, teamName: string | nil)
		if not teamName or teamName:len() == 0 then
			error("[HasAccess]: No Team name provided for Team Check")
		end

		if not Teams:FindFirstChild(teamName) then
			error(`[HasAccess]: No Team with name: {teamName}`)
		end

		if player.Team.Name == teamName then
			return true
		end

		return false
	end,
}
