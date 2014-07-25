_beacon = _this select 0;

_side = _beacon getVariable ["side", ""];
_isGroupOnly = _beacon getVariable ["groupOnly", false];
_ownerUID = _beacon getVariable ["ownerUID", ""];

_canUse = false;
if (_side == playerSide) then {
	if (_isGroupOnly) then {
		{
			if (getPlayerUID _x == _ownerUID) exitWith {
				_canUse = true;
			};
		} forEach (units group player);
	} else {
        _canUse = true;
    };
};

_canUse;