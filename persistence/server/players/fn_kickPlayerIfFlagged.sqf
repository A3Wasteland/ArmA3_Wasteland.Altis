// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_kickPlayerIfFlagged.sqf
//	@file Author: AgentRev

private ["_UID", "_name", "_flag"];
_UID = _this select 0;
_name = _this select 1;

_flag = _UID call fn_getPlayerFlag;

if (!isNil "_flag" && {count _flag > 1}) then
{
	// Super mega awesome dodgy player kick method
	"Logic" createUnit [[1,1,1], createGroup sideLogic,
	("this spawn
	{
		if (isServer) then
		{
			_grp = group _this;
			deleteVehicle _this;
			deleteGroup _grp;
		}
		else
		{
			waitUntil {!isNull player};
			if (getPlayerUID player == '" + _UID + "') then
			{
				call compile preprocessFile 'client\functions\quit.sqf';
			};
		};
	}")];

	//_oldName = _flag select 0; // always empty for extDB
	_hackType = _flag select 1;

	diag_log format ["ANTI-HACK: %1 (%2) was kicked due to having been flagged for [%3] in the past", _name, _UID, _hackType];
};
