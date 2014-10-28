// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Name: toggleGodMode.sqf

if (isDedicated) exitWith {};

if ((getPlayerUID player) call isAdmin) then
{
	_curPlayerInvulnState = player getVariable ["isAdminInvulnerable", false];

	if (!_curPlayerInvulnState) then
	{
		player setDamage 0;
		player allowDamage false;
		vehicle player setDamage 0;
		player setVariable ["isAdminInvulnerable", true, true];

		if (player getVariable ["FAR_isUnconscious", 0] == 1) then
		{
			player setVariable ["FAR_isUnconscious", 0, true];
			[] spawn
			{
				sleep 1;
				closeDialog 27911; // ReviveGUI_IDD
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
