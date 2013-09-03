#include "defs.hpp"
#define GET_DISPLAY (uiNameSpace getVariable "balca_debug_hint")
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)

[3,_this] call PG_get(FNC_statistics);


_trackCam = {
	private ["_cam","_lastpos","_dir","_vel","_bullet","_acctime"];
	_bullet = _this;
	_ammo = typeOf _bullet;
	_startpos = getPos _bullet;
	_lastpos = getPos _bullet;
	_interrupt = (findDisplay 46) displayAddEventHandler ["KeyDown", "c_proving_ground_TRACKING = false;_this set [0,nil];true"];
	PG_set(TRACKING,true);

	sleep .01;

	setAccTime PG_get(bullettime);
	showCinemaBorder false;
	_cam = "camera" camCreate getPosASL _bullet;
	_cam cameraEffect ["internal", "back"];
	_cam camSetTarget _bullet;
	_cam camSetRelPos [0,-10,2];
	_cam camCommit 0.1;


	while {!(isNull _bullet)&&(PG_get(TRACKING))} do {
		_lastTime = time;
		_dir = getDir _bullet;
		_vel = velocity _bullet;
		_spd = (_vel distance [0,0,0]) max 1;
		_lastpos = getPosASL _bullet;
		sleep 0.01;
		_velVector = [(_vel select 0)/_spd,(_vel select 1)/_spd,(_vel select 2)/_spd];
		_cam camSetRelPos [0,-10,2];
		//_cam camSetRelPos [-5*(_velVector select 0),-5*(_velVector select 1),-5*(_velVector select 2)];
		_cam camcommit 5*(time - _lastTime);
		cutRsc ["balca_debug_hint","PLAIN"];
		GET_CTRL(balca_hint_text_IDC) ctrlSetText format ["%1",_ammo];
		GET_CTRL(balca_hint_text2_IDC) ctrlSetText format ["Speed: %1",round(_spd)];
	};

	setAccTime 1;
	if (((_startpos distance _lastpos)>700)&&(PG_get(TRACKING))) then {
		_cam camSetPos [(_lastpos select 0) - 200*sin(_dir), (_lastpos select 1)-200*cos(_dir), (_lastpos select 2) + sin(45)*200];
		_cam camCommit 5;
		_cam camSetTarget _lastpos;
		_endTime = time + 5;
		while {PG_get(TRACKING)&&(time<_endtime)} do {sleep .1};
	};

	_cam cameraeffect ["terminate", "back"];
	camDestroy _cam;
	PG_set(TRACKING,false);
	(findDisplay 46) displayRemoveEventHandler ["KeyDown",_interrupt];

};

_trackMarker = {
	_bullet = _this;
	_startpos = getPos _bullet;
	_lastpos = getPos _bullet;
	sleep .01;

	_markerName = "PG_hitmarker" + str(_lastpos)+str(random 100000);
	createMarkerLocal [_markerName,_lastpos];
	_markerName setMarkerTypeLocal "mil_dot";
	_markerName setMarkerColorLocal "ColorRed";
	//_markerName setMarkerSizeLocal [.3,.3];
	_markerName setMarkerAlphaLocal 1;
	PG_set(hitmarkers,PG_get(hitmarkers)+[_markerName]);


	while {!(isNull _bullet)} do {;
		_markerName setMarkerPosLocal getPosASL _bullet;
		sleep 0.01;
	};
};

//////////////////
_bullet = if ((count _this)>6) then {
	_this select 6;
}else{
	nearestObject [_veh, _ammo];
};

if (PG_get(bulletcam)) then {
	_bullet spawn _trackCam;
};

if (PG_get(hitmarker)) then {
	_bullet spawn _trackMarker;
};

