// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: playerSetupStart.sqf
//	@file Author: [GoT] JoSchaap, AgentRev

private "_player";
_player = _this;

_player setSkill 0;
{_player disableAI _x} foreach ["move","anim","target","autotarget"];
_player setVariable ["BIS_noCoreConversations", true];
_player allowDamage false;
[_player, true] call fn_hideObjectGlobal;
//_player enableSimulation false;

if (["A3W_unlimitedStamina"] call isConfigOn) then
{
	_player enableFatigue false;
};

//AJ Custom Camera Functions
[] spawn fn_cameracheck;

enableSentences false;

removeAllWeapons _player;
removeUniform _player;
removeVest _player;
removeBackpack _player;
removeGoggles _player;
removeHeadgear _player;
