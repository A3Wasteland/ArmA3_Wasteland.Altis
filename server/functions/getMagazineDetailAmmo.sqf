// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getMagazineDetailAmmo.sqf
//	@file Author: AgentRev

private ["_mag", "_lastIndexOf", "_start", "_end"];
_mag = _this select 0;

if (_mag == "") exitWith {0};

_lastIndexOf =
{
	private ["_str", "_chr", "_len", "_idx"];
	_str = toArray (_this select 0);
	_chr = (toArray (_this select 1)) select 0;

	_len = count _str;
	reverse _str;

	_idx = _str find _chr;

	if (_idx != -1) then
	{
		_idx = (_len - 1) - _idx;
	};

	_idx
};

_start = [_mag, "("] call _lastIndexOf;
_end = [_mag, ")"] call _lastIndexOf;

if (_start != -1 && _end > _start) then {
	call compile (_mag select [_start, (_end - _start) + 1])
} else {
	0
}
