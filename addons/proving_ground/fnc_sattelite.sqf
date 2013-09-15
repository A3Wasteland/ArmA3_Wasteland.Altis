#include "defs.hpp"
_pos = _this select 0;
_pos = [_pos select 0,_pos select 1,-(_pos select 2)];
disableSerialization;

showCinemaBorder false;
_cam = "camera" camCreate [_pos select 0,_pos select 1,200];
_cam cameraeffect ["External", "Top"];

_dir = 0;
_pitch = -89;
_fov = 0.7;
_cam camSetFov 0.7;
_cam setVectorDirAndUp [[sin(_dir)*cos(_pitch),cos(_dir)*cos(_pitch),sin(_pitch)],[-sin(_dir)*sin(_pitch), -cos(_dir)*sin(_pitch), -cos(_pitch)]];

//titleText["WASD - move, Arrows - rotate, Num-/Num+ - zoom, V - NV, N - normal view, Q - exit","plain down"];
_keyhandler = (findDisplay 46) displayAddEventHandler ["KeyDown", "_this call c_proving_ground_satcam_keyhandler"];
GVAR(balca_satcam) = [_cam,_keyhandler,[_pos select 0,_pos select 1,200],[_dir,_pitch,_fov]];
GVAR(balca_satcam_mouseHandlerId) = (findDisplay 46) displayAddEventHandler ["MouseMoving", "_this call c_proving_ground_balca_satcam_MouseMovingHandler"];
GVAR(balca_satcam_MouseMovingHandler) = {
	_display = _this select 0;
	_dx = _this select 1;
	_dy = _this select 2;

	_balca_satcam = GVAR(balca_satcam);
	_cam = _balca_satcam select 0;
	_keyhandler = _balca_satcam select 1;
	_campos = _balca_satcam select 2;
	_dir = (_balca_satcam select 3) select 0;
	_pitch = (_balca_satcam select 3) select 1;
	_fov = (_balca_satcam select 3) select 2;
	_pitch = (_pitch - _dy) min 89 max -89;
	_dir = (_dir + _dx)%360;
	_cam setVectorDirAndUp [[sin(_dir)*cos(_pitch),cos(_dir)*cos(_pitch),sin(_pitch)],[-sin(_dir)*sin(_pitch), -cos(_dir)*sin(_pitch), -cos(_pitch)]];
	_cam camCommit 0.01;
	GVAR(balca_satcam) = [_cam,_keyhandler,_campos,[_dir,_pitch,_fov]];
};
