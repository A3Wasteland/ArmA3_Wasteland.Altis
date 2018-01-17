// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: checkCooldown.sqf

private _error = "";
private _serverDiff = ["A3W_serverTickTimeDiff", 0] call getPublicVar;
private _artiUseVar = "A3W_artilleryLastUse_" + getPlayerUID player;
private _artiLastUse = missionNamespace getVariable _artiUseVar;
private _cooldown = ["A3W_artilleryCooldown", 3600] call getPublicVar;


if (!isNil "_artiLastUse") then
{
	_timeDiff = diag_TickTime + _serverDiff - _artiLastUse;

	if (_timeDiff < _cooldown) then
	{
		private _remainder = (_cooldown -_timeDiff) / 3600;
		private _hours = floor  _remainder;
		private _mins = floor ((_remainder - _hours) * 60);
		private _secs = floor ((_remainder - _hours - (_mins / 60)) * 3600);

		_error = format ["You must wait %1h %2m %3s before using the Artillery Strike again.", _hours, _mins, _secs];
		[_error, "Error"] spawn BIS_fnc_guiMessage;
		playSound "FD_CP_Not_Clear_F";
	};
};

_error
