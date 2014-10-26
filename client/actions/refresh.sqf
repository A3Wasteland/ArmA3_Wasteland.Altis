// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
private ["_old", "_new"];
_old = _this select 0;
_new = _this select 1;

/*
if not(isNull _old ) then {
	{
		_old removeAction _x;
	} forEach mf_player_actions;
	mf_player_actions = [];
};
*/

if (!isNull _new) then
{
	{ [_new, _x select 1] call fn_addManagedAction } forEach mf_player_actions_definitions;
};
