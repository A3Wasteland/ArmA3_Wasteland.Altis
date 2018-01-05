if (!isNil "parking_saving_functions_defined") exitWith {};
diag_log format["Loading parking saving functions ..."];

#include "macro.h"

if (isServer) then {
  pp_notify = {
    //diag_log format["%1 call pp_notify", _this];
    ARGVX3(0,_player,objNull);
    ARGVX3(1,_msg,"");
    ARGV3(2,_dialog,"");


    pp_notify_request = [_msg,OR(_dialog,nil)];
    (owner _player) publicVariableClient "pp_notify_request";
  };

  pp_mark_vehicle = {
    //diag_log format["%1 call pp_create_mark_vehicle", _this];
    ARGVX3(0,_player,objNull);
    ARGVX3(1,_vehicle,objNull);

    pp_mark_vehicle_request = [_vehicle];
    (owner _player) publicVariableClient "pp_mark_vehicle_request";
  };

  pp_is_safe_position = {
    ARGVX3(0,_player,objNull);
    ARGVX3(1,_class,"");
    ARGVX3(2,_position,[]);

    def(_classes);
    _classes = ["Helicopter", "Plane", "Ship_F", "Car", "Motorcycle", "Tank"];

    def(_size);
    _size = sizeof _class;

    ((_position distance _player) < 50 && {
     (count(nearestObjects [_position, _classes , _size]) == 0)})
  };

  if (call A3W_savingMethod == "extDB") then
  {
    v_addSaveVehicle =
    {
      params ["_parked_vehicles", "_vehicle"];

      private _vehID = [_vehicle, 0, true] call fn_saveVehicle;
      private _vehProps = _vehicle getVariable "A3W_parkedProperties";

      if (isNil "_vehProps") exitWith {nil};
      _vehicle setVariable ["A3W_parkedProperties", nil];
      if (isNil "_vehID") exitWith {nil};

      [_parked_vehicles, _vehID, _vehProps] call fn_setToPairs;
      true
    };

    v_restoreVehicle =
    {
      params ["_data_pair", ["_ignore_expiration",false,[false]], ["_create_array",[],[[]]]];

      _data_pair params ["_vehicleID", "_vehData"];
      private _pos = _create_array select 1;
      private _safeDistance = _create_array select 3;

      [_vehData, "Position", _pos] call fn_setToPairs;
      [_vehData, "Direction"] call fn_removeFromPairs;
      [_vehData, "Velocity"] call fn_removeFromPairs;

      private _varNames = call fn_getVehicleVars;
      private _varVals = [_vehData, _varNames] call fn_preprocessSavedData;

      private ["_veh", "_hoursAlive", "_hoursUnused"];
      private (_varVals apply {_x select 0});

      { (_x select 1) call compile format ["%1 = _this", _x select 0] } forEach _varVals;

      private _lockState = [1,2] select (["A3W_vehicleLocking"] call isConfigOn);

      // delete wrecks near spawn
      {
        if (!alive _x) then
        {
          deleteVehicle _x;
        };
      } forEach nearestObjects [_markerPos, ["LandVehicle","Air","Ship"], 25 max sizeOf _class];

      call fn_restoreSavedVehicle;

      _veh call fn_manualVehicleSave;
      _veh
    };
  };

  pp_park_vehicle_request_handler = {
    ARGVX3(1,_this,[]);
    ARGVX3(0,_player,objNull);
    ARGVX3(1,_vehicle,objNull);

    if (not(alive _vehicle)) exitWith {};

    def(_uid);
    _uid = getPlayerUID _player;

    private _vehOwner = _vehicle getVariable ["ownerUID",""];

    if !(_vehOwner in ["",_uid]) exitWith {
      [_player, format ["Someone else has the ownership of the %1, you cannot park it.", ([typeOf _vehicle] call generic_display_name)], "Parking Error"] call pp_notify;
    };

    diag_log format["Parking vehicle %1(%2) for player %3(%4)", typeOf _vehicle, netId _vehicle,  (name _player), _uid];

    def(_parked_vehicles);
    _parked_vehicles = _player getVariable "parked_vehicles";
    _parked_vehicles = OR(_parked_vehicles,[]);

    if (_vehOwner isEqualTo "") then {
      _vehicle setVariable ["ownerUID", _uid];
    };

    private _saveFlag = (_vehicle getVariable ["A3W_purchasedVehicle", false] || _vehicle getVariable ["A3W_missionVehicle", false]);

    if !(_saveFlag) then {
      _vehicle setVariable ["A3W_purchasedVehicle", true];
    };

    [_this, _player, _vehicle, _uid, _vehOwner, _parked_vehicles, _saveFlag] spawn
    {
      params ["_this", "_player", "_vehicle", "_uid", "_vehOwner", "_parked_vehicles", "_saveFlag"];

      def(_added);
      _added = [_parked_vehicles, _vehicle, false] call v_addSaveVehicle;

      if (isNil "_added") exitWith {
        if (_vehOwner isEqualTo "") then {
          _vehicle setVariable ["ownerUID", nil];
        };

        if !(_saveFlag) then {
          _vehicle setVariable ["A3W_purchasedVehicle", nil];
        };

        diag_log format["ERROR: Could not park vehicle %1(%2) for player %3(%4)", typeOf _vehicle, netId _vehicle,  (name _player), _uid];
        [_player, format["An unknown error happened while trying to park the %1", ([typeOf _vehicle] call generic_display_name)], "Parking Error"] call pp_notify;
      };

      def(_display_name);
      _display_name = [typeOf _vehicle] call generic_display_name;

      if (!isNil "fn_untrackSavedVehicle") then { _vehicle call fn_untrackSavedVehicle };
      deleteVehicle _vehicle;

      _player setVariable ["parked_vehicles", _parked_vehicles]; //, true];
      ["parked_vehicles", _parked_vehicles] remoteExecCall ["A3W_fnc_setVarPlayer", _player];
      //[_player] call fn_saveAccount;
      [_player, format["%1, your %2 has been parked.", (name _player), _display_name]] call pp_notify;
    };
  };

  pp_retrieve_vehicle_request_handler = {
    ARGVX3(1,_this,[]);
    ARGVX3(0,_player,objNull);
    ARGVX3(1,_vehicle_id, "");

    def(_uid);
    _uid = getPlayerUID _player;

    diag_log format["Retrieving parked vehicle %1 for player %2(%3)", _vehicle_id,  (name _player), _uid];

    def(_parked_vehicles);
    _parked_vehicles = _player getVariable "parked_vehicles";
    _parked_vehicles = OR(_parked_vehicles,[]);

    def(_vehicle_data);
    _vehicle_data = [_parked_vehicles, _vehicle_id] call fn_getFromPairs;

    if (!isARRAY(_vehicle_data)) exitWith {
      diag_log format["ERROR: Could not retrieve vehicle %1 for player %2(%3)", _vehicle_id,  (name _player), _uid];
      [_player, format["An error occurred, your vehicle (%2) could not be retrieved. Please report this error to A3Armory.com.", _vehicle_id], "Retrieval Error"] call pp_notify;
    };

    //def(_position);
    //_position = [_vehicle_data, "Position"] call fn_getFromPairs;

    //def(_class);
    _class = [_vehicle_data, "Class"] call fn_getFromPairs;

    private ["_marker", "_markerPos", "_dirAngle", "_pos", "_posAGL"];
    private _nearbySpawns = allMapMarkers select {_x select [0,7] == "Parking" && {_x select [count _x - 6, 6] == "_spawn" && _player distance markerPos _x < 100}};

    if !(_nearbySpawns isEqualTo []) then
    {
      _marker = _nearbySpawns select 0;
      _markerPos = markerPos _marker;
      _dirAngle = markerDir _marker;

      if (surfaceIsWater _markerPos) then
      {
        _markerPos set [2, (getPosASL _player) select 2];
        _posAGL = ASLtoAGL _markerPos;
        _pos = if (round getNumber (configFile >> "CfgVehicles" >> _class >> "canFloat") > 0) then { _posAGL } else { ASLtoATL _markerPos };
      }
      else
      {
        _pos = _markerPos;
        _posAGL = _pos;
      };

      _pos set [2, (_pos select 2) + 0.1];
    };

    def(_create_array);
    //if (not([_player,_class,_position] call pp_is_safe_position)) then {
      //we don't have an exact safe position, let the game figure one out
      _create_array = [_class, if (isNil "_pos") then { getPos _player } else { _pos }, [], [0,50] select (isNil "_pos"), ""];
    //};

    def(_vehicle);
    _vehicle = [[_vehicle_id, _vehicle_data], true,OR(_create_array,nil)] call v_restoreVehicle;

    if (isNil "_vehicle") exitWith {
      diag_log format["ERROR: Could not restore vehicle %1 for player %2(%3)", _vehicle_id,  (name _player), _uid];
      [_player, format["An error occurred, your vehicle (%1) could not be restored. Please report this error to A3Armory.com.", _vehicle_id], "Restoring Error"] call pp_notify;
    };

    [_parked_vehicles, _vehicle_id] call fn_removeFromPairs;
    _player setVariable ["parked_vehicles", _parked_vehicles]; //, true];
    ["parked_vehicles", _parked_vehicles] remoteExecCall ["A3W_fnc_setVarPlayer", _player];
    //[_player] call fn_saveAccount;

    def(_display_name);
    _display_name = [typeOf _vehicle] call generic_display_name;
    [_player, _vehicle] call pp_mark_vehicle;
    [_player, format["%1, your %2 has been retrieved (marked on map)", (name _player), _display_name]] call pp_notify;
  };

  "pp_park_vehicle_request" addPublicVariableEventHandler pp_park_vehicle_request_handler;
  "pp_retrieve_vehicle_request" addPublicVariableEventHandler pp_retrieve_vehicle_request_handler;

};

