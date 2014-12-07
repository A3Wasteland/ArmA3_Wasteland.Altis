#include "macro.h"
#include "defines.h"

if (!undefined(atm_functions_defined)) exitWith {};
diag_log format["Loading atm functions ..."];


atm_is_object_atm = {
  ARGVX4(0,_object,objNull,false);
  ([": atm",str(_object)] call BIS_fnc_inString)
};



atm_is_player_near = {
  private["_pos1", "_pos2"];
  _pos1 = (eyePos player);
  _pos2 = ([_pos1, call cameraDir] call BIS_fnc_vectorAdd);

  private["_objects"];
  _objects = lineIntersectsWith [_pos1,_pos2,objNull,objNull,true];
  if (isNil "_objects" || {typeName _objects != typeName []}) exitWith {false};


  private["_found"];
  _found = false;
  {
    if ([_x] call atm_is_object_atm) exitWith {
	    _found = true;
	  };
  } forEach _objects ;

  (_found)
};


atm_actions = [];

atm_remove_actions = {
	if (count atm_actions == 0) exitWith {};

	{
		private["_action_id"];
		_action_id = _x;
		player removeAction _action_id;
	} forEach atm_actions;
	atm_actions = [];
};

atm_add_actions = {
	if (count atm_actions > 0) exitWith {};
	private["_player"];
	_player = _this select 0;

  private["_action_id", "_text"];
  _action_id = _player addAction ["<img image='addons\bank\icons\bank.paa'/> Access ATM", {[player] call bank_menu_dialog;}];
  atm_actions = atm_actions + [_action_id];
};


atm_check_actions = {
  	private["_player"];
    _player = player;
    private["_vehicle", "_in_vehicle"];
    _vehicle = (vehicle _player);
    _in_vehicle = (_vehicle != _player);

    if (not(_in_vehicle || {not(alive _player) || {not(call atm_is_player_near)}})) exitWith {
      [_player] call atm_add_actions;
    };

   [_player] call atm_remove_actions;
};

atm_client_loop = {
	private ["_atm_client_loop_i"];
	_atm_client_loop_i = 0;

	while {_atm_client_loop_i < 5000} do {
		call atm_check_actions;
		sleep 0.5;
		_atm_client_loop_i = _atm_client_loop_i + 1;
	};
	[] spawn atm_client_loop;
};

[] spawn atm_client_loop;

atm_functions_defined = true;
diag_log format["Loading atm functions complete"];
