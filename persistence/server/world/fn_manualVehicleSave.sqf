// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_manualVehicleSave.sqf
//	@file Author: AgentRev

#define MANUAL_VEH_SAVE_COOLDOWN 5

params ["_veh", ["_wait",false,[false]]];

if (_veh isEqualType "") then { _veh = objectFromNetId _veh };

if !(_veh getVariable ["A3W_purchasedVehicle", false] || _veh getVariable ["A3W_missionVehicle", false]) then
{
	_veh setVariable ["A3W_purchasedVehicle", true, true];
};

if (diag_tickTime - (_veh getVariable ["vehSaving_lastSave", 0]) > MANUAL_VEH_SAVE_COOLDOWN) then
{
	[_veh, "vehSaving_lastUse"] call fn_setTickTime;

	if (_veh call fn_isVehicleSaveable && call A3W_savingMethod == "extDB") then
	{
		private _saveThread = [_veh] spawn
		{
			_vehID = _this call fn_saveVehicle;

			if (!isNil "_vehID" && {isServer && !isNil "A3W_hcObjSaving_unit" && {!isNull A3W_hcObjSaving_unit}}) then
			{
				A3W_hcObjSaving_trackVehID = _vehID;
				(owner A3W_hcObjSaving_unit) publicVariableClient "A3W_hcObjSaving_trackVehID";
			};
		};

		if (_wait && canSuspend) then
		{
			waitUntil {scriptDone _saveThread};
		};
	};

	_veh setVariable ["vehSaving_lastSave", diag_tickTime];
};
