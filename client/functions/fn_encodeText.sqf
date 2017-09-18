// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_encodeText.sqf
//	@file Author: AgentRev

// convert special characters to their XML entities for subsequent use with parseText
// https://en.wikipedia.org/wiki/Character_encodings_in_HTML#XML_character_references

private _specialChars = [38, 60, 62, 34, 39]; //  & < > " '
private _convertTo = [[38,97,109,112,59], [38,108,116,59], [38,103,116,59], [38,113,117,111,116,59], [38,97,112,111,115,59]]; //  &amp; &lt; &gt; &quot; &apos;
private _chars = [];
private "_i";

{
	_i = _specialChars find _x;
	if (_i isEqualTo -1) then { _chars pushBack _x } else { _chars append (_convertTo select _i) };
} forEach toArray param [0,"",[""]];

toString _chars
