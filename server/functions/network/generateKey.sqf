// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: generateKey.sqf
//	@file Author: AgentRev
//	@file Created: 08/06/2013 01:07

private ["_key", "_i"];
_key = "k";

for "_i" from 1 to 5 do
{
	_key = _key + str (100000 + random 899999);
};

_key
