call compile preprocessFileLineNumbers "addons\UAV_Control\config.sqf";

uav_control_get_group_uids = {
  private["_player"];
  _player = _this select 0;

  private["_group_uids"];
  _group_uids = [getPlayerUID _player];
  {if (true) then {
    private["_member"];
    _member = _x;
    if (isNil "_member" || { typeName _member != typeName objNull || {isNull _member}}) exitWith {};

    private["_member_uid"];
    _member_uid = getPlayerUID _member;
    if (isNil "_member_uid" || { typeName _member_uid != typeName "" || {_member_uid == ""}}) exitWith {};

    _group_uids pushBack _member_uid;
  };} forEach (units (group _player));

  (_group_uids)
};


uav_control_check_access = {
  private["_player", "_uav"];
  _player = _this select 0;
  _uav = _this select 1;

  if (_uav isKindOf "UAV_01_base_F") exitWith {}; //allow quad-rotors

  private["_uid", "_owner_uid"];
  _owner_uid = _uav getVariable ["ownerUID",""];
  _uid = getPlayerUID _player;

  if (_owner_uid == "" || {_uid == ""}) exitWith {}; //UAV not owned by anyone ...

  if (uav_control_permission == "owner" && {_uid == _owner_uid}) exitWith {};
  if (uav_control_permission == "group" && {_owner_uid in ([_player] call uav_control_get_group_uids)}) exitWith {};
  if (uav_control_permission == "side") exitWith {}; //this is the default enforced by the game

  _player connectTerminalToUAV objNull;
  ["You can't control this UAV. It doesn't belong to you", 5] call mf_notify_client;
};

uav_control_loop = {
  private["_uav1", "_uav2"];
  while {true} do {
    waitUntil { sleep 0.1; _uav1 = getConnectedUAV player; !(isNull _uav1)};
    [player, _uav1] call uav_control_check_access;
    waitUntil { sleep 0.1; _uav2 = getConnectedUAV player; (isNull _uav2 || {_uav1 != _uav2})};
  };
};

[] spawn uav_control_loop;
