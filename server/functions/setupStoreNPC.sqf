//	@file Version: 1.0
//	@file Name: setupStoreNPC.sqf
//	@file Author: AgentRev
//	@file Created: 12/10/2013 12:36
//	@file Args:

#define STORE_ACTION_CONDITION "_this distance _target < 3"
#define SELL_ACTION_CONDITION "{_obj = missionNamespace getVariable ['R3F_LOG_joueur_deplace_objet', objNull]; _obj isKindOf 'ReammoBox_F' || {_obj isKindOf 'AllVehicles'}}"
#define SELL_BOX_ACTION_CONDITION "cursorTarget == _target"

private ["_npc", "_type", "_num", "_npcName"];

_npc = _this select 0;
_type = _this select 1;
_num = _this select 2;

if (hasInterface) then
{
	switch (toLower _type) do
	{
		case "genstore":
		{
			_npc addAction ["<img image='client\icons\store.paa'/> Open General Store", "client\systems\generalStore\loadGenStore.sqf", [], 1, false, false, "", STORE_ACTION_CONDITION];
		};
		case "gunstore":
		{
			_npc addAction ["<img image='client\icons\store.paa'/> Open Gun Store", "client\systems\gunStore\loadgunStore.sqf", [], 1, false, false, "", STORE_ACTION_CONDITION];
		};
		case "vehstore":
		{
			_npc addAction ["<img image='client\icons\store.paa'/> Open Vehicle Store", "client\systems\vehicleStore\loadVehicleStore.sqf", [], 1, false, false, "", STORE_ACTION_CONDITION];
		};
	};

	_npc addAction ["<img image='client\icons\money.paa'/> Sell contents", "client\systems\selling\sellCrateItems.sqf", [], 1, false, false, "", STORE_ACTION_CONDITION + " && " + SELL_ACTION_CONDITION];
};

_npcName = format ["%1%2", _type, _num];
_npc setName _npcName;

_npc allowDamage false;
{ _npc disableAI _x } forEach ["MOVE","FSM","TARGET","AUTOTARGET"];

_building = nearestBuilding _npc;

// Prevent structural damage, but allow shooting breakable stuff
_building addEventHandler ["HandleDamage",
{
	_selection = _this select 1;
	_damage = _this select 2;

	_selArray = toArray _selection;
	_selArray resize 4;

	if ((toString _selArray) in ["","dam_"]) then
	{
		0
	}
	else
	{
		_damage
	};
}];

if (isServer) then
{
	removeAllWeapons _npc;
	
	waitUntil {!isNil "storeConfigDone"};
	
	{
		if (_x select 0 == _npcName) exitWith
		{
			//collect our arguments
			_npcPos = _x select 1;
			_deskDirMod = _x select 2;

			private "_storeOwnerAppearance";
				
			{
				if (_x select 0 == _npcName) exitWith
				{
					_storeOwnerAppearance = _x;
				};
			} forEach (call storeOwnerConfigAppearance);

			{
				_type = _x select 0;
				_classname = _x select 1;

				switch (_type) do
				{
					case "weapon":
					{
						if (_classname != "") then
						{
							diag_log format ["Applying %1 as weapon for %2", _classname, _npcName];
							_npc addWeapon _classname;
						};
					};
					case "uniform":
					{
						if (_classname != "") then
						{
							diag_log format ["Applying %1 as uniform for %2", _classname, _npcName];
							_npc addUniform _classname;
						};
					};
					case "switchMove":
					{
						if (_classname != "") then
						{
							diag_log format ["Applying %1 as switchMove for %2", _classname, _npcName];
							_npc switchMove _classname;
						};
					};
				};
			} forEach (_storeOwnerAppearance select 1); 

			_pDir = getDir _npc;
			
			private "_bPos";
			switch (toUpper typeName _npcPos) do
			{
				case "SCALAR":
				{
					_bPos = _building buildingPos _npcPos;
				};
				case "ARRAY":
				{
					_bPos = _npcPos;
				};
			};
			
			_bPos = _building buildingPos _npcPos;

			if ([_bPos, [0,0,0]] call BIS_fnc_areEqual) then
			{
				_bPos = getPosATL _npc;
			}
			else
			{
				_npc setPosATL _bPos;
			};

			_desk = [_npc, _bPos, _pDir, _deskDirMod] call compile preprocessFileLineNumbers "server\functions\createStoreFurniture.sqf";
			
			sleep 1;
			
			_bbNPC = boundingBoxReal _npc;
			_bbDesk = boundingBoxReal _desk;
			_bcNPC = boundingCenter _npc;
			_bcDesk = boundingCenter _desk;
			
			_npcHeightRel = (_desk worldToModel (getPosATL _npc)) select 2;
			
			// must be done twice for the direction to set properly
			for "_i" from 1 to 2 do
			{
				_npc attachTo
				[
					_desk,
					[
						0,
						
						((_bcNPC select 1) - (_bcDesk select 1)) +
						((_bbNPC select 1 select 1) - (_bcNPC select 1)) - 
						((_bbDesk select 1 select 1) - (_bcDesk select 1)) + 0.1,
						
						_npcHeightRel
					]
				];
				_npc setDir 180;
			};
			
			detach _npc;
			sleep 1;
			
			_npc enableSimulation false;
			_desk enableSimulation false;
		};

	} forEach (call storeOwnerConfig);
};

// Add sell box in front of counter
if (hasInterface) then
{
	_objs = nearestObjects [_npc, ["Land_CashDesk_F"], 5];

	if (count _objs > 0) then
	{
		_desk = _objs select 0;

		_sellBox = "Box_IND_Ammo_F" createVehicleLocal getPosATL _desk;
		_sellBox setVariable ["R3F_LOG_disabled", true];
		_sellBox setVariable ["A3W_storeSellBox", true];
		_sellBox setObjectTexture [0, ""]; // remove side marking
		_sellBox allowDamage false;

		clearBackpackCargo _sellBox;
		clearMagazineCargo _sellBox;
		clearWeaponCargo _sellBox;
		clearItemCargo _sellBox;

		_sellBox setPosASL ((getPosASL _desk) vectorAdd ([[-0.05,-0.6,0], -(getDir _desk)] call BIS_fnc_rotateVector2D));
		_sellBox setDir (getDir _desk + 90);

		_sellBox addAction ["<img image='client\icons\money.paa'/> Sell crate contents", "client\systems\selling\sellCrateItems.sqf", [true], 1, false, false, "", STORE_ACTION_CONDITION + " && " + SELL_BOX_ACTION_CONDITION];

		_sellBox spawn
		{
			_sellBox = _this;
			_boxPos = getPosATL _sellBox;
			_boxVecDir = vectorDir _sellBox;
			_boxVecUp = vectorUp _sellBox;

			while {!isNull _sellBox} do
			{
				sleep 5;
				if ((getPosATL _sellBox) vectorDistance _boxPos > 0.05 || (vectorDir _sellBox) vectorDistance _boxVecDir > 0.05) then
				{
					_sellBox setPosATL _boxPos;
					_sellBox setVectorDirAndUp [_boxVecDir, _boxVecUp];
				};
			};
		};
	};
};
