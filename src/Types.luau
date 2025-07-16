export type AccessConfig = {
	RequireAll: boolean | nil, -- Default => false
} & ({ string } | { AccessConfig })

export type ModuleConfig = {
	Index: string,
	Callback: (player: Player, groups: { [string]: GroupConfig }, ...string) -> boolean,
}

export type GroupConfig = {
	Index: string,
	GroupId: string,
	Ranks: {
		[string]: {
			Rank: number,
		},
	},
}

return nil
