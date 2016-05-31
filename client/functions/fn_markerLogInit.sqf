// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_markerLogInit.sqf
//	@file Author: AgentRev, based on code by Killzone Kid: http://killzonekid.com/arma-scripting-tutorials-whos-placingdeleting-markers/

#include "fn_markerDefines.sqf"

A3W_markerLog_logArray = [];
A3W_markerLog_allMarkers = [];
A3W_markerLog_markerChannel = 0;

0 spawn
{
	"pvar_A3W_markerLog" addPublicVariableEventHandler A3W_fnc_markerLogPvar;
};

{
	_x spawn
	{
		scopeName "setMarkerEHs";

		waitUntil
		{
			if (_this == BRIEFING_IDD && getClientStateNumber > 9) then { breakOut "setMarkerEHs" };
			!isNull findDisplay _this
		};

		(findDisplay _this) displayAddEventHandler ["KeyDown", "KeyDown" call A3W_fnc_markerLogEvent];
		(findDisplay _this) displayAddEventHandler ["ChildDestroyed", "ChildDestroyed" call A3W_fnc_markerLogEvent];
		(findDisplay _this displayCtrl MAP_IDC) ctrlAddEventHandler ["MouseButtonDblClick", "MouseButtonDblClick" call A3W_fnc_markerLogEvent];
	};
} forEach [MAP_IDD, BRIEFING_IDD];
