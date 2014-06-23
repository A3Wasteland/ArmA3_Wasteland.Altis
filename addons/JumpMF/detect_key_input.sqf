//////////////////////////////////////////////////////////////////
// Script File for [Arma 3] - detect_key_input.sqf
// Created by: Das Attorney
// Modified by: AgentRev
//////////////////////////////////////////////////////////////////

#define HORDE_JUMPMF_SLOWING_MULTIPLIER 0.75

private ["_pressedKey", "_handled"];
_pressedKey = _this select 1;
_handled = false;

if (_pressedKey in actionKeys "GetOver") then
{
	if (horde_jumpmf_var_jumping) then
	{
		_handled = true;
	}
	else
	{
		if (vehicle player == player && {stance player == "STAND"} && {getFatigue player < 0.6} && {isTouchingGround player} && {[["Mrun","Meva"], animationState player] call fn_findString == 8}) then
		{
			horde_jumpmf_var_jumping = true;
			
			[] spawn
			{
				private ["_prevMove", "_prevVel", "_fatigue", "_load"];
				
				_prevMove = animationState player;
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
						(velocity player) select 2
					];
					!(["AovrPercMrun", animationState player] call fn_startsWith)
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
