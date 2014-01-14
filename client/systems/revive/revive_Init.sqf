/*
	File: revive_Init.sqf
	Orignal Author: Farooq
	Modified by Torndeco

	Description:
	Initialize Revive
	Code is taken / based of FAAR Revive.

	TODO:
	Add Optional Settings for admins
	Add Bounty System ? Player Donate Cash to killers Bounty ? AI Event Mission that tries to kill Player with highest Bounty ?
	Add Player Screams ?
	Add use of inventory items i.e  medkits ?
	Custom Camera ?
*/

_init_revive = {

	// Setup HandleDamage EH
	player removeAllEventHandlers "HandleDamage";

	player addEventHandler ["HandleDamage", revive_DamageHandler];
	player setVariable ["revive_isUnconscious", false, true];

	player addAction ["<t color=""#C90000"">" + "Revive" + "</t>", "client\systems\revive\reviveCheck.sqf", [], 10, true, true, "", "call reviveCheck"];
};

init_revive = _init_revive call mf_compile;

revive_Check = "client\systems\revive\revive_Check.sqf" call mf_compile;
revive_DamageHandler = "client\systems\revive\revive_DamageHandler.sqf" call mf_compile;
revive_Unconscious = "client\systems\revive\revive_Unconscious.sqf" call mf_compile;

waitUntil {sleep 0.1; !isNull player};

call init_revive;

player addEventHandler ["Respawn",  init_revive];