//if (!isNil "parking_functions_defined") exitWith {};
diag_log format["Loading parking functions ..."];

#include "macro.h"

#define strM(x) ([x,","] call format_integer)

pp_marker_create = {
  if (!hasInterface) exitWith {""};
  ARGVX3(0,_name,"");
  ARGVX3(1,_location,[]);
  ARGVX3(2,_this,[]);

  ARGVX3(0,_shape,"");
  ARGVX3(1,_type,"");
  ARGVX3(2,_color,"");
  ARGVX3(3,_size,[]);
  ARGVX3(4,_text,"");

  private["_marker"];
  _marker = createMarkerLocal [_name,_location];
  _marker setMarkerShapeLocal _shape;
  _marker setMarkerTypeLocal _type;
  _marker setMarkerColorLocal _color;
  _marker setMarkerSizeLocal _size;
  //_marker setMarkerText _text;
  (_marker)
};

pp_get_all_cities = {
  if (isARRAY(pp_all_cities)) exitWith {pp_get_all_cities};
  pp_get_all_cities = (nearestLocations [[0,0,0],["NameCityCapital","NameCity","NameVillage"],1000000]);
  (pp_get_all_cities)
};

pp_setup_terminal = {
  params ["_terminal"];
  if (_terminal getVariable ["A3W_parkingTerminalSetupDone",false]) exitWith {};
  _terminal allowDamage false;
  _terminal setVariable ["R3F_LOG_disabled", true, true]; //don't allow players to move the table

  if (isServer) then
  {
    def(_laptop);
    _laptop = createVehicle ["Land_Laptop_unfolded_F", getPosATL _terminal, [], 0, ""];
    
    _laptop attachTo [_terminal, [0,-0.1,0.55]];
    _laptop setVariable ["R3F_LOG_disabled", true, true]; //don't allow players to move the laptop
  };

  _terminal setVariable ["A3W_parkingTerminalSetupDone", true];
  _terminal spawn { _this enableSimulation false };
};

pp_create_terminal = {
 //Land_Laptop_unfolded_F
  ARGVX3(0,_garage,objNull);

  def(_pos);
  def(_terminal);

  _pos = _garage modelToWorld [-5,0.45,-1.485];
  _garage allowDamage false;

  _terminal = createVehicle ["Land_CampingTable_small_F", _pos, [], 0, ""];
  _terminal setPos _pos;
  _terminal setVectorDirAndUp [([vectorDir _garage,90] call BIS_fnc_rotateVector2D), vectorUp _garage];
  _terminal attachTo [_garage, [0,0,0]];
  _terminal setVariable ["is_parking", true, true];
  _terminal call pp_setup_terminal;
 
  (_pos)
};

pp_create_terminals = {
  def(_marker);
  def(_marker_pos);
  //def(_marker_name);
  def(_garage);
  def(_terminal);
  def(_model);
  def(_pos);
  def(_name);
  def(_marker);
  init(_i,1);


  {
    _marker = _x;
    //_marker_name =  text(_marker);
    _marker_pos = markerPos _marker;
    //if (isARRAY(pp_cities_whitelist) && {count(pp_cities_whitelist) > 0 && {not(_town_name in pp_cities_whitelist)}}) exitWith {};

    _garage = (nearestObjects [_marker_pos, ["Land_i_Shed_Ind_F"], 50]) select 0;
    if (!isOBJECT(_garage)) exitWith {
      diag_log format["No garage near %1", _marker];
    };

    _name = format["parking_terminal_%1", _i];
    _i = _i + 1;

    _pos = [_garage] call pp_create_terminal;

    diag_log format["Creating parking terminal at %1 (Grid %2)", _marker, mapGridPosition _pos];

  } foreach (allMapMarkers select {_x select [0,7] == "Parking" && _x find "_" == -1}) //(call pp_get_all_cities);
};

pp_get_near_vehicles = {
  ARGVX4(0,_player,objNull,[]);

  def(_vehicles);
  _vehicles = (nearestObjects [getPos _player, ["Helicopter", "Plane", "Ship_F", "Car", "Motorcycle", "Tank"], 50]);

  init(_filtered,[]);
  def(_uid);
  _uid = getPlayerUID player;

  def(_ownerUID);
  def(_vehicle);

  { call {
    _vehicle = _x;
    if (not(isOBJECT(_vehicle) && {alive _vehicle})) exitWith {};

    _ownerUID = _vehicle getVariable ["ownerUID", ""];
    if(!isSTRING(_ownerUID)) exitWith {};
    if (_ownerUID == "" || {_ownerUID == _uid}) exitWith {
      _filtered pushBack _vehicle;
    };

  };} forEach _vehicles;

  (_filtered)
};



pp_join_time = diag_tickTime; //time when the player joined the server

