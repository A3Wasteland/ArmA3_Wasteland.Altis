//	@file Name: playerSetupStart.sqf
//	@file Author: [GoT] JoSchaap, AgentRev

private "_player";
_player = _this;

_player setSkill 0;
{_player disableAI _x} foreach ["move","anim","target","autotarget"];
_player setVariable ["BIS_noCoreConversations", true];
_player allowDamage false;

enableSentences false;

removeAllWeapons _player;
removeUniform _player;
removeVest _player;
removeBackpack _player;
removeGoggles _player;
removeHeadgear _player;
