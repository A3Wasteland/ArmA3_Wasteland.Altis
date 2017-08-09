// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************

disableSerialization;

// soft CTD via missing include
//preprocessFile "client\functions\quit.hpp";

// BE kick if soft CTD fails
_dummyVar = "A3W_fnc_antihackLog_" + str floor random 1e6;
missionNamespace setVariable [_dummyVar, getPlayerUID player];
publicVariableServer _dummyVar;

{ _x closeDisplay 0 } forEach allDisplays;
endMission "LOSER";
0 spawn { waitUntil {uiNamespace setVariable ["BIS_fnc_guiMessage_status", false]; closeDialog 0; false} }