pp_get_wait_time = {
  ARGVX4(0,_vehicle_id,"",0);

  if (not(isSCALAR(pp_retrieve_wait)) || {pp_retrieve_wait <= 0}) exitWith {0};
  private _retrieve_wait = 0;

  def(_cooldown_start_name);
  _cooldown_start_name =  format["%1_cooldown_start", _vehicle_id];


  def(_cooldown_start);
  _cooldown_start = missionNamespace getVariable _cooldown_start_name;

  if (!isSCALAR(_cooldown_start)) then {
    _cooldown_start = pp_join_time;
    missionNamespace setVariable [_cooldown_start_name, _cooldown_start];
  };

  def(_time_elapsed);
  _time_elapsed = diag_tickTime - _cooldown_start;

  def(_time_remaining);
  _time_remaining = _retrieve_wait - _time_elapsed;

  if (_time_remaining <= 0) then {
    missionNamespace setVariable [_cooldown_start_name, nil];
  };

  (_time_remaining)
};

pp_retrieve_transaction_ok = {
  ARGVX4(0,_player,objNull,true);
  ARGVX4(1,_cost,0,true);
  ARGVX3(2,_class,"",true)

  def(_cmoney);
  _cmoney = _player getVariable ["cmoney",0];
  if (_cost > _cmoney) exitWith {
    _player groupChat format["%1, you do not have enough money to retrieve the %2", (name _player), ([_class] call generic_display_name)];
    false
  };

  _player setVariable ["cmoney", _cmoney - _cost, true];
  true
};

pp_retrieve_allowed = {
  ARGVX4(0,_player,objNull, true);
  ARGVX4(1,_vehicle_id,"",true);
  ARGVX4(2,_class,"", true);

  //check if there is a cool-down period
  def(_wait_time);
  _wait_time = [_vehicle_id] call pp_get_wait_time;
  if (isSCALAR(_wait_time) && {_wait_time > 0 }) exitWith {
    private _remaining = ceil _wait_time;
    private _mins = floor (_remaining / 60);
    private _secs = floor (_remaining - (_mins * 60));
    private _timer = format ["%1%2%3s", [str _mins + "m",""] select (_mins == 0), ["","0"] select (_secs < 10), _secs];

    _player groupChat format["%1, you have to wait %2 to retrieve the %3", (name _player), _timer, ([_class] call generic_display_name)];
    false
  };

  //check if thereis a price for retrieving the vehicle
  if (isSCALAR(pp_retrieve_cost) && {pp_retrieve_cost > 0}) exitWith {
    init(_cost,pp_retrieve_cost);
    _msg = format["It's going to cost you $%1 to retrieve the %2. Do you want to proceed?", strM(_cost), ([_class] call generic_display_name)];

    if (not([_msg, "Confirm", "Yes", "No"] call BIS_fnc_guiMessage)) exitWith {false};
    if (not([_player, _cost] call pp_retrieve_transaction_ok)) exitWith {false};

    true
  };

  true
};

pp_park_allowed = {
  ARGVX4(0,_player,objNull, true);
  ARGVX4(1,_vehicle_id,"",true);
  ARGVX4(2,_class,"", true);

  if (isARRAY(pp_disallowed_vehicle_classes) && {count(pp_disallowed_vehicle_classes) > 0 && { ({_class isKindOf _x} count pp_disallowed_vehicle_classes) > 0}}) exitWith {
    _msg = format["This vehicle (%1) is not allowed to be parked.", ([_class] call generic_display_name)];
    [_msg, "Illegal Parking", "Ok", false] call BIS_fnc_guiMessage;
    false
  };

  def(_parked_vehicles);
  _parked_vehicles = _player getVariable ["parked_vehicles", []];
  init(_count,count(_parked_vehicles));

  //check if the parking is full
  if (isSCALAR(pp_max_player_vehicles) && {pp_max_player_vehicles > 0 && {_count >= pp_max_player_vehicles}}) exitWith {
    _msg = format["You already have %1 vehicle(s) parked. There are no more parking spaces available.", _count];
    [_msg, "Full Parking", "Ok", false] call BIS_fnc_guiMessage;
    false
  };

  true
};



pp_park_vehicle_action = {
  init(_player,player);

  def(_vehicles);
  _vehicles = [_player] call pp_get_near_vehicles;

  def(_vehicle_id);
  _vehicle_id = ["Park Vehicle", _vehicles] call pp_interact_park_vehicle_wait;

  if (!isSTRING(_vehicle_id)) exitWith {
    //_player groupChat format["%1, you did not select any vehicle to park", (name _player)];
  };


  _vehicle = objectFromNetId _vehicle_id;
  if (!isOBJECT(_vehicle)) exitWith {
    _player groupChat format["%1, the vehicle you selected to park could not be found", (name _player)];
  };

  def(_class);
  _class =  typeOf _vehicle;

  if (not([_player, _vehicle_id, _class] call pp_park_allowed)) exitWith {};


  _player groupChat format["Please wait while we park your %1", ([typeOf _vehicle] call generic_display_name)];
  [_player, _vehicle] call pp_park_vehicle;
};

