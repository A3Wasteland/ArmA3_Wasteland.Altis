#define compile(file) [_path, file] call mf_compile
private "_path";
_path = _this;

mf_player_actions = [];
mf_player_actions_definitions = [];

mf_player_actions_set = compile("set.sqf");
mf_player_actions_refresh = compile("refresh.sqf");