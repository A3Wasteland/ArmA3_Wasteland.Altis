#include "dikcodes.h"
#include "macro.h"

if (not(undefined(camera_functions_defined))) exitWith {nil};
diag_log format["Loading camera functions ..."];

object_calcualte_vectors = {
	ARGVX2(0,_data);
	def(_direction);
	def(_angle);
	def(_pitch);

	_direction = _data select 0;
	_angle = _data select 1;
	_pitch = _data select 2;

	_vecdx = sin(_direction) * cos(_angle);
	_vecdy = cos(_direction) * cos(_angle);
	_vecdz = sin(_angle);

	_vecux = cos(_direction) * cos(_angle) * sin(_pitch);
	_vecuy = sin(_direction) * cos(_angle) * sin(_pitch);
	_vecuz = cos(_angle) * cos(_pitch);


	def(_dir_vector);
	def(_up_vector);
	_dir_vector = [_vecdx,_vecdy,_vecdz];
	_up_vector = [_vecux,_vecuy,_vecuz];

	([_dir_vector,_up_vector])
};

object_set_heading = {
	ARGVX2(0,_object);
	ARGVX2(1,_data);

	def(_vectors);
	_vectors = [_data] call object_calcualte_vectors;
	_object setVectorDirAndUp _vectors;
};

object_setVariable = {
	ARGVX2(0,_object);
	ARGVX2(1,_variable_name);
	ARGV2(2,_variable_value);
	ARGV2(3,_remote);

	if (undefined(_remote)) then {
		_remote =  false;
	};

	if (undefined(_variable_name)) exitWith {nil};

	if (undefined(_variable_value)) then {
		_object setVariable [_variable_name,nil,_remote];
	}
	else {
		_object setVariable [_variable_name,_variable_value,_remote];
	};
};


object_getVariable = {
	ARGVX2(0,_object);
	ARGVX2(1,_variable_name);
	ARGV2(2,_default);
	if (typeName _object != "OBJECT") exitWith {nil};
	if (undefined(_variable_name)) exitWith {nil};


	//player commandChat format["_object = %1",_object];
	def(_result);
	_result = _object getVariable [_variable_name,OR(_default,nil)];

	if (undefined(_result)) exitWith {OR(_default,nil)};
	_result
};

camera_keyUpHandler = {
  //player commandChat format["camera_keyUpHandler %1",_this];
  ARGVX2(0,_this);

  ARGV2(0,_display);
  ARGV2(1,_key);
  ARGV2(2,_shift);
  ARGV2(3,_control);
  ARGV2(4,_alt);

  init(_player,camera_unit);
  [false,_key] call camera_update_key_tracker;

  if (_shift) then {
    camera_shift_held = false;
  };

  if (_control) then {
    camera_control_held = false;
  };

  if (_alt) then {
    camera_alt_held = false;
  };

  if (_key == DIK_LWIN) then {
    camera_lwin_held = false;
  };

  if (_key == DIK_SPACE) then {
    camera_space_held = false;
  };


  if ((_key in (actionKeys "MoveForward") ||
    _key in (actionKeys "MoveBack") ||
    _key in (actionKeys "TurnLeft") ||
    _key in (actionKeys "TurnRight") ||
    _key in [DIK_Q, DIK_Z]) &&
    (count(camera_key_tracker) == 0)) then {
    [_player,0] call camera_set_velocity;
  };

  false
};

camera_remove_keyUp = {
  disableSerialization;
    _display = findDisplay 46;
  if (not(undefined(camera_keyUpHandler_id))) then {
    _display displayRemoveEventHandler  ["keyUp",camera_keyUpHandler_id];
    camera_keyUpHandler_id = nil;
  };
};


camera_setup_keyUp = {
  init(_data,_this);

  disableSerialization;
    _display = findDisplay 46;
  if ( undefined(camera_keyUpHandler_id) ) then {
    camera_keyUpHandler_id = _display displayAddEventHandler  ["keyUp",format["[_this,%1] call camera_keyUpHandler",_data]];
  };
};


camera_move_pos_vector = {
  ARGVX2(0,_pos);
  ARGVX2(1,_data);
  ARGVX2(2,_velocity);

  def(_direction);
  def(_angle);
  def(_pitch);
  _direction = _data select 0;
  _angle = _data select 1;
  _pitch = _data select 2;

  _vecdx = (sin(_direction) * cos(_angle)) * _velocity;
  _vecdy = (cos(_direction) * cos(_angle)) * _velocity;
  _vecdz = (sin(_angle)) * _velocity;

  _pos = [((_pos select 0) + _vecdx),((_pos select 1) + _vecdy),((_pos select 2) + _vecdz)];
  _pos
};


camera_next_target = {
  ARGVX2(0,_direction);
  ARGV2(1,_target);

  def(_units);
  _units = playableUnits;
  _target = if (undefined(_target)) then {_units select 0} else {_target};

  def(_index);
  _index = _units find _target;
  _index = _index + _direction;
  _index = if (_index >= (count(_units))) then {0} else {_index};
  _index = if (_index < 0) then { (count _units) - 1} else {_index};
  _target = _units select _index;

  (_target)
};

