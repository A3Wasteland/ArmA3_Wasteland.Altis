// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: vehicleInfo.sqf
//	@file Author: [KoS] His_Shadow, AgentRev
//	@file Created: 1/09/2013 05:13
//	@file Args: [vehicle_type]

#include "dialog\vehiclestoreDefines.hpp";

disableSerialization;
private ["_vehClass", "_price", "_dialog", "_vehlist", "_vehText", "_colorlist", "_itemIndex", "_itemText", "_itemData", "_colorsArray", "_colorlistIndex"];

//Initialize Values
_vehClass = "";
_price = 0;

// Grab access to the controls
_dialog = findDisplay vehshop_DIALOG;
_vehlist = _dialog displayCtrl vehshop_veh_list;
_vehText = _dialog displayCtrl vehshop_veh_TEXT;
_colorlist = _dialog displayCtrl vehshop_color_list;
lbClear _colorlist;
_colorlist lbSetCurSel -1;

//Get Selected Item
_itemIndex = lbCurSel _vehlist;
_itemText = _vehlist lbText _itemIndex;
_itemData = _vehlist lbData _itemIndex;

_vehText ctrlSetText "";

{
	if (_itemText == _x select 0 && _itemData == _x select 1) then
	{
		_vehClass = _x select 1;
		_price = _x select 2;
		_vehText ctrlSetText format ["Price: $%1", [_price] call fn_numbersText];
	};
} forEach (call allVehStoreVehicles);

_colorsArray  = [];

{
	if (_x select 0 == "All" || {_vehClass isKindOf (_x select 0)}) then
	{
		{
			[_colorsArray, _x select 0, _x select 1] call fn_setToPairs;
		} forEach (_x select 1);
	};
} forEach call colorsArray;

{
	_colorlistIndex = _colorlist lbAdd (_x select 0);
	_colorlist lbSetPicture [_colorlistIndex, _x select 1];
	_colorlist lbSetData [_colorlistIndex, _x select 1];
} forEach _colorsArray;
