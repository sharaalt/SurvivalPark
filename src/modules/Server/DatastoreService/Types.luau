local Types = {}

export type DatastoreManager = {
	new: (data: any) -> (),
	SaveData: () -> (),
	LoadData: () -> (),
	UpdateData: () -> (),
	Destroy: () -> (),
}

return Types
