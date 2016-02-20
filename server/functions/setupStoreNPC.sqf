// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: setupStoreNPC.sqf
//	@file Author: AgentRev
//	@file Created: 12/10/2013 12:36
//	@file Args:

#define STORE_ACTION_CONDITION "(player distance _target < 3)"
#define SELL_CRATE_CONDITION "(!isNil 'R3F_LOG_joueur_deplace_objet' && {R3F_LOG_joueur_deplace_objet isKindOf 'ReammoBox_F'})"
#define SELL_CONTENTS_CONDITION "(!isNil 'R3F_LOG_joueur_deplace_objet' && {{R3F_LOG_joueur_deplace_objet isKindOf _x} count ['ReammoBox_F','AllVehicles'] > 0})"
#define SELL_VEH_CONTENTS_CONDITION "{!isNull objectFromNetId (player getVariable ['lastVehicleRidden', ''])}"
#define SELL_BIN_CONDITION "(cursorTarget == _target)"

private ["_npc", "_npcName", "_startsWith", "_building"];

_npc = _this select 0;
_npcName = vehicleVarName _npc;
_npc setName [_npcName,"",""];

_npc allowDamage false;
{ _npc disableAI _x } forEach ["MOVE","FSM","TARGET","AUTOTARGET"];

if (hasInterface) then
{
	_startsWith =
	{
		private ["_needle", "_testArr"];
		_needle = _this select 0;
		_testArr = toArray (_this select 1);
		_testArr resize count toArray _needle;
		(toString _testArr == _needle)
	};

	switch (true) do
	{
		case (["GenStore", _npcName] call _startsWith):
		{
			_npc addAction ["<img image='client\icons\store.paa'/> Open General Store", "client\systems\generalStore\loadGenStore.sqf", [], 1, true, true, "", STORE_ACTION_CONDITION];
		};
		case (["GunStore", _npcName] call _startsWith):
		{
			_npc addAction ["<img image='client\icons\store.paa'/> Open Gun Store", "client\systems\gunStore\loadgunStore.sqf", [], 1, true, true, "", STORE_ACTION_CONDITION];
		};
		case (["VehStore", _npcName] call _startsWith):
		{
			_npc addAction ["<img image='client\icons\store.paa'/> Open Vehicle Store", "client\systems\vehicleStore\loadVehicleStore.sqf", [], 1, true, true, "", STORE_ACTION_CONDITION];
		};
	};

	_npc addAction ["<img image='client\icons\money.paa'/> Sell crate", "client\systems\selling\sellCrateItems.sqf", [false, false, true], 0.99, false, true, "", STORE_ACTION_CONDITION + " && " + SELL_CRATE_CONDITION];
	_npc addAction ["<img image='client\icons\money.paa'/> Sell contents", "client\systems\selling\sellCrateItems.sqf", [], 0.98, false, true, "", STORE_ACTION_CONDITION + " && " + SELL_CONTENTS_CONDITION];
	_npc addAction ["<img image='client\icons\money.paa'/> Sell last vehicle contents", "client\systems\selling\sellVehicleItems.sqf", [], 0.97, false, true, "", STORE_ACTION_CONDITION + " && " + SELL_VEH_CONTENTS_CONDITION];
};

