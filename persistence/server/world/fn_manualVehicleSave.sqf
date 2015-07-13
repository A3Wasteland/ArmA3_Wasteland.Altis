// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_manualVehicleSave.sqf
//	@file Author: AgentRev

#define MANUAL_VEH_SAVE_COOLDOWN 5

private "_veh";
_veh = _this;

if (typeName _veh == "STRING") then { _veh = objectFromNetId _veh };

if (diag_tickTime - (_veh getVariable ["vehSaving_lastSave", 0]) > MANUAL_VEH_SAVE_COOLDOWN) then
{
	[_veh, "vehSaving_lastUse"] call fn_setTickTime;

	if (_veh call fn_isVehicleSaveable && call A3W_savingMethod == "extDB") then
	{
		[_veh] spawn
		{
			_vehID = _this call fn_saveVehicle;

			if (!isNil "_vehID" && {isServer && !isNil "A3W_hcObjSaving_unit" && {!isNull A3W_hcObjSaving_unit}}) then
			{
				A3W_hcObjSaving_trackVehID = _vehID;
				(owner A3W_hcObjSaving_unit) publicVariableClient "A3W_hcObjSaving_trackVehID";
			};
		};
	};

	_veh setVariable ["vehSaving_lastSave", diag_tickTime];
};
