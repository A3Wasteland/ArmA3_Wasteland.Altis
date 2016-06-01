_updateType = [_this, 0, 0, [0]] call BIS_fnc_param; // 1 - view, 2 - obj, 3 - both, 0 - both and terrain
_inUAV = if (isNil {_this select 1}) then {UAVControl (getConnectedUAV player) select 1 != ""} else {_this select 1};

if (_inUAV) then {
	switch (true) do {
		case (getConnectedUAV player isKindOf "LandVehicle" || getConnectedUAV player isKindOf "Ship"): {
			if (_updateType == 1 || _updateType == 0 || _updateType == 3) then {
				setViewDistance CHVD_car;
			};
			if (_updateType == 2 || _updateType == 0 || _updateType == 3) then {
				setObjectViewDistance CHVD_carObj;
			};
		};
		case (getConnectedUAV player isKindOf "Man"): {
			if (_updateType == 1 || _updateType == 0 || _updateType == 3) then {
				setViewDistance CHVD_foot;
			};
			if (_updateType == 2 || _updateType == 0 || _updateType == 3) then {
				setObjectViewDistance CHVD_footObj;
			};
		};
		default {
			if (_updateType == 1 || _updateType == 0 || _updateType == 3) then {
				setViewDistance CHVD_air;
			};
			if (_updateType == 2 || _updateType == 0 || _updateType == 3) then {
				setObjectViewDistance CHVD_airObj;
			};
		};
	};
} else {
	switch (true) do {
		case (vehicle player isKindOf "LandVehicle" || vehicle player isKindOf "Ship"): {
			if (_updateType == 1 || _updateType == 0 || _updateType == 3) then {
				setViewDistance CHVD_car;
			};
			if (_updateType == 2 || _updateType == 0 || _updateType == 3) then {
				setObjectViewDistance CHVD_carObj;
			};
		};
		case (vehicle player isKindOf "Air"): {
			if (_updateType == 1 || _updateType == 0 || _updateType == 3) then {
				setViewDistance CHVD_air;
			};
			if (_updateType == 2 || _updateType == 0 || _updateType == 3) then {
				setObjectViewDistance CHVD_airObj;
			};
		};
		default {
			if (_updateType == 1 || _updateType == 0 || _updateType == 3) then {
				setViewDistance CHVD_foot;
			};
			if (_updateType == 2 || _updateType == 0 || _updateType == 3) then {
				setObjectViewDistance CHVD_footObj;
			};
		};
	};
};
if (_updateType == 0) then {
	[_inUAV] call CHVD_fnc_updateTerrain;
};