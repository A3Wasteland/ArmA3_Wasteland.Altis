//	@file Version: 1.0
//	@file Name: vehicleInfo.sqf
//	@file Author: [KoS] His_Shadow, AgentRev
//	@file Created: 1/09/2013 05:13
//	@file Args: [vehicle_type]

#include "dialog\vehiclestoreDefines.hpp";

disableSerialization;
private ["_veh_type", "_price", "_dialog", "_vehlist", "_vehText", "_picture", "_colorlist", "_itemIndex", "_itemText", "_itemData", "_weap_type", "_noColorVehicles", "_rgbOnlyVehicles", "_isRGB", "_onlyRGB", "_colorlistIndex"];

//Initialize Values
_veh_type = "";
_picture = "";
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
		_weap_type = _x select 1; 
		_price = _x select 2;
		_vehText ctrlSetText format ["Price: $%1", _price];	
	};
} forEach (call allVehStoreVehicles);

if ({_itemData isKindOf _x} count (call noColorVehicles) == 0) then
{
	_onlyRGB = {_itemData isKindOf _x} count (call rgbOnlyVehicles) > 0;
	
	{
		_isRGB = _x select 1;
		
		if (_isRGB || !_onlyRGB) then
		{
			_colorlist lbAdd format ["%1", _x select 0];
		};
	} forEach (call colorsArray);
};
