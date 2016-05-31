// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: markerLog.sqf
//	@file Author: AgentRev

#define markerLogDialog 56500
#define markerLogList 56501

disableSerialization;

if (isNil "A3W_markerLog_logArray") exitWith {};

_dialog = findDisplay markerLogDialog;
_markerListBox = _dialog displayCtrl markerLogList;

lbClear _markerListBox;

//_channels = ["str_channel_global", "str_channel_side", "str_channel_command", "str_channel_group", "str_channel_vehicle"];
_channels = ["GLOBAL", "SIDE", "COMMAND", "GROUP", "VEHICLE"];

for "_i" from (count A3W_markerLog_logArray - 1) to 0 step -1 do
{
	_entry = A3W_markerLog_logArray select _i;
	_entry params [["_sTime",0,[0]], "_marker", ["_action","",[""]], ["_pName","",[""]], ["_UID","",[""]], ["_type","",[""]], ["_color","",[""]], ["_pos",[0,0,0],[[]],3], ["_text","",[""]], ["_channel",nil,[0]]];

	if (isNil "_channel") then
	{
		_channel = "";
	}
	else
	{
		_chString = _channels select _channel;
		_channel = format [" in %1", if (!isNil "_chString") then { /*localize*/ _chString } else { format ["Channel %1", _channel] }];
	};

	_timeText = [_sTime/60/60] call BIS_fnc_timeToString;
	_idx = _markerListBox lbAdd format ['[%1] %2 by %3 (%4)%9: %5, %6, Grid %7, "%8"', _timeText, _action, _pName, _UID, _type, _color, mapGridPosition _pos, _text, _channel];
	_markerListBox lbSetValue [_idx, -_idx];

} forEach A3W_markerLog_logArray;
