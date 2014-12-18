// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: savePlayerData.sqf
//	@file Author: AgentRev

if (!isNil "savePlayerHandle" && {typeName savePlayerHandle == "SCRIPT"} && {!scriptDone savePlayerHandle}) exitWith {};

savePlayerHandle = _this spawn
{
	if (alive player &&
	   {!isNil "isConfigOn" && {["A3W_playerSaving"] call isConfigOn}} &&
	   {!isNil "playerSetupComplete" && {playerSetupComplete}} &&
	   {!isNil "respawnDialogActive" && {!respawnDialogActive}} &&
	   {player getVariable ["FAR_isUnconscious", 0] == 0}) then
	{
		_UID = getPlayerUID player;
		_manualSave = [_this, 0, false, [false]] call BIS_fnc_param;

		// In case script is triggered via menu action
		if (!_manualSave) then
		{
			_manualSave = [_this, 3, false, [false]] call BIS_fnc_param;
		};

		_info =
		[
			["Name", name player],
			["LastSide", str playerSide],
			["BankMoney", player getVariable ["bmoney", 0]]
		];

		_data = [player] call fn_getPlayerData;


		if (!isNil "playerData_infoPairs") then
		{
			{
				_oldPair = _x;
				{
					if (_x isEqualTo _oldPair) then
					{
						_info set [_forEachIndex, -1];
					};
				} forEach _info;
			} forEach playerData_infoPairs;

			_info = _info - [-1];
		};

		if (!isNil "playerData_savePairs") then
		{
			{
				_oldPair = _x;
				{
					if (_x isEqualTo _oldPair) then
					{
						_data set [_forEachIndex, -1];
					};
				} forEach _data;
			} forEach playerData_savePairs;

			_data = _data - [-1];
		};

		if (alive player) then
		{
			if (count _info > 0 || count _data > 0) then
			{
				pvar_savePlayerData = [_UID, _info, _data, player];
				publicVariableServer "pvar_savePlayerData";
			};

			if (_manualSave) then
			{
				cutText ["\nPlayer saved!", "PLAIN DOWN", 0.2];
			};
		};

		if (isNil "playerData_infoPairs") then
		{
			playerData_infoPairs = _info;
		}
		else
		{
			{
				[playerData_infoPairs, _x select 0, _x select 1] call fn_setToPairs;
			} forEach _info;
		};

		if (isNil "playerData_savePairs") then
		{
			playerData_savePairs = _info;
		}
		else
		{
			{
				[playerData_savePairs, _x select 0, _x select 1] call fn_setToPairs;
			} forEach _data;
		};
	};
};

if (typeName savePlayerHandle == "SCRIPT") then
{
	_savePlayerHandle = savePlayerHandle;
	waitUntil {scriptDone _savePlayerHandle};
	savePlayerHandle = nil;
};
