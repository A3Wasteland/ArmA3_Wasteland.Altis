
if (X_Client) then {
	_curPlayerInvulnState = player getVariable ["isAdminInvulnerable", 0];

	if (_curPlayerInvulnState == 0) then
	{
		hint "You are now invulnerable";
		player setVariable ["isAdminInvulnerable", 1, true];

		player removeAllEventHandlers "handleDamage";
		player addEventHandler ["handleDamage", { false }];        
		player allowDamage false;
	}
	else
	{
		hint "You are no longer invulnerable";
		player setVariable ["isAdminInvulnerable", 0, true];

		player removeAllEventHandlers "handleDamage";
		player addEventHandler ["handleDamage", { true }];        
		player allowDamage true;
	};
};