camera_update_target = {
  ARGVX2(0,_player);
  ARGVX2(1,_key);
  ARGVX2(2,_shift);
  ARGVX2(3,_control);


  def(_target);
  def(_previous_target);
  _target =  [_player,"camera_target"] call object_getVariable;
  _previous_target = _target;

  def(_handled);
  _handled = false;
  if (_shift && _key in (actionKeys "NextChannel")) then {
    _target = [+1,_target] call camera_next_target;
    camera_unit commandChat format["Attaching to %1",(name _target)];
    [_player, _target, OR(_previous_target,nil)] call camera_attach_to_target;

    _handled = true;
  };

  if (_shift && _key in (actionKeys "PrevChannel")) then {
    _target = [-1,_target] call camera_next_target;
    camera_unit commandChat format["Attaching to %1",(name _target)];
    [_player, _target, OR(_previous_target,nil)] call camera_attach_to_target;
    _handled = true;
  };

  if (_shift && _key in (actionKeys "Chat")) then {
    private["_new_target", "_current_target"];
    _new_target = [10] call camera_target;
    
    def(_aiming_at_same_player);
    _aiming_at_same_player = (!isNil "_new_target" && {!isNil "_previous_target" && {_new_target == _previous_target}});
    
    def(_not_aiming_at_anything);
    _not_aiming_at_anything = (isNil "_new_target" && {!isNil "_previous_target"});
    
    if (_not_aiming_at_anything || _aiming_at_same_player) then {
      camera_unit commandChat format["Detaching from %1", (name _previous_target)];
      [_player, _previous_target] call camera_detach_from_target;
    }
    else { if (not(_aiming_at_same_player) && {not(isNil "_new_target")}) then {
      camera_unit commandChat format["Attaching to %1",(name _new_target)];
      [_player, _new_target, OR(_previous_target,nil)] call camera_attach_to_target;
    }
    else {
      camera_unit commandChat format["Nothing to detach from, or attach to"];
    };};

    _handled = true;
  };
  
  if (_control && _key == DIK_H) then {
    camera_hud_enabled = if (isNil "camera_hud_enabled") then {true} else {nil};
    _handled = true;
  };
  
  if (_control && _key == DIK_E) then {
    [] call camera_toggle;
    _handled = true;
  };
  
  _handled
};

camera_detach_from_target = {
  ARGVX3(0,_player,objNull);
  ARGV3(1,_previous_target,objNull);
  
  _camera = [_player,"camera"] call object_getVariable;

  detach _camera;
  [_player,"camera_target",nil] call object_setVariable;

  def(_heading);
  _heading = if (undefined(_previous_target)) then {nil} else {[_previous_target,([_player] call camera_get_heading)] call camera_heading_modelToWorld;};
  [_player,OR(_heading,nil)] call camera_set_heading;

  def(_pos);
  _pos = if (undefined(_previous_target)) then {nil} else {_previous_target modelToWorld ([_player] call camera_get_position)};
  [_player,OR(_pos,nil)] call camera_set_position;
  
};

camera_attach_to_target = {
  ARGVX3(0,_player,objNull);
  ARGVX3(1,_target,objNull);
  ARGV3(2,_previous_target,objNull);
  
  [_player,"camera_target",_target] call object_setVariable;
  
  def(_pos);
  _pos = if (undefined(_previous_target)) then {nil} else {[_player] call camera_get_position};
  [_player,OR(_pos,nil)] call camera_set_position;

  def(_heading);
  _heading = if (undefined(_previous_target)) then {[0,0,0]} else {[_player] call camera_get_heading};
  [_player,OR(_heading,nil)] call camera_set_heading;
};

camera_get_map_open = {
  ARGVX2(0,_player);

  def(_map_open);
  _map_open = [_player,"camera_map_open"] call object_getVariable;
  _map_open = if (undefined(_map_open)) then {false} else {_map_open};
  _map_open
};

camera_set_map_open = {
  ARGVX2(0,_player);
  ARGVX2(1,_map_open);

  [_player,"camera_map_open",_map_open] call object_setVariable;
};

camera_map_control = {
  ((finddisplay 12) displayctrl 51)
};

camera_map_open = {
  ARGVX2(0,_player);

  [_player,true] call camera_set_map_open;
  openMap [true,true];

  (call camera_map_control) mapCenterOnCamera false;

  def(_pos);
  _pos = [_player] call camera_get_world_position;
  mapAnimAdd [0,(ctrlMapScale (call camera_map_control)) ,_pos];
  mapAnimCommit;
};

camera_map_close = {
  ARGVX2(0,_player);

  [_player,false] call camera_set_map_open;
  openMap [false,false];

  def(_pos);
  _pos = [_player] call camera_get_world_position;
  mapAnimAdd [0,(ctrlMapScale (call camera_map_control)) ,_pos];
  mapAnimCommit;
};