if (isClient) then {
  pp_notify_request_handler = {_this spawn {
    //diag_log format["%1 call pp_notify_request_handler", _this];
    ARGVX3(1,_this,[]);
    ARGVX3(0,_msg,"");
    ARGV3(1,_dialog,"");

    if (isSTRING(_dialog)) exitWith {
      [_msg, _dialog, "OK", false] call BIS_fnc_guiMessage;
    };

    player groupChat _msg;
  };};

  "pp_notify_request" addPublicVariableEventHandler {_this call pp_notify_request_handler};

  pp_mark_vehicle_request_handler = {_this spawn {
    //diag_log format["%1 call pp_mark_vehicle_request_handler", _this];
    ARGVX3(1,_this,[]);
    ARGVX3(0,_vehicle,objNull);

    sleep 1; //give enough time for the vehicle to be move to the correct location (before marking)
    def(_class);
    _class = typeOf _vehicle;

    def(_name);
    _name = [_class] call generic_display_name;

    def(_pos);
    _pos = getPos _vehicle;

    def(_marker);
    _marker = format["pp_vehicle_marker_%1", ceil(random 1000)];
    _marker = createMarkerLocal [_marker, _pos];
    _marker setMarkerTypeLocal "waypoint";
    _marker setMarkerPosLocal _pos;
    _marker setMarkerColorLocal "ColorBlue";
    //_marker setMarkerTextLocal _name;

    _vehicle setVariable ["was_parked", true];

    if (!alive getConnectedUAV player) then {
      player connectTerminalToUAV _vehicle; // attempt uav connect
    };

    [_marker] spawn {
      ARGVX3(0,_marker,"");
      sleep 60;
      deleteMarkerLocal _marker;
    };
  };};

  "pp_mark_vehicle_request" addPublicVariableEventHandler {_this call pp_mark_vehicle_request_handler};

  pp_park_vehicle = {
    pp_park_vehicle_request = _this;
    publicVariableServer "pp_park_vehicle_request";
  };

  pp_retrieve_vehicle = {
    pp_retrieve_vehicle_request = _this;
    publicVariableServer "pp_retrieve_vehicle_request";
  };
};


diag_log format["Loading parking saving functions complete"];
parking_saving_functions_defined = true;