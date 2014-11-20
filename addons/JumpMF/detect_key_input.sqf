//////////////////////////////////////////////////////////////////
// Script File for [Arma 3] - detect_key_input.sqf
// Created by: Das Attorney
// Modified by: AgentRev
//////////////////////////////////////////////////////////////////

#define HORDE_JUMPMF_SLOWING_MULTIPLIER 0.75

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

			_move spawn
			{
				private ["_prevMove", "_prevVel", "_fatigue", "_load"];

				_prevMove = _this;
				_prevVel = velocity player;
				_fatigue = getFatigue player;
				_load = loadAbs player;

				[player, "AovrPercMrunSrasWrflDf"] call switchMoveGlobal;

				waitUntil
				{
					player setFatigue (_fatigue + 0.05 + (_load / 5000));
					player setVelocity
					[
						(_prevVel select 0) * HORDE_JUMPMF_SLOWING_MULTIPLIER,
						(_prevVel select 1) * HORDE_JUMPMF_SLOWING_MULTIPLIER,
						((velocity player) select 2) min 1
					];
					(animationState player != "AovrPercMrunSrasWrflDf")
				};

				[player, _prevMove] call switchMoveGlobal;
				player setVelocity
				[
					_prevVel select 0,
					_prevVel select 1,
					(velocity player) select 2
				];

				sleep 0.5; // Cooldown

				horde_jumpmf_var_jumping = false;
			};

			_handled = true;
		};
	};
};

_handled
