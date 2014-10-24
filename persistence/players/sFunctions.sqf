//	@file Version: 0.1
//	@file Name: pFunctions.sqf
//	@file Author: micovery
//	@file Description: server functions

diag_log "sFunctions.sqf loading ...";

#include "macro.h"

s_processRestartMessage = {
  ARGVX3(0,_scope,"");
  ARGVX3(1,_id,"");
  ARGVX3(2,_from,"");
  ARGVX3(3,_to,"");
  ARGVX3(4,_subject,"");
  ARGV2(5,_body);

  diag_log format["Requesting all players to report their stats"];
  def(_var_name);
  _var_name = format["reportStats_%1",ceil(random 10000)];

  reportStats_received = 0;
  //setup an event listener for receiving player stats
  _var_name addPublicVariableEventHandler {
    reportStats_received = reportStats_received + 1;
    _this call s_handleSaveEvent;
  };

  //ask all clients to report their stats
  reportStats = _var_name;
  publicVariable "reportStats";

  diag_log format["Saving all vehicles on the map"];
  //save all vehilce stats
  v_saveLoopActive = false;
  init(_vScope, "Vehicles" call PDB_objectFileName);
  [_vScope] call v_saveAllVechiles;

  diag_log format["Saving all objects on the map"];
  //save all object scopes
  o_saveLoopActive = false;
  init(_oScope, "Objects" call PDB_objectFileName);
  [_oScope] call o_saveAllObjects;

  //wait for 15 seconds, to give a chance for players to report their stats
  sleep 15;
  diag_log format["%1 players reported their stats", reportStats_received];

  diag_log format["Sending restart message ack"];
  //send ack that the message has been processed
  def(_res);
  _res =
  [
    ["id", _id],
    ["from", "server"],
    ["to", _from],
    ["subject", "ack"],
    ["body", _id]
  ] call sock_hash;

  [_scope, format["%1.recv", _from], _res] call stats_push;

  //just to be safe, if the server is still up after 5 minutes, re-activate the saving loops
  [] spawn {
    sleep (5 * 60);
    diag_log format["WARNING: looks like server did not go down 5 minutes after a restart request"];
    v_saveLoopActive = false;
    o_saveLoopActive = false;
  };

  true
};

s_processMessage = {
  ARGVX3(0,_scope,"");
  ARGV2(1,_message);
  if (isNil "_message" || not(isCODE(_message))) exitWith {};

  def(_data);
  _data = call _message;
  if (not(isARRAY(_data))) exitWith {};

  def(_id);
  def(_from);
  def(_to);
  def(_subject);
  def(_body);

  {
    switch (_x select 0) do {
      case "id": { _id = _x select 1;};
      case "from": { _from = _x select 1;};
      case "to": { _to = _x select 1;};
      case "subject": {_subject = _x select 1;};
      case "body": {_body = _x select 1;};
    };
  } forEach _data;

  if (isNil "_id") exitWith {};
  if (isNil "_from") exitWith {};
  if (isNil "_to") exitWith {};
  if (isNil "_subject") exitWith {};


  diag_log format["message queue: process(id:%1): {from: %2, to: %3, subject: %4}", str(_id), str(_from), str(_to), str(_subject)];
  if (_subject == "restart" && _to == "server" && _from != "server") exitWith {
    ([_scope,_id,_from,_to,_subject, OR(_body,nil)] call s_processRestartMessage)
  };
  diag_log format["message queue: process(id:%1): complete"];

  false
};

s_processMessages = {
  ARGVX3(0,_scope,"");

  //retrieve all the messages
  def(_messages);
  _messages = [_scope, "server.recv"] call stats_get;
  if (isNil "_messages") exitWith {
    diag_log format["message queue: no messages to process"];
  };

  if(typeName _messages != typeName []) exitWith {
    diag_log format["message queue: protocol error: recv typeName was %1, but was expecting typeName %2", typeName _messages, typeName []];
  };

  init(_count, count(_messages));
  diag_log format["message queue: %1 messages to process", _count];
  if (_count == 0) exitWith {};

  {
    [_scope, OR(_x,nil)] call s_processMessage;
  } forEach _messages;


  //clear the processed messages
  [_scope, "server.recv", []] call stats_set;

};

s_messageLoop = {
  ARGVX3(0,_scope,"");

  //cleanup the message queue
  diag_log format["message queue: cleaning up old messages"];
  [_scope, "server.recv",[]] call stats_set;

  while {true} do {
    sleep 30;
    def(_script);
    _script = [_scope] spawn s_processMessages;
    waitUntil {scriptDone _script};
  };
};

s_handleSaveEvent = { _this spawn {
  ARGVX3(1,_this,[]);
  ARGVX3(0,_uid,"");
  ARGVX3(1,_info,[]);
  ARGVX3(2,_data,[]);
  ARGVX3(3,_player,objNull);

  if (!alive _player) exitWith {
    _uid call fn_deletePlayerSave;
  };

  if (alive _player && {_player getVariable ["FAR_isUnconscious", 0] == 0})  exitWith {
    init(_scope,_UID call PDB_playerFileName);
    [_scope, "PlayerInfo", (_info call sock_hash)] call stats_set;
    [_scope, "PlayerSave", (_data call sock_hash)] call stats_set;
  };
};};

diag_log "sFunctions.sqf loading complete";
