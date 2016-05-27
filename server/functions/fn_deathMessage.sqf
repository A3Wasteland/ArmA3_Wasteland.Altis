// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_deathMessage.sqf
//	@file Author: AgentRev

if (round difficultyOption "deathMessages" > 0) exitWith {};

params
[
	["_mode", 0, [0]], // 0 = server-side processing, 1 = broadcast message from server to all clients
	["_victim", objNull, [objNull,""]], // victim unit or name string
	["_killer", objNull, [objNull,""]], // killer unit or name string
	["_friendlyFire", false, [false]], // friendly fire boolean, determines if teamkill message needs to be used
	["_aiKiller", false, [false]], // AI killer boolean, ignored if mode = 0
	["_cause", "", [""]] // cause of death string, ignored if mode = 0
];

if (_mode isEqualTo 0) then
{
	if (!isServer) exitWith {};

	private _victimName = _victim getVariable ["A3W_handleDisconnect_name", ""];

	if (_victimName isEqualTo "" && !alive _victim && !isPlayer _victim) exitWith {}; // "Error: No unit"

	(_victim getVariable ["A3W_deathCause_local", []]) params [["_cLocalString","",[""]], ["_cLocalTime",nil,[0]]];
	(_victim getVariable ["A3W_deathCause_remote", []]) params [["_cRemoteString","",[""]], ["_cRemoteTime",2e11,[0]]];

	// death cause tagged by remote sources have an expiry time of 10 secs (serverTime)
	_cause = [_cLocalString, _cRemoteString] select (isNil "_cLocalTime" || {_cRemoteTime < _cLocalTime && _cRemoteTime > _cLocalTime - 10});

	if (_victimName isEqualTo "") then
	{
		_victimName = name _victim;
	};

	private _killerName = if (!alive _killer && !isPlayer _killer) then { "" } else { name _killer };
	_aiKiller = (!isNull _killer && !isPlayer _killer && isNil {_killer getVariable "cmoney"});

	[1, _victimName, _killerName, _friendlyFire, _aiKiller, _cause] remoteExecCall ["A3W_fnc_deathMessage"];
}
else
{
	if (!hasInterface) exitWith {};
	if !([_victim,_killer] isEqualTypeAll "") exitWith {};

	// FOR CONSISTENT USER EXPERIENCE, MESSAGES SHOULD BE LOWERCASE, INVARIABLE, AND EXPLICIT (NO PUNS OR EUPHEMISMS), JUST LIKE DEFAULT ARMA MESSAGES
	private _message = switch (_cause) do
	{
		case "headshot": // enemy player headshot with A3W_headshotNoRevive = 1;
		{
			if (_killer != "") then { format ["%1 headshot %2", _killer, _victim] }
			else                    { format ["%1 was headshot", _victim] } // not supposed to happen, but just in case
		};

		case "slay": // finished off by enemy while bleeding
		{
			if (_killer != "") then { format ["%1 finished off %2", _killer, _victim] }
			else                    { format ["%1 was finished off", _victim] } // not supposed to happen, but just in case
		};

		case "bleedout": { format ["%1 bled out", _victim] }; // bleedout timer ran out, gave up while bleeding

		case "suicide": { format ["%1 suicided", _victim] }; // respawned from pause menu, crashed vehicle, last resort, player setDamage 1

		case "drown": { format ["%1 drowned", _victim] }; // ran out of oxygen underwater, or sank while bleeding

		case "forcekill": { format ["%1 was killed", _victim] }; // admin slay, antihack/teamkill kick

		default
		{
			switch (true) do
			{
				case (_aiKiller):           { format ["%1 was killed by AI", _victim] }; // vehicle destroyed by AI
				case (_killer != ""): 
				{
					if (_friendlyFire) then { format ["%1 teamkilled %2", _killer, _victim] } // destroyed friendly vehicle, crashed vehicle with friendlies on board
					else                    { format ["%1 killed %2", _killer, _victim] } // destroyed enemy vehicle
				};
				default
				{
					if (_friendlyFire) then { format ["%1 was teamkilled", _victim] } // not supposed to happen, but just in case
					else                    { format ["%1 died", _victim] } // disconnected while bleeding, any other cause not covered above
				};
			}
		};
	};

	systemChat _message;
};
