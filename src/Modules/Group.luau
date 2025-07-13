local Types = require(script.Parent.Parent.Types)

return {
	Index = "Group",
	Callback = function(
		player: Player,
		groups: { [string]: Types.GroupConfig },
		groupIndex: string?,
		rankRange: string?
	)
		assert(groupIndex, "[HasAccess]: Group Index is required in Group Module")

		local groupConfig = groups[groupIndex]
		if not groupConfig then
			warn(`[HasAccess]: Group with index {groupIndex} not registered! defaulting to false`)
			return false
		end

		local rank = player:GetRankInGroup(groupConfig.GroupId)
		if rank == 0 then
			return false
		elseif not rankRange then
			return true
		end

		if not rankRange then
			return true
		end

		if string.find(rankRange, "-") then
			local RangeSplit = string.split(rankRange, "-")
			local Minimum = tonumber(RangeSplit[1])
			if not Minimum and groupConfig.Ranks[RangeSplit[1]] then
				Minimum = groupConfig.Ranks[RangeSplit[1]].Rank
			else
				error("[HasAccess]: Invalid Minimum Rank Range Provided!")
			end

			local Maximum = tonumber(RangeSplit[2])
			if not Maximum and groupConfig.Ranks[RangeSplit[2]] then
				Maximum = groupConfig.Ranks[RangeSplit[2]].Rank
			else
				error("[HasAccess]: Invalid Maximum Rank Range Provided!")
			end

			return rank >= Minimum and Maximum >= rank
		end

		if string.find(rankRange, "+") then
			local RangeSplit = string.split(rankRange, "+")
			local TargetRank = tonumber(RangeSplit[1])
			if not TargetRank and groupConfig.Ranks[RangeSplit[1]] then
				TargetRank = groupConfig.Ranks[RangeSplit[1]].Rank
			else
				error("[HasAccess]: Invalid Target Rank Provided!")
			end

			return rank >= TargetRank
		end

		if string.find(rankRange, "<") then
			local RangeSplit = string.split(rankRange, "<")
			local TargetRank = tonumber(RangeSplit[1])
			if not TargetRank and groupConfig.Ranks[RangeSplit[1]] then
				TargetRank = groupConfig.Ranks[RangeSplit[1]].Rank
			else
				error("[HasAccess]: Invalid Target Rank Provided!")
			end

			return rank <= TargetRank
		end

		local TargetRank = tonumber(rankRange)
		if not TargetRank and groupConfig.Ranks[rankRange] then
			TargetRank = groupConfig.Ranks[rankRange].Rank
		else
			error("[HasAccess]: Invalid Target Rank Provided!")
		end

		return rank == TargetRank
	end,
}
