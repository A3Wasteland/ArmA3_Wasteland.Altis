// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: processMoneyPickup.sqf
//	@file Author: AgentRev

private ["_player", "_moneyObj", "_money"];

_player = param [0, objNull, [objNull]];
_moneyObj = param [1, objNull, ["",objNull]];

if (typeName _moneyObj == "STRING") then
{
	_moneyObj = objectFromNetId _moneyObj;
};

if (!alive _player || !isPlayer _player || !(_moneyObj isKindOf "Land_Money_F")) exitWith {};

if (_moneyObj getVariable ["owner", "world"] == "world") then
{
	_moneyObj setVariable ["owner", getPlayerUID _player];
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
