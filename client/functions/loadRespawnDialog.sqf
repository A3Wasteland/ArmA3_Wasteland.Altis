//	@file Version: 2.0
//	@file Name: loadRespawnDialog.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, MercyfulFate, AgentRev
//	@file Created: 20/11/2012 05:19

#define respawn_Content_Text 3401
#define respawn_MissionUptime_Text 3402
#define respawn_Town_Button0 3403
#define respawn_Town_Button1 3404
#define respawn_Town_Button2 3405
#define respawn_Town_Button3 3406
#define respawn_Town_Button4 3407
#define respawn_PlayersInTown_Text0 3408
#define respawn_PlayersInTown_Text1 3409
#define respawn_PlayersInTown_Text2 3410
#define respawn_PlayersInTown_Text3 3411
#define respawn_PlayersInTown_Text4 3412
#define respawn_Random_Button 3413
#define respawn_LoadTowns_Button 3414
#define respawn_LoadBeacons_Button 3415
#define respawn_Preload_Checkbox 3416

// Check if both players are on the same side, and that our player is BLUFOR or OPFOR, or that both are in the same group
#define FRIENDLY_CONDITION (side _x == playerSide && {playerSide in [BLUFOR,OPFOR] || group _x == group player})

#define BEACON_CHECK_RADIUS 250

disableSerialization;
waitUntil {!isNil "bis_fnc_init"};

private ["_player", "_city", "_radius", "_name", "_enemyCount", "_friendlyCount", "_side", "_dynamicControlsArray", "_enemyPresent", "_tempArray", "_text", "_players", "_playerArray"];

createDialog "RespawnSelectionDialog";
_display = uiNamespace getVariable "RespawnSelectionDialog";
_display displayAddEventHandler ["KeyDown", "(respawnDialogActive && _this select 1 == 1)"];
_respawnText = _display displayCtrl respawn_Content_Text;
_missionUptimeText = _display displayCtrl respawn_MissionUptime_Text;

_townsButton = _display displayCtrl respawn_LoadTowns_Button;
_beaconsButton = _display displayCtrl respawn_LoadBeacons_Button;

_side = switch (playerSide) do
{
	case BLUFOR: { "BLUFOR" };
	case OPFOR:  { "OPFOR" };
	default      { "Independent" };
};

_respawnText ctrlSetStructuredText parseText (format ["Welcome to Wasteland<br/>You are on %1. Please select a spawn point.", _side]);
respawnDialogActive = true;

_dynamicControlsArray =
[
	[respawn_Town_Button0, respawn_PlayersInTown_Text0],
	[respawn_Town_Button1, respawn_PlayersInTown_Text1],
	[respawn_Town_Button2, respawn_PlayersInTown_Text2],
	[respawn_Town_Button3, respawn_PlayersInTown_Text3],
	[respawn_Town_Button4, respawn_PlayersInTown_Text4]
];

_btnMax = count _dynamicControlsArray;

_disableAllButtons = "";

{
	_disableAllButtons = _disableAllButtons + (format ["ctrlEnable [%1, false]; ", _x]);
} forEach [respawn_Random_Button, respawn_LoadTowns_Button, respawn_LoadBeacons_Button, respawn_Preload_Checkbox];

{
	_button = _display displayCtrl (_x select 0);
	_button ctrlShow false;
	_button ctrlSetText "";
	_disableAllButtons = _disableAllButtons + (format ["ctrlEnable [%1, false]; ", _x select 0]);
} forEach _dynamicControlsArray;

buttonSetAction [respawn_Random_Button, format ["%1 [%2,0] execVM 'client\functions\spawnAction.sqf'", _disableAllButtons, respawn_Random_Button]];

(_display displayCtrl respawn_Preload_Checkbox) cbSetChecked (profileNamespace getVariable ["A3W_preloadSpawn", true]);

