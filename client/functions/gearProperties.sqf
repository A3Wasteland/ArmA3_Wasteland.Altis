// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: gearProperties.sqf
//	@file Author: AgentRev
//	@file Created: 08/10/2013 13:58

private ["_newItem", "_type", "_text", "_containerClass", "_oldCapacity", "_oldBallArmor", "_oldExplArmor", "_newCapacity", "_newBallArmor", "_newExplArmor", "_oldItem", "_armorVals", "_diffCapacity", "_diffBallArmor", "_diffExplArmor", "_textArr"];

_newItem = _this select 0;
_type = toLower (_this select 1);

_text = "";
_oldCapacity = 0;
_oldBallArmor = 0;
_oldExplArmor = 0;
_newCapacity = 0;
_newBallArmor = 0;
_newExplArmor = 0;

switch (_type) do
{
	case "uniform":
	{
		_oldItem = uniform player;

		if (_oldItem != "") then
		{
			_oldCapacity = [_oldItem] call getCapacity;
		};

		_newCapacity = [_newItem] call getCapacity;
	};
	case "vest":
	{
		_oldItem = vest player;

		if (_oldItem != "") then
		{
			_oldCapacity = [_oldItem] call getCapacity;
			_armorVals = [_oldItem] call fn_getItemArmor;
			_oldBallArmor = _armorVals select 0;
			_oldExplArmor = _armorVals select 1;
		};

		_newCapacity = [_newItem] call getCapacity;
		_armorVals = [_newItem] call fn_getItemArmor;
		_newBallArmor = _armorVals select 0;
		_newExplArmor = _armorVals select 1;
	};
	case "backpack":
	{
		_oldItem = backpack player;

		if (_oldItem != "") then
		{
			_oldCapacity = [_oldItem] call getCapacity;
		};

		_newCapacity = [_newItem] call getCapacity;
	};
	case "headgear":
	{
		_oldItem = headgear player;

		if (_oldItem != "") then
		{
			_armorVals = [_oldItem] call fn_getItemArmor;
			_oldBallArmor = _armorVals select 0;
			_oldExplArmor = _armorVals select 1;
		};

		_armorVals = [_newItem] call fn_getItemArmor;
		_newBallArmor = _armorVals select 0;
		_newExplArmor = _armorVals select 1;
	};
};

if (_type in ["uniform","vest","backpack"]) then
{
	if (isNil "_oldCapacity") then { _oldCapacity = 0 };
	if (isNil "_newCapacity") then { _newCapacity = 0 };

	_diffCapacity = _newCapacity - _oldCapacity;
	_text = "Capacity: ";

	switch (true) do
	{
		case (_diffCapacity > 0): { _text = _text + (str _newCapacity) + " (<t color='#00ff00'>+" + (str abs _diffCapacity) + "</t>)" };
		case (_diffCapacity < 0): { _text = _text + (str _newCapacity) + " (<t color='#ff0000'>-" + (str abs _diffCapacity) + "</t>)" };
		default                   { _text = _text + (str _newCapacity) + " (<t color='#a0a0a0'>+0</t>)" };
	};

	_text = _text + "<br/>";
};

if (_type in ["vest","headgear"]) then
{
	if (isNil "_oldBallArmor") then { _oldBallArmor = 0 };
	if (isNil "_oldExplArmor") then { _oldExplArmor = 0 };
	if (isNil "_newBallArmor") then { _newBallArmor = 0 };
	if (isNil "_newExplArmor") then { _newExplArmor = 0 };

	_diffBallArmor = _newBallArmor - _oldBallArmor;
	_diffExplArmor = _newExplArmor - _oldExplArmor;

	_textArr = [];

	{
		_textArr pushBack format ["%1: %2 %3", _x select 0, _x select 1, switch (true) do
		{
			case (_x select 2 > 0):  { "(<t color='#00ff00'>+" + str abs (_x select 2) + "</t>)" };
			case (_x select 2 < 0):  { "(<t color='#ff0000'>-" + str abs (_x select 2) + "</t>)" };
			default                  { "(<t color='#a0a0a0'>+0</t>)" };
		}];
	} forEach [
		["Ballistic Armor", _newBallArmor, _diffBallArmor],
		["Explosive Armor", _newExplArmor, _diffExplArmor]
	];

	_text = _text + (_textArr joinString "<br/>");
};

_text
