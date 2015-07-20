scriptName "3Dmarkers.sqf";
/*
	author - BrotherhoodOfHam
	
	version: 1.1
	
	description:
		Shows all user placed map markers as icons on the screen, icons can be toggled on and off by pressing Y.
		MUST be executed on mission start in order to work correctly.
	
	Examples of usage:
	
		init.sqf -
			nul = [] execVM "3Dmarkers.sqf";
		
		or
		
		description.ext -
			class params
			{
				class marker3D
				{
					title = "3D markers";
					values[] = {0,1};
					texts[] = {$STR_DISABLED,$STR_ENABLED};
					default = 1;
					isGlobal = 1;
					file = "3Dmarkers.sqf";
				};
			};
		
	known issues:
		- needs to be run on mission start to work properly - causes issues with detecting which radio channel is selected otherwise.
		
	Todo:
		- Optimize draw3D loop for 3d markers
		- Add support for markers to fade or shrink with distance
*/

#include "\a3\editor_f\data\scripts\dikCodes.h"

//for debugging
//#define DEBUG_MODE

if (!hasInterface) exitWith {};
if (([_this, 0, 1, [1]] call BIS_fnc_param) == 0) exitWith {};

///////////////////////////////////////////////////////////////editable parameters//////////////////////////////////////////////////////////////////////

BH_fnc_mkr3D_toggleKey = DIK_Y; //replace with whatever key you want to use for showing/hiding 3D markers in game. DIK code macros are provided.
BH_fnc_mkr3D_JIPsync = true; //sync markers in global and side chat for JIP players

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

waitUntil {!isNull player};

with uiNamespace do
{
	BH_fnc_mkr3D_logGrp_global = [];
	BH_fnc_mkr3D_logGrp = [];

	BH_fnc_mkr3D_logGrp_west= [];
	BH_fnc_mkr3D_logGrp_east= [];
	BH_fnc_mkr3D_logGrp_ind = [];
	BH_fnc_mkr3D_logGrp_civ = [];

	BH_fnc_mkr3D_logGrp_dir = [];
	BH_fnc_mkr3D_logGrp_veh = [];
	BH_fnc_mkr3D_logGrp_grp = [];
	BH_fnc_mkr3D_logGrp_com = [];
};

BH_fnc_mkr3D =
{
	if (isDedicated) exitWith {};
	
	if (isNull player) then
	{
		waitUntil {!isNull player};
		waitUntil {!isNull ([] call BIS_fnc_displayMission)};
	};
	
	private ["_path", "_pos", "_text", "_markers", "_marker", "_cfg", "_colour", "_index", "_name", "_type", "_grp", "_array", "_data"];
	
	_marker = _this select 0;
	
	if (getMarkerColor _marker == "") exitWith {};
	
	_path = getText (configfile >> "cfgMarkers" >> (markerType _marker) >> "icon");
	
	_pos = getMarkerPos _marker;
	
	#ifdef DEBUG_MODE
		hint parseText format ["<t align = 'center'>3D MARKERS:</t><br/><t align = 'left'>Name: %1<br/>Channel: %2<br/></t>", _marker, (uiNamespace getVariable ["VON_curSelChannel", "error"])];
	#endif
	
	_cfg = configFile >> "cfgMarkers";
	
	_colour = getArray (configfile >> "cfgMarkerColors" >> getMarkerColor _marker >> "color");
	
	if (count _colour == 0) then {_colour = [1,1,1,1]};
	
	{
		if (typeName _x == typeName "") then
		{
			_colour set [_foreachindex, call compile _x];
		};
	} forEach _colour;
	
	_text = markerText _marker;
	
	_logic = "logic" createVehicleLocal _pos;
	
	_data = [] call BH_fnc_mkr3D_VON;
	_grp = _data select 1;
	_type = _data select 2;
	
	_array = uiNamespace getVariable _grp;
	
	_index = count _array;
	_array set [_index, _logic];
	
	uiNamespace setVariable [_grp, _array];
	
	_name = format ["BH_mkr3D_log_%1_%2", _type, _index];
	
	_logic setVehicleVarName _name;
	uiNamespace setVariable [_name, _logic];
	
	_code = format ['uiNamespace getVariable %1', str _name];
	
	_logic setVariable
	[
		"BH_UserMkr_EH",
		addMissionEventhandler
		[
			"draw3D",
			compile format
			[
				'
					if (count (toArray (getMarkerColor %5)) > 0) then
					{
						if (uiNamespace getVariable ["BH_fnc_mkr3D_show", true]) then
						{
							drawIcon3D
							[
								%1,
								%2,
								%3,
								1,
								1,
								0,
								%4,
								0,
								0.05
							];
						};
					}
					else
					{
						_obj = %6;
						
						if (isNull _obj) exitWith {};
						
						_type = (_obj getVariable "BH_UserMkr_Array");
						_array = uiNamespace getVariable _type;
						
						_index = _array find _obj;
						_array set [_index, objNull];
						
						uiNamespace setVariable [_type, _array];
						
						removeMissionEventhandler ["draw3D", _obj getVariable "BH_UserMkr_EH"];
						deleteVehicle _obj;
					};
				',
				str _path,
				_colour,
				_pos,
				str _text,
				str _marker,
				_code
			]
		]
	];
	
	_logic setVariable
	[
		"BH_UserMkr_ID",
		_marker
	];
	
	_logic setVariable
	[
		"BH_UserMkr_Array",
		_grp
	];
};

