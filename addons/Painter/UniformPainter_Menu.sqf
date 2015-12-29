// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: UniformPainter_ownerMenu.sqf
//	@file Author: LouD / Cael817 for original script
//	@file Description: Paint script

#define Paint_Menu_option 17001
disableSerialization;

private ["_start","_panelOptions","_Paint_select","_displayPaint"];
_uid = getPlayerUID player;
if (!isNil "_uid") then {
	_start = createDialog "Paint_Menu";

	_displayPaint = uiNamespace getVariable "Paint_Menu";
	_Paint_select = _displayPaint displayCtrl Paint_Menu_option;

	_panelOptions = 
	[
		"Bloodshot ($ 500)",
		"Orange Camo ($ 500)",
		"Pink Camo ($ 500)",
		"Red Camo ($ 500)",
		"Digital ($ 500)",
		"Digital Black ($ 500)",
		"Digital Desert ($ 500)",
		"Digital Wood ($ 500)",
		"Drylands ($ 500)",
		"Hex ($ 500)",
		"Sand ($ 500)",
		"Swamp ($ 500)",
		"Urban ($ 500)",
		"Woodland ($ 500)",
		"Woodland Dark ($ 500)",
		"Woodland Tiger ($ 500)",
		"Weed ($ 500)"
	];

	{
		_Paint_select lbAdd _x;
	} forEach _panelOptions;
};

