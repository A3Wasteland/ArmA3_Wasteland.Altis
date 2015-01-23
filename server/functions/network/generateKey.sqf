// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: generateKey.sqf
//	@file Author: AgentRev
//	@file Created: 08/06/2013 01:07

private ["_chars", "_nChars", "_key", "_i"];
_chars = toArray "abcdefghijklmnopqrstuvwxyz0123456789_";
_nChars = count _chars;
_key = [97 + floor random 26];

for "_i" from 1 to (16 + random 8) do
{
	_key pushBack (_chars select floor random _nChars);
};

toString _key
