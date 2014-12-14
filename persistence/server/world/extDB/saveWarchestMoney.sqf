// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveWarchestMoney.sqf
//	@file Author: AgentRev

private ["_fundsWest", "_fundsEast"];

_fundsWest = 0;
_fundsEast = 0;

if (["A3W_warchestMoneySaving"] call isConfigOn) then
{
	_fundsWest = ["pvar_warchest_funds_west", 0] call getPublicVar;
	_fundsEast = ["pvar_warchest_funds_east", 0] call getPublicVar;
};

[format ["updateWarchestMoney:%1:%2:%3", call A3W_extDB_ServerID, _fundsWest, _fundsEast]] call extDB_Database_async;