if (isServer) then
{
	// nearestBuilding no longer detects barracks since A3 v1.42, so we need this shitty workaround
	_building = (_npc modelToWorld [0,0,0]) nearestObject "House";
	if !(_building isKindOf "Land_i_Barracks_V1_F") then { _building = nearestBuilding _npc };

	_npc setVariable ["storeNPC_nearestBuilding", netId _building, true];

	_facesCfg = configFile >> "CfgFaces" >> "Man_A3";
	_faces = [];

	for "_i" from 0 to (count _facesCfg - 1) do
	{
		_faceCfg = _facesCfg select _i;

		_faceTex = toArray getText (_faceCfg >> "texture");
		_faceTex resize 1;
		_faceTex = toString _faceTex;

		if (_faceTex == "\") then
		{
			_faces pushBack configName _faceCfg;
		};
	};

	_face = _faces call BIS_fnc_selectRandom;
	_npc setFace _face;
	_npc setVariable ["storeNPC_face", _face, true];
}
else
{
	private "_nearestBuilding";

	waitUntil
	{
		sleep 0.1;
		_nearestBuilding = _npc getVariable "storeNPC_nearestBuilding";
		!isNil "_nearestBuilding"
	};

	_building = objectFromNetId _nearestBuilding;
};

if (isNil "_building" || {isNull _building}) then
{
	_building = (_npc modelToWorld [0,0,0]) nearestObject "House";
	if !(_building isKindOf "Land_i_Barracks_V1_F") then { _building = nearestBuilding _npc };
};

_building allowDamage true;
for "_i" from 1 to 99 do { _building setHit ["glass_" + str _i, 1] }; // pre-break the windows so people can shoot thru them
_building allowDamage false; // disable building damage

if (isServer) then
{
	removeAllWeapons _npc;
	_createStoreFurniture = compile preprocessFileLineNumbers "server\functions\createStoreFurniture.sqf";

	waitUntil {!isNil "storeConfigDone"};

	{
		if (_x select 0 == _npcName) exitWith
		{
			private ["_frontOffset", "_bPos"];

			//collect our arguments
			_npcPos = _x select 1;
			_deskDirMod = _x select 2;

			if (_npcPos < 0) then { _npcPos = 1e9 }; // fix for buildingPos Arma 3 v1.55 change

			if (typeName _deskDirMod == "ARRAY" && {count _deskDirMod > 0}) then
			{
				if (count _deskDirMod > 1) then
				{
					_frontOffset = _deskDirMod select 1;
				};

				_deskDirMod = _deskDirMod select 0;
			};

			_storeOwnerAppearance = [];

			{
				if (_x select 0 == _npcName) exitWith
				{
					_storeOwnerAppearance = _x select 1;
				};
			} forEach (call storeOwnerConfigAppearance);

			{
				_type = _x select 0;
				_classname = _x select 1;

				switch (toLower _type) do
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
			} forEach _storeOwnerAppearance;

			_pDir = getDir _npc;
			_bPos = _building buildingPos _npcPos;

			if (_bPos isEqualTo [0,0,0]) then
			{
				_bPos = getPosATL _npc;
			}
			else
			{
				if (!isNil "_frontOffset") then
				{
					_bPos = _bPos vectorAdd ([[0, _frontOffset, 0], -_pDir] call BIS_fnc_rotateVector2D);
				};

				_npc setPosATL _bPos;
			};

			_desk = [_npc, _bPos, _pDir, _deskDirMod] call _createStoreFurniture;
			_npc setVariable ["storeNPC_cashDesk", netId _desk, true];

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
			_desk enableSimulationGlobal false;
		};
	} forEach (call storeOwnerConfig);
};

if (isServer) then
{
	_npc setVariable ["storeNPC_setupComplete", true, true];
};

// Add sell box in front of counter
if (hasInterface) then
{
	waitUntil {sleep 1; _npc getVariable ["storeNPC_setupComplete", false]};

	_desk = objectFromNetId (_npc getVariable ["storeNPC_cashDesk", ""]);
	_face = _npc getVariable ["storeNPC_face", ""];

	if (_face != "") then
	{
		_npc setFace _face;
	};

	if (!isNull _desk) then
	{
		[_desk, _npcName] spawn
		{
			_desk = _this select 0;
			_npcName = _this select 1;

			_sellBoxVar = "A3W_sellBox_" + _npcName;

			_createSellBox =
			{
				_deskOffset = (getPosASL _desk) vectorAdd ([[-0.05,-0.6,0], -(getDir _desk)] call BIS_fnc_rotateVector2D);

				missionNamespace setVariable [_sellBoxVar, objNull];

				// Box created outside scheduler to prevent its destruction before allowDamage kicks in
				[[_deskOffset, _sellBoxVar],
				{
					_deskOffset = _this select 0;
					_sellBoxVar = _this select 1;

					_sellBox = "Box_IND_Ammo_F" createVehicleLocal ASLtoATL _deskOffset;
					_sellBox allowDamage false;

					missionNamespace setVariable [_sellBoxVar, _sellBox];
				}] execFSM "call.fsm";

				waitUntil {_sellBox = missionNamespace getVariable _sellBoxVar; !isNull _sellBox};

				_sellBox setVariable ["R3F_LOG_disabled", true];
				_sellBox setVariable ["A3W_storeSellBox", true];
				_sellBox setObjectTexture [0, ""]; // remove side marking

				clearBackpackCargo _sellBox;
				clearMagazineCargo _sellBox;
				clearWeaponCargo _sellBox;
				clearItemCargo _sellBox;

				// must be done twice for the position to set properly
				for "_i" from 1 to 2 do
				{
					_sellBox setVelocity [0,0,0];
					_sellBox setVectorDirAndUp [[vectorDir _desk, -90] call BIS_fnc_rotateVector2D, [0,0,1]];
					_sellBox setPosASL _deskOffset;
					_boxPos = getPos _sellBox;

					if (_boxPos select 2 > 0) then
					{
						_boxPosASL = getPosASL _sellBox;
						_boxPosASL set [2, (_boxPosASL select 2) - (_boxPos select 2)];
						_sellBox setPosASL _boxPosASL;
					};
				};

				_sellBox addAction ["<img image='client\icons\money.paa'/> Sell bin contents", "client\systems\selling\sellCrateItems.sqf", [true], 1, false, false, "", STORE_ACTION_CONDITION + " && " + SELL_BIN_CONDITION];

				_boxPos = getPosATL _sellBox;
				_boxVecDir = vectorDir _sellBox;
				_boxVecUp = vectorUp _sellBox;
			};

			private ["_sellBox", "_boxPos", "_boxVecDir", "_boxVecUp"];
			call _createSellBox;

			while {true} do
			{
				sleep 5;
				if (!alive _sellBox) then
				{
					deleteVehicle _sellBox;
					call _createSellBox;
				}
				else
				{
					if ((getPosATL _sellBox) vectorDistance _boxPos > 0.1 ||
					   {(vectorDir _sellBox) vectorDistance _boxVecDir > 0.1} ||
					   {(vectorUp _sellBox) vectorDistance _boxVecUp > 0.1}) then
					{
						_sellBox setPosATL _boxPos;
						_sellBox setVectorDirAndUp [_boxVecDir, _boxVecUp];
					};
				};
			};
		};
	};
};
