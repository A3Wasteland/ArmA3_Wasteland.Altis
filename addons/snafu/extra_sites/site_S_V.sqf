// Main airfield
_pos = [14511.586914,16332.287109,0.00123787];
_object = createVehicle ["Land_Scrap_MRAP_01_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosATL _pos;

//Selakano
_pos = [20786.210938,7266.402344,-0.00472641];
_object = createVehicle ["Land_Scrap_MRAP_01_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosATL _pos;

//Saltflats
_pos = [22986.46875,18863.994141,-0.195639];
_object = createVehicle ["Land_Scrap_MRAP_01_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosATL _pos;

//North Airfield
_pos = [26734.578125,24598.246094,-0.0024128];
_object = createVehicle ["Land_Scrap_MRAP_01_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 230;
_object setPosATL _pos;
//.......
_pos = [3953.425537,15070.771484,-0.292678];
_object = createVehicle ["Land_Scrap_MRAP_01_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 120;
_object setPosATL _pos;
[_object, 0, -0] call BIS_fnc_setPitchBank;






