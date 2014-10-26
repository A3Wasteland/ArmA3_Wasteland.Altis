// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: c_applyPlayerInfo.sqf
//	@file Author: AgentRev

// This is where you load custom player variables that must persist between deaths, i.e. bank money amount if you have an ATM addon

if (isDedicated) exitWith {};

private ["_data", "_name", "_value"];

_data = _this;

{
	_name = _x select 0;
	_value = _x select 1;

	switch (_name) do
	{
		case "Donator": { player setVariable ["isDonator", _value > 0] };
		//case "BankMoney": { player setVariable ["bmoney", _value max 0] }; // Not implemented in vanilla mission
	};
} forEach _data;
