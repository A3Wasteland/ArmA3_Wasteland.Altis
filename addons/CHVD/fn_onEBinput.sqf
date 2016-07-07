private ["_textValue","_updateType"];
_varType1 = param [0, "", [""]];
_slider1 = param [1, controlNull, [0, controlNull]];
_text1 = param [2, controlNull, [0, controlNull]];
_varType2 = param [3, "", [""]];
_slider2 = param [4, controlNull, [0, controlNull]];
_text2 = param [5, controlNull, [0, controlNull]];
_syncVar = param [6, "", [""]];

if (count _this < 7) then {
	_updateType = 2;
} else {
	if (call compile _syncVar) then {
		_updateType = 3;
	} else {
		_updateType = 1;
	};
};

switch (_updateType) do {
	case 1: {
		_textValue = [ctrlText _text1, "0123456789"] call BIS_fnc_filterString;
		_textValue = if (_textValue == "") then {0} else {call compile _textValue min 12000 max 0};

		sliderSetPosition [_slider1, _textValue min CHVD_maxView max 200];
		//ctrlSetText [_text1, str round (_textValue min CHVD_maxView max 200)];
		sliderSetRange [_slider2, 0, _textValue min CHVD_maxView max 200];

		call compile format ["%1 = %2", _varType1, _textValue min CHVD_maxView max 200];
		call compile format ["profileNamespace setVariable ['%1',%1]", _varType1];

		if ((call compile _varType2) > _textValue) then {
			sliderSetPosition [_slider2, _textValue min CHVD_maxObj max 0];
			ctrlSetText [_text2, str round (_textValue min CHVD_maxObj max 0)];

			call compile format ["%1 = %2", _varType2, _textValue min CHVD_maxObj max 0];
			call compile format ["profileNamespace setVariable ['%1',%1]", _varType2];
		};

		//[_updateType] call CHVD_fnc_updateSettings;
	};
	case 2: { // object update
		_textValue = [ctrlText _text1, "0123456789"] call BIS_fnc_filterString;
		_textValue = if (_textValue == "") then {0} else {call compile _textValue min 12000 max 0};

		sliderSetPosition [_slider1, _textValue min CHVD_maxObj max 0];
		//ctrlSetText [_text1, str round (_textValue min CHVD_maxObj max 0)];

		call compile format ["%1 = %2", _varType1, _textValue min CHVD_maxObj max 0];
		call compile format ["profileNamespace setVariable ['%1',%1]", _varType1];

		//[_updateType] call CHVD_fnc_updateSettings;
	};
	case 3: { // view update
		_textValue = [ctrlText _text1, "0123456789"] call BIS_fnc_filterString;
		_textValue = if (_textValue == "") then {0} else {call compile _textValue min 12000 max 0};

		sliderSetPosition [_slider1, _textValue min CHVD_maxView max 200];
		//ctrlSetText [_text1, str round (_textValue min CHVD_maxView max 200)];
		sliderSetRange [_slider2, 0, _textValue min CHVD_maxView max 200];

		call compile format ["%1 = %2", _varType1, _textValue min CHVD_maxView max 200];
		call compile format ["profileNamespace setVariable ['%1',%1]", _varType1];

		if ((call compile _varType2) > _textValue) then {
			sliderSetPosition [_slider2, _textValue min CHVD_maxObj max 0];
			ctrlSetText [_text2, str round (_textValue min CHVD_maxObj max 0)];

			call compile format ["%1 = %2", _varType2, _textValue min CHVD_maxObj max 0];
			call compile format ["profileNamespace setVariable ['%1',%1]", _varType2];
		};

		sliderSetPosition [_slider2, _textValue min CHVD_maxObj max 0];
		ctrlSetText [_text2, str round (_textValue min CHVD_maxObj max 0)];

		call compile format ["%1 = %2", _varType2, _textValue min CHVD_maxObj max 0];
		call compile format ["profileNamespace setVariable ['%1',%1]", _varType2];

		//[_updateType] call CHVD_fnc_updateSettings;
	};
};
