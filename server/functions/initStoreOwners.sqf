
if(!isServer) exitWith {};
private ["_pos","_spotNum", "_name", "_men", "_run", "_fName","_bPos", "_markerName", "_mPos", "_objects", "_building", "_xName", "_deskDirMod", "_pDir", "_chair"];
{
	//collect our arguments
	_name = _x select 0;
	_spotNum = _x select 1;
	_deskDirMod = _x select 2;
	
	//find the building closes to this gun store owner
	_markerName = format["move_%1",_name];
	_mPos = (getMarkerPos _markerName);
	_objects =  nearestObjects [_mPos, ["Building"], 10];
	_building = _objects select 0;

	//if we grabbed more than just the owning building then make damn sure they don't take damage
	{
		_x removeAllEventHandlers "hit";
		_x removeAllEventHandlers "dammaged";
		_x removeAllEventHandlers "handleDamage";
		_x addeventhandler ["hit", {(_this select 0) setdamage 0;}];
		_x addeventhandler ["dammaged", {(_this select 0) setdamage 0;}];
		_x addEventHandler["handledamage", {false}];
		_x allowDamage false;
	}foreach _objects;

	//find the owner himself
	_men = nearestObjects[_mPos, ["Man"], 10];

	//diag_log format["initStoreOwners found vendor %1", _men];

	{
		_xName = name _x;

		// Set the appearance according to the config array
		_storeOwnerAppearance = [(call storeOwnerConfigAppearance), { _x select 0 == _name }] call BIS_fnc_conditionalSelect;
		{
			switch (_x select 0) do {
				case 'weapon': { if (_x select 1 ) != '') then { _x addWeapon (_x select 1); }; };
				case 'uniform': { if (_x select 1 ) != '') then { _x addUniform (_x select 1); }; };
			};
		} forEach (_storeOwnerAppearance select 1); 

		_pDir = (getDir _x);
		_bPos = (_building buildingPos _spotNum);
		/*_chair =*/ [_x, _bPos, _pDir, _deskDirMod, _name] call createStoreFurniture;
		_x setPos [(_bPos select 0), (_bPos select 1), (_bPos select 2)];
		
		_x setVelocity [0,0,0];
		_x disableAI "MOVE"; _x disableAI "ANIM"; _x disableAI "TARGET";
		//_x setDir 45;
		//if(!isNil "_foundChair") then {_x attachTo [_foundChair select 0,[0,-.3,0]];};
		//_x attachTo [_chair select 0,[0,-.3,.25]];};
		//_x switchMove "passenger_flatground_leanright";
	}foreach _men;

	_markerName setMarkerPos (getpos (_men select 0));

}foreach (call storeOwnerConfig);

