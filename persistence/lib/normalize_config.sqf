#include "macro.h"

#define ON_SCALAR(v) (isSCALAR(v) && {v == 1})


cfg_missionVehicleSaving_on = ON_SCALAR(A3W_missionVehicleSaving);
cfg_purchasedVehicleSaving_on = ON_SCALAR(A3W_purchasedVehicleSaving);
cfg_townVehicleSaving_on = ON_SCALAR(A3W_townVehicleSaving);
cfg_staticWeaponSaving_on = ON_SCALAR(A3W_staticWeaponSaving);
cfg_spawnBeaconSaving_on = ON_SCALAR(A3W_spawnBeaconSaving);
cfg_boxSaving_on = ON_SCALAR(A3W_boxSaving);
cfg_warchestSaving_on = ON_SCALAR(A3W_warchestSaving);
cfg_warchestMoneySaving_on = ON_SCALAR(A3W_warchestMoneySaving);
cfg_baseSaving_on = ON_SCALAR(A3W_baseSaving);


A3W_saveable_vehicles_list = OR_ARRAY(A3W_saveable_vehicles_list,[]);
A3W_objectLifetime = OR_SCALAR(A3W_objectLifetime,0);
A3W_object_saveInterval = OR_POSITIVE(A3W_object_saveInterval,60);
A3W_player_saveInterval = OR_POSITIVE(A3W_player_saveInterval,60);
A3W_playersList_saveInterval = OR_POSITIVE(A3W_playersList_saveInterval,60);


A3W_vehicleLifetime = OR_SCALAR(A3W_vehicleLifetime,0);
A3W_vehicleMaxUnusedTime = OR_SCALAR(A3W_vehicleMaxUnusedTime,0);
A3W_vehicle_saveInterval = OR_POSITIVE(A3W_vehicle_saveInterval,60);
A3W_locked_vehicles_list = OR_ARRAY(A3W_locked_vehicles_list,[]);


A3W_healthTime = OR_POSITIVE(A3W_healthTime,60*5);
A3W_hungerTime = OR_POSITIVE(A3W_hungerTime,60*60);
A3W_thirstTime = OR_POSITIVE(A3W_thirstTime,60*50);
publicVariable "A3W_healthTime";
publicVariable "A3W_hungerTime";
publicVariable "A3W_thirstTime";



diag_log format["[INFO] config: A3W_purchasedVehicleSaving = %1", cfg_purchasedVehicleSaving_on];
diag_log format["[INFO] config: A3W_missionVehicleSaving = %1", cfg_missionVehicleSaving_on];
diag_log format["[INFO] config: A3W_townVehicleSaving = %1", cfg_townVehicleSaving_on];
diag_log format["[INFO] config: A3W_staticWeaponSaving = %1", cfg_staticWeaponSaving_on];
diag_log format["[INFO] config: A3W_spawnBeaconSaving = %1", cfg_spawnBeaconSaving_on];
diag_log format["[INFO] config: A3W_boxSaving = %1", cfg_boxSaving_on];
diag_log format["[INFO] config: A3W_warchestSaving = %1", cfg_warchestSaving_on];
diag_log format["[INFO] config: A3W_warchestMoneySaving = %1", cfg_warchestMoneySaving_on];
diag_log format["[INFO] config: A3W_baseSaving = %1", cfg_baseSaving_on];


diag_log format["[INFO] config: A3W_objectLifetime = %1", A3W_objectLifetime];
diag_log format["[INFO] config: A3W_object_saveInterval = %1", A3W_object_saveInterval];
diag_log format["[INFO] config: A3W_player_saveInterval = %1", A3W_player_saveInterval];
diag_log format["[INFO] config: A3W_playersList_saveInterval = %1", A3W_playersList_saveInterval];


diag_log format["[INFO] config: A3W_vehicle_saveInterval = %1", A3W_vehicle_saveInterval];
diag_log format["[INFO] config: A3W_vehicleMaxUnusedTime = %1", A3W_vehicleMaxUnusedTime];
diag_log format["[INFO] config: A3W_vehicleLifetime = %1", A3W_vehicleLifetime];

diag_log ("[INFO] config: A3W_locked_vehicles_list = " + str(A3W_locked_vehicles_list));
diag_log ("[INFO] config: A3W_saveable_vehicles_list = " + str(A3W_saveable_vehicles_list));

diag_log format["[INFO] config: A3W_healthTime = %1", A3W_healthTime];
diag_log format["[INFO] config: A3W_hungerTime = %1", A3W_hungerTime];
diag_log format["[INFO] config: A3W_thirstTime = %1", A3W_thirstTime];


