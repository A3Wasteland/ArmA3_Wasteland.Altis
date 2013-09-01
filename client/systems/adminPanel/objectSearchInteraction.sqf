// objectSearchInteraction

#define objectSearchDialog 55600
#define objectSearchFindButton 55601
#define objectSearchFindTexteditBox 55602
#define objectSearchObjectList 55603
#define objectSearchTeleportButton 55604
#define objectSearchCancelButton 55605

#define OBJECT_SEARCH_ACTION_FIND 0
#define OBJECT_SEARCH_ACTION_TELEPORT 1
#define OBJECT_SEARCH_ACTION_DISMISS 2

disableSerialization;

private ["_uid"];

_uid = getPlayerUID player;
if ((_uid in moderators) OR (_uid in administrators) OR (_uid in serverAdministrators)) then {
	_dialog = createDialog "ObjectSearch";
	_display = findDisplay objectSearchDialog;
	_objectSearchTerm = _dialog displayCtrl objectSearchFindTexteditBox;
	_objectListBox = _dialog displayCtrl objectSearchObjectList;
	
	_switch = _this select 0;



	_index = lbCurSel _objectListBox;
	_positionData = _objectListBox lbData _index;
	
	if (_check == 0) exitWith{};
	
	switch (_switch) do
	{
	    case OBJECT_SEARCH_ACTION_FIND:
		{
			if (!isNil "_target") then
			{
				_spectating = ctrlText _spectateButton;
				if (_spectating == "Spectate") then {
					_spectateButton ctrlSetText "Spectating";
					//player commandChat format ["Viewing %1.", name _target];
					
					if (!isNil "_camadm") then { camDestroy _camadm; };
					_camadm = "camera" camCreate ([(position vehicle _target select 0) - 5,(position vehicle _target select 1), (position vehicle _target select 2) + 10]);
					_camadm cameraEffect ["external", "TOP"];
					_camadm camSetTarget (vehicle _target);
					_camadm camCommit 1;
								
					_rnum = 0;
					while {ctrlText _spectateButton == "Spectating"} do {
						switch (_rnum) do 
						{
							if (daytime > 19 || daytime < 5) then {camUseNVG true;} else {camUseNVG false;};
							case 0: {detach _camadm; _camadm attachTo [(vehicle _target), [0,-10,4]]; _camadm setVectorUp [0, 1, 5];}; 
							case 1: {detach _camadm; _camadm attachTo [(vehicle _target), [0,10,4]]; _camadm setDir 180; _camadm setVectorUp [0, 1, -5];};
							case 2: {detach _camadm; _camadm attachTo [(vehicle _target), [0,1,50]]; _camadm setVectorUp [0, 50, 1];};
							case 3: {detach _camadm; _camadm attachTo [(vehicle _target), [-10,0,2]]; _camadm setDir 90; _camadm setVectorUp [0, 1, 5];};
							case 4: {detach _camadm; _camadm attachTo [(vehicle _target), [10,0,2]]; _camadm setDir -90; _camadm setVectorUp [0, 1, -5];};                                                                        
						};
						player commandchat "Viewing cam " + str(_rnum) + " on " + str(name vehicle _target);
						_rnum = _rnum + 1;
						if (_rnum > 4) then {_rnum = 0;};
						sleep 5;
					};
				} else {
					_spectateButton ctrlSetText "Spectate";
					player commandchat format ["No Longer Viewing.", name _target];
					player cameraEffect ["terminate","back"];
					if (!isNil "_camadm") then { camDestroy _camadm; };
				};
			};
		};
		case 1: //Warn
		{
			_warnText = ctrlText _warnMessage;
	        _playerName = name player;
			[format ["Message from Admin: %1", _warnText], "titleTextMessage", _target, false] call TPG_fnc_MP;
		};
	    case 2: //Slay
	    {
			[{player setDamage 1; endMission "LOSER"; deleteVehicle player}, "BIS_fnc_spawn", _target, false] call TPG_fnc_MP;
	    };
	    case 3: //Unlock Team Switcher
	    {      
			_targetUID = getPlayerUID _target;
	        {
			    if(_x select 0 == _targetUID) then
			    {
			    	pvar_teamSwitchList = [pvar_teamSwitchList, _forEachIndex] call BIS_fnc_removeIndex;
			        publicVariable "pvar_teamSwitchList";
	                
					[{client_firstSpawn = nil}, "BIS_fnc_spawn", _target, false] call TPG_fnc_MP;
			    };
			}forEach pvar_teamSwitchList;			
	    };
		case 4: //Unlock Team Killer
	    {      
			_targetUID = getPlayerUID _target;
	        {
			    if(_x select 0 == _targetUID) then
			    {
			    	pvar_teamKillList = [pvar_teamKillList, _forEachIndex] call BIS_fnc_removeIndex;
			        publicVariable "pvar_teamKillList";
			    };
			}forEach pvar_teamKillList;       		
	    };
        case 5: //Remove All Money
	    {      
			_targetUID = getPlayerUID _target;
	        {
			    if(getPlayerUID _x == _targetUID) exitWith
			    {
  					_x setVariable["cmoney",0,true];
			    };
			}forEach playableUnits;       		
	    };
        case 6: //Remove All Weapons
	    {      
			_targetUID = getPlayerUID _target;
	        {
			    if(getPlayerUID _x == _targetUID) exitWith
			    {
  					removeAllWeapons _x;
			    };
			}forEach playableUnits;       		
	    };
        case 7: //Check Player Gear
	    {      
			_targetUID = getPlayerUID _target;
	        {
			    if(getPlayerUID _x == _targetUID) exitWith
			    {
  					createGearDialog [_x, "RscDisplayInventory"];
			    };
			}forEach playableUnits;        		
	    };
	};
};
