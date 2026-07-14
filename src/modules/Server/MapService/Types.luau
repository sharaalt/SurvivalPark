local Types = {}

export type BaseMapClass = {
	new: (mapName: string, mapInstance: Model) -> (),
	Move: (position: Vector3) -> (),
	Destroy: () -> (),
}

return Types
