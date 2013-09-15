/*********************************************************#
# @@ScriptName: territoryActivityHandler.sqf
# @@Author: Nick 'Bewilderbeest' Ludlam <bewilder@recoil.org>
# @@Create Date: 2013-09-15 19:33:17
# @@Modify Date: 2013-09-15 20:15:37
# @@Function:
#*********************************************************/

// Called with [_message, _money(optional)], "territoryActivityHandler", side, false] call TPG_fnc_MP;

diag_log format["territoryActivityHandler called with %1", _this];

if (typeName _this == "ARRAY" && {count _this >= 1}) then {
	_msg = _this select 0;
	_money = 0; if (count _this >= 2) then { _money = _this select 1; };
	
	titleText [_msg, "plain"]; titleFadeOut 10;
	if (_money > 0) then {
		player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _money, true];
	};

	player say 'FD_Finish_F'; // Nice sound effect to draw players attention to the notification
};
