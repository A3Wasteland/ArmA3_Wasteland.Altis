//	@file Version: 1.0
//	@file Name: onKeyPress.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

private ["_key", "_handled"];

_key = _this select 1;
_handled = false;

switch (_key) do
{
	// U key
	case 22:
	{
		execVM "client\systems\adminPanel\checkAdmin.sqf";
	};

	// Tilde (key above Tab)
	case 41:
	{
		[] spawn loadPlayerMenu;
		_handled = true;
	};

	// Left Windows key
	case 219:
	{
		showPlayerNames = true;
	};

	// Right Windows key
	case 220:
	{
		showPlayerNames = true;
	};
};

_handled
