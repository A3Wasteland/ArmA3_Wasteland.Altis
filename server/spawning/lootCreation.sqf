//	Random weapons and items spawning script for wasteland missions.
//	Authors: 
//	original: Ed! (404Forums)
//	Adjusted for Arma3 Wasteland use by: [GoT] JoSchaap (GoT2DayZ.nl), 
//	Player near town spawning concept by: Na_Palm (BIS-Forums)

_odd1 = 60;					//The odds that a building is selected to place loot.
_odd2 = 50;					//The odds that the selected building's spots will have loot(almost like odds per room).
_odditem = 45;					//Chance of item instead of weapon
_oddfuelcan = 35;				//Chance of a spawned fuelcan to be full instead of empty
_spawnradius = 50;				//Distance added to the radius around city's original marker to spawn loot (expands the radius with this value)
_interval = 5400;				//Time (in sec.) to pass before a city spawns new loot
randomweapontestint = 0.01;			//Sets the intervals in which weaponpositions are tested. (Lower = slower, but more accurate. Higher = faster, but less accurate.)
									
//Array of buildings that are eligeble to spawn loot in :)
_spawnlootIN = [
"Land_LightHouse_F", 
"Land_Lighthouse_small_F", 
"Land_Metal_Shed_F", 
"Land_i_House_Big_01_V1_F", 
"Land_i_House_Big_01_V1_dam_F", 
"Land_i_House_Big_02_V1_F", 
"Land_i_House_Big_02_V1_dam_F", 
"Land_i_Shop_01_V1_F", 
"Land_u_Addon_01_V1_F", 
"Land_Addon_01_V1_dam_F", 
"Land_u_Addon_02_V1_F", 
"Land_i_Addon_03_V1_F", 
"Land_i_Addon_03mid_V1_F", 
"Land_i_Addon_04_V1_F", 
"Land_i_Garage_V1_F", 
"Land_Garage_V1_dam_F", 
"Land_i_Shop_01_V1_dam_F", 
"Land_i_Shop_02_V1_F", 
"Land_i_Shop_02_V1_dam_F", 
"Land_i_House_Small_01_V1_F", 
"Land_i_House_Small_01_V1_dam_F", 
"Land_i_House_Small_01_V2_dam_F", 
"Land_i_House_Small_01_V2_F", 
"Land_u_House_Small_01_V1_F", 
"Land_u_House_Small_01_V1_dam_F", 
"Land_i_House_Small_02_V1_F", 
"Land_i_House_Small_02_V1_dam_F", 
"Land_u_House_Small_02_V1_F", 
"Land_u_House_Small_02_V1_dam_F", 
"Land_i_House_Small_03_V1_F", 
"Land_i_House_Small_03_V1_dam_F", 
"Land_cargo_addon01_V1_F", 
"Land_cargo_addon01_V2_F", 
"Land_cargo_addon02_V2_F", 
"Land_Slum_House01_F", 
"Land_Slum_House02_F", 
"Land_Slum_House03_F", 
"Land_i_Stone_HouseBig_V1_F", 
"Land_i_Stone_HouseBig_V1_dam_F", 
"Land_i_Stone_Shed_V1_F", 
"Land_i_Stone_Shed_V1_dam_F", 
"Land_d_Stone_Shed_V1_F", 
"Land_i_Stone_HouseSmall_V1_F", 
"Land_i_Stone_HouseSmall_V1_dam_F", 
"Land_Unfinished_Building_01_F", 
"Land_Airport_Tower_F", 
"Land_Airport_Tower_dam_F", 
"Land_dp_bigTank_F", 
"Land_dp_smallFactory_F", 
"Land_dp_smallTank_F", 
"Land_FuelStation_Build_F", 
"Land_FuelStation_Shed_F", 
"Land_ReservoirTank_Airport_F", 
"Land_Shed_Big_F", 
"Land_Shed_Small_F",  
"Land_Communication_anchor_F", 
"Land_Communication_F", 
"Land_TBox_F", 
"Land_TTowerBig_1_F", 
"Land_TTowerBig_2_F", 
"Land_i_Barracks_V1_F", 
"Land_MilOffices_V1_F", 
"Land_Radar_F"
];



randomweapon_weaponlist = [
["arifle_SDAR_F","20Rnd_556x45_UW_mag"],
["arifle_TRG21_ACO_pointer_F","30Rnd_556x45_Stanag_Tracer_Red"],
["arifle_TRG20_ACO_F","30Rnd_556x45_Stanag_Tracer_Yellow"],
["arifle_TRG21_F","30Rnd_556x45_Stanag"],
["arifle_TRG20_F","30Rnd_556x45_Stanag"],
["arifle_MK20_F","30Rnd_556x45_Stanag"],
["arifle_MK20C_F","30Rnd_556x45_Stanag"],
["SMG_01_F","30Rnd_45ACP_Mag_SMG_01"],
["SMG_02_F","30Rnd_9x21_Mag"],
["hgun_ACPC2_snds_F","9Rnd_45ACP_Mag"],
["hgun_P07_snds_F","16Rnd_9x21_Mag"],
["hgun_Rook40_snds_F","16Rnd_9x21_Mag"],
];


randomweapon_itemlist = [
							//Water
"Land_Basket_F",
							//Food
"Land_Bucket_F",
							//repairkit
"Land_Suitcase_F",
							//fuelcan
"Land_CanisterFuel_F"
];

