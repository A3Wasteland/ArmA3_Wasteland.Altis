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
private ["_dialog", "_vehlist", "_vehText", "_colorlist", "_itemIndex", "_itemText", "_itemData", "_colorsArray", "_cfgColors", "_class", "_texs", "_color", "_tex", "_added", "_existingTex", "_colorlistIndex"];

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

_itemData = call compile _itemData; // [name, class, price, type, variant, ...]

if (isNil "_itemData") exitWith
{
	_vehText ctrlSetText "";
};

_itemData params ["", "_vehClass", "_price"];
_vehText ctrlSetText format ["Price: $%1", [_price] call fn_numbersText];

if (getArray (configfile >> "CfgVehicles" >> _vehClass >> "hiddenSelections") isEqualTo []) exitWith {}; // unpaintable

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

					_added = true;
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
	_x params ["_texName", "_texData"];
	private _tex = _texData;

	if (_tex isEqualType []) then
	{
		if (count _tex == 1 && _tex isEqualTypeAll "") then
		{
			private _srcTextures = getArray (configFile >> "CfgVehicles" >> _vehClass >> "TextureSources" >> (_tex select 0) >> "textures");

			if !(_srcTextures isEqualTo []) then
			{
				_tex = _srcTextures select 0;
			};
		}
		else
		{
			_tex sort true;
			_tex = _tex select 0 select 1;
		};
	};

	if (!isNil "_tex" && {_tex isEqualType "" && {_tex != ""}}) then
	{
		_colorlistIndex = _colorlist lbAdd _texName;
		_colorlist lbSetPicture [_colorlistIndex, _tex];
		_colorlist lbSetData [_colorlistIndex, str _texData];
	};
} forEach _colorsArray;