_setPlayersInfo =
{
	private ["_location", "_maxRad", "_centerPos", "_maxRad", "_townEntry"];
	
	_location = _this; // spawn beacon object or town marker name
	_isBeacon = (typeName _location == "OBJECT");
	_maxRad = 0;
	_friendlyUnits = [];
	_friendlyPlayers = 0;
	_friendlyNPCs = 0;
	_enemyPlayers = 0;
	_enemyNPCs = 0;
	
	if (_isBeacon) then
	{
		_centerPos = _location call fn_getPos3D;
		_maxRad = BEACON_CHECK_RADIUS;
	}
	else // town
	{
		_centerPos = markerPos _location;
		{
			if (_x select 0 == _location) exitWith
			{
				_maxRad = _x select 1;
			};
		} forEach (call cityList);
	};
	
	{
		if (alive _x && {_x isKindOf "CAManBase"} && {_x distance _centerPos <= _maxRad}) then
		{
			if (FRIENDLY_CONDITION) then
			{
				if (isPlayer _x) then
				{
					_friendlyPlayers = _friendlyPlayers + 1;
					_friendlyUnits set [count _friendlyUnits, _x];
				}
				else
				{
					_friendlyNPCs = _friendlyNPCs + 1;
				};
			}
			else
			{
				if (isPlayer _x) then
				{
					_enemyPlayers = _enemyPlayers + 1;
				}
				else
				{
					if (side _x != sideLogic) then
					{
						_enemyNPCs = _enemyNPCs + 1;
					};
				};
			};
		};
	} forEach allUnits;
	
	// Store enemy counts in the beacon or public variables so we don't have to recount again later on
	if (_isBeacon) then
	{
		_location setVariable ["friendlyUnits", _friendlyUnits];
		_location setVariable ["friendlyPlayers", _friendlyPlayers];
		_location setVariable ["friendlyNPCs", _friendlyNPCs];
		_location setVariable ["enemyPlayers", _enemyPlayers];
		_location setVariable ["enemyNPCs", _enemyNPCs];
	}
	else
	{
		missionNamespace setVariable [format ["%1_friendlyUnits", _location], _friendlyUnits];
		missionNamespace setVariable [format ["%1_friendlyPlayers", _location], _friendlyPlayers];
		missionNamespace setVariable [format ["%1_friendlyNPCs", _location], _friendlyNPCs];
		missionNamespace setVariable [format ["%1_enemyPlayers", _location], _enemyPlayers];
		missionNamespace setVariable [format ["%1_enemyNPCs", _location], _enemyNPCs];
	};
};

_getPlayersInfo =
{
	private ["_location", "_isBeacon"];
	_location = _this; // spawn beacon object or town marker name
	_isBeacon = (typeName _location == "OBJECT");
	
	_friendlyUnits = [];
	_friendlyPlayers = 0;
	_friendlyNPCs = 0;
	_enemyPlayers = 0;
	_enemyNPCs = 0;
	
	if (_isBeacon) then
	{
		_friendlyUnits = _location getVariable ["friendlyUnits", []];
		_friendlyPlayers = _location getVariable ["friendlyPlayers", 0];
		_friendlyNPCs = _location getVariable ["friendlyNPCs", 0];
		_enemyPlayers = _location getVariable ["enemyPlayers", 0];
		_enemyNPCs = _location getVariable ["enemyNPCs", 0];
	}
	else // town
	{
		_friendlyUnits = missionNamespace getVariable [format ["%1_friendlyUnits", _location], []];
		_friendlyPlayers = missionNamespace getVariable [format ["%1_friendlyPlayers", _location], 0];
		_friendlyNPCs = missionNamespace getVariable [format ["%1_friendlyNPCs", _location], 0];
		_enemyPlayers = missionNamespace getVariable [format ["%1_enemyPlayers", _location], 0];
		_enemyNPCs = missionNamespace getVariable [format ["%1_enemyNPCs", _location], 0];
	};
};

// Function to determine the player thresold for use by BIS_fnc_sortBy (friendly = +1, enemy = -1)
_getPlayerThreshold =
{
	private ["_friendlyPlayers", "_friendlyNPCs", "_enemyPlayers", "_enemyNPCs"];
	_this call _getPlayersInfo;
	
	((_friendlyPlayers + _friendlyNPCs) - (_enemyPlayers + _enemyNPCs) + (if (!showBeacons && _enemyPlayers > _friendlyPlayers) then { -1000 } else { 0 }))
};

// Function to determine if a beacon is allowed for use with BIS_fnc_conditionalSelect
_isBeaconAllowed =
{
	private ["_beacon", "_allowed", "_ownerUID"];
	
	_beacon = _this;
	_allowed = false;
	
	if (alive _beacon && _beacon getVariable ["side", sideUnknown] == playerSide) then
	{
		if (playerSide == INDEPENDENT || {_beacon getVariable ["groupOnly", false]}) then
		{
			_ownerUID = _beacon getVariable ["ownerUID", ""];
			
			if ({getPlayerUID _x == _ownerUID} count units player > 0) then
			{
				_allowed = true;
			};
		}
		else
		{
			_allowed = true;
		};
	};
	
	_allowed
};


showBeacons = false;

