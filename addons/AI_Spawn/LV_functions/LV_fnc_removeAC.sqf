//ARMA3Alpha function LV_fnc_removeAC v0.8 - by SPUn / lostvar
//removes ambienCombat units in various ways
//Syntax: nul = [handle,style,syncedUnit,range/delay,flee direction] execVM "addons\AI_Spawn\LV_functions\LV_fnc_removeAC.sqf";
//*handle = the name of ambientCombat, ex: war = [this] execVM "addons\AI_Spawn\ambientCombat.sqf"; <-war is the handle
//*style = 0 or 1 or 2 (0 = units dissapear straight away, 1 = units forfeit and dissapear after *range, 2 = units die straight away)
//*syncedUnit = unit/object ambientCombat is "synced" to (trigger name, or unit name etc, same as on line which calls ambientCombat.sqf)
//*range/delay = range in meters / max delay in secs (if used style 1, units will dissapear after moving *range from *syncedUnit) OR
//												 	 (if used style 2, units will die after random *delay)
//*flee direction = 0-360 (direction where ai will forfeit if style 1 is used) DEFAULT: nil (away from syncedUnit)
if (!isServer)exitWith{};
private ["_i","_i2","_style","_syncedUnit","_range","_unit","_dir","_nPos","_handle","_grp","_fleeDir"];
_handle = _this select 0;
_style = _this select 1;
_syncedUnit = _this select 2;
_range = _this select 3;
_fleeDir = _this select 4;

LV_deleteOnDestination = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_deleteOnDestination.sqf";
LV_killAfterDelay = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_killAfterDelay.sqf";

if(!(isNil("ACpatrol")))then{terminate ACpatrol;};
if(!(isNil("ACcleanUp")))then{terminate ACcleanUp;};
if(!(isNil("ACcommunication")))then{terminate ACcommunication;};
terminate _handle;
_i = 0;
while{_i < (count LV_ACS_activeGroups)}do{
	_grp = LV_ACS_activeGroups select _i;
	{
		_unit = _x;

		switch(_style)do{
			case (0):{
				if(vehicle _unit != _unit)then{deleteVehicle (vehicle _unit);};
				deleteVehicle _unit;
			};
			case (1):{
				if(isNil("_fleeDir"))then{
					_dir = (((getPos _unit) select 0) - ((getPos _syncedUnit) select 0)) atan2 (((getPos _unit) select 1) - ((getPos _syncedUnit) select 1));
					if(_dir < 0) then {_dir = _dir + 360;}; 
					_nPos = [((getPos _syncedUnit) select 0) + (sin _dir) * (_range+200), ((getPos _syncedUnit) select 1) + (cos _dir) * (_range+200), 0];
				}else{
					_dir = _fleeDir;
					_nPos = [((getPos _unit) select 0) + (sin _dir) * (_range+200), ((getPos _unit) select 1) + (cos _dir) * (_range+200), 0];
				};
				
				
				
				if(surfaceIsWater _nPos)then{
					_disPAI = _nPos distance _syncedUnit;
					if(_disPAI < 600)then{_disPAI = 600;};
					_nPos = _nPos findEmptyPosition[1, _disPAI];
				};
				 
				
				_unit doMove _nPos;
				_unit setBehaviour "CARELESS";
				
				//_markerstr = createMarker[("markername"+(str _unit)),_nPos];
				//_markerstr setMarkerShape "ICON";
				//("markername"+(str _unit)) setMarkerType "mil_dot";

				[_unit,_nPos] spawn LV_deleteOnDestination;
			};
			case (2):{
				[_unit, _range] spawn LV_killAfterDelay;
			};
		};
		
	}forEach units _grp;
	LV_ACS_activeGroups = LV_ACS_activeGroups - [_grp];
};

//hint "end";