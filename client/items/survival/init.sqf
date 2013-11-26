//@file Version: 1.0
//@file Name: init.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Initialize Wasteland's Survival Items
//@file Arguments: The path to the directory holding this file.

//_this should be the path to this folder
mf_items_survival_eat = [_this, "eat.sqf"] call mf_compile;
mf_items_survival_drink = [_this, "drink.sqf"] call mf_compile;
_energy_drink = [_this, "energy_drink.sqf"] call mf_compile;
//mf_items_survival_cook = [_this, "cook.sqf"] call mf_compile;
//mf_items_survival_cook = [_this, "cookable.sqf"] call mf_compile;

//MF_ITEMS_COOKED_MEAT = "cooked_meat";
//MF_ITEMS_RAW_MEAT = "raw_meat";
MF_ITEMS_CANNED_FOOD = "cannedfood";
MF_ITEMS_WATER = "water";
MF_ITEMS_ENERGY_DRINK = "energydrink";

//[MF_ITEMS_RAW_MEAT, "Raw Meat", {[MF_ITEMS_RAW_MEAT, MF_ITEMS_COOKED_MEAT] call mf_items_survival_cook}, "Land_BakedBeans_F", "", 5];
//[MF_ITEMS_COOKED_MEAT, "Raw Meat", {50 call mf_items_survival_eat}, "Land_BakedBeans_F", "", 5];
[MF_ITEMS_CANNED_FOOD, "Canned Food", {50 call mf_items_survival_eat}, "Land_BakedBeans_F","client\icons\cannedfood.paa", 5] call mf_inventory_create;
[MF_ITEMS_WATER, "Water Bottle", {50 call mf_items_survival_drink}, "Land_BottlePlastic_V2_F","client\icons\water.paa", 5] call mf_inventory_create;
[MF_ITEMS_ENERGY_DRINK, "Energy Drink", _energy_drink, "Land_Can_V3_F","client\icons\water.paa", 2] call mf_inventory_create;

// Take Food from Sacks
[] call {
    private["_label", "_code", "_condition"];
    _label = "<img image='client\icons\cannedfood.paa'/> Take Canned Food";
    _code = {
        _nobj = (nearestobjects [player, ["Land_Sacks_goods_F"],  5] select 0);
        _nobj setVariable["food",(_nobj getVariable "food")-1,true];
        [MF_ITEMS_CANNED_FOOD, 1] call mf_inventory_add;
        player playmove "AinvPknlMstpSlayWrflDnon";
        if(_nobj getVariable "food" < 1) then {
            _nobj spawn {
                _this setDamage 1.31337;
            	sleep 2;
            	deleteVehicle _this;
        	};
            hint "You have taken some food\nNo more food left in sacks";
        } else {
            hint format["You have taken some food\n(Sacks still have %1)", (_nobj getVariable "food")];
        };
    };
    _condition = 'player distance (nearestobjects [player, ["Land_Sacks_goods_F"],  5] select 0) < 5 and not(MF_ITEMS_CANNED_FOOD call mf_inventory_is_full) and (nearestobjects [player, ["Land_Sacks_goods_F"],  5] select 0) getVariable "food" > 0';

	["take-food-sack", [_label, _code, nil,0, false, false, "", _condition]] call mf_player_actions_set;
};

// Take Water from White water container
[] call {
    private["_label", "_code", "_condition"];
    _label = "<img image='client\icons\water.paa'/> Fill Water Bottle";
    _code = {
        _nobj = (nearestobjects [player, ["Land_WaterBarrel_F"],  5] select 0);
        _nobj setVariable["water",(_nobj getVariable "water")-1,true];
        [MF_ITEMS_WATER, 1] call mf_inventory_add;
        player playmove "AinvPknlMstpSlayWrflDnon";
        if(_nobj getVariable "water" < 1) then {
            _nobj spawn {
                _npos = getPos _this;
                _vecu = vectorUp _this;
                _vecd = vectorDir _this;
                deleteVehicle _this;
                _veh = createVehicle ["Land_Barrel_empty", _npos, [], 0, "CAN_COLLIDE"];
                _veh setVectorDirAndUp [_vecd, _vecu];
                _veh spawn {sleep 5; deleteVehicle _this};
            };
            hint "You have filled a water bottle.\nBarrel is empty";
        } else {
            hint format["You have filled a water bottle.\n(Water left: %1)", (_nobj getVariable "water")];
        };
    };
    _condition = 'player distance (nearestobjects [player, ["Land_WaterBarrel_F"],  5] select 0) < 5 and not(MF_ITEMS_WATER call mf_inventory_is_full) and (nearestobjects [player, ["Land_WaterBarrel_F"],  5] select 0) getVariable "water" > 0';
	["take-water-barrel", [_label, _code, nil,0, false, false, "", _condition]] call mf_player_actions_set;
};

// Take Water from Well
[] call {
    private["_label", "_code", "_condition"];
    _label = "<img image='client\icons\water.paa'/> Fill Water Bottle";
    _code = {
        [MF_ITEMS_WATER, 1] call mf_inventory_add;
        hint "You have filled a water bottle";
    };
    _condition = 'player distance (nearestobjects [player, ["Land_StallWater_F","Land_Water_source_F"],  3] select 0) < 3 and not(MF_ITEMS_WATER call mf_inventory_is_full)';
	["take-water-well", [_label, _code, nil,0, false, false, "", _condition]] call mf_player_actions_set;
};
