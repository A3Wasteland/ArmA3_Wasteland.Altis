{ deleteVehicle (_x select 0) } forEach (call findHackedVehicles);

player commandChat "All Hacked Vehicles Deleted";

closeDialog 0;
execVM "client\systems\adminPanel\vehicleManagement.sqf";
