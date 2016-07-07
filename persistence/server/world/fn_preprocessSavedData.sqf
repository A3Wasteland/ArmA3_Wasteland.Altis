// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_preprocessSavedData.sqf
//	@file Author: AgentRev

params ["_varNames", "_varValues"];

private _vars = [];
private "_varVal";
private _iVal = 0;

{
	while {_varVal = _varValues select _iVal; (_varVal select 0) param [0] != _x select 0 && _iVal < count _varValues} do
	{
		_iVal = _iVal + 1;
	};

	if (_iVal < count _varValues) then
	{
		_vars pushBack [_varVal select 1, _x select 1];
		_iVal = _iVal + 1;
	}
	else
	{
		_iVal = 0;
	};
} forEach _varNames;

_vars
