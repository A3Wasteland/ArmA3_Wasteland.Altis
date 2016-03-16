// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
{ deleteVehicle (_x select 0) } forEach (call findHackedVehicles);

player commandChat "All Hacked Vehicles Deleted";
["VehicleMgmt_DeleteAllHackedVehicles", "complete"] call notifyAdminMenu;

closeDialog 0;
execVM "client\systems\adminPanel\vehicleManagement.sqf";
