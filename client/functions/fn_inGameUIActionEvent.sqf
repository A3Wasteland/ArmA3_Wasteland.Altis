// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_inGameUIActionEvent.sqf
//	@file Author: AgentRev

params ["_target", "_unit", "", "_action", "","", "_showWindow", "","", "_menuOpen"];
private _handled = false;

if (_unit == player && (_showWindow || _menuOpen)) then
{
	switch (true) do
	{
		case (_handled): {};

		case (_action == "UseMagazine" || _action == "UseContainerMagazine"): // placed explosive
		{
			_minDist = ["A3W_remoteBombStoreRadius", 100] call getPublicVar;
			if (_minDist <= 0) exitWith {};

			_nearbyStores = entities "CAManBase" select {_x getVariable ["storeNPC_setupComplete", false] && {player distance _x < _minDist}};

			if !(_nearbyStores isEqualTo []) exitWith
			{
				playSound "FD_CP_Not_Clear_F";
				[format ["You are not allowed to place explosives within %1m of a store.", _minDist], 5] call mf_notify_client;
				_handled = true;
			};

			_nearbyMissions = allMapMarkers select {markerType _x == "Empty" && {[["Mission_","ForestMission_","LandConvoy_"], _x] call fn_startsWith && {player distance markerPos _x < _minDist}}};

			if !(_nearbyMissions isEqualTo []) exitWith
			{
				playSound "FD_CP_Not_Clear_F";
				[format ["You are not allowed to place explosives within %1m of a mission spawn.", _minDist], 5] call mf_notify_client;
				_handled = true;
			};

			_nearbyParking = allMapMarkers select {markerType _x == "Empty" && {["Parking", _x] call fn_startsWith && {player distance markerPos _x < _minDist}}};

			if !(_nearbyParking isEqualTo []) exitWith
			{
				playSound "FD_CP_Not_Clear_F";
				[format ["You are not allowed to place explosives within %1m of a parking location.", _minDist], 5] call mf_notify_client;
				_handled = true;
			};

			_nearbyStorage = nearestObjects [player, ["Land_PaperBox_open_full_F", "Land_Pallet_MilBoxes_F", "Land_PaperBox_open_empty_F", "Land_PaperBox_closed_F"], _minDist] select {_x getVariable ["is_storage", false]};

			if !(_nearbyStorage isEqualTo []) exitWith
			{
				playSound "FD_CP_Not_Clear_F";
				[format ["You are not allowed to place explosives within %1m of a storage location.", _minDist], 5] call mf_notify_client;
				_handled = true;
			};
		};

		// now done via enableWeaponDisassembly in vehicleSetup.sqf
		case (_action == "DisAssemble" && {{_target isKindOf _x} count ["StaticMGWeapon","StaticGrenadeLauncher","StaticMortar"] > 0}):
		{
			playSound "FD_CP_Not_Clear_F";
			[format ['You are not allowed to disassemble weapons.\nUse the "%1" option instead.', ["STR_R3F_LOG_action_deplacer_objet", "Move"] call getPublicVar], 5] call mf_notify_client;
			_handled = true;
		};

		case (_action == "ManualFire"): // use UAV AI to re-align attack heli turret with pilot crosshair when manual fire is enabled with no gunner (thx KK xoxoxo)
		{
			private _veh = vehicle player;

			if ({_veh isKindOf _x} count ["Heli_Attack_01_base_F","Heli_Attack_02_base_F","VTOL_02_base_F"] > 0 && isNull gunner _veh) then
			{
				_bob = createAgent ["B_UAV_AI", [0,0,0], [], 0, "NONE"];
				_bob setName ["","",""];
				_bob moveInGunner _veh;

				[_veh, _bob] spawn
				{
					params ["_veh", "_bob"];
					_time = time;
					waitUntil {sleep 0.5; (abs (_veh animationSourcePhase "MainTurret") < 0.001 && abs (_veh animationSourcePhase "MainGun") < 0.001) || time - _time > 10};
					deleteVehicle _bob;
				};
			};
		};

		case (_action select [0,5] == "GetIn"): // Speed up get in vehicle animation since player unit appears idle for other players
		{
			0 spawn
			{
				scopeName "getInCheck";
				_time = time;

				waitUntil
				{
					if ((toLower animationState player) find "getin" != -1) exitWith
					{
						player setAnimSpeedCoef 2;
						true
					};

					if (time - _time >= 3) then
					{
						breakOut "getInCheck";
					};

					false
				};

				_time = diag_tickTime;

				waitUntil {(toLower animationState player) find "getin" == -1 || diag_tickTime - _time >= 1};

				player setAnimSpeedCoef 1;
			};
		};
	};
};

if (!_handled && !isNil "A3W_fnc_stickyCharges_actionEvent") then
{
	_handled = _this call A3W_fnc_stickyCharges_actionEvent;
};

_handled