camera_update_map = {
  ARGVX2(0,_player);
  ARGVX2(1,_key);
  ARGVX2(2,_shift);

  if (not(_key in (actionKeys "ShowMap"))) exitWith {nil};

  if (not([_player] call camera_get_map_open)) then {
    [_player] call camera_map_open;
  }
  else {
    [_player] call camera_map_close;
  };
};

camera_get_max_velocity = {
  ARGVX2(0,_player);

  def(_velocity);
  _velocity = [_player,"camera_max_velocity"] call object_getVariable;
  _velocity = if (undefined(_velocity)) then {0} else {_velocity};
  _velocity
};

camera_set_max_velocity = {
  ARGVX2(0,_player);
  ARGVX2(1,_velocity);
  [_player,"camera_max_velocity",_velocity] call object_setVariable;

};

camera_get_velocity = {
  ARGVX2(0,_player);

  def(_velocity);
  _velocity = [_player,"camera_velocity"] call object_getVariable;
  _velocity = if (undefined(_velocity)) then {0} else {_velocity};
  _velocity
};

camera_set_velocity = {
  ARGVX2(0,_player);
  ARGVX2(1,_velocity);
  [_player,"camera_velocity",_velocity] call object_setVariable;
};


camera_calculate_velocity = {
  ARGVX2(0,_player);
  ARGVX2(1,_shift);

  def(_velocity);
  def(_max_velocity);
  def(_delta);
  _delta = 0.05;

  _velocity = [_player] call camera_get_velocity;
  _max_velocity = [_player] call camera_get_max_velocity;

  if (_velocity < _max_velocity) then {
    _velocity = (_velocity + _delta);
    _velocity = (_velocity) min (_max_velocity);
  }
  else {
    _velocity = (_velocity - _delta);
    _velocity = (_velocity) max (_max_velocity);
  };

  [_player,_velocity] call camera_set_velocity;

  _velocity = if (_shift) then {_velocity + 3} else {_velocity};
  (_velocity)
};

camera_get_position = {
  ARGVX2(0,_player);

  def(_target);
  _target = [_player,"camera_target"] call object_getVariable;

  def(_position);
  def(_relative);
  def(_default);
  _relative = [0,-3,3];
  _default = if (undefined(_target)) then {_player modelToWorld _relative} else {_relative};

  _position = [_player,"camera_pos"] call object_getVariable;
  _position = if (undefined(_position)) then {_default} else {_position};
  _position
};

camera_get_world_position = {
  ARGVX2(0,_player);

  def(_pos);
  _pos = [_player] call camera_get_position;

  def(_target);
  _target = [_player,"camera_target"] call object_getVariable;
  _pos = if (undefined(_target)) then { _pos } else { _target modelToWorld _pos };
  _pos
};

camera_save_position = {
  ARGVX2(0,_player);
  ARGV2(1,_position);
  [_player,"camera_pos",OR(_position,nil)] call object_setVariable;
};


camera_set_position = {
  ARGVX2(0,_player);
  ARGV2(1,_position);

  [_player,OR(_position,nil)] call camera_save_position;
  _position = [_player] call camera_get_position;

  def(_target);
  _target = [_player,"camera_target"] call object_getVariable;

  def(_camera);
  _camera = [_player,"camera"] call object_getVariable;
  if (undefined(_camera)) exitWith {nil};

  if (undefined(_target)) then {
    _camera setPos _position;
    //_camera camSetPos _position;
    //_camera camCommit 0.3;
  }
  else {
    _camera attachTo [(vehicle _target),_position];
  };

};

camera_update_position = {
  //player commandChat format["camera_update_position %1",_this];
  ARGVX2(0,_player);
  ARGVX2(1,_key);
  ARGVX2(2,_shift);

  def(_position);
  _position = [_player] call camera_get_position;

  def(_velocity);
  _velocity = [_player,_shift] call camera_calculate_velocity;

  def(_heading);
  def(_direction);
  def(_angle);
  def(_bank);
  _heading = [_player] call camera_get_heading;
  _direction = _heading select 0;
  _angle = _heading select 1;
  _bank = _heading select 2;

  if (_key in (actionKeys "MoveForward")) then {
    _position = [_position,[_direction,_angle,_bank],_velocity] call camera_move_pos_vector;
  };

  if (_key in (actionKeys "MoveBack")) then {
    _angle = _angle + 180;
    _angle = if (_angle > 360) then { _angle - 360 } else {_angle};
    _position = [_position,[_direction,_angle,_bank],_velocity] call camera_move_pos_vector;
  };

  if (_key in (actionKeys "TurnLeft") || _key in (actionKeys "MoveLeft")) then {
    _direction = _direction - 90;
    _direction = if (_direction < 0) then { 360 - abs(_direction) } else {_direction};
    _position = [_position,[_direction,0,_bank],_velocity] call camera_move_pos_vector;
  };

  if (_key in (actionKeys "TurnRight") || _key in (actionKeys "MoveRight")) then {
    _direction = _direction + 90;
    _direction = if (_direction > 360) then {_direction - 360} else {_direction};
    _position = [_position,[_direction,0,_bank],_velocity] call camera_move_pos_vector;
  };


  if (_key == DIK_Q) then {
    _angle = _angle + 90;
    _angle = if (_angle > 360) then { _angle - 360 } else {_angle};
    _position = [_position,[_direction,_angle,_bank],_velocity] call camera_move_pos_vector;
  };


  if (_key == DIK_Z)  then {
    _angle = _angle - 90;
    _angle = if (_angle < 0) then { 360 - abs(_angle) } else {_angle};
    _position = [_position,[_direction,_angle,_bank],_velocity] call camera_move_pos_vector;
  };

  [_player,OR(_position,nil)] call camera_set_position;
};


