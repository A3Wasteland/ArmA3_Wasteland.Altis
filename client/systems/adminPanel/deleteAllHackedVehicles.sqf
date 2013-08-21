
{ deleteVehicle (_x select 0) } forEach (call findHackedVehicle);

player commandChat "All Hacked Vehicles Deleted";

closeDialog 0;
execVM "client\systems\adminPanel\vehicleManagement.sqf";