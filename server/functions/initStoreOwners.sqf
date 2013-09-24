
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


   //_markerName setMarkerShape "ICON";
   //_markerName setMarkerType "mil_dot";
   //_markerName setMarkerColor "ColorRed";
   //_markerName setMarkerText "THE STORE OWNER";

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
		_man = _x;
		_xName = name _man;	


		// Set the appearance according to the config array
		_storeOwnerAppearances = [(call storeOwnerConfigAppearance), { (_x select 0) == _name }] call BIS_fnc_conditionalSelect;
		_storeOwnerAppearance = _storeOwnerAppearances select 0;

		{
			_type = _x select 0;
			_classname = _x select 1;

			switch (_type) do {
				case 'weapon': { if (_classname != '') then { diag_log format["applying %1 as weapon for %2", _classname, _name]; _man addWeapon _classname; }; };
				case 'uniform': { if (_classname != '') then { diag_log format["applying %1 as uniform for %2", _classname, _name];  _man addUniform _classname; }; };
				case 'switchMove': { if (_classname != '') then { diag_log format["applying %1 as switchMove for %2", _classname, _name];  _man switchMove _classname; }; };
			};
		} forEach (_storeOwnerAppearance select 1); 

		_pDir = (getDir _man);
		_bPos = (_building buildingPos _spotNum);
		/*_chair =*/ [_man, _bPos, _pDir, _deskDirMod, _name] call createStoreFurniture;
		_man setPos [(_bPos select 0), (_bPos select 1), (_bPos select 2)];
		
		_man setVelocity [0,0,0];
		_man disableAI "MOVE"; _man disableAI "ANIM"; _man disableAI "TARGET";
		//_man setDir 45;
		//if(!isNil "_foundChair") then {_man attachTo [_foundChair select 0,[0,-.3,0]];};
		//_man attachTo [_chair select 0,[0,-.3,.25]];};
		//_man switchMove "passenger_flatground_leanright";
	}foreach _men;

	_markerName setMarkerPos (getpos (_men select 0));

}foreach (call storeOwnerConfig);

