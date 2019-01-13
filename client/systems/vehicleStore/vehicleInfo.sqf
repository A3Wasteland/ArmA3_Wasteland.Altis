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
private ["_dialog", "_vehlist", "_vehText", "_colorlist", "_itemIndex", "_itemText", "_colorsArray", "_cfgColors", "_class", "_texs", "_color", "_tex", "_added", "_existingTex", "_colorlistIndex"];

//Initialize Values
_vehClass = "";
_price = 0;

// Grab access to the controls
_dialog = ctrlParent (_this select 0);
_vehlist = _dialog displayCtrl vehshop_veh_list;
_vehText = _dialog displayCtrl vehshop_veh_TEXT;
_colorlist = _dialog displayCtrl vehshop_color_list;
_partList = _dialog displayCtrl vehshop_part_list;

lbClear _colorlist;
lbClear _partList;
_colorlist lbSetCurSel -1;
_partList lbSetCurSel -1;

//Get Selected Item
_itemIndex = lbCurSel _vehlist;
_itemText = _vehlist lbText _itemIndex;
_itemData = if (isNil "_itemData") then compile (_vehlist lbData _itemIndex) else { _itemData }; // [name, class, price, type, variant, ...]

if (isNil "_itemData") exitWith
{
	_vehText ctrlSetText "";
};

_itemData params ["_vehName", "_vehClass", "_price"];

_vehText ctrlSetText format ["%1Price: $%2", [_vehName + "\n", ""] select isNil "_repaint", [_price] call fn_numbersText];

_vehCfg = configFile >> "CfgVehicles" >> _vehClass;

/****************************************************************************************************/
if !(getArray (_vehCfg >> "hiddenSelections") isEqualTo []) then
{
_colorsArray  = [];

_cfgColors = call colorsArray;
reverse _cfgColors;

{
	_class = _x select 0;
	_texs = _x select 1;

	if (_class == "All" || {_vehClass isKindOf _class}) then
	{
		// add all unlisted TextureSources before adding generic colors, except the M-900 because its textures are a fucking mess
		if (_class == "All") then
		{
			if !(_vehClass isKindOf "Heli_Light_01_base_F") then
			{
				private ["_texSrcCfg", "_texSrc", "_texName"];

				{
					_texSrcCfg = _x;
					_texSrc = configName _texSrcCfg;

					if (_colorsArray findIf {_x select 1 isEqualTo [_texSrc]} == -1) then
					{
						_texName = getText (_texSrcCfg >> "displayName");
						_texName = format ["%1 - %2" , [_texName,_texSrc] select (_texName == ""), getText (_vehCfg >> "displayName")];
						[_colorsArray, _texName, [_texSrc]] call fn_setToPairs;
					};
				} forEach configProperties [_vehCfg >> "TextureSources", "!(getArray (_x >> 'textures') isEqualTo [])"];
			};

			_colorsArray sort true;
		};

		{
			_color = _x select 0;
			_tex = _x select 1;
			_added = false;

			if (_tex isEqualType []) then
			{
				_existingTex = [_colorsArray, _color, ""] call fn_getFromPairs;

				if (_existingTex isEqualType []) then
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

if (!isNil "_repaint" && {_repaint}) then
{
	_colorlistIndex = _colorlist lbAdd "default";
	_colorlist lbSetData [_colorlistIndex, "''"];
};

{
	_x params ["_texName", "_texData"];
	_tex = _texData;

	if (_tex isEqualType []) then
	{
		if (count _tex == 1 && _tex isEqualTypeAll "") then
		{
			_srcTextures = getArray (_vehCfg >> "TextureSources" >> (_tex select 0) >> "textures");

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
};
/****************************************************************************************************/

// disable custom parts for MH-9 Hummingbird, because if "Add back seats" is unticked, people can still sit in the back and are invisible from the outside
if (_vehClass isKindOf "B_Heli_Light_01_F") exitWith {};

// default initPhase
_animSources = configProperties [_vehCfg >> "AnimationSources", "getText (_x >> 'displayName') != ''"];

if (!isNil "_vehicle" && {!isNull _vehicle}) then // repaint old vehicle
{
	_animSources = _animSources apply { [configName _x, _vehicle animationSourcePhase configName _x] };
}
else // new vehicle
{
	_animSources = _animSources apply { [configName _x, getNumber (_x >> "initPhase")] };

	// animationList initPhase override
	_animList = getArray (_vehCfg >> "animationList");
	for "_i" from 0 to (count _animList - 1) step 2 do
	{
		_initOdds = _animList select (_i+1);
		[_animSources, _animList select _i, round _initOdds] call fn_setToPairs;
	};
};

_parts = [];

{
	_x params ["_animSrc", "_initPhase"];
	_animSrcCfg = _vehCfg >> "AnimationSources" >> _animSrc;
	_animName = getText (_animSrcCfg >> "displayName");
	_animScope = _animSrcCfg >> "scope";

	if (_animName != "" && {getNumber _animScope > 1 || !isNumber _animScope}) then // same display conditions as in BIS_fnc_garage (vehicle appearance editor)
	{
		_parts pushBack [_animName, _animSrc, vehshop_list_checkboxTextures select (_initPhase >= 1)];
	};
} forEach _animSources;

_parts sort true;

{
	_x params ["_animName", "_animData", "_animPicture"];
	_partListIndex = _partList lbAdd _animName;
	_partList lbSetPicture [_partListIndex, _animPicture];
	_partList lbSetData [_partListIndex, _animData];
} forEach _parts;
