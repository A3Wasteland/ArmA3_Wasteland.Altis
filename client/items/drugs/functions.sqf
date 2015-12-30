// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: functions.sqf
//@file Author: micovery
//@file Description: Drug effects

drug_lsd_effects = { _this spawn {
  private["_player", "_duration"];
  _player = _this select 0;
  _duration = _this select 1;


  private["_effect1","_effect2"];
  _effect1 = ppEffectCreate ["WetDistortion",300];
  _effect1 ppEffectEnable true;
  _effect1 ppEffectAdjust [0.5,1,1,4.1,3.7,2.5,1.85,0.0051,0.0051,0.0051,0.0051,0.5,0.3,10,6.0];
  _effect1 ppEffectCommit 5;
  
  _effect2 = ppEffectCreate ["chromAberration",200];
  _effect2 ppEffectEnable true;
  _effect2 ppEffectAdjust [0.2,0.2,true];
  _effect2 ppEffectCommit 1;
  
  
   private["_ps1"];
  _ps1 = "#particlesource" createVehicleLocal getPos _player;
  _ps1 setParticleCircle [0,[0,0,0]];
  
  _ps1 setParticleRandom [0,[2,2,2],[0.2,0.2,3],1, 3,[0,0,0,0],0.01,0.03];
  _ps1 setParticleParams ["\a3\animals_f\butterfly","","SpaceObject",1,5,[0,0,-0.5],[0,0,0],0,1.275,1,0,[1,1],[[0,1,0 ,1],[0,1,0 ,1],[0,1,0 ,1]],[0,0],0,0,"","",_player];
  
  _ps1 setDropInterval 0.35;
	  
    
  playMusic ["LeadTrack03_F_Bootcamp", 0];
  
  _duration = _duration/2;
  private["_timeout"];
  _timeout = time + _duration;
  waitUntil {
    private["_position","_weite"];
    _position = getPos _player;
    _weite = 100;
    
    private["_x","_y","_z"];
    _x = _position select 0;
    _y = _position select 1;
    _z = _position select 2;
    
    private["_w1","_w2","_w3"];
    _w1 = (random _weite) - (random _weite);
    _w2 = (random _weite) - (random _weite);
    _w3 = random 7;
    
    private["_f1","_f2","_f3"];
    _f1 = random 1;
    _f2 = random 1;
    _f3 = random 1;
    
    private["_g1","_g2","_g3"];
    _g1 = random 5;
    _g2 = random 10;
    _g3 = random 5;
      
    private["_v1","_v2","_v3"];
    _v1 = random 0.05;
    _v2 = random 0.05;
    _v3 = 0.1 - random 0.075;
    private["_index"];
    _index = [1,6,7,8,13] select floor(random 5);
    drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,12,_index,0], "","Billboard",1,_duration,[_x + _w1,_y + _w2,_z + _w3],[_v1,_v2,_v3],1,1.275,1,0,[_g1,_g2,_g3],[ [_f1,_f2,_f3,1],[_f2,_f1,_f3,1],[_f3,_f2,_f1,1] ],[1000],3,0.2,"","",""];
    
    sleep 0.05;
    (time > _timeout)
  };
  
  sleep _duration;
  playMusic "";
  ppEffectDestroy _effect1;
  ppEffectDestroy _effect2;
  deleteVehicle _ps1;

};};


drug_marijuana_effects = { _this spawn {
  private["_player", "_duration"];
  _player = _this select 0;
  _duration = _this select 1;

  
  private["_shell"];
  _shell = "SmokeShellGreen" createVehicleLocal position _player;
  _shell attachTo [(vehicle _player),[0,0,0]];

  private["_effect1","_effect2"];
  _effect1 = ppEffectCreate ["colorCorrections",1501];
  _effect1 ppEffectEnable true;
  
  _effect2 = ppEffectCreate ["chromAberration",200];
  _effect2 ppEffectEnable true;
  
  
  private["_ps1"];
  _ps1 = "#particlesource" createVehicleLocal getPos _player;
  _ps1 setParticleCircle [0,[0,0,0]];
  
  _ps1 setParticleRandom [0,[2,2,2],[0.2,0.2,3],1, 3,[0,0,0,0],0.01,0.03];
  _ps1 setParticleParams ["\a3\animals_f\butterfly","","SpaceObject",1,5,[0,0,-0.5],[0,0,0],0,1.275,1,0,[1,1],[[0,1,0 ,1],[0,1,0 ,1],[0,1,0 ,1]],[0,0],0,0,"","",_player];
  
  _ps1 setDropInterval 0.35;
  
  playMusic ["defcon", 0]; 
  enableEnvironment  false;
  
  _player enableFatigue true;
  private["_timeout"];
  _timeout = time + _duration;

  waitUntil {
    _effect1 ppEffectAdjust [1,1,0,[0,0,0,0.5],[0.9 + (random 10)/100, 0.60 + (random 20)/100, 0.15 + (random 10)/100, random 1], [0.5 +(random 40)/100, 0.75 + (random 10)/100, 0.01 + (random 10)/100, random 1]];
    _effect1 ppEffectCommit 1;
    
    _effect2 ppEffectAdjust [0.01,0.01,true];
    _effect2 ppEffectCommit 1;
    _player setFatigue 1;
    
    (random 3) fadeMusic (random 1);
    sleep 3;
    (time > _timeout)
  };
  
  _player setFatigue 0;
  _player enableFatigue false;
  enableEnvironment true;
  playMusic "";
  deleteVehicle _shell;
  ppEffectDestroy _effect1;
  ppEffectDestroy _effect2;
  deleteVehicle _ps1;
};};

drug_cocaine_effects = { _this spawn {
  private["_player", "_duration"];
  _player = _this select 0;
  _duration = _this select 1;

  
  private["_effect1","_force"];
  _effect1 = ppEffectCreate ["chromAberration",200];
  _effect1 ppEffectEnable true;
  
  playMusic ["BackgroundTrack03_F", 0];
  
  
  private["_timeout"];
  _timeout = time + _duration;
  waitUntil {
    _force = random 10;
    _effect1 ppEffectAdjust [_force / 24,_force / 24,false];
    _effect1 ppEffectCommit (0.3 + random 0.1);
    waituntil {ppEffectCommitted _effect1};
    (time > _timeout)
  };
  
  playMusic "";
  ppEffectDestroy _effect1;
};};


    
drug_heroin_effects = { _this spawn {
  private["_player", "_duration"];
  _player = _this select 0;
  _duration = _this select 1;

  

  private["_effect1","_effect2"];
  _effect1 = ppEffectCreate ["RadialBlur",37];
  _effect1 ppEffectEnable true;
  
  _effect2 = ppEffectCreate ["chromAberration",200];
  _effect2 ppEffectEnable true;
  
  playMusic ["LeadTrack03a_F_EPB", 0];
  _player enableFatigue true;
  
  private["_timeout"];
  _timeout = time + _duration;
  waitUntil {

    _effect2 ppEffectAdjust [random 0.1,random 0.1,true];
    _effect2 ppEffectCommit 3;
	_player setFatigue 1;
    
    3 setFog (random 1);
    if ((random 100) < 5) then {
      waituntil {
        addCamShake [random 10,random 1,random 3];
        ppEffectCommitted _effect2
      };
    };
    (time > _timeout)
  };
  
  3 setFog 0;
  playMusic "";
  _player setFatigue 0;
  _player enableFatigue false;
  ppEffectDestroy _effect1;
  ppEffectDestroy _effect2;
};};


