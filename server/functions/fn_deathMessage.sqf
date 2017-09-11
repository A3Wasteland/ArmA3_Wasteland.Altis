// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_deathMessage.sqf
//	@file Author: AgentRev

// this script must ONLY be called within fn_killFeedEntry.sqf

private _killerUnit = _killer;
private _victimUnit = _victim;
private _aiKiller = _killerAI;
private _friendlyFire = _killerFriendly;

params [["_killer",_killerName,[""]], ["_victim",_victimName,[""]]]; // custom names

// you have access to all _killParams variables defined at the bottom of fn_killBroadcast.sqf

	// FOR CONSISTENT USER EXPERIENCE, MESSAGES SHOULD BE LOWERCASE, INVARIABLE, AND EXPLICIT (NO PUNS OR EUPHEMISMS), JUST LIKE DEFAULT ARMA MESSAGES
	private _message = switch (_victimCause) do
	{
		case "headshot": // enemy player headshot with A3W_headshotNoRevive = 1; - feature currently disabled
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

		case "survival": { format ["%1 has died of dysentery", _victim] }; // starvation, dehydration

		case "forcekill": { format ["%1 was killed", _victim] }; // admin slay, antihack/teamkill kick

		default
		{
			switch (true) do
			{
				case (!_victimDead): // injury
				{
					switch (true) do
					{
						case (_killer == ""):                                { format ["%1 was injured", _victim] }; // injured by self or unknown sources
						case (_aiKiller):                                    { format ["%1 was injured by AI", _victim] }; // injured by AI
						case (_friendlyFire && _victimCause == "roadkill"):  { format ["%1 injured %2 with vehicle (friendly fire)", _killer, _victim] }; // roadkill injury by friendly
						default                                              { format ["%1 injured %2%3", _killer, _victim, [""," (friendly fire)"] select _friendlyFire] }; // injured by other player
					};
				};
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

_message
