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
private ["_vehClass", "_price", "_dialog", "_vehlist", "_vehText", "_colorlist", "_itemIndex", "_itemText", "_itemData", "_colorsArray", "_cfgColors", "_class", "_texs", "_color", "_tex", "_added", "_existingTex", "_colorlistIndex"];

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

if (getArray (configfile >> "CfgVehicles" >> _itemData >> "hiddenSelections") isEqualTo []) exitWith {}; // unpaintable

_colorsArray  = [];

_cfgColors = call colorsArray;
reverse _cfgColors;

{
	_class = _x select 0;
	_texs = _x select 1;

	if (_class == "All" || {_vehClass isKindOf _class}) then
	{
		{
			_color = _x select 0;
			_tex = _x select 1;
			_added = false;

			if (typeName _tex == "ARRAY") then
			{
				_existingTex = [_colorsArray, _color, ""] call fn_getFromPairs;

				if (typeName _existingTex == "ARRAY") then
				{
					{
						[_existingTex, _x select 0, _x select 1] call fn_setToPairs;
					} forEach _tex;
				};
			};

			if (!_added) then
			{
				[_colorsArray, _color, _tex] call fn_setToPairs;
			};
		} forEach _texs;
	};
} forEach _cfgColors;

{
	_tex = _x select 1;
	_colorlistIndex = _colorlist lbAdd (_x select 0);

	_colorlist lbSetPicture [_colorlistIndex, if (_tex isEqualType []) then
	{
		if (count _tex == 1 && _tex isEqualTypeAll "") then
		{
			private _srcTextures = getArray (configFile >> "CfgVehicles" >> _vehClass >> "TextureSources" >> (_tex select 0) >> "textures");
			if (_srcTextures isEqualTo []) exitWith { "" };

			_srcTextures select 0
		}
		else { _tex select 0 select 1 }
	}
	else { _tex }];

	_colorlist lbSetData [_colorlistIndex, str _tex];
} forEach _colorsArray;
