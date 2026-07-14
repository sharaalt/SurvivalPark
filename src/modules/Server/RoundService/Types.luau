local Types = {}

export type RoundTable = {
	_roundName: string,
	_roundDuration: number,
	_ronudPlayers: { Player },
}

export type BaseRound = {
	new: (roundName: string, roundDuration: number, roundPlayers: { Player }) -> (),
	StartRound: (self: BaseRound) -> (),
	AssignTeams: (self: BaseRound) -> (),
	EndRound: (self: BaseRound) -> (),
	_main: (self: BaseRound) -> (),
	Destroy: (self: BaseRound) -> (),
}

return Types