camera_MouseZChanged_handler = {
  //player commandChat format["camera_MouseZChanged_handler %1",_this];
  ARGVX2(0,_this);
  init(_player,camera_unit);

  ARGV2(1,_zc);

  def(_velocity);
  _velocity = [_player] call camera_get_max_velocity;
  _velocity = if (_zc > 0) then {_velocity + 0.1} else {_velocity - 0.1};
  _velocity = (_velocity) min (5);
  _velocity = (_velocity) max (0);
  _velocity = (round(_velocity * 100) / 100);
  //player commandChat format["Camera max velocity set at %1",_velocity];
  [_player,_velocity] call camera_set_max_velocity;

  true
};

camera_remove_MouseZChanged = {
  disableSerialization;
  def(_control);
  _control = findDisplay 46;
  if (not(undefined(camera_MouseZChanged_id))) then {
    _control displayRemovEeventHandler  ["MouseZChanged",camera_MouseZChanged_id];
    camera_MouseZChanged_id = nil;
  };
};

camera_setup_MouseZChanged = {
  init(_data,_this);
  disableSerialization;
  def(_control);
  _control = findDisplay 46;
  if ( undefined(camera_MouseZChanged_id) ) then {
    camera_MouseZChanged_id = _control displayAddEventHandler  ["MouseZChanged",format["[_this,%1] call camera_MouseZChanged_handler",_data]];
    //player commandChat format["camera_MouseZChanged_id = %1",camera_MouseZChanged_id];
  };
};

camera_get_nightvision = {
  ARGVX2(0,_player);

  def(_nightvision);
  _nightvision = [_player,"camera_nightvision"] call object_getVariable;
  _nightvision = if (undefined(_nightvision)) then {0} else {_nightvision};
  _nightvision
};

camera_set_nightvision = {
  ARGVX2(0,_player);
  ARGVX2(1,_nightvision);

  [_player,"camera_nightvision",_nightvision] call object_setVariable;
  (_nightvision)
};

camera_update_nightvision = {
  ARGVX2(0,_player);
  ARGVX2(1,_key);

  if (not(_key in actionKeys "NightVision")) exitWith {nil};

  def(_nightvision);
  _nightvision = [_player] call camera_get_nightvision;
  _nightvision = ((_nightvision + 1) % 10);
  //player commandChat format["_nightvision = %1",_nightvision];
  switch (_nightvision) do {
    case 0: {
      camera_unit commandChat format["Setting camera default mode"];
      camUseNVG false;
      false SetCamUseTi 0;
    };
    case 1: {
      camera_unit commandChat format["Setting camera NV "];
      camUseNVG true;
      false SetCamUseTi 0;
    };
    case 2: {
      camera_unit commandChat format["Setting camera thermal white-hot"];
      camUseNVG false;
      true SetCamUseTi 0;
    };
    case 3: {
      camera_unit commandChat format["Setting camera thermal black-hot"];
      camUseNVG false;
      true SetCamUseTi 1;
    };
    case 4: {
      camera_unit commandChat format["Setting camera thermal light-green-hot"];
      camUseNVG false;
      true SetCamUseTi 2;
    };
    case 5: {
      camera_unit commandChat format["Setting camera thermal dark-green-hot"];
      camUseNVG false;
      true SetCamUseTi 3;
    };
    case 6: {
      camera_unit commandChat format["Setting camera light-orange-hot "];
      camUseNVG false;
      true SetCamUseTi 4;
    };
    case 7: {
      camera_unit commandChat format["Setting camera dark-orange-hot "];
      camUseNVG false;
      true SetCamUseTi 5;
    };
    case 8: {
      camera_unit commandChat format["Setting camera orange body-heat "];
      camUseNVG false;
      true SetCamUseTi 6;
    };
    case 9: {
      camera_unit commandChat format["Setting camera colored body-heat "];
      camUseNVG false;
      true SetCamUseTi 7;
    };
  };

  [_player,_nightvision] call camera_set_nightvision;
};

