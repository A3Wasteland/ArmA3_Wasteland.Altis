#define compile(file) [_path, file] call mf_compile
private "_path";
_path = _this;

mf_player_actions = [];
mf_player_actions_definitions = [];

mf_player_actions_set = compile("set.sqf");
mf_player_actions_refresh = compile("refresh.sqf");

a3w_actions = [];

a3w_actions_start = compile("start.sqf");
a3w_actions_notify = compile("notify.sqf");
a3w_actions_mutex = false;
