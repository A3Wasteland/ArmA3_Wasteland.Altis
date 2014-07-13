//	@file Version: 1.0
//	@file Name: onKeyPress.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

private ["_key", "_handled"];

_key = _this select 1;
_handled = false;

switch (true) do
{
	// U key
	case (_key == 22):
	{
		execVM "client\systems\adminPanel\checkAdmin.sqf";
	};

	// Tilde (key above Tab)
	case (_key == 41):
	{
		[] spawn loadPlayerMenu;
		_handled = true;
	};

	// Left & right Windows key
	case (_key in [219,220]):
	{
		if (isNil "showPlayerNames") then
		{
			showPlayerNames = true;
		}
		else
		{
			showPlayerNames = !showPlayerNames;
		};
	};

	case (_key in actionKeys "GetOver"):
	{
		_veh = vehicle player;

		if (_veh == player) then
		{
			if ((getPos player) select 2 > 2.5) then
			{
				execVM "client\actions\openParachute.sqf";
				_handled = true;
			};
		}
		else
		{
			if (_veh isKindOf "ParachuteBase") then
			{
				moveOut player;
				_veh spawn
				{
					sleep 1;
					deleteVehicle _this;
				};
			};
		};
	};
};

_handled
