// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_encodeText.sqf
//	@file Author: AgentRev

private ["_text", "_specialChars", "_convertTo", "_resultArr", "_idx"];
_text = _this select 0;

_specialChars = [34,38,60,62]; // "&<>
_convertTo = [[38,113,117,111,116,59], [38,97,109,112,59], [38,108,116,59], [38,103,116,59]]; // &quot; &amp; &lt; &gt;

_resultArr = [];

{
	_idx = _specialChars find _x;

	if (_idx != -1) then
	{
		_resultArr append (_convertTo select _idx);
	}
	else
	{
		_resultArr pushBack _x;
	};
} forEach toArray _text;

toString _resultArr