//-------------------------------------------------------------------------------------

    randomweaponspawnweapon = 
	{
		_position = _this;
		_selectedgroup = (floor(random(count randomweapon_weaponlist)));
		_weapon = randomweapon_weaponlist select _selectedgroup select 0;
		_weaponholder = createVehicle ["groundWeaponHolder", _position, [], 0, "CAN_COLLIDE"];
		_weaponholder addWeaponCargoGlobal [_weapon, 1];
		if((count((randomweapon_weaponlist) select _selectedgroup)) > 1) then {
			for[{_rm = 0}, {_rm < (2 + floor(random(3)))}, {_rm = _rm + 1}] do {
				_mag = randomweapon_weaponlist select _selectedgroup select ((floor(random((count(randomweapon_weaponlist select _selectedgroup) - 1)))) + 1);
				_weaponholder addMagazineCargoGlobal [_mag, 1]; 
			};
		};
		_weaponholder setPos _position;
    };

	
    randomweaponspawnitem = 
	{
		_position = _this;
		_numf = 0;
		_selectedgroup = (floor(random(count randomweapon_itemlist)));
		_class = randomweapon_itemlist select _selectedgroup;
		_item = createVehicle [_class, _position, [], 0, "CAN_COLLIDE"];
		if(_class == "Land_CanisterFuel_F") then {
			_numf = (random 100);
			if (_numf < _oddfuelcan) then {
				_item setVariable["fuel", true, true];
				_item setVariable["mf_item_id", MF_ITEMS_JERRYCAN_FULL, true]
			} else {
				_item setVariable["fuel", false, true];
				_item setVariable["mf_item_id", MF_ITEMS_JERRYCAN_EMPTY, true]
			};
		};
		if(_class == "Land_Basket_F") then {
			_item setVariable["mf_item_id", MF_ITEMS_CANNED_FOOD, true]
		};
		if(_class == "Land_Bucket_F") then {
			_item setVariable["mf_item_id", MF_ITEMS_WATER, true]
		};
		if(_class == "Land_Suitcase_F") then {
			_item setVariable["mf_item_id", MF_ITEMS_REPAIR_KIT, true]
		};
		_item setPos _position;
    };

//-------------------------------------------------------------------------------------
	
	spawnlootintown =
	{
    _pos = _this;
    randomweapon_buildings = nearestObjects [_pos, _spawnlootIN, _spawnradius];
    sleep 30;
	{
		_building = _x;
		_buildingpos = [];
		_endloop = false;
		_poscount = 0;
		while {!_endloop} do {
			if(((_building buildingPos _poscount) select 0) != 0 && ((_building buildingPos _poscount) select 1) != 0) then {
				_buildingpos = _buildingpos + [_building buildingPos _poscount];
				_poscount = _poscount + 1;
			} else {
				_endloop = true;
			};
		};
		_num = (random 100);
		if (_num < _odd1) then {
			if (count _buildingpos > 0) then {  
				for[{_r = 0}, {_r < count _buildingpos}, {_r = _r + 1}] do
				{
					_num2 = (random 100);
					if (_num2 < _odd2) then {
						_pos = _buildingpos select _r;
						_posnew = _pos;
						if(_pos select 2 < 0) then {
							_pos = [_pos select 0, _pos select 1, 1];
						};
						_z = 0;
						_testpos = true;
						while {_testpos} do 
						{
							if((!lineIntersects[ATLtoASL(_pos), ATLtoASL([_pos select 0, _pos select 1, (_pos select 2) - (randomweapontestint * _z)])]) && (!terrainIntersect[(_pos), ([_pos select 0, _pos select 1, (_pos select 2) - (randomweapontestint * _z)])]) && (_pos select 2 > 0)) then {
								_posnew = [_pos select 0, _pos select 1, (_pos select 2) - (randomweapontestint * _z)];
								_z = _z + 1;
							} else {
								_testpos = false;
							};
						};
						_posnew = [_posnew select 0,_posnew select 1,(_posnew select 2) + 0.05];
						_woi = floor(random(100));
						if(_woi < _odditem) then {
							_posnew call randomweaponspawnitem;
						} else {
							_posnew call randomweaponspawnweapon;
						};
					};
				};
			};    
		};
    }foreach randomweapon_buildings;
	};

//-------------------------------------------------------------------------------------

	townarea_list = [];
	_posPlayer = [];
	_posTown = [];
	_tradius = 0;
	_lastSpawned = 0;
	{
		_pos = getMarkerPos (_x select 0);
		_tradius = (_x select 1);
		townarea_list set [count townarea_list, [_pos, _lastSpawned]];
	}forEach (call citylist);
	while {true} do {
		{
			if ((isPlayer _x) && (alive _x)) then {
				_posPlayer = getPos _x;
				usedtown_list = [];
				{
					_posTown = (_x select 0);
					_lastSpawned = (_x select 1);
					_dospawnradius = (_tradius + _spawnradius);
					if (((_posTown distance _posPlayer) < _dospawnradius) && ((_interval < (time - _lastSpawned)) || (_lastSpawned == 0))) then {
						_posTown call spawnlootintown;
						usedtown_list set [count usedtown_list, [_forEachIndex, time]];
					};
				}forEach townarea_list;
				{
					(townarea_list select (_x select 0)) set [1,(_x select 1)];
				}forEach usedtown_list;
			};		
		}forEach playableUnits;
		sleep 10;
	};
