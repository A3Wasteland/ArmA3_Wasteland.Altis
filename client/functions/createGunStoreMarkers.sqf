// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: createGunStoreMarkers.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap
//	@file Args:

_radius = 70;
_status = [];
_gunStores = [];
_col_empty = "ColorYellow";
_col_enemy = "ColorRed";
_col_friendly = "ColorGreen";
_col_mixed = "ColorOrange";

//Creates the markers around gunstores.
{
	if (!isPlayer _x && {(vehicleVarName _x) select [0,8] == "GunStore"}) then
	{
		_npcPos = getPosATL _x;

		if (["A3W_showGunStoreStatus"] call isConfigOn) then
		{
			// Circle zone
			_markerName = format["marker_shop_zone_%1",_x];
			deleteMarkerLocal _markerName;
			_marker = createMarkerLocal [_markerName, _npcPos];
			_markerName setMarkerShapeLocal "ELLIPSE";
			_markerName setMarkerColorLocal _col_empty;
			_markerName setMarkerSizeLocal [_radius, _radius];
			_markerName setMarkerBrushLocal "Grid";
			_markerName setMarkerAlphaLocal 0.5;
		};

		/*
		// Gun store title
		_markerName = format["marker_shop_title_%1",_x];
		deleteMarkerLocal _markerName;
		_marker = createMarkerLocal [_markerName, _npcPos];
		_markerName setMarkerShapeLocal "ICON";
		_markerName setMarkerTypeLocal "mil_dot";
		_markerName setMarkerColorLocal "ColorRed";
		_markerName setMarkerSizeLocal [1,1];
		_markerName setMarkerTextLocal "GUN STORE";
		*/

		// Gun store description
		_markerName = format["marker_shop_desc_%1",_x];
		deleteMarkerLocal _markerName;
		// _npcPos set [1, (_npcPos select 1) - 100];
		_marker = createMarkerLocal [_markerName, _npcPos];
		_markerName setMarkerShapeLocal "ICON";
		_markerName setMarkerTypeLocal "mil_dot";
		_markerName setMarkerColorLocal _col_empty;
		_markerName setMarkerSizeLocal [1,1];
		_markerName setMarkerTextLocal "GUN STORE";
		// _markerName setMarkerAlphaLocal 0.5;

		_status pushBack "EMPTY";

		_gunStores pushBack _x;
	};
} forEach entities "CAManBase";

//Used to set the status of each store.
_setStatus =
{
	if(_status select (_this select 0) == (_this select 1)) exitWith {};

	_markerNameZone = format ["marker_shop_zone_%1", _gunStores select (_this select 0)];
	_markerNameDescription = format ["marker_shop_desc_%1", _gunStores select (_this select 0)];
	switch(_this select 1) do {
		case "EMPTY": {
			_markerNameZone setmarkerColorLocal _col_empty;
			_markerNameDescription setmarkerColorLocal _col_empty;
			_markerNameDescription setMarkerTextLocal "GUN STORE";
		};
		case "ENEMY": {
			_markerNameZone setmarkerColorLocal _col_enemy;
			_markerNameDescription setmarkerColorLocal _col_enemy;
			_markerNameDescription setMarkerTextLocal "GUN STORE (Enemies)";
		};
		case "FRIENDLY": {
			_markerNameZone setmarkerColorLocal _col_friendly;
			_markerNameDescription setmarkerColorLocal _col_friendly;
			_markerNameDescription setMarkerTextLocal "GUN STORE (Allies)";
		};
		case "MIXED": {
			_markerNameZone setmarkerColorLocal _col_mixed;
			_markerNameDescription setmarkerColorLocal _col_mixed;
			_markerNameDescription setMarkerTextLocal "GUN STORE (Enemies and Allies)";
		};
	};

	if (["A3W_gunStoreIntruderWarning"] call isConfigOn) then
	{
		if((_this select 2) && ((_this select 1) in ["ENEMY", "MIXED"])) then {
			hintSilent parseText format ["<t size='2' color='#ff0000'>%1</t><br/><br/>%2.","Warning!","Enemy player just entered the area"];
		};
	};

	_status set [_this select 0, _this select 1];
};

if (["A3W_showGunStoreStatus"] call isConfigOn) then
{
	//Check each store to see if their state has changed and then calls the update function to make the display the correct state.
	showmarkers = true;
	while {showmarkers} do
	{
		{
			_npc = _x;
			_friendlyCount = 0;
			_enemyCount = 0;

			{
				if (isPlayer _x && alive _x && _x distance _npc < _radius) then
				{
					if ([_x, player] call A3W_fnc_isFriendly) then
					{
						_friendlyCount = _friendlyCount + 1;
					}
					else
					{
						_enemyCount = _enemyCount + 1;
					};
				};
			} forEach playableUnits;

			if (player distance _npc < _radius) then
			{
				if(_enemyCount > 0) then
				{
					if (_friendlyCount > 0) then
					{
						[_forEachIndex, "MIXED", true] call _setStatus;
					}
					else
					{
						[_forEachIndex, "ENEMY", true] call _setStatus;
					};
				}
				else
				{
					[_forEachIndex, "FRIENDLY", true] call _setStatus;
				};
			}
			else
			{
				if (_enemyCount > 0) then
				{
					if (_friendlyCount > 0) then
					{
						[_forEachIndex, "MIXED", false] call _setStatus;
					}
					else
					{
						[_forEachIndex, "ENEMY", false] call _setStatus;
					};
				}
				else
				{
					if (_friendlyCount > 0) then
					{
						[_forEachIndex, "FRIENDLY", false] call _setStatus;
					}
					else
					{
						[_forEachIndex, "EMPTY", false] call _setStatus;
					};
				};
			};
		} forEach _gunStores;

		sleep 1;
	};
};
