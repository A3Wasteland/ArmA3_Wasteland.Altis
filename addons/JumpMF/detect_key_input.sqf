//////////////////////////////////////////////////////////////////
// Script File for [Arma 3] - detect_key_input.sqf
// Created by: Das Attorney
// Modified by: AgentRev
//////////////////////////////////////////////////////////////////

#define HORDE_JUMPMF_SLOWING_MULTIPLIER 0.9
#define HORDE_JUMPMF_IMPUSLE 2.5

private ["_pressedKey", "_handled", "_move", "_moveM", "_moveP"];
_pressedKey = _this select 1;
_handled = false;

if (_pressedKey in actionKeys "GetOver") then
{
	if (horde_jumpmf_var_jumping) exitWith
	{
		_handled = true;
	};

	if (vehicle player == player) then
	{
		_move = animationState player;
		_moveM = toLower (_move select [8,4]);
		_moveP = toLower (_move select [4,4]);

		if (_moveM in ["mrun","meva"] && _moveP in ["perc","pknl"] && getFatigue player < 0.6 && isTouchingGround player) then
		{
			horde_jumpmf_var_jumping = true;

			private _prevVel = velocity player;
			private _fatigue = getFatigue player;

			[player, "AovrPercMrunSrasWrflDf"] call switchMoveGlobal;

			if (currentWeapon player == "") then
			{
				player playMoveNow "AovrPercMrunSrasWrflDf";
			};

			horde_jumpmf_var_prevVel = _prevVel;
			horde_jumpmf_var_vel1 = nil;
			horde_jumpmf_var_vel2 = _prevVel select 2;

			private _frameEvent = addMissionEventHandler ["EachFrame",
			{
				horde_jumpmf_var_vel1 = ((velocity player) select 2) + ([0,HORDE_JUMPMF_IMPUSLE] select isNil "horde_jumpmf_var_vel1");

				// Ignore very high downward accelerations caused by step transitions, otherwise this kills the player
				if (horde_jumpmf_var_vel1 - horde_jumpmf_var_vel2 < -7) then
				{
					horde_jumpmf_var_vel1 = horde_jumpmf_var_vel2;
				};

				player setVelocity
				[
					(horde_jumpmf_var_prevVel select 0) * HORDE_JUMPMF_SLOWING_MULTIPLIER,
					(horde_jumpmf_var_prevVel select 1) * HORDE_JUMPMF_SLOWING_MULTIPLIER,
					horde_jumpmf_var_vel1 min HORDE_JUMPMF_IMPUSLE
				];

				horde_jumpmf_var_vel2 = (velocity player) select 2;
			}];

			[_move, _prevVel, _fatigue, _frameEvent] spawn
			{
				params ["_prevMove", "_prevVel", "_fatigue", "_frameEvent"];
				private _load = loadAbs player;

				waitUntil
				{
					player setFatigue (_fatigue + 0.05 + (_load / 5000));
					(animationState player != "AovrPercMrunSrasWrflDf")
				};

				removeMissionEventHandler ["EachFrame", _frameEvent];

				/*[player, _prevMove] call switchMoveGlobal;
				player setVelocity
				[
					_prevVel select 0,
					_prevVel select 1,
					(velocity player) select 2
				];*/

				sleep 0.5; // Cooldown
				horde_jumpmf_var_jumping = false;
			};

			_handled = true;
		};
	};
};

_handled