camera_target = {
  ARGVX3(0,_distance,0);
  private["_objects", "_object"];
  _objects = nearestObjects [(screenToWorld [(safezoneX + 0.5 * safezoneW),(safezoneY + 0.5 * safezoneH)]),["LandVehicle","Man"],_distance];
  if (count _objects == 0) exitWith {nil};
  _object = (_objects select 0);
  
  if (isNil "_object" || isNull _object) exitWith {nil};
  
  if (_object isKindOf "Man" && {!isPlayer _object}) exitWith {nil};
  if (_object isKindOf "LandVehicle" && {(count (crew _object)) == 0}) exitWith {nil};
  
  _object
};

camera_enabled = {
  ARGVX2(0,_player);

  def(_camera);
  _camera = [_player,"camera"] call object_getVariable;
  not(isNil "_camera" || {isNull _camera})
};

camera_keyDownHandler = {
  //player commandChat format["camera_keyDownHandler = %1",_this];
  init(_player,camera_unit);

  ARGVX2(0,_this);
  ARGVX2(1,_key);
  ARGVX2(2,_shift);
  ARGVX2(3,_control);
  ARGVX2(4,_alt);

  [true,_key] call camera_update_key_tracker;
  //player commandChat format["_key = %1",_key];

  if (_shift) then {
    camera_shift_held = true;
  };

  if (_control) then {
    camera_control_held = true;
  };

  if (_alt) then {
    camera_alt_held = true;
  };

  if (_key == DIK_LWIN) then {
    camera_lwin_held = true;
  };

  if (_key == DIK_SPACE) then {
    camera_space_held = true;
  };
  


  def(_camera);
  _camera = [_player,"camera"] call object_getVariable;
  if (undefined(_camera)) exitWith {nil};

  [_player,_key,_shift] call camera_update_map;
  if ([_player] call camera_get_map_open) exitWith {false};

  [_player,_key] call camera_update_nightvision;

  def(_handled);
  _handled = [_player,_key,_shift,_control] call camera_update_target;


  [_player,_key,_shift] call camera_update_position;


  _handled
};

camera_remove_keyDown = {
  disableSerialization;
    _display = findDisplay 46;
  if (not(undefined(camera_keyDownHandler_id))) then {
    _display displayRemoveEventHandler  ["keyDown",camera_keyDownHandler_id];
    camera_keyDownHandler_id = nil;
  };
};

camera_setup_keyDown = {
  init(_data,_this);

  disableSerialization;
    _display = findDisplay 46;
  if ( undefined(camera_keyDownHandler_id) ) then {
    camera_keyDownHandler_id = _display displayAddEventHandler  ["keyDown",format["[_this,%1] call camera_keyDownHandler",_data]];
  };
};


camera_mouseMoving_handler = {
  //player commandChat format["camera_mouseMoving_handler %1",_this];

  ARGVX2(0,_this);
  ARGVX2(1,_xc);
  ARGVX2(2,_yc);


  init(_player,camera_unit);

  if (dialog) exitWith {false};

  if ([_player] call camera_get_map_open) exitWith {false};


  [_player,_xc,_yc] call camera_update_heading;
  false
};

camera_remove_mouseMoving = {
  disableSerialization;
    _display = findDisplay 46;
  if (not(undefined(camera_mouseMoving_id))) then {
    _display displayRemoveEventHandler  ["mouseMoving",camera_mouseMoving_id];
    camera_mouseMoving_id = nil;
  };
};

camera_setup_mouseMoving = {
  init(_data,_this);
  disableSerialization;
    _display = findDisplay 46;
  if ( undefined(camera_mouseMoving_id) ) then {
    camera_mouseMoving_id = _display displayAddEventHandler  ["mouseMoving",format["[_this,%1] call camera_mouseMoving_handler",_data]];
  };
};


camera_heading2vectors = {
  ARGVX2(0,_heading);

  def(_direction);
  def(_angle);
  def(_bank);
  _direction = _heading select 0;
  _angle = _heading select 1;
  _bank = _heading select 2;

  _vecdx = sin(_direction) * cos(_angle);
  _vecdy = cos(_direction) * cos(_angle);
  _vecdz = sin(_angle);

  _vecux = cos(_direction) * cos(_angle) * sin(_bank);
  _vecuy = sin(_direction) * cos(_angle) * sin(_bank);
  _vecuz = cos(_angle) * cos(_bank);

  ([ [_vecdx,_vecdy,_vecdz],[_vecux,_vecuy,_vecuz] ])
};

camera_vectorDir2heading = {
  //player commandChat format["camera_vectorDir2heading %1",_this];
  ARGVX2(0,_vectorDir);

  def(_vecdz);
  def(_vecdy);
  def(_vecdx);
  _vecdx = _vectorDir select 0;
  _vecdy = _vectorDir select 1;
  _vecdz = _vectorDir select 2;

  def(_angle);
  _angle = asin(_vecdz);
  _direction = asin(_vecdx / cos(_angle));

  _angle = if (_angle < 0) then {360 - abs(_angle)} else {_angle};
  _direction = if (_direction < 0) then {360 - abs(_direction)} else {_direction};

  def(_heading);
  _heading = [_direction,_angle,0];

  //player commandChat format["_convert = %1",_heading];
  _heading
};

