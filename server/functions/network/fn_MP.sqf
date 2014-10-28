// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************

/*
	Author: Karel Moricky, modified by AgentRev

	Description:
	Send function for remote execution (and executes locally if conditions are met)

	Parameter(s):
		0: ANY - function params
		1: STRING - function name
		2 (Optional):
			BOOL - true to execute on every client, false to execute it on server only
			OBJECT - the function will be executed only where unit is local [default: everyone]
			GROUP - the function will be executed only on client who is member of the group
			SIDE - the function will be executed on all players of the given side
			NUMBER - the function will be executed only on client with the given ID
			ARRAY - array of previous data types
		3 (Optional): BOOL - true for persistent call (will be called now and for every JIP client) [default: false]

	Returns:
	Nothing (Previously ARRAY - sent packet)
*/

with missionnamespace do {
	private ["_params","_functionName","_target","_isPersistent","_isCall","_packet"];

	_params = [_this,0,[]] call bis_fnc_param;
	_functionName = [_this,1,"",[""]] call bis_fnc_param;
	_target = [_this,2,true,[objnull,true,0,[],sideUnknown,grpnull]] call bis_fnc_param;
	_isPersistent = [_this,3,false,[false]] call bis_fnc_param;
	_isCall = [_this,4,false,[false]] call bis_fnc_param;

	_packet = [0,_params,_functionName,_target,_isPersistent,_isCall];

	//--- Local execution
	if (isServer || !isMultiplayer) then
	{
		[_mpPacketKey, _packet] spawn A3W_fnc_MPexec;
	}
	else //--- Send to server
	{
		missionNamespace setVariable [_mpPacketKey, _packet];
		publicVariableServer _mpPacketKey;
	}

	// call compile _mpPacketKey
};
