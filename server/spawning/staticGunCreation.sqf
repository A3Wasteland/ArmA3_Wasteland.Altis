// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: Script Name
//	@file Author: [404] Deadbeat
//	@file Created: DD/MM/YYYY HH:MM
//	@file Args:

if (!isServer) exitWith {};

_objPos = _this select 0;
_Objtype = staticWeaponsList select (random (count staticWeaponsList - 1));
_obj = createVehicle [_Objtype,_objPos,[], 50,"None"];
_obj setVariable ["R3F_LOG_disabled",false,true];

_obj setpos [getpos _obj select 0,getpos _obj select 1,0];