camera_save_heading = {
  ARGVX2(0,_player);
  ARGVX2(1,_heading);
  [_player,"camera_heading",_heading] call object_setVariable;
};

camera_get_heading = {
  ARGVX2(0,_player);

  def(_camera);
  _camera = [_player,"camera"] call object_getVariable;

  def(_heading);
  _heading = [_player,"camera_heading"] call object_getVariable;
  _heading = if (undefined(_heading)) then {[_player,[0,0,0]] call camera_heading_modelToWorld} else {_heading};
  _heading
};

camera_update_heading = {
  ARGVX2(0,_player);
  ARGVX2(1,_xc);
  ARGVX2(2,_yc);;

  def(_heading);
  _heading = [_player] call camera_get_heading;

  def(_dir);
  _dir = _heading select 0;
  _dir = _dir + _xc;
  _dir = if (_dir > 360) then { _dir - 360 } else { _dir };
  _dir = if (_dir < 0) then { 360 - abs(_dir) } else { _dir};

  def(_angle);
  _angle = _heading select 1;
  _angle = if (undefined(_angle)) then {0} else {_angle};
  _angle =  _angle - _yc;
  _angle = if (_angle > 360) then { _angle - 360 } else { _angle };
  _angle = if (_angle < 0) then { 360 - abs(_angle) } else { _angle};

  def(_bank);
  _bank = _heading select 2;

  _heading = [_dir,_angle,_bank];
  //player commandChat format["_update_heading = %1",_heading];
  [_player,_heading] call camera_set_heading;
};


camera_set_heading = {
  ARGVX2(0,_player);
  ARGVX2(1,_heading);

  def(_camera);
  _camera = [_player,"camera"] call object_getVariable;
  if (undefined(_camera)) exitWith {nil};

  //player commandChat format["_heading_before = %1",_heading];
  [_player,_heading] call camera_save_heading;
  _heading = [_player] call camera_get_heading;

  //player commandChat format["_heading_last = %1",_heading];
  def(_vectors);
  _vectors = [_heading] call camera_heading2vectors;
  _camera setVectorDirAndUp _vectors;


};

camera_heading_modelToWorld = {
  ARGVX2(0,_target);
  ARGVX2(1,_heading);

  //player commandChat format["_heading2_before = %1",_heading];
  def(_tdir);
  _tdir = getDir _target;

  def(_dir);
  _dir = _heading select 0;
  _dir = _dir + _tdir;
  _dir = if (_dir > 360) then { _dir - 360 } else { _dir };
  _heading set [0,_dir];
  //player commandChat format["_heading2_after = %1",_heading];
  _heading
};

camera_destroy = {
  //camera_unit commandChat format["camera_destroy %1",_this];
  ARGVX3(0,_player, objNull);

  def(_camera);
  _camera = [_player,"camera"] call object_getVariable;
  if (undefined(_camera)) exitWith {};

  [_player,"camera",nil] call object_setVariable;
  [_player] call camera_map_close;

  _camera cameraEffect ["terminate","back"];
  //camera_unit commandChat format["destroying camera! %1",_camera];
  camDestroy _camera;
};


camera_create = {
  ARGVX3(0,_player, objNull);
  if (not(isPlayer _player)) exitWith {};

  def(_pos);
  def(_camera);
  _pos = (getPosATL _player);
  _camera = "camera" camCreate [(_pos select 0),(_pos select 1),((_pos select 2) + 3)];
  _camera cameraEffect ["Internal","LEFT"];
  _camera setPos _pos;
  _camera camSetFoV 1;
  _camera camPrepareFocus [-1,-1];
  _camera camCommitPrepared 0;

  showCinemaBorder false;
  cameraEffectEnableHUD true;
  clearRadio;
  enableRadio true;
  //_camera camCommand "MANUAL ON";
  _camera camCommand "INERTIA OFF";

  [_player,"camera",_camera] call object_setVariable;
  [_player,"camera_target",nil] call object_setVariable;
  [_player,nil] call camera_set_heading;
  [_player,nil] call camera_set_position;
  [_player] call camera_map_close;
  [_player,0] call camera_set_velocity;
  [_player,1] call camera_set_max_velocity;


  //hook for disabling camera when player dies
  [_camera,_player] spawn {
    ARGVX2(0,_camera);
    ARGVX2(1,_player);

    camera_unit commandChat format["waiting!"];
    waitUntil {
      (not(alive _player) || (isNull ([_player,"camera",objNull] call object_getVariable)))
    };

    [_player] call camera_destroy;
  };

  _camera
};

