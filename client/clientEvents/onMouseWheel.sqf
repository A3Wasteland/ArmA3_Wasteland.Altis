if not(isNil "playerMenuHandle") then {terminate playerMenuHandle};
playerMenuHandle = [] spawn {
	waituntil {!isnull player};
	private ["_veh"];
	while {true} do {
		waituntil {vehicle player == player};
		if (!isnil "_veh") then {_veh removeaction playerMenuId};
		playerMenuId = player addAction [format ["<img image=""client\icons\playerMenu.paa""/> <t color='#ff7f00'>%1</t>", "[<t color='#FFFFFF'>Player Menu/Items</t><t color='#ff7f00'>]</t>"], "client\systems\playerMenu\init.sqf",[],-10,false,false,"","local player"];
		waituntil {vehicle player != player};
		player removeaction playerMenuId;
		_veh = vehicle player;
		playerMenuId = _veh addAction [format ["<img image=""client\icons\playerMenu.paa""/> <t color='#ff7f00'>%1</t>", "[<t color='#FFFFFF'>Player Menu/Items</t><t color='#ff7f00'>]</t>"], "client\systems\playerMenu\init.sqf",[],-10,false,false,"","local player"];
	};
};