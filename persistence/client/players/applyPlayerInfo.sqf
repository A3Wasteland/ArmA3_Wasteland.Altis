// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: applyPlayerInfo.sqf
//	@file Author: AgentRev

// This is where you load custom player variables that must persist between deaths

private ["_data", "_name", "_value"];

_data = _this;

{
	_name = _x select 0;
	_value = _x select 1;

	switch (_name) do
	{
		//case "Donator": { player setVariable ["Donator", _value > 0] }; // deprecated
		//case "BankMoney": { player setVariable ["bmoney", _value max 0, true] }; // NOTE: Bank money assignation has been moved server-side
	};
} forEach _data;
