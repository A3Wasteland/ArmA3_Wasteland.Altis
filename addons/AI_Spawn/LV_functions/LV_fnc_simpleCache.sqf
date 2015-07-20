/*ARMA3Alpha function LV_fnc_simpleCache v0.6 - by SPUn / lostvar

		This script caches fillHouse & militarize scripts.

	nul = [[ID's],[players],distance,keep count,MP] execVM "addons\AI_Spawn\LV_functions\LV_fnc_simpleCache.sqf";
	
	ID's		=	array of script ID's
	players 	=	array of players (doesnt matter what you set here if you use MP mode)
	distance	=	distance between player(s) and militarize/fillHouse on where scripts will be activated
	keep count	=	true = script will count & save AI amounts, false = AI amount will be reseted on each time it activates again
	MP			=	true = all alive non-captive playableUnits will activate scripts, false = only units in players-array
	
	example:
	
	nul = [[13,14],[playerUnit1],500,true,false] execVM "addons\AI_Spawn\LV_functions\LV_fnc_simpleCache.sqf";

*/
if (!isServer)exitWith{};
private ["_mp","_i","_cPos","_inRange","_aliveCount","_grp","_center","_scriptParams","_id","_ids","_units","_distance","_amountArr","_script","_params","_vehicleAmount","_vehicleArr","_excludeSingleHeliPilot","_inRangeUnits","_pilotCandidate"];

//Additional settings:
_excludeSingleHeliPilot = false; //true = if single player flies over area as pilot, area wont trigger (reduces lag)
//

_ids = _this select 0;
_units = _this select 1;
_distance = _this select 2;
_keepCount = _this select 3;
_mp = _this select 4;

if(_mp)then{if(isNil("LV_GetPlayers"))then{LV_GetPlayers = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_getPlayers.sqf";};};

while{true}do{
	for[{_i=0}, {_i<(count _ids)}, {_i=_i+1}] do{
		
		waitUntil{sleep 1;(!isNil("LVgroup"+(str (_ids select _i))))}; //wait til group exists
		call compile format["_grp = LVgroup%1;",(str (_ids select _i))]; //get group
		waitUntil{sleep 1;(!isNil("LVgroup"+(str (_ids select _i))+"CI"))};
		call compile format["_scriptParams = LVgroup%1CI",(str (_ids select _i))]; //get arguments
		while{isNil("_scriptParams")}do{sleep 2;call compile format["_scriptParams = LVgroup%1CI",(str (_ids select _i))];};
		
		_id = _ids select _i;
		_script = _scriptParams select 0;
		_params = _scriptParams select 1;

		_center = _params select 0;
	
		_inRange = false;
		if(_center in allMapMarkers)then{
			_cPos = getMarkerPos _center;
		}else{
			if (typeName _center == "ARRAY") then{
				_cPos = _center;
			}else{
				_cPos = getPos _center;
			};
		};
		if(_mp)then{_units = call LV_GetPlayers;};
		_inRangeUnits = [];
		{
			if((_x distance _cPos) < _distance)then{
				_inRange = true;
				_inRangeUnits set[(count _inRangeUnits),_x];
			};
		}forEach _units;
		
		if(_excludeSingleHeliPilot)then{
			if((count _inRangeUnits) == 1)then{
				_pilotCandidate = (_inRangeUnits select 0);
				if((vehicle _pilotCandidate) != _pilotCandidate)then{
					if(((vehicle _pilotCandidate) isKindOf "Air")&&((driver (vehicle _pilotCandidate))==_pilotCandidate))then{
						_inRange = false;
					};
				};
			};
		};
		
		if((isNil("LVgroup"+(str (_ids select _i))+"spawned"))&&(_inRange))then{
			//hint format ["CREATING: LVgroup%1",_id];
			if(_script == "militarize")then{ 
				call compile format["nul = %1 execVM 'addons\AI_Spawn\militarize.sqf';",_params];
			}else{
				call compile format["nul = %1 execVM 'addons\AI_Spawn\fillHouse.sqf';",_params];
			};
			call compile format["LVgroup%1spawned = true;", (_ids select _i)];
		}else{
			if((!isNil("LVgroup"+(str (_ids select _i))+"spawned"))&&(!_inRange))then{
				if(_keepCount)then{
					_aliveCount = ({alive _x} count units _grp);
					//hint format ["DELETING: LVgroup%1 \n SAVED SIZE: %2",_id,_aliveCount];
					_amountArr = [_aliveCount,0];
					if(_script == "militarize")then{
						_vehicleAmount = 0;
						{
							if(vehicle _x != _x)then{
								if((canMove (vehicle _x))&&(alive _x))then{
									_vehicleAmount = _vehicleAmount + 1; _aliveCount = _aliveCount - 1;
								};
							};
						}forEach units _grp;
						_amountArr = [_aliveCount,0];
						call compile format["(LVgroup%1CI select 1) set [6, %2];",_id,_amountArr];
						if(_vehicleAmount > 0)then{
							_vehicleArr = [_vehicleAmount,0];
							call compile format["(LVgroup%1CI select 1) set [7, %2];",_id,_vehicleArr];
						};
					}else{
						call compile format["(LVgroup%1CI select 1) set [4, %2];",_id,_amountArr];
					};
				};
					{
						if(vehicle _x != _x)then{deleteVehicle (vehicle _x);};
						deleteVehicle _x;
					}forEach units _grp;
					call compile format["LVgroup%1spawned = nil;", (_ids select _i)];
				if(_keepCount)then{ //REMOVE this sentence if you want script to be terminated once all units have been killed
					if(_aliveCount == 0)then{
						_ids = _ids - [_id];
					};
				};
			};
		};
	
	};
	sleep 2;
};