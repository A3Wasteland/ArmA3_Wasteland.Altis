private ["_output"];
_terrainGrid = _this select 0;
switch (true) do {
	case (_terrainGrid >= 49): {
		_output = 0;	
	};
	case (_terrainGrid >= 25): {
		_output = 1;	
	};
	case (_terrainGrid >= 12.5): {
		_output = 2;	
	};
	case (_terrainGrid >= 3.125): {
		_output = 3;	
	};
	default {
		_output = 0;	
	};
};
_output
