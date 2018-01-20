// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_takeArtilleryStrike.sqf
//	@file Author: AgentRev

params [["_player",objNull,[objNull]], ["_obj",objNull,[objNull]], ["_granted",false,[false]]];

if (!alive _player || !isRemoteExecuted) exitWith {};

if (_granted) then // client post-process
{
	["artillery", 1] call mf_inventory_add;
	["You have picked up an Artillery Strike.\n You can use it from the Player Menu. ", 5] call a3w_actions_notify;
}
else // server process
{
	if (!isServer || !alive _obj || remoteExecutedOwner != owner _player) exitWith {};

	if (_obj getVariable ["mf_item_id",""] == "artillery") then // dropped item
	{
		private _ownerUnit = _obj getVariable ["ownerUnit", objNull];
		if (alive _ownerUnit && _ownerUnit distance _obj < 10) exitWith {};
		_obj setVariable ["ownerUnit", _player];
		deleteVehicle _obj; // obj could be remote, so delete might not be instant, hence why setVariable for extra safety
		_granted = true;
	}
	else
	{
		private _strikeCount = _obj getVariable ["artillery", 0];
		if (_strikeCount < 1) exitWith {};
		_obj setVariable ["artillery", _strikeCount - 1, true];

		if (_obj isKindOf "AllVehicles" && !(_obj isKindOf "StaticWeapon")) then
		{
			if (!isNil "fn_manualVehicleSave") then { _obj call fn_manualVehicleSave };
		}
		else
		{
			if (!isNil "fn_manualObjectSave") then { _obj call fn_manualObjectSave };
		};

		_granted = true;
	};

	if (_granted) then
	{
		[_player, _obj, _granted] remoteExecCall ["A3W_fnc_takeArtilleryStrike", _player];
	};
};
