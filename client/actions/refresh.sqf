private ["_old", "_new", "_action"];
_old = _this select 0;
_new = _this select 1;
if not(isNull _old ) then {
	{
		_old removeAction _x;
	} forEach mf_player_actions;
	mf_player_actions = [];
};

if not(isNull _new) then {
	{
		_action = _new addAction (_x select 1);
		mf_player_actions set [count mf_player_actions, _action];
	} forEach mf_player_actions_definitions;
};