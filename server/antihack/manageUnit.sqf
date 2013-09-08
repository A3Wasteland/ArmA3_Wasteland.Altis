//	@file Version: 1.0
//	@file Name: manageUnit.sqf
//	@file Author: AgentRev
//	@file Created: 04/07/2013 20:46

private ["_unit", "_packetKey", "_assignPacketKey", "_checksum", "_assignChecksum", "_varPayload", "_fastVarPayload"];

_unit = _this select 0;
_packetKey = _this select 1;
_assignPacketKey = _this select 2;
_checksum = _this select 3;
_assignChecksum = _this select 4;
_varPayload = _this select 5;
_fastVarPayload = _this select 6;

_unit addEventHandler ["HandleDamage", {false}];
_unit disableAI "MOVE";
_unit disableAI "FSM";

if (isServer) then
{
	removeAllWeapons _unit;
	removeBackpack _unit;
	removeVest _unit;
	removeUniform _unit;
	removeGoggles _unit;
	_unit addVest "V_RebreatherIR";
	_unit addUniform "U_O_Wetsuit";
	_unit addGoggles "G_Diving";
	_unit setPosATL [1,1,1];
	_unit switchMove "";
		
	[_unit, _packetKey, _assignPacketKey, _checksum, _assignChecksum] spawn
	{
		private ["_unit"];
		_unit = _this select 0;
		
		while { alive _unit } do { sleep 1 };
		
		if (!isNull _unit) then
		{
			deleteVehicle _unit;
		};
		
		[_this select 1, _this select 2, _this select 3, _this select 4] execVM "server\antihack\createUnit.sqf";
	};
};

if (isNil _checksum) then
{
	fn_findString = compileFinal preprocessFileLineNumbers "server\antihack\fn_findString.sqf";
	fn_filterString = compileFinal preprocessFileLineNumbers "server\antihack\fn_filterString.sqf";
	
	if (!isDedicated) then
	{
		if (!isServer) then
		{
			TPG_fnc_MPexec = compileFinal (_assignPacketKey + (preprocessFileLineNumbers "server\antihack\remote\fn_MPexec.sqf"));
			TPG_fnc_MP = compileFinal (_assignPacketKey + (preprocessFileLineNumbers "server\antihack\remote\fn_MP.sqf"));
			call compile (_assignPacketKey + (preprocessFileLineNumbers "server\antihack\remote\fn_initMultiplayer.sqf"));
		};
		
		clientFlagHandler = compileFinal (_assignChecksum + (preprocessFileLineNumbers "server\antihack\clientFlagHandler.sqf"));
		chatBroadcast = compileFinal (_assignChecksum + (preprocessFileLineNumbers "server\antihack\chatBroadcast.sqf"));
		[] spawn compile (_assignChecksum + (preprocessFileLineNumbers "server\antihack\payload.sqf"));
		
		if (_varPayload != "") then
		{
			[] spawn compile (_assignChecksum + _varPayload);
		};
		
		if (_fastVarPayload != "") then
		{
			[] spawn compile (_assignChecksum + _fastVarPayload);
		};
	};
	
	call compile format ["%1 = compileFinal 'true'", _checksum];
};
