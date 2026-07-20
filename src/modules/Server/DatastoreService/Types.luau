local Types = {}

export type DatastoreManager = {
	new: (data: any) -> (),
	Set: (self: DatastoreManager, path: { string }, value: any) -> (),
	Get: (self: DatastoreManager, path: { string }) -> (),
	Destroy: () -> (),
}

export type DataProfile = {
	Data: { any },
	UserId: number,
	_dirty: boolean,
}

return Types
