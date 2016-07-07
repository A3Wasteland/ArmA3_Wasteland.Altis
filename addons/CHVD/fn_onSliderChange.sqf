private ["_sliderPos","_updateType"];
_varType1 = param [0, "", [""]];
_slider1 = ctrlIDC (param [1, 0, [0, controlNull]]);
_sliderPos = param [2, 0, [0]];
_text1 = param [3, 0, [0, controlNull]];
_varType2 = param [4, "", [""]];
_slider2 = param [5, 0, [0, controlNull]];
_text2 = param [6, 0, [0, controlNull]];
_syncVar = param [7, "", [""]];

if (count _this < 8) then {
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
		sliderSetPosition [_slider1, _sliderPos min CHVD_maxView max 200];
		ctrlSetText [_text1, str round (_sliderPos min CHVD_maxView max 200)];
		sliderSetRange [_slider2, 0, _sliderPos min CHVD_maxView max 200];

		call compile format ["%1 = %2", _varType1, _sliderPos min CHVD_maxView max 200];
		call compile format ["profileNamespace setVariable ['%1',%1]", _varType1];

		if ((call compile _varType2) > _sliderPos) then {
			sliderSetPosition [_slider2, _sliderPos min CHVD_maxObj max 0];
			ctrlSetText [_text2, str round (_sliderPos min CHVD_maxObj max 0)];

			call compile format ["%1 = %2", _varType2, _sliderPos min CHVD_maxObj max 0];
			call compile format ["profileNamespace setVariable ['%1',%1]", _varType2];
		};

		//[_updateType] call CHVD_fnc_updateSettings;
	};
	case 2: { // object update
		sliderSetPosition [_slider1, _sliderPos min CHVD_maxObj max 0];
		ctrlSetText [_text1, str round (_sliderPos min CHVD_maxObj max 0)];

		call compile format ["%1 = %2", _varType1, _sliderPos min CHVD_maxObj max 0];
		call compile format ["profileNamespace setVariable ['%1',%1]", _varType1];

		//[_updateType] call CHVD_fnc_updateSettings;
	};
	case 3: { // view update
		sliderSetPosition [_slider1, _sliderPos min CHVD_maxView max 200];
		ctrlSetText [_text1, str round (_sliderPos min CHVD_maxView max 200)];
		sliderSetRange [_slider2, 0, _sliderPos min CHVD_maxView max 200];

		call compile format ["%1 = %2", _varType1, _sliderPos min CHVD_maxView max 200];
		call compile format ["profileNamespace setVariable ['%1',%1]", _varType1];

		if ((call compile _varType2) > _sliderPos) then {
			sliderSetPosition [_slider2, _sliderPos min CHVD_maxObj max 0];
			ctrlSetText [_text2, str round (_sliderPos min CHVD_maxObj max 0)];

			call compile format ["%1 = %2", _varType2, _sliderPos min CHVD_maxObj max 0];
			call compile format ["profileNamespace setVariable ['%1',%1]", _varType2];
		};

		sliderSetPosition [_slider2, _sliderPos min CHVD_maxObj max 0];
		ctrlSetText [_text2, str round (_sliderPos min CHVD_maxObj max 0)];

		call compile format ["%1 = %2", _varType2, _sliderPos min CHVD_maxObj max 0];
		call compile format ["profileNamespace setVariable ['%1',%1]", _varType2];

		//[_updateType] call CHVD_fnc_updateSettings;
	};
};
