#include "defs.hpp"
private ["_event","_keyCode","_shift","_control","_alt"];
private["_handled","_ctrl", "_dikCode", "_shift", "_ctrlKey", "_alt"];
_ctrl = _this select 0;
_dikCode = _this select 1;
_shift = _this select 2;
_ctrlKey = _this select 3;
_alt = _this select 4;
_handled = false;

_balca_satcam = GVAR(balca_satcam);
_cam = _balca_satcam select 0;
_keyhandler = _balca_satcam select 1;
_campos = _balca_satcam select 2;
_dir = (_balca_satcam select 3) select 0;
_pitch = (_balca_satcam select 3) select 1;
_fov = (_balca_satcam select 3) select 2;
switch (_dikCode) do {
	case 17:{	//W
		_newpos = [(_campos select 0) + sin(_dir)*(_campos select 2)/4,(_campos select 1) + cos(_dir)*(_campos select 2)/4,_campos select 2];
		_cam camSetPos _newpos;
		_cam camCommit 0.1;
		GVAR(balca_satcam) = [_cam,_keyhandler,_newpos,[_dir,_pitch,_fov]];
		};
	case 31:{	//S
		_newpos = [(_campos select 0) - sin(_dir)*(_campos select 2)/4,(_campos select 1) - cos(_dir)*(_campos select 2)/4,_campos select 2];
		_cam camSetPos _newpos;
		_cam camCommit 0.1;
		GVAR(balca_satcam) = [_cam,_keyhandler,_newpos,[_dir,_pitch,_fov]];
		};
	case 30:{	//A
		_newpos = [(_campos select 0) + sin(_dir-90)*(_campos select 2)/4,(_campos select 1) + cos(_dir-90)*(_campos select 2)/4,_campos select 2];
		_cam camSetPos _newpos;
		_cam camCommit 0.1;
		GVAR(balca_satcam) = [_cam,_keyhandler,_newpos,[_dir,_pitch,_fov]];
		};
	case 32:{	//D
		_newpos = [(_campos select 0) + sin(_dir+90)*(_campos select 2)/4,(_campos select 1) + cos(_dir+90)*(_campos select 2)/4,_campos select 2];
		_cam camSetPos _newpos;
		_cam camCommit 0.1;
		GVAR(balca_satcam) = [_cam,_keyhandler,_newpos,[_dir,_pitch,_fov]];
		};
	case 200:{	//up
		_pitch = (_pitch + 1) min 89;
		_cam setVectorDirAndUp [[sin(_dir)*cos(_pitch),cos(_dir)*cos(_pitch),sin(_pitch)],[-sin(_dir)*sin(_pitch), -cos(_dir)*sin(_pitch), -cos(_pitch)]];
		_cam camCommit 0.1;
		GVAR(balca_satcam) = [_cam,_keyhandler,_campos,[_dir,_pitch,_fov]];
		};
	case 208:{	//down
		_pitch = (_pitch - 1) max -89;
		_cam setVectorDirAndUp [[sin(_dir)*cos(_pitch),cos(_dir)*cos(_pitch),sin(_pitch)],[-sin(_dir)*sin(_pitch), -cos(_dir)*sin(_pitch), -cos(_pitch)]];
		_cam camCommit 0.1;
		GVAR(balca_satcam) = [_cam,_keyhandler,_campos,[_dir,_pitch,_fov]];
		};
	case 203:{	//left
		_dir = (_dir - 1);
		_cam setVectorDirAndUp [[sin(_dir)*cos(_pitch),cos(_dir)*cos(_pitch),sin(_pitch)],[-sin(_dir)*sin(_pitch), -cos(_dir)*sin(_pitch), -cos(_pitch)]];
		_cam camCommit 0.1;
		GVAR(balca_satcam) = [_cam,_keyhandler,_campos,[_dir,_pitch,_fov]];
		};
	case 205:{	//right
		_dir = (_dir + 1);
		_cam setVectorDirAndUp [[sin(_dir)*cos(_pitch),cos(_dir)*cos(_pitch),sin(_pitch)],[-sin(_dir)*sin(_pitch), -cos(_dir)*sin(_pitch), -cos(_pitch)]];
		_cam camCommit 0.1;
		GVAR(balca_satcam) = [_cam,_keyhandler,_campos,[_dir,_pitch,_fov]];
		};
	case 16:{	//Q
		_newpos = [(_campos select 0),(_campos select 1),(((_campos select 2)*1.1) min 2000)];
		_cam camSetPos _newpos;
		_cam camCommit 0.1;
		GVAR(balca_satcam) = [_cam,_keyhandler,_newpos,[_dir,_pitch,_fov]];
		};
	case 44:{	//Z
		_newpos = [(_campos select 0),(_campos select 1),(((_campos select 2)/1.1) max 2)];
		_cam camSetPos _newpos;
		_cam camCommit 0.1;
		GVAR(balca_satcam) = [_cam,_keyhandler,_newpos,[_dir,_pitch,_fov]];
		};
/*	case 78:{	//Num +
		_fov = _fov*1.1;
		_cam camSetFov _fov;
		_cam camCommit 0.1;
		GVAR(balca_satcam) = [_cam,_keyhandler,_campos,[_dir,_pitch,_fov]];
		};
	case 74:{	//Num -
		_fov = _fov/1.1;
		_cam camSetFov _fov;
		_cam camCommit 0.1;
		GVAR(balca_satcam) = [_cam,_keyhandler,_campos,[_dir,_pitch,_fov]];
		};*/
	case 20:{	//T white is hot
		ppEffectDestroy ppColor;
		ppEffectDestroy ppInversion;
		ppEffectDestroy ppGrain;

		true setCamUseTi 0;
		camUseNVG false;
	};
	case 49:{	//N normal view
		ppEffectDestroy ppColor;
		ppEffectDestroy ppInversion;
		ppEffectDestroy ppGrain;

		false setCamUseTi 0;
		false setCamUseTi 1;
		camUseNVG false;

		ppGrain = ppEffectCreate ["filmGrain", 2005];
		ppGrain ppEffectEnable true;
		ppGrain ppEffectAdjust [0.02, 1, 1, 0, 1];
		ppGrain ppEffectCommit 0;
	};
	case 19:{	//R black is hot
		ppEffectDestroy ppColor;
		ppEffectDestroy ppInversion;
		ppEffectDestroy ppGrain;

		true setCamUseTi 1;
		camUseNVG false;
	};
	case 47:{	//V night vision
		ppEffectDestroy ppColor;
		ppEffectDestroy ppInversion;
		ppEffectDestroy ppGrain;

		false setCamUseTi 0;
		false setCamUseTi 1;
		camUseNVG true;
	};
	case 1:{	//Esc
		ppEffectDestroy ppColor;
		ppEffectDestroy ppInversion;
		ppEffectDestroy ppGrain;

		false setCamUseTi 0;
		false setCamUseTi 1;
		camUseNVG false;
		(findDisplay 46) displayRemoveEventHandler ["KeyDown",_keyhandler];
		(findDisplay 46) displayRemoveEventHandler ["MouseMoving",GVAR(balca_satcam_mouseHandlerId)];
		GVAR(balca_satcam) = nil;
		_cam cameraEffect ["terminate","back"];
		camDestroy _cam;
	};
	default {
		//titleText["WASD - move, Q/Z - altitude, V - NV, N - normal view","plain down"];
	};
};//end switch
