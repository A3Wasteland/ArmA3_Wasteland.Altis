#include "defs.hpp"
#define GET_DISPLAY (findDisplay balca_stat_display_IDD)
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)

_stat = PG_get(STAT);
_mode = _this select 0;
_opt = _this select 1;
switch (_mode) do {
case 0: {//init
	_weapon = _stat select 0;
	_hits = _stat select 1;
	_kills = _stat select 2;
	_shots = _stat select 3;
	_props = PG_get(TARGET_PROPS);
	_tdist = _props select 0;
	_tspeed = _props select 1;
	_tdir = _props select 2;
	_rprops = PG_get(TARGET_PROPS_RAND);
	_rdist = _rprops select 0;
	_rspeed = _rprops select 1;
	_rdir = _rprops select 2;
	_lb = parseText "<br/>";
	_displayName = getText(configFile >> "cfgWeapons" >> _weapon >> "displayName");
	_mode_text = switch PG_get(target_mode) do {
		case 0: {
			composeText ["	Target mode: static land",_lb,
				"Distance: ",str _tdist,_lb,
				"Speed: ", str _tspeed,_lb,_lb];
			};
		case 1: {
			composeText ["	Target mode: random land",_lb,
				"Distance: ",str _tdist," +/- ",str _rdist,_lb,
				"Speed: ", str _rspeed,_lb,_lb];
		};
		case 2: {
			composeText ["	Target mode: AI land",_lb,_lb];
		};
		case 3: {
			composeText ["	Target mode: AI air",_lb,_lb];
		};
		default {""};
	};
	_text = composeText [_mode_text,
		"	Weapon: ",_displayName,_lb,
		"Shots: ",str _shots,_lb,
		"Hits: ", str _hits,_lb,
		"Kills: ", str _kills,_lb,
		"Accuracy: ", str (_hits/(_shots max 1)),_lb];
	GET_CTRL(balca_stat_text_IDC) ctrlSetStructuredText _text;
};
case 1: {//reset
	_stat = [currentWeapon(vehicle player),0,0,0];//weapon,hits,kills,shots
	PG_set(STAT,_stat);
	[0] call PG_get(FNC_statistics);
};
case 2: {//copy
	copyToClipboard (ctrlText GET_CTRL(balca_stat_text_IDC));
};
case 3: {//fired EH
	if ((_stat select 0) == currentWeapon(vehicle player)) then {
		_stat set [3,(_stat select 3)+1];
		PG_set(STAT,_stat)
	};
};
case 4: {//hit EH
	_killer = (_opt select 1);
	if ((_killer == (vehicle player))&&((_stat select 0) == currentWeapon(vehicle player))) then {
		_stat set [1,(_stat select 1)+1];
		PG_set(STAT,_stat)
	};
};
case 5: {//killed EH
	_killer = _opt select 1;
	if ((_killer == (vehicle player))&&((_stat select 0) == currentWeapon(vehicle player))) then {
		_stat set [2,(_stat select 2)+1];
		PG_set(STAT,_stat)
	};
};
};