camera_mouseButtonClick_handler = {
  //player commandChat format["camera_mouseButtonClick_handler %1",_this];
  ARGVX2(0,_this);

  init(_player,camera_unit);

  if (not([_player] call camera_get_map_open)) exitWith {false};

  ARGVX2(0,_display);
  ARGVX2(1,_button);
  ARGVX2(2,_x);
  ARGVX2(3,_y);
  ARGVX2(5,_control);

  if (not(_button == 0)) exitWith {nil};

  def(_target);
  _target = [_player,"camera_target"] call object_getVariable;
  if (not(undefined(_target))) exitWith {
    player commandChat format["Cannot teleport while camera is attached to a target"];
    false
  };

  def(_world_pos);
  _world_pos = _display posScreenToWorld [_x,_y];

  def(_pos);
  _pos = [_player] call camera_get_position;
  _world_pos set [2,(_pos select 2)];

  [_player,_world_pos] call camera_set_position;
  mapAnimAdd [0,(ctrlMapScale _display),_world_pos];
  mapAnimCommit;

  [_player] call camera_map_close;

  true
};

camera_remove_mouseButtonClick = {
  disableSerialization;
  def(_control);
  _control = call camera_map_control;
  if (not(undefined(camera_mouseButtonClick_id))) then {
    _control ctrlRemovEeventHandler  ["MouseButtonClick",camera_mouseButtonClick_id];
    camera_mouseButtonClick_id = nil;
  };
};

camera_setup_mouseButtonClick = {
  init(_data,_this);
  disableSerialization;
  def(_control);
  _control = call camera_map_control;
  if (undefined(camera_mouseButtonClick_id)) then {
    camera_mouseButtonClick_id = _control ctrlAddEventHandler  ["MouseButtonClick",format["[_this,%1] call camera_mouseButtonClick_handler",_data]];
    //player commandChat format["camera_mouseButtonClick_id = %1",camera_mouseButtonClick_id];
  };
};

camera_MouseButtonDown_handler = {
  //player commandChat format["camera_MouseButtonDown_handler %1",_this];
  ARGV2(0,_this);

  init(_player,camera_unit);

  ARGV2(0,_display);
  ARGV2(1,_button);
  ARGV2(2,_x);
  ARGV2(3,_y);
  ARGV2(4,_shift);
  ARGV2(5,_control);


  true
};

camera_remove_MouseButtonDown = {
  disableSerialization;
  def(_display);
    _display = findDisplay 46;
  if (not(undefined(camera_MouseButtonDown_id))) then {
    _display displayRemoveEventHandler  ["MouseButtonDown",camera_MouseButtonDown_id];
    camera_MouseButtonDown_id = nil;
  };
};

camera_setup_MouseButtonDown = {
  init(_data,_this);
  disableSerialization;

  def(_display);
    _display = findDisplay 46;
  if ( undefined(camera_MouseButtonDown_id) ) then {
    camera_MouseButtonDown_id = _display displayAddEventHandler  ["MouseButtonDown",format["[_this,%1] call camera_MouseButtonDown_handler",_data]];
    //player commandChat format["camera_MouseButtonDown_id = %1",camera_MouseButtonDown_id];
  };
};

camera_MouseButtonUp_handler = {
  //player commandChat format["camera_MouseButtonUp_handler %1",_this];
  ARGVX2(0,_this);

  init(_player,camera_unit);

  ARGVX2(0,_display);
  ARGVX2(1,_button);
  ARGVX2(2,_x);
  ARGVX2(3,_y);
  ARGVX2(5,_control);


  true
};

camera_remove_MouseButtonUp = {
  disableSerialization;

  def(_display);
    _display = findDisplay 46;
  if (not(undefined(camera_MouseButtonUp_id))) then {
    _display displayRemoveEventHandler  ["MouseButtonUp",camera_MouseButtonUp_id];
    camera_MouseButtonUp_id = nil;
  };
};

camera_setup_MouseButtonUp = {
  init(_data,_this);
  disableSerialization;

  def(_display);
  _display = findDisplay 46;
  if ( undefined(camera_MouseButtonUp_id) ) then {
    camera_MouseButtonUp_id = _display displayAddEventHandler  ["MouseButtonUp",format["[_this,%1] call camera_MouseButtonUp_handler",_data]];
    //player commandChat format["camera_MouseButtonUp_id = %1",camera_MouseButtonUp_id];
  };
};





camera_start_loop = {
  //player commandChat format["camera_start_loop %1"];
  camera_loop_active =  true;
  ["A3W_camera_oneachFrame", "onEachFrame", camera_loop] call BIS_fnc_addStackedEventHandler;
};

