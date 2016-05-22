// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: UniformPainter_Menu.sqf
//	@file Author: LouD
//	@file Description: Paint script

#define Paint_Menu_option 17001
disableSerialization;

private ["_start","_panelOptions","_Paint_select","_displayPaint"];
_uid = getPlayerUID player;
if (!isNil "_uid") then 
{
	_start = createDialog "Paint_Menu";

	_displayPaint = uiNamespace getVariable "Paint_Menu";
	_colorlist = _displayPaint displayCtrl Paint_Menu_option;
	lbClear _colorlist;
	_colorlist lbSetCurSel -1;

	_colorsArray  = [];
	_cfgColors = call colorsArray;
	reverse _cfgColors;

	{
		
		_class = _x select 0;
		_texs = _x select 1;

		if (_class == "All") then
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
		_colorlist lbSetPicture [_colorlistIndex, if (typeName _tex == "ARRAY") then { _tex select 0 select 1 } else { _tex }];
		_colorlist lbSetData [_colorlistIndex, str _tex];
		lbSort [_colorlist, "ASC"];
	} forEach _colorsArray;
};