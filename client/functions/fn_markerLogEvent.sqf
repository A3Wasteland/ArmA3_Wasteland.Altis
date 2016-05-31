// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_markerLogEvent.sqf
//	@file Author: AgentRev, based on code by Killzone Kid: http://killzonekid.com/arma-scripting-tutorials-whos-placingdeleting-markers/

#include "fn_markerDefines.sqf"

switch (_this) do
{
	case "KeyDown":
	{
		{
			if (_this select 1 == 211) then // 211 = Del
			{
				_markerNames = allMapMarkers;
				_markerParams = (+_markerNames) apply {_x call A3W_fnc_markerLogParams};

				if (!isNil "A3W_markerLog_deleteThread" && {!scriptDone A3W_markerLog_deleteThread}) exitWith {};

				A3W_markerLog_deleteThread = [_markerNames, _markerParams] spawn
				{
					params ["_markerNames", "_markerParams"];

					{
						if (_x select [0,5] == "_USER") then
						{
							_i = _markerNames find _x;

							if (_i != -1) then
							{
								_markerPvar =
								[
									_x,
									"DELETED",
									profileName,
									getPlayerUID player
								];

								_xMarkerParams = _markerParams select _i;

								if (_xMarkerParams param [0,""] != "") then
								{
									_markerPvar append _xMarkerParams;
									_markerPvar call A3W_fnc_markerLogEntry;
								};
							};
						};
					} forEach (_markerNames - allMapMarkers);
				};
			};

			nil
		}
	};
	case "ChildDestroyed":
	{
		{
			if (ctrlIDD (_this select 1) == INSERTMARKER_IDD && _this select 2 == 1) then
			{
				A3W_markerLog_allMarkers spawn
				{
					{
						if (_x select [0,5] == "_USER") then
						{
							_markerPvar =
							[
								_x,
								"ADDED",
								profileName,
								getPlayerUID player
							];

							_markerPvar append (_x call A3W_fnc_markerLogParams);
							_markerPvar pushBack A3W_markerLog_markerChannel;
							_markerPvar call A3W_fnc_markerLogEntry;
						};
					} forEach (allMapMarkers - _this);
				};
			};

			nil
		}
	};
	case "MouseButtonDblClick":
	{
		{
			0 spawn
			{
				if (!isNull findDisplay INSERTMARKER_IDD) then
				{
					(findDisplay INSERTMARKER_IDD) displayAddEventHandler ["KeyDown", { if ((_this select 1) in [28,156]) then A3W_fnc_markerLogInsert; nil }]; // [28,156] = Enter, Numpad Enter
					(findDisplay INSERTMARKER_IDD displayCtrl 1) buttonSetAction "call A3W_fnc_markerLogInsert";
				};
			};

			nil
		}
	};
};
