//ARMA3Alpha function LV_fnc_AIcommunication v0.1 - by SPUn / lostvar
//Makes AI communicate via reveal command with other same sided groups
//NOTE: This is just ugly brain fart, there must be a simplier way to do all this
//Next version will use nearObjects, so all groups in one array will inform same side groups about enemies,
//	not just enemies in some array. But until I find some time to work on it, I'll leave this one here.
private["_i","_i2","_wGroup","_eGroup","_temp1","_temp2"];
while{true}do{
	_i = 0;
	while{_i < (count LV_AI_westGroups)}do{
		_i2 = 0;
		_wGroup = LV_AI_westGroups select _i;
		while{_i2 < (count LV_AI_eastGroups)}do{
			_eGroup = LV_AI_eastGroups select _i2;
			{
				if((_wGroup knowsAbout _x) > 1)then{
					_temp1 = _x;
					//hint "WEST SPOTTED EAST";
					{
						if(count (units _x) > 0)then{
							if((_x knowsAbout _temp1)<0.5)then{
								_x reveal [_temp1, 1.6];
								//hint format["WEST GROUP INFORMS %1",_x];
							};
							sleep 2;
						};
					}forEach LV_AI_westGroups;
				};
			}forEach units _eGroup;
			
			{
				if((_eGroup knowsAbout _x) > 1)then{
					_temp2 = _x;
					//hint "EAST SPOTTED WEST";
					{
						if(count (units _x) > 0)then{
							if((_x knowsAbout _temp2)<0.5)then{
								_x reveal [_temp2, 1.6];
								//hint format["EAST GROUP INFORMS %1",_x];
							};
							sleep 2;
						};
					}forEach LV_AI_eastGroups;
				};
			}forEach units _wGroup;
			
			_i2 = _i2 + 1;
			//sleep 4;
		};
		_i = _i + 1;
		//sleep 2;
	};
	sleep 6;
};