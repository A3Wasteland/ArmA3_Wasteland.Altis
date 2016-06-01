_state = [_this, 0, 0, [0]] call BIS_fnc_param;
_syncVar = [_this, 1, "", [""]] call BIS_fnc_param;
_slider = [_this, 2, controlNull, [0, controlNull]] call BIS_fnc_param;
_text = [_this, 3, controlNull, [0, controlNull]] call BIS_fnc_param;
_sliderView = [_this, 4, controlNull, [0, controlNull]] call BIS_fnc_param;
_varType = [_this, 5, "", [""]] call BIS_fnc_param;

if (_state == 1) then {
	call compile format ["%1 = true",_syncVar];
	call compile format ["profileNamespace setVariable ['%1',%1]", _syncVar];
	ctrlEnable [_slider, false];
	ctrlEnable [_text, false];
	
	ctrlSetText [_text, str round ((sliderPosition _sliderView) min CHVD_maxObj)];
	sliderSetPosition [_slider, (sliderPosition _sliderView) min CHVD_maxObj];
	
	call compile format ["%1 = %2", _varType, (sliderPosition _sliderView) min CHVD_maxObj];
	call compile format ["profileNamespace setVariable ['%1',%1]", _varType];
	[3] call CHVD_fnc_updateSettings;
} else {
	call compile format ["%1 = false",_syncVar];
	call compile format ["profileNamespace setVariable ['%1',%1]", _syncVar];
	ctrlEnable [_slider, true];
	ctrlEnable [_text, true];
};