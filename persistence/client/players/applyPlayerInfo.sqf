// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: applyPlayerInfo.sqf
//	@file Author: AgentRev

// This is where you load custom player variables that must persist between deaths

private _data = _this;

{
	_x params ["_name", "_value"];

	switch (_name) do
	{
		case "Donator": { player setVariable ["Donator", _value > 0] }; // not used in vanilla
		//case "BankMoney": { player setVariable ["bmoney", _value max 0, true] }; // NOTE: Bank money assignation has been moved server-side
		case "Bounty": { player setVariable ["bounty", _value, true] };
		case "BountyKills": { player setVariable ["bountyKills", _value, true] };
		case "PrivateStorage": { player setVariable ["private_storage", _value] };
		case "ParkedVehicles": { player setVariable ["parked_vehicles", _value] }; // parked vehicles are mostly handled server-side, this is just a ghost copy to populate UI
	};
} forEach _data;
