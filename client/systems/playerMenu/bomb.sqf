// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
private["_bomb","_tmp"];
_bomb = getPos (_this select 0);
_del = _this select 0;

sleep 20;
deleteVehicle _del;
_tmp = "Bo_Mk82" createVehicle [_bomb select 0,_bomb select 1, 0.1];
