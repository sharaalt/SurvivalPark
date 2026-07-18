local Types = {}

export type DatastoreManager = {
	new: (data: any) -> (),
	SaveData: () -> (),
	LoadData: () -> (),
	UpdateData: () -> (),
	Destroy: () -> (),
}

export type CacheData = {
	_cacheTime: number,
	_dirtyProfiles: {},
	_datastoreManager: DatastoreManager,
}

return Types