camera_stop_loop = {
  //player commandChat format["camera_stop_loop %1"];
  camera_loop_active = false;
  ["A3W_camera_oneachFrame", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
};


camera_loop = {
  if (not(camera_loop_active)) exitWith {};
  if (isNil "camera_unit" || {typeName camera_unit != "OBJECT" || {isNull camera_unit}}) exitWith {};

  private["_player"];
  _player = camera_unit;
  if (not([_player] call camera_enabled)) exitWith {};

  [_player] call camera_hud_update;
};

camera_hud_target = nil;
camera_hud_update = {
  private["_player", "_target"];
  _player = _this select 0;
  _target = [3] call camera_target;

  if (isNil "_target" || {
    typeName _target != typeName objNull || {
	isNull _target || {
	isNil "camera_hud_enabled"}}}) exitWith {
	if (!isNil "camera_hud_target") then {
	  camera_hud_target = nil;
	  hintSilent "";
	};
  };

  camera_hud_target = _target;
  [_target] call camera_3d_tags_draw;
  [_target] call camera_show_info;
};

camera_toggle = {
  if (!isOBJECT(camera_unit) || {isNull camera_unit || {!alive camera_unit}}) then {
    camera_unit = player;
  };

  init(_player,camera_unit);


  def(_camera);
  _camera = [_player,"camera"] call object_getVariable;
  _camera = if (undefined(_camera)) then {objNull} else {_camera};


  if (isNull _camera) then {
    camera_unit commandChat format["Enabling camera"];
    [] call camera_setup_mouseMoving;
    [] call camera_setup_keyDown;
    [] call camera_setup_keyUp;
    [] call camera_setup_mouseButtonClick;
    [] call camera_setup_MouseZChanged;
    [] call camera_setup_MouseButtonDown;
    [] call camera_setup_MouseButtonUp;
    [_player] call camera_create;

    [] call camera_start_loop;

  }
  else {
    camera_unit commandChat format["Disabling camera"];
    [] call camera_remove_mouseMoving;
    [] call camera_remove_keyDown;
    [] call camera_remove_keyUp;
    [] call camera_remove_mouseButtonClick;
    [] call camera_remove_MouseZChanged;
    [] call camera_remove_MouseButtonDown;
    [] call camera_remove_MouseButtonUp;

    [] call camera_stop_loop;

    [_player] call camera_destroy;

  };
};

camera_shift_held = false;
camera_control_held = false;
camera_alt_held = false;
camera_lwin_held = false;
camera_space_held = false;


camera_key_tracker = [];
camera_update_key_tracker = {
  ARGVX2(0,_down);
  ARGVX2(1,_key);

  if (not(_key in (actionKeys "MoveForward") ||
    _key in (actionKeys "MoveBack") ||
    _key in (actionKeys "TurnLeft") ||
    _key in (actionKeys "TurnRight") ||
    _key in [DIK_Q, DIK_Z])) exitWith {};

  if (_down && {(camera_key_tracker find _key) == -1}) then {
    camera_key_tracker set [count(camera_key_tracker),_key];
  };

  if (not(_down) && {(camera_key_tracker find _key) >= 0}) then {
    camera_key_tracker = camera_key_tracker - [_key];
  };
};


camera_show_info = {
  private["_target"];
	_target = _this select 0;

	hintSilent format["name: %1\ndamage: %2\nfatigue: %3\nrecoil: %4",
	  (name _target),
	  (damage _target),
	  (getFatigue _target),
	  (unitRecoilCoefficient _target)
	 ];
};

camera_3d_tags_draw = {
	private["_target"];
	_target = _this select 0;

	private["_player"];
	_player = camera_unit;


	disableSerialization;

  if (not(alive _target) || visibleMap) exitWith {};

  private["_vehicle"];
  _vehicle = (vehicle _target);

  if (not(alive _vehicle) || {not(isPlayer _target) || {not(alive _target)}}) exitWith {};

  private["_distance", "_has_admin_camera", "_under_base"];
  _distance = _target distance ([_player,"camera",objNull] call object_getVariable);

  if (_distance > 25) exitWith {};


  private["_part", "_pos", "_pos3d", "_pos2d"];
  _part = if (_vehicle == _target) then {"neck" } else {"engine"};
  _pos = (_target selectionPosition _part);
  _pos = [(_pos select 0), (_pos select 1), (_pos select 2) + 0.3];
  _pos3d = ((vehicle _target) modelToWorld (_pos));
  if (not(count _pos3d == 3)) exitWith {};

  private["_size", "_font"];
  _size = 0.045;
  _font = "PuristaMedium";

  private["_text", "_icon"];
  _icon = "\A3\ui_f\data\map\markers\military\triangle_CA.paa";

  _pos2d = worldToScreen((vehicle _target) modelToWorld (_pos));
  if (not(count (_pos2d) == 2)) exitWith {};

  private["_x", "_y"];
  _x = abs((_pos2d select 0) - 0.5);
  _y = abs((_pos2d select 1) - 0.5);

  _text = format["%1 (%2) [%3]",  (name _target), (side _target), round(_distance)];

  drawIcon3D [_icon, [0.71,0.28,0,0.8], _pos3d, 0.6,0.6, 180, _text, 2, _size, _font];
};


diag_log format["Loading camera functions loaded ..."];
camera_functions_defined =  true;