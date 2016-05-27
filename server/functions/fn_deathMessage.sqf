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
	["_cause", "", [""]] // cause of death string, ignored if mode = 0
];

if (_mode isEqualTo 0) then
{
	if (!isServer) exitWith {};

	(_victim getVariable ["A3W_deathCause_local", []]) params [["_cLocalString","",[""]], ["_cLocalTime",nil,[0]]];
	(_victim getVariable ["A3W_deathCause_remote", []]) params [["_cRemoteString","",[""]], ["_cRemoteTime",2e11,[0]]];

	// death cause tagged by remote sources have an expiry time of 10 secs (serverTime)
	_cause = [_cLocalString, _cRemoteString] select (isNil "_cLocalTime" || {_cRemoteTime < _cLocalTime && _cRemoteTime > _cLocalTime - 10});

	[1, _victim, _killer, _friendlyFire, _cause] remoteExecCall ["A3W_fnc_deathMessage"];
}
else
{
	if (!hasInterface) exitWith {};

	private _victimName = if (_victim isEqualType objNull) then { name _victim } else { _victim };

	if (_victimName isEqualTo "") exitWith {};

	private _aiKiller = false;
	private _killerName = "";

	if (_killer isEqualType objNull) then
	{
		if (!isNull _killer && !isPlayer _killer && isNil {_killer getVariable "cmoney"}) then
		{
			_aiKiller = true;
			_killerName = "AI";
		}
		else
		{
			_killerName = name _killer;
		};
	}
	else
	{
		_killerName = _killer;
	};

	// FOR CONSISTENT USER EXPERIENCE, MESSAGES SHOULD BE LOWERCASE, INVARIABLE, AND EXPLICIT (NO PUNS OR EUPHEMISMS), JUST LIKE DEFAULT ARMA MESSAGES
	private _message = switch (_cause) do
	{
		case "headshot": // enemy player headshot with A3W_headshotNoRevive = 1;
		{
			if (_killerName != "") then { format ["%1 headshot %2", _killerName, _victimName] }
			else                        { format ["%1 was headshot", _victimName] } // not supposed to happen, but just in case
		};

		case "slay": // finished off by enemy while bleeding
		{
			if (_killerName != "") then { format ["%1 finished off %2", _killerName, _victimName] }
			else                        { format ["%1 was finished off", _victimName] } // not supposed to happen, but just in case
		};

		case "bleedout": { format ["%1 bled out", _victimName] }; // bleedout timer ran out, gave up while bleeding

		case "suicide": { format ["%1 suicided", _victimName] }; // respawned from pause menu, crashed vehicle, last resort, player setDamage 1

		case "drown": { format ["%1 drowned", _victimName] }; // ran out of oxygen underwater, or sank while bleeding

		case "forcekill": { format ["%1 was killed", _victimName] }; // admin slay, antihack/teamkill kick

		default
		{
			switch (true) do
			{
				case (_aiKiller):           { format ["%1 was killed by AI", _victimName] }; // vehicle destroyed by AI
				case (_killerName != ""): 
				{
					if (_friendlyFire) then { format ["%1 teamkilled %2", _killerName, _victimName] } // destroyed friendly vehicle, crashed vehicle with friendlies on board
					else                    { format ["%1 killed %2", _killerName, _victimName] } // destroyed enemy vehicle
				};
				default
				{
					if (_friendlyFire) then { format ["%1 was teamkilled", _victimName] } // not supposed to happen, but just in case
					else                    { format ["%1 died", _victimName] } // disconnected while bleeding, any other cause not covered above
				};
			}
		};
	};

	systemChat _message;
};
