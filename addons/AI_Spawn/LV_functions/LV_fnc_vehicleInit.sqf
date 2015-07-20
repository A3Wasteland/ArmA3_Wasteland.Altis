//ARMA3Alpha function LV_fnc_vehicleInit v0.2 - by SPUn / lostvar
//Function to set custom init commands for units
//Call this from another scripts with syntax:
//[_unit,_customInit] spawn LV_vehicleInit;
//
//Make sure _customInit is in format:
//"init command '1'; init command '2';"
//-Every init command MUST be ended in semicolon!
//-Keep it inside quotes, and if you need quotes in init commands, you MUST use ' or "" instead of "


private["_unit","_customInit","_array0","_num","_globalUnit"];
_unit = _this select 0;
_customInit = _this select 1;

_array0 = toArray(str(_customInit));
_globalUnit = false;
_num = 0;
_scolons = 0;
_commandms = [];
for [{_i=1}, {_i<(count _array0)}, {_i=_i+1}] do{
	if(((_array0 select _i) == 116)&&((count _array0)>(_i+3)))then{ 
	   if((_i > 0)&&((_array0 select (_i-1)) == 95))then{
	     _commandms set[(count _commandms), (_array0 select _i)];
	   }else{
		if(((_array0 select (_i+1)) == 104)&&((_array0 select (_i+2)) == 105)&&((_array0 select (_i+3)) == 115))then{
			if(!_globalUnit)then{
				while{!(isNil("LVVIUID"+(str _num)))}do{
					_num = _num + 1;
				};
				call compile format ["LVVIUID%1 = _unit",_num];
			};
			
			_unArr = toArray("LVVIUID"+(str _num));
			_a = 0;
			while {_a < (count _unArr) }do{
				_commandms set[(count _commandms), (_unArr select _a)];
				_a = _a + 1;
			};
			_globalUnit = true;
			_i = _i + 3;
		}else{
			_commandms set[(count _commandms), (_array0 select _i)];
		};
	   };
	}else{
		_commandms set[(count _commandms), (_array0 select _i)];
	};
	
    if((_array0 select _i) == 59)then{
		_scolons = _scolons + 1;
		[toString(_commandms)] call {
			_cmd = _this select 0;
			//hint format["%1",_cmd];
			call compile format["%1",_cmd];
		};
		_commandms = [];
	};
};

if(_globalUnit)then{
	call compile format ["LVVIUID%1 = nil",_num];
};
