_state = param [0, 0, [0]];
_syncVar = param [1, "", [""]];
_slider = param [2, controlNull, [0, controlNull]];
_text = param [3, controlNull, [0, controlNull]];
_sliderView = param [4, controlNull, [0, controlNull]];
_varType = param [5, "", [""]];

if (_state == 1) then {
	call compile format ["%1 = true",_syncVar];
	call compile format ["profileNamespace setVariable ['%1',%1]", _syncVar];
	ctrlEnable [_slider, false];
	ctrlEnable [_text, false];

	ctrlSetText [_text, str round ((sliderPosition _sliderView) min CHVD_maxObj max 0)];
	sliderSetPosition [_slider, (sliderPosition _sliderView) min CHVD_maxObj max 0];

	call compile format ["%1 = %2", _varType, (sliderPosition _sliderView) min CHVD_maxObj max 0];
	call compile format ["profileNamespace setVariable ['%1',%1]", _varType];
	//[3] call CHVD_fnc_updateSettings;
} else {
	call compile format ["%1 = false",_syncVar];
	call compile format ["profileNamespace setVariable ['%1',%1]", _syncVar];
	ctrlEnable [_slider, true];
	ctrlEnable [_text, true];
};
