// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_findString.sqf
//	@file Author: AgentRev

/*
	Parameters:
	_this select 0: String or Array - string(s) to search for
	_this select 1: String - string to check in
	_this select 2: Boolean - case sensitive search (optional, default: false)

	Returns: Number - first match position, -1 if not found
*/

params [["_needles",[],["",[]]], ["_haystack","",[""]], ["_caseSensitive",false,[false]]];

if (_needles isEqualType "") then
{
	(if (_caseSensitive) then { _haystack } else { toLower _haystack }) find (if (_caseSensitive) then { _needles } else { toLower _needles })
}
else
{
	if (!_caseSensitive) then
	{
		_haystack = toLower _haystack;
	};

	private _found = -1;

	{
		_found = _haystack find (if (_caseSensitive) then { _x } else { toLower _x });
		if (_found != -1) exitWith {};
	} forEach _needles;

	_found
};
