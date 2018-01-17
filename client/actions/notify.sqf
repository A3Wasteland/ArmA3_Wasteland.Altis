// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#define TIME_DELTA 0.1
assert (count _this == 2);
if not(isNil "MF_MSG_HANDLER") then {
	if not(scriptDone MF_MSG_HANDLER) then {terminate MF_MSG_HANDLER};
};
MF_MSG_HANDLER = _this spawn {
	_text = _this select 0;
	_time = _this select 1;
	titleText[_text, "PLAIN DOWN", _time / 10];
	/*_i = 0;
	while {_i < _time} do {
		titleText[_text, "PLAIN DOWN", 0.01];
		sleep TIME_DELTA;
		_i = _i + TIME_DELTA;
	};*/
};
