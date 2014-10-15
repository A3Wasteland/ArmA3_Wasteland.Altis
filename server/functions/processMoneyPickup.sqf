//	@file Name: processMoneyPickup.sqf
//	@file Author: AgentRev

private ["_player", "_moneyObj", "_money"];

_player = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_moneyObj = [_this, 1, objNull, ["",objNull]] call BIS_fnc_param;

if (typeName _moneyObj == "STRING") then
{
	_moneyObj = objectFromNetId _moneyObj;
};

if (!alive _player || !isPlayer _player || !(_moneyObj isKindOf "Land_Money_F")) exitWith {};

if (_moneyObj getVariable ["owner", "world"] == "world") then
{
	_money = _moneyObj getVariable ["cmoney", 0];
	deleteVehicle _moneyObj;

	if (_money < 0) then { _money = 0 };
	if (_money > 0) then
	{
		_player setVariable ["cmoney", (_player getVariable ["cmoney", 0]) + _money, true];
	};

	pvar_playerEventServer = ["pickupMoney", _money];
	(owner _player) publicVariableClient "pvar_playerEventServer";
};
