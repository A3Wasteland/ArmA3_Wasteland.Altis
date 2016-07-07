
if (isServer) then
{
  waitUntil {missionNamespace getVariable ["A3W_savingMethod",""] isEqualType {}};
}
else
{
  waitUntil {!isNil "A3W_serverSetupComplete"};
};

if !(["A3W_privateStorage"] call isConfigOn) exitWith {};


call compile preprocessFileLineNumbers "addons\storage\config.sqf";
call compile preprocessFileLineNumbers "addons\storage\ps_functions.sqf";
