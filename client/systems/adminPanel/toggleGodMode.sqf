//@file Name: toggleGodMode.sqf

if (isDedicated) exitWith {};

if ((getPlayerUID player) call isAdmin) then
{
	_curPlayerInvulnState = player getVariable ["isAdminInvulnerable", false];

	if (!_curPlayerInvulnState) then
	{
		player allowDamage false;
		player setVariable ["isAdminInvulnerable", true, true];

		if (player getVariable ["FAR_isUnconscious", 0] == 1) then
		{
			player setVariable ["FAR_isUnconscious", 0, true];
			[] spawn
			{
				sleep 1;
				closeDialog 911;
			};
		};

		hint "You are now invulnerable";
	}
	else
	{
		player allowDamage true;
		player setVariable ["isAdminInvulnerable", false, true];
		hint "You are no longer invulnerable";
	};
};
