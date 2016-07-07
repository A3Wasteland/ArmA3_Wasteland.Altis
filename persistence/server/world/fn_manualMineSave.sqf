// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_manualMineSave.sqf
//	@file Author: AgentRev

#define MANUAL_MINE_SAVE_COOLDOWN 5

params ["_dummy"];

if (_dummy isEqualType "") then { _dummy = objectFromNetId _dummy };

if (diag_tickTime - (_dummy getVariable ["mineSaving_lastSave", 0]) > MANUAL_MINE_SAVE_COOLDOWN) then
{
	if (_dummy call fn_isMineSaveable && call A3W_savingMethod == "extDB") then
	{
		[_dummy, nil, true] spawn
		{
			_mineID = _this call fn_saveMine;

			if (!isNil "_mineID" && {isServer && !isNil "A3W_hcObjSaving_unit" && {!isNull A3W_hcObjSaving_unit}}) then
			{
				A3W_hcObjSaving_trackMineID = _mineID;
				(owner A3W_hcObjSaving_unit) publicVariableClient "A3W_hcObjSaving_trackMineID";
			};
		};
	};

	_dummy setVariable ["mineSaving_lastSave", diag_tickTime];
};