BH_fnc_mkr3D_VON =
{
	private ["_r"];
	
	if (isDedicated) exitWith {};
	
	_r = switch (uiNamespace getVariable ['VON_curSelChannel', '']) do
	{
		//case localize "str_channel_global" : {[true, "BH_fnc_mkr3D_logGrp_global", 0]};  //Disabled global 3d markers as that'd be obnoxious
		case localize "str_channel_side" : 
		{
			[
				side player, 
				switch (side player) do
				{
					case west: {"BH_fnc_mkr3D_logGrp_west"};
					case east: {"BH_fnc_mkr3D_logGrp_east"};
					case resistance: {"BH_fnc_mkr3D_logGrp_ind"};
					case civilian: {"BH_fnc_mkr3D_logGrp_civ"};
				},
				1
			]
		};
		case localize "str_channel_command" : {[player, "BH_fnc_mkr3D_logGrp_com", 2]};
		case localize "str_channel_group" : {[group player, "BH_fnc_mkr3D_logGrp_grp", 3]};
		case localize "str_channel_vehicle" : {[crew vehicle player, "BH_fnc_mkr3D_logGrp_veh", 4]};
		case localize "str_channel_direct" : {[player, "BH_fnc_mkr3D_logGrp_dir", 5]};
		default {[player, "BH_fnc_mkr3D_logGrp_dir", 5]};
	};
	
	_r
};

disableSerialization;

waitUntil {!isNull ([] call BIS_fnc_displayMission)};

uiNamespace setVariable ["VON_curSelChannel", (localize "str_channel_group")];
uiNamespace setVariable ["BH_fnc_mkr3D_show", true];

_map = (findDisplay 12) displayCtrl 51;

addMissionEventhandler
[
	"draw3D",
	{
		if (!isNull (findDisplay 63)) then
		{
			_text = ctrlText ((findDisplay 63) displayCtrl 101);
			
			uiNamespace setVariable ["VON_curSelChannel", _text];
			
			#ifdef DEBUG_MODE
			hintSilent _text;
			#endif
		};
	}
];

([] call BIS_fnc_displayMission) displayAddEventhandler
[
	"keydown",
	{
		_key = _this select 1;
		
		switch (true) do
		{
			case (_key == BH_fnc_mkr3D_toggleKey):  //default DIK_Y (0x15)
			{
				_toggle = !(uiNamespace getVariable "BH_fnc_mkr3D_show");
				uiNamespace setVariable ["BH_fnc_mkr3D_show", _toggle];
				
				_layer = "BH_marker3D_indic" call BIS_fnc_rscLayer;
				_layer cutRsc ["RscDynamicText", "PLAIN"];
				
				_ctrl = (uiNamespace getVariable "BIS_dynamicText") displayCtrl 9999;
				
				_ctrl ctrlSetPosition
				[
					0.4 * safezoneW + safezoneX,
					0.05 * safezoneH + safezoneY,
					0.2 * safezoneW,
					0.05 * safezoneH
				];
				
				_ctrl ctrlCommit 0;
				
				_format = if (_toggle) then {"on"} else {"off"};
				
				_text = format
				[
					"<t align = 'center' shadow = '0' size = '0.7'>3D markers: %1</t>",
					_format
				];
				
				_ctrl ctrlSetStructuredText parseText _text;
				_ctrl ctrlSetFade 1;
				_ctrl ctrlCommit 2;
			};
		};
		
		false
	}
];

_map ctrlAddEventHandler
[
	"MouseButtonDblClick",
	{
		_this spawn
		{
			disableSerialization;
			
			waitUntil {!isNull (findDisplay 54)}; //RscDisplayInsertMarker
			_display = findDisplay 54;
			
			_display displayAddEventhandler
			[
				"unload",
				{
					disableSerialization;
					
					_display = _this select 0;
					//_map = (findDisplay 12) displayCtrl 51;
					_path = ctrlText (_display displayCtrl 102);
					
					if ((_this select 1) == 1) then
					{
						nul = [allMapMarkers, _path, _display] spawn
						{
							private ["_target", "_persistent"];
							
							_target = ([] call BH_fnc_mkr3D_VON) select 0;
							_persistent = false;
							
							//JIP persistence
							if (BH_fnc_mkr3D_JIPsync) then
							{
								_persistent = switch (typeName _target) do
								{
									case (typeName true): {true};
									case (typeName sideLogic): {true};
									default {false};
								};
							};
							
							[
								[
									[(allMapMarkers - (_this select 0)) select 0],
									{
										if (!hasInterface) exitWith {};
										
										waitUntil {missionNamespace getVariable ["3Dmarkers_intialized", false]};
										
										_this spawn BH_fnc_mkr3D;
									}
								],
								"BIS_fnc_spawn",
								_target,
								_persistent,
								false
							] spawn BIS_fnc_MP;
						};
					};
				}
			]
		};
		
		false
	}
];

{
	(ctrlParent _map) displayAddEventhandler
	[
		_x,
		{
			if (!isNull (findDisplay 63)) then
			{
				_text = ctrlText ((findDisplay 63) displayCtrl 101);
				
				uiNamespace setVariable ["VON_curSelChannel", _text];
				
				#ifdef DEBUG_MODE
				hintSilent _text;
				#endif
			};
		}
	];
} forEach ["mouseMoving", "mouseHolding"];

missionNamespace setVariable ["3Dmarkers_intialized", true];