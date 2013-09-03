//	@file Version: 1.0
//	@file Name: Script Name
//	@file Author: [404] Deadbeat
//	@file Created: DD/MM/YYYY HH:MM
//	@file Args:

if(!X_Server) exitWith {};

_objPos = _this select 0;
_Objtype = staticWeaponsList select (random (count staticWeaponsList - 1));
_obj = createVehicle [_Objtype,_objPos,[], 50,"None"]; 

_obj setpos [getpos _obj select 0,getpos _obj select 1,0];