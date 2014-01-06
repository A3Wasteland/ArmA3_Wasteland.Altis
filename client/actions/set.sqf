private ["_new", "_added"];
_new = [];
_added = false;
{
	if (_x select 0 == _this select 0) then {
		_new set [count _new, _this];
		_added = true;
	} else {
		_new set [count _new, _x];
	};
} forEach mf_player_actions_definitions;

if not _added then {
	_new set [count _new, _this];
};
mf_player_actions_definitions = _new;