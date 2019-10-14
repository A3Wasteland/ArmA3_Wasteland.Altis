// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: populateVehicleStore.sqf
//	@file Author: [KoS] His_Shadow, AgentRev
//	@file Created: 1/09/2013 05:13
//	@file Args: [vehicle_type]

#include "dialog\vehiclestoreDefines.hpp";
disableSerialization;
private ["_switch", "_dialog", "_vehlisttext", "_vehlist", "_colorlist", "_vehArray", "_noBuzzard", "_playerSideNum", "_vehClass", "_vehPicture", "_vehlistIndex"];
_switch = _this select 0;

// Grab access to the controls
_dialog = findDisplay vehshop_DIALOG;
_vehlisttext = _dialog displayCtrl vehshop_veh_TEXT;
_vehlist = _dialog displayCtrl vehshop_veh_list;
_colorlist = _dialog displayCtrl vehshop_color_list;
private _partList = _dialog displayCtrl vehshop_part_list;

lbClear _vehlist;
lbClear _colorlist;
lbClear _partList;
_vehlist lbSetCurSel -1;

_vehArray = switch (_switch) do
{
	case 0: { call landArray };
	case 1: { call armoredArray };
	case 2: { call tanksArray };
	case 3: { call helicoptersArray };
	case 4: { call planesArray };
	case 5: { call boatsArray };
	default { [] };
};

_noBuzzard = ["vehicleStore_noBuzzard", true] call getPublicVar;

_playerSideNum = switch (playerSide) do
{
	case BLUFOR:      { 1 };
	case OPFOR:       { 0 };
	case INDEPENDENT: { 2 };
	default           { 3 };
};

// Populate the vehicle shop list
{
	_x params ["_vehName", "_vehClass"];

	if ((!_noBuzzard || {!(_vehClass isKindOf "Plane_Fighter_03_base_F")}) && !("HIDDEN" in (_x select [3,999]))) then
	{
		_vehCfg = configFile >> "CfgVehicles" >> _vehClass;

		if (["UGV_01_base_F","UGV_02_Base_F","UAV_01_base_F","UAV_02_base_F","UAV_06_base_F"] findIf {_vehClass isKindOf _x} == -1 || {getNumber (_vehCfg >> "side") in [3,_playerSideNum]}) then
		{
			_vehPicture = getText (configFile >> "CfgVehicles" >> _vehClass >> "picture");
			_vehlistIndex = _vehlist lbAdd format ["%1", [_vehName, getText (_vehCfg >> "displayName")] select (_vehName == "")];
			_vehlist lbSetPicture [_vehlistIndex, _vehPicture];
			_vehlist lbSetData [_vehlistIndex, str _x];

			[_x, configFile >> "CfgVehicles", _vehlist, _vehlistIndex] call fn_checkStoreItemDLC;
		};
	};
} forEach _vehArray;
