local Types = {}

export type DatastoreManager = {
	new: (data: any) -> (),
	Set: () -> (),
	Get: () -> (),
	Destroy: () -> (),
}

export type DataProfile = {
	Data: { any },
	UserId: number,
	_dirty: boolean,
}

return Types
