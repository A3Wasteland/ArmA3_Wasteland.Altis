// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: playerSetupGear.sqf
//	@file Author: [GoT] JoSchaap, AgentRev

private ["_player", "_uniform", "_vest", "_headgear", "_goggles"];
_player = _this;

// Clothing is now defined in "client\functions\getDefaultClothing.sqf"

_uniform = [_player, "uniform"] call getDefaultClothing;
_vest = [_player, "vest"] call getDefaultClothing;
_headgear = [_player, "headgear"] call getDefaultClothing;
_goggles = [_player, "goggles"] call getDefaultClothing;

if (_uniform != "") then { _player addUniform _uniform };
if (_vest != "") then { _player addVest _vest };
if (_headgear != "") then { _player addHeadgear _headgear };
if (_goggles != "") then { _player addGoggles _goggles };

sleep 0.1;

// Remove GPS
_player unlinkItem "ItemGPS";

// Remove radio
//_player unlinkItem "ItemRadio";

// Remove NVG
if (hmd _player != "") then { _player unlinkItem hmd _player };

// Add NVG
_player linkItem "NVGoggles";

_player addBackpack "B_AssaultPack_rgr";
switch (typeOf _player) do {
	case "B_medic_F": { _player addItem "MediKit" };
	case "O_medic_F": { _player addItem "MediKit" };
	case "I_medic_F": { _player addItem "MediKit" }; 
	case "B_engineer_F": { _player addItem "ToolKit" };
	case "O_engineer_F": { _player addItem "ToolKit" };
	case "I_engineer_F": { _player addItem "ToolKit" };
};
_player addMagazine "9Rnd_45ACP_Mag";
_player addWeapon "hgun_ACPC2_F";
_player addMagazine "9Rnd_45ACP_Mag";
_player addMagazine "9Rnd_45ACP_Mag";
_player addMagazine "9Rnd_45ACP_Mag";
_player addItem "FirstAidKit";
_player selectWeapon "hgun_ACPC2_F";

if (_player == player) then
{
	thirstLevel = 100;
	hungerLevel = 100;
};
