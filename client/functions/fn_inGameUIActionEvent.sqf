// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_inGameUIActionEvent.sqf
//	@file Author: AgentRev

params ["", "_unit", "", "_action", "","", "_showWindow", "","", "_menuOpen"];
private _handled = false;

if (!isNil "A3W_fnc_stickyCharges_actionEvent") then
{
	_handled = _handled || A3W_fnc_stickyCharges_actionEvent;
};

if (_unit == player && (_showWindow || _menuOpen)) then
{
	if (_action == "DisAssemble") then
	{
		[format ['You are not allowed to disassemble weapons.\nUse the "%1" option instead.', ["STR_R3F_LOG_action_deplacer_objet", "Move"] call getPublicVar], 5] call mf_notify_client;
		playSound "FD_CP_Not_Clear_F";
		_handled = true;
	};

	if (_action == "ManualFire") then // use UAV AI to re-align attack heli turret with pilot crosshair when manual fire is enabled with no gunner (thx KK xoxoxo)
	{
		private _veh = vehicle player;

		if ({_veh isKindOf _x} count ["Heli_Attack_01_base_F","Heli_Attack_02_base_F"] > 0 && isNull gunner _veh) then
		{
			_bob = createAgent ["B_UAV_AI", [0,0,0], [], 0, ""];
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

	if (_action select [0,5] == "GetIn") then // Speed up get in vehicle animation since player unit appears idle for other players
	{
		player setAnimSpeedCoef 2;
	};
};

_handled
