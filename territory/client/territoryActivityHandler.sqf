// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*********************************************************#
# @@ScriptName: territoryActivityHandler.sqf
# @@Author: Nick 'Bewilderbeest' Ludlam <bewilder@recoil.org>
# @@Create Date: 2013-09-15 19:33:17
# @@Modify Date: 2013-09-15 20:15:37
# @@Function:
#*********************************************************/

// Called with [_message, _money(optional)], "A3W_fnc_territoryActivityHandler", side, false] call A3W_fnc_MP;

diag_log format["A3W_fnc_territoryActivityHandler called with %1", _this];

if (typeName _this == "ARRAY" && {count _this >= 1}) then {
	_msg = _this select 0;
	_money = 0; if (count _this >= 2) then { _money = _this select 1; };

	titleText [_msg, "plain down", 0.5];
	if (_money > 0) then
	{
	
	_flagGroup = format ["Flag_%1",current_territorygrp_rnd];
	_inrange_payout = false;
		{
			_marker = _x;
			//markername starts with Flag_ but not with current random territory grp
			if ([_flagGroup, _marker] call fn_startsWith) then
			{
				if ((player distance (getmarkerpos _x))< 25000) then
				{
				_inrange_payout = true;
				};			
			};	
	
		} forEach allMapMarkers;
	
		if (_inrange_payout) then
		{
			player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _money, true];
		}
		else 
		{ 
		titleText ["You are more than 2km away from the capture territories so you received no money.", "plain down", 0.5];
		};
			
	};

	playSound 'FD_Finish_F'; // Nice sound effect to draw players attention to the notification
};

