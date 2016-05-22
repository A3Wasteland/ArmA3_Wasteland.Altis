_inUAV = if (isNil {_this select 0}) then {UAVControl (getConnectedUAV player) select 1 != ""} else {_this select 0};

if (_inUAV) then {
	switch (true) do {
		case (getConnectedUAV player isKindOf "LandVehicle" || getConnectedUAV player isKindOf "Ship"): {
			setTerrainGrid CHVD_carTerrain;
		};
		case (getConnectedUAV player isKindOf "Man"): {
			setTerrainGrid CHVD_footTerrain;
		};
		default {
			setTerrainGrid CHVD_airTerrain;
		};
	};
} else {
	switch (true) do {
		case (vehicle player isKindOf "LandVehicle" || vehicle player isKindOf "Ship"): {
			setTerrainGrid CHVD_carTerrain;
		};
		case (vehicle player isKindOf "Air"): {
			setTerrainGrid CHVD_airTerrain;
		};
		default {
			setTerrainGrid CHVD_footTerrain;
		};
	};
};