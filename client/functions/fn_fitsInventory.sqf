//	@file Version: 2.0
//	@file Name: fn_fitsInventory.sqf
//	@file Author: AgentRev
//	@file Created: 05/05/2013 00:22
//	@file Args: _player, _item

private ["_player", "_item", "_return", "_allowedContainers"];

_player = _this select 0;
_item = _this select 1;
_return = false;

if (count _this > 2) then
{
	_allowedContainers = _this select 2;
}
else
{
	_allowedContainers = ["uniform", "vest", "backpack"];
};

if (typeName _allowedContainers != "ARRAY") then
{
	_allowedContainers = [_allowedContainers];
};

{
	if (typeName _x == "STRING") then
	{
		switch (toLower _x) do
		{
			case "uniform":  { _return = _return || {_player canAddItemToUniform _item} };
			case "vest":     { _return = _return || {_player canAddItemToVest _item} };
			case "backpack": { _return = _return || {_player canAddItemToBackpack _item} };
		};
	};
} forEach _allowedContainers;

_return
