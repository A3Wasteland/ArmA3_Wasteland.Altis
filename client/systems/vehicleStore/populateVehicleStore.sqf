//	@file Version: 1.0
//	@file Name: populateVehicleStore.sqf
//	@file Author: [KoS] His_Shadow, AgentRev
//	@file Created: 1/09/2013 05:13
//	@file Args: [vehicle_type]

#include "dialog\vehiclestoreDefines.hpp";
disableSerialization;
private ["_switch", "_dialog", "_vehlisttext", "_vehlist", "_colorlist", "_vehArray", "_vehClass", "_vehPicture", "_vehlistIndex"];
_switch = _this select 0;

// Grab access to the controls
_dialog = findDisplay vehshop_DIALOG;
_vehlisttext = _dialog displayCtrl vehshop_veh_TEXT;
_vehlist = _dialog displayCtrl vehshop_veh_list;
_colorlist = _dialog displayCtrl vehshop_color_list;

lbClear _vehlist;
lbClear _colorlist;
_vehlist lbSetCurSel -1;

switch (_switch) do 
{
	case 0: { _vehArray = call landArray };
	case 1: { _vehArray = call armoredArray };
	case 2: { _vehArray = call tanksArray };
	case 3: { _vehArray = call helicoptersArray };
	case 4: { _vehArray = call planesArray };
	case 5: { _vehArray = call boatsArray };
	case 6: { _vehArray = call submarinesArray };
	default { _vehArray = [] };
};

// Populate the vehicle shop list
{
	_vehClass = _x select 1;
	_vehPicture = getText (configFile >> "CfgVehicles" >> _vehClass >> "picture");
	_vehlistIndex = _vehlist lbAdd format ["%1", _x select 0];
	_vehlist lbSetPicture [_vehlistIndex, _vehPicture];
	_vehlist lbSetData [_vehlistIndex, _vehClass];
} forEach _vehArray;
