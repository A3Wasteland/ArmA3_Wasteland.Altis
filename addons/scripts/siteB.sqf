//@file Version: 1.3
//@file Name: site_B.sqf
//@file Author: Cael817, GID Positioning System

//NW Corner, ladder north
_pos = [02030.962891,743.119873,3.625];
_object = createVehicle ["Land_Pier_Box_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 180;
_object setPosASL _pos;
[_object, 0, -0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//NE Corner, ladder south
_pos = [02130.861328,743.12384,3.6224];
_object = createVehicle ["Land_Pier_Box_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 180;
_object setPosASL _pos;
[_object, 0, -0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//SW Corner, ladder south
_pos = [02030.970703,642.342529,3.61987];
_object = createVehicle ["Land_Pier_Box_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
////[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//SE Corner, ladder south
_pos = [02130.859375,642.334045,3.6277];
_object = createVehicle ["Land_Pier_Box_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//NWC 1
_pos = [02061.015625,744.729610,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//NWC 2
_pos = [02061.015625,736.729919,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//NEC 1
_pos = [02101.015625,744.728610,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//NEC 2
_pos = [02101.015625,736.729675,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN 1
_pos = [02028.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN2
_pos = [02036.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN 3
_pos = [02044.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN 4
_pos = [02052.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN 5
_pos = [02060.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN 6
_pos = [02068.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN 7
_pos = [02076.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN 8
_pos = [02084.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN 9
_pos = [02092.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN 10
_pos = [02100.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN 11
_pos = [02108.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN 12
_pos = [02116.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN 13
_pos = [02124.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CN 14
_pos = [02132.912109,712.627625,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 1
_pos = [02028.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 2
_pos = [02036.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 3
_pos = [02044.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 4
_pos = [02052.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 5
_pos = [02060.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 6
_pos = [02068.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 7
_pos = [02076.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 8
_pos = [02084.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 9
_pos = [02092.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 10
_pos = [02100.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 11
_pos = [02108.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 12
_pos = [02116.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 13
_pos = [02124.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//CS 14
_pos = [02132.914063,672.627075,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//SWC 1
_pos = [02061.015625,648.729610,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//SWC 2
_pos = [02061.015625,640.729919,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//SEC 1
_pos = [02101.015625,648.728610,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//SEC 2
_pos = [02101.015625,640.729675,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 1 East start
_pos = [2020.913574,672.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 1 East Center start
_pos = [2012.913574,672.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 1 West Center start
_pos = [2004.913574,672.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 1 West start
_pos = [1996.913574,672.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 2 East start
_pos = [2020.913574,712.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 2 East Center start
_pos = [2012.913574,712.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 2 West Center start
_pos = [2004.913574,712.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 2 West start
_pos = [1996.913574,712.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 3 East Center 
_pos = [2012.913574,752.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 3 Center
_pos = [2004.913574,752.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 3 West
_pos = [1996.913574,752.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 4 East Center 
_pos = [2012.913574,792.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 4 Center
_pos = [2004.913574,792.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 4 West
_pos = [1996.913574,792.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 5 East Center 
_pos = [2012.913574,832.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 5 Center
_pos = [2004.913574,832.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 5 West
_pos = [1996.913574,832.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 6 East Center 
_pos = [2012.913574,872.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 6 Center
_pos = [2004.913574,872.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 6 West
_pos = [1996.913574,872.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 7 East Center 
_pos = [2012.913574,912.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 7 Center
_pos = [2004.913574,912.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 7 West
_pos = [1996.913574,912.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 8 East Center 
_pos = [2012.913574,952.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 8 Center
_pos = [2004.913574,952.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 8 West
_pos = [1996.913574,952.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 9 East Center 
_pos = [2012.913574,992.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 9 Center
_pos = [2004.913574,992.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 9 West
_pos = [1996.913574,992.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 10 East Center 
_pos = [2012.913574,1032.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 10 Center
_pos = [2004.913574,1032.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 10 West
_pos = [1996.913574,1032.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 11 East Center 
_pos = [2012.913574,1072.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 11 Center
_pos = [2004.913574,1072.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 11 West
_pos = [1996.913574,1072.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 12 East Center 
_pos = [2012.913574,1112.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 12 Center
_pos = [2004.913574,1112.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 12 West
_pos = [1996.913574,1112.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 13 East Center 
_pos = [2012.913574,1152.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 13 Center
_pos = [2004.913574,1152.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 13 West
_pos = [1996.913574,1152.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 14 East Center 
_pos = [2012.913574,1192.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 14 Center
_pos = [2004.913574,1192.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 14 West
_pos = [1996.913574,1192.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 15 East Center 
_pos = [2012.913574,1232.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 15 Center
_pos = [2004.913574,1232.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 15 West
_pos = [1996.913574,1232.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 16 East Center 
_pos = [2012.913574,1272.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 16 Center
_pos = [2004.913574,1272.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 16 West
_pos = [1996.913574,1272.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 17 East Center 
_pos = [2012.913574,1312.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 17 Center
_pos = [2004.913574,1312.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 17 West
_pos = [1996.913574,1312.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 18 East Center 
_pos = [2012.913574,1352.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 18 Center
_pos = [2004.913574,1352.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 18 West
_pos = [1996.913574,1352.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 19 East Center 
_pos = [2012.913574,1392.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 19 Center
_pos = [2004.913574,1392.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 19 West
_pos = [1996.913574,1392.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 20 East Center 
_pos = [2012.913574,1432.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 20 Center
_pos = [2004.913574,1432.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 20 West
_pos = [1996.913574,1432.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 21 East Center 
_pos = [2012.913574,1472.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 21 Center
_pos = [2004.913574,1472.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 21 West
_pos = [1996.913574,1472.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 22 East Center 
_pos = [2012.913574,1512.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 22 Center
_pos = [2004.913574,1512.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 22 West
_pos = [1996.913574,1512.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 23 East Center 
_pos = [2012.913574,1552.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 23 Center
_pos = [2004.913574,1552.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 23 West
_pos = [1996.913574,1552.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 24 East Center 
_pos = [2012.913574,1592.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 24 Center
_pos = [2004.913574,1592.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 24 West
_pos = [1996.913574,1592.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//W Runway 25 East Center = 1000m
_pos = [2012.913574,1632.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 25 Center = 1000m
_pos = [2004.913574,1632.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Runway 25 West = 1000m
_pos = [1996.913574,1632.624695,-2.3683];
_object = createVehicle ["Land_nav_pier_m_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 90;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
//**************
//NW Hangar, facing south
_pos = [02044.708984,719.66742,3.5501];
_object = createVehicle ["Land_Hangar_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
_object allowDamage false;

//NC Hangar, facing south
_pos = [02080.910156,719.66742,3.5501];
_object = createVehicle ["Land_Hangar_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
_object allowDamage false;

//NE Hangar, facing south
_pos = [02117.117188,719.66742,3.5501];
_object = createVehicle ["Land_Hangar_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;
_object allowDamage false;

// Barracks
_pos = [02081.441406,645.34613,3.42625];
_object = createVehicle ["Land_i_Barracks_V2_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 180;
_object setPosASL _pos;
[_object, 0, -0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//E Fuelpump roof
_pos = [02130.566406,641.615479,3.45621];
_object = createVehicle ["Land_fs_roof_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//E Fuelpump 1
_pos = [02128.517578,641.648315,3.62916];
_object = createVehicle ["Land_fs_feed_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
//_object enableSimulation false;

//E Fuelpump 2
_pos = [02130.546875,641.648315,3.62916];
_object = createVehicle ["Land_fs_feed_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
//_object enableSimulation false;

//E Fuelpump 3
_pos = [02132.423828,641.648315,3.62916];
_object = createVehicle ["Land_fs_feed_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
//_object enableSimulation false;

//W Fuelpump roof
_pos = [02030.677734,641.615479,3.45621];
_object = createVehicle ["Land_fs_roof_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Fuelpump 1
_pos = [02028.597656,641.648315,3.62916];
_object = createVehicle ["Land_fs_feed_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

//W Fuelpump 2
_pos = [02030.693359,641.648315,3.62916];
_object = createVehicle ["Land_fs_feed_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
//_object enableSimulation false;

//W Fuelpump 3
_pos = [02032.599609,641.648315,3.62916];
_object = createVehicle ["Land_fs_feed_F", _pos, [], 0, "CAN_COLLIDE"];
_object setDir 0;
_object setPosASL _pos;
//[_object, 0, 0] call BIS_fnc_setPitchBank;
_object enableSimulation false;

diag_log "Extra sites and buildings, site_B loaded";