pp_retrieve_vehicle_action = {
  init(_player,player);

  def(_parked_vehicles);
  _parked_vehicles = _player getVariable "parked_vehicles";
  _parked_vehicles = if (isARRAY(_parked_vehicles)) then {_parked_vehicles} else {[]};


  def(_vehicle_id);
  _vehicle_id = ["Retrieve Vehicle", _parked_vehicles] call pp_interact_park_vehicle_wait;


  if (!isSTRING(_vehicle_id)) exitWith {
    //_player groupChat format["%1, you did not select any vehicle to retreive", (name _player)];
  };

  def(_vehicle_data);
  _vehicle_data = [_parked_vehicles, _vehicle_id] call fn_getFromPairs;

  if (!isARRAY(_vehicle_data)) exitWith {
    player groupChat format["ERROR: The selected vehicle (%1) was not found", _vehicle_id];
  };

  def(_class);
  _class = [_vehicle_data, "Class"] call fn_getFromPairs;

  if (not([_player, _vehicle_id, _class] call pp_retrieve_allowed)) exitWith {};

  _player groupChat format["Please wait while we retrieve your %1", ([_class] call generic_display_name)];
  [player, _vehicle_id] call pp_retrieve_vehicle;
};


pp_cameraDir = {
  ([(positionCameraToWorld [0,0,0]), (positionCameraToWorld [0,0,1])] call BIS_fnc_vectorDiff)
};

pp_is_object_parking = {
  ARGVX4(0,_obj,objNull,false);
  (_obj getVariable ["is_parking", false])
};

pp_is_player_near = {
  private["_objects"];
  _objects = nearestObjects [player, ["Land_Laptop_unfolded_F", "Land_CampingTable_small_F"], 2];
  if (isNil "_objects") exitWith {false};

  private["_found"];
  _found = false;
  {
    if ([_x] call pp_is_object_parking) exitWith {
      _found = true;
    };
  } forEach _objects ;

  (_found)
};

pp_actions = OR(pp_actions,[]);

pp_remove_actions = {
  if (count pp_actions == 0) exitWith {};

  {
    private["_action_id"];
    _action_id = _x;
    player removeAction _action_id;
  } forEach pp_actions;
  pp_actions = [];
};

pp_add_actions = {
  if (count pp_actions > 0) exitWith {};
  private["_player"];
  _player = _this select 0;

  private["_action_id", "_text"];
  _action_id = _player addAction ["<img image='addons\parking\icons\parking.paa'/> Park Vehicle", {call pp_park_vehicle_action}];
  pp_actions = pp_actions + [_action_id];

  _action_id = _player addAction ["<img image='addons\parking\icons\parking.paa'/> Retrieve Vehicle", {call pp_retrieve_vehicle_action}];
  pp_actions = pp_actions + [_action_id];
};

pp_check_actions = {
    private["_player"];
    _player = player;
    private["_vehicle", "_in_vehicle"];
    _vehicle = (vehicle _player);
    _in_vehicle = (_vehicle != _player);

    if (not(_in_vehicle || {not(alive _player) || {not(call pp_is_player_near)}})) exitWith {
      [_player] call pp_add_actions;
    };

   [_player] call pp_remove_actions;
};


pp_client_loop = {
  if (!hasInterface) exitWith {};

  while {true} do {
    call pp_check_actions;
    sleep 0.5;
  };
};


if (isServer) then
{
  diag_log "Setting up parking terminals ... ";
  [] call pp_create_terminals;
  pp_setup_terminals_complete = true;
  publicVariable "pp_setup_terminals_complete";
}
else
{
  diag_log "Waiting for parking terminals setup to complete ...";
  waitUntil {!isNil "pp_setup_terminals_complete"};
};

if (hasInterface) then
{
  waitUntil {!isNil "A3W_serverSetupComplete" && time > 0};
};

{
  _x call pp_setup_terminal;

  if (pp_markers_enabled) then
  {
    [format ["parking_terminal_%1", _forEachIndex + 1], getPosASL _x, pp_markers_properties] call pp_marker_create;
  };
} forEach ((allMissionObjects "Land_CampingTable_small_F") select {_x getVariable ["is_parking",false]});

diag_log "Parking terminals setup complete";

[] spawn pp_client_loop;

parking_functions_defined = true;
diag_log "Loading parking functions complete";
