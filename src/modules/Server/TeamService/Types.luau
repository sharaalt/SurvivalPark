local Types = {}

export type TeamTable = {
	_teamCreated: number,
	_teamObject: Team,
	_teamPlayers: { [number]: Player },
}

return Types
