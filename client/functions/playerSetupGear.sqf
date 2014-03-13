//	@file Name: playerSetup.sqf
//	@file Author: [GoT] JoSchaap, AgentRev

private "_player";
_player = _this;

// Clothing is now defined in "client\functions\getDefaultClothing.sqf"

_player addUniform ([_player, "uniform"] call getDefaultClothing);
_player addVest ([_player, "vest"] call getDefaultClothing);
_player addHeadgear ([_player, "headgear"] call getDefaultClothing);
_player addGoggles ([_player, "goggles"] call getDefaultClothing);

sleep 0.1;

_player unlinkItem "ItemGPS";
//_player unlinkItem "ItemRadio";

// # Remove NVGs #########
{
	if (["NVGoggles", _x] call fn_findString != -1) then
	{
		_player unlinkItem _x;
	};
} forEach assignedItems _player;
// #######################

// # Add NVGs ############
/*
switch (side _player) do
{
	case OPFOR:       { _player linkItem "NVGoggles_OPFOR" };
	case INDEPENDENT: { _player linkItem "NVGoggles_INDEP" };
	default           { _player linkItem "NVGoggles" };
};
*/
// #######################

_player addBackpack "B_AssaultPack_rgr";
_player addMagazine "9Rnd_45ACP_Mag";
_player addWeapon "hgun_ACPC2_F";
_player addMagazine "9Rnd_45ACP_Mag";
_player addMagazine "9Rnd_45ACP_Mag";
_player addMagazine "9Rnd_45ACP_Mag";
_player addItem "FirstAidKit";
_player selectWeapon "hgun_ACPC2_F";

thirstLevel = 100;
hungerLevel = 100;