while {respawnDialogActive} do
{
	_timeText = [serverTime/60/60] call BIS_fnc_timeToString;
	_missionUptimeText ctrlSetText format ["Mission uptime: %1", _timeText];
	
	_locations = [];
	
	_towns = [];
	{
		private "_friendlyPlayers";
		_town = _x select 0;
		_town call _setPlayersInfo;
		
		if (_friendlyPlayers > 0) then
		{
			[_towns, _town] call BIS_fnc_arrayPush;
		};
	} forEach (call cityList);

	_beacons = [];
	{
		if (_x call _isBeaconAllowed) then
		{
			_beacons set [count _beacons, _x];
		};
	} forEach (["pvar_spawn_beacons", []] call getPublicVar);
	
	if (ctrlEnabled (_display displayCtrl respawn_Random_Button)) then
	{
		if (count _towns == 0) then
		{
			if (ctrlEnabled _townsButton) then { _townsButton ctrlEnable false };
		}
		else
		{
			if (!ctrlEnabled _townsButton) then { _townsButton ctrlEnable true };
			if (count _beacons == 0 && showBeacons) then { showBeacons = false };
		};
		
		if (count _beacons == 0) then
		{
			if (ctrlEnabled _beaconsButton) then { _beaconsButton ctrlEnable false };
		}
		else
		{
			if (!ctrlEnabled _beaconsButton) then { _beaconsButton ctrlEnable true };
			if (count _towns == 0 && !showBeacons) then { showBeacons = true };
		};
	};
	
	_locations = if (showBeacons) then
	{
		[_beacons, [], {_x call _getPlayerThreshold}, "DESCEND", {alive _x}] call BIS_fnc_sortBy
	}
	else
	{
		[_towns, [], {_x call _getPlayerThreshold}, "DESCEND"] call BIS_fnc_sortBy
	};
	
	_btnIndex = 0;
	
	{
		_location = _x;
		
		_buttonIdc = _dynamicControlsArray select _btnIndex select 0;
		_button = _display displayCtrl _buttonIdc;
		_text = _display displayCtrl (_dynamicControlsArray select _btnIndex select 1);
		
		_isBeacon = (typeName _location == "OBJECT");
		
		private ["_friendlyUnits", "_friendlyPlayers", "_enemyPlayers", "_enemyNPCs"];
		_location call _getPlayersInfo;
		
		_textStr = "";
		
		if (!_isBeacon) then
		{
			if (_enemyPlayers > _friendlyPlayers) then
			{
				_textStr = _textStr + "[<t color='#ff0000'>Blocked by enemy</t>] ";
				_button ctrlEnable false;
			}
			else
			{
				if (ctrlEnabled (_display displayCtrl respawn_Random_Button)) then
				{
					_button ctrlEnable true;
				};
			};
		};
		
		if (_friendlyPlayers > 0) then
		{
			{
				_textStr = _textStr + format ["<t color='#00ff00'>%1</t>", name _x];
				if (_forEachIndex < _friendlyPlayers - 1 && _textStr != "") then { _textStr = _textStr + ", " };
			} forEach _friendlyUnits;
		};
		
		/*
		if (_friendlyNPCs > 0) then
		{
			if (_textStr != "") then { _textStr = _textStr + ", " };
			_textStr = format ["%1 friendly NPC%2", _friendlyNPCs, if (_friendlyNPCs == 1) then { "" } else { "s" }];
		};
		*/
		
		if (_enemyPlayers > 0) then
		{
			if (_textStr != "") then { _textStr = _textStr + ", " };
			_textStr = _textStr + format ["<t color='#ff0000'>%1 enemy player%2</t>", _enemyPlayers, if (_enemyPlayers == 1) then { "" } else { "s" }];
		};
		
		if (_enemyNPCs > 0) then
		{
			if (_textStr != "") then { _textStr = _textStr + ", " };
			_textStr = _textStr + format ["<t color='#ff0000'>%1 enemy NPC%2</t>", _enemyNPCs, if (_enemyNPCs == 1) then { "" } else { "s" }];
		};

		_data = "";
		
		if (_isBeacon) then
		{
			_pos = getPos _location;
			_owner = _location getVariable ["ownerName", "[Beacon]"];
			
			_button ctrlSetText format ["%1", _owner];
			_data = format ["2,%1", [_pos, _owner]];
		}
		else
		{
			{
				if (_x select 0 == _location) exitWith
				{
					_button ctrlSetText (_x select 2);
					_data = format ["1,'%1'", _location];
				};
			} forEach (call cityList);
		};
		
		_button buttonSetAction format ["%1 [%2,%3] execVM 'client\functions\spawnAction.sqf'", _disableAllButtons, _buttonIdc, _data];
		_button ctrlShow true;
		_text ctrlSetStructuredText parseText _textStr;
		_text ctrlShow true;
		
		_btnIndex = _btnIndex + 1;
		
		if (_btnIndex >= _btnMax) exitWith {}; // no more buttons to display on
	} forEach _locations;
	
	if (_btnIndex < _btnMax) then
	{
		for "_i" from _btnIndex to (_btnMax - 1) do
		{
			_btnArr = _dynamicControlsArray select _i;
			_button = _display displayCtrl (_btnArr select 0);
			_text = _display displayCtrl (_btnArr select 1);
			
			_button ctrlShow false;
			_button ctrlSetText "";
			_button buttonSetAction "";
			_text ctrlShow false;
			_text ctrlSetText "";
		};
	};
	
	sleep 0.25;
};
