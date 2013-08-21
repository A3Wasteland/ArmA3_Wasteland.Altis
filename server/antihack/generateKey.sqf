//	@file Version: 1.1
//	@file Name: generateKey.sqf
//	@file Author: AgentRev
//	@file Created: 08/06/2013 01:07

private ["_key", "_char"];
_key = [];

for "_x" from 0 to (floor random 33 + 31) do
{
	if (_x != 0) then
	{
		_char = floor random 36;
	}
	else
	{
		_char = floor random 26 + 10;
	};
	
	if (_char < 10) then
	{
		_char = _char + 48;
	}
	else
	{
		_char = _char + 55;
	};
	
	_key set [_x, _char];		
};

toString _key
