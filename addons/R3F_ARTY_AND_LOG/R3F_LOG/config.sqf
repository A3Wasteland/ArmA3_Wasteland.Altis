/****** TOW WITH VEHICLE  ******/

/**
 * List of class names of (ground or air) vehicles which can tow towables objects.
 */
R3F_LOG_CFG_remorqueurs =
[
	"Car_F",
	"Ship_F",
	"Tank_F"
];

/**
 * List of class names of towables objects.
 */
R3F_LOG_CFG_objets_remorquables =
[
	"Car_F",
	"Ship_F",
	"Tank_F",
	"Plane",
	"Helicopter_Base_F"
];

/****** LIFT WITH VEHICLE  ******/

/**
 * List of class names of air vehicles which can lift liftables objects.
 */
R3F_LOG_CFG_heliporteurs =
[
	"Helicopter_Base_F"
];

/**
 * List of class names of liftables objects.
 */
R3F_LOG_CFG_objets_heliportables =
[
	"Car_F",
	"Ship_F",
	"Tank_F",
	"Plane",
	"Helicopter_Base_F"
        //"Box_IND_AmmoVeh_F",
        //"B_supplyCrate_F"
];


/****** LOAD IN VEHICLE / CHARGER DANS LE VEHICULE ******/


/**
 * List of class names of (ground or air) vehicles which can transport transportables objects.
 * The second element of the arrays is the load capacity (in relation with the capacity cost of the objects).
 */
R3F_LOG_CFG_transporteurs =
[
	["Quadbike_01_base_F", 5],
	["UGV_01_base_F", 10],
	["Hatchback_01_base_F", 10],
	["SUV_01_base_F", 20],
	["Offroad_01_base_F", 30],
	["Van_01_base_F", 40],
	["MRAP_01_base_F", 20],
	["MRAP_02_base_F", 20],
	["MRAP_03_base_F", 20],
	["B_Truck_01_box_F", 450],
	["Truck_F", 150],
	["Wheeled_APC_F", 30],
	["Tank_F", 30],
	["Rubber_duck_base_F", 10],
	["Boat_Civil_01_base_F", 10],
	["Boat_Armed_01_base_F", 20],
	["Heli_Light_01_base_F", 10],
	["Heli_Light_02_base_F", 20],
	["I_Heli_light_03_base_F", 20],
	["Heli_Transport_01_base_F", 25],
	["Heli_Transport_02_base_F", 100],
	["Heli_Attack_01_base_F", 10],
	["Heli_Attack_02_base_F", 20],
        ["Box_IND_AmmoVeh_F",300],
        ["B_supplyCrate_F",200]
];

 
R3F_LOG_CFG_objets_transportables = 
[
	["StaticWeapon",5],
        ["B_HMG_01_A_F",5],
        ["O_HMG_01_A_F",5],
        ["I_HMG_01_A_F",5],
        ["I_HMG_01_A_F",5],
        ["B_GMG_01_A_F",5],
        ["O_GMG_01_A_F",5],
        ["I_GMG_01_A_F",5],

        ["Box_IND_AmmoVeh_F",20],
        ["B_supplyCrate_F",30],
        ["Land_BarrelWater_F",5],
	["Box_NATO_AmmoVeh_F", 10],
        ["Box_East_WpsSpecial_F", 5],
	["B_supplyCrate_F", 5],
	["ReammoBox_F", 3],
	["Kart_01_Base_F", 5],
	["Quadbike_01_base_F", 10],
	["Rubber_duck_base_F", 10],
	["UAV_01_base_F", 2],
	["Land_BagBunker_Large_F", 10],
	["Land_BagBunker_Small_F", 5],
	["Land_BagBunker_Tower_F", 7],
	["Land_BagFence_Corner_F", 2],
	["Land_BagFence_End_F", 2],
	["Land_BagFence_Long_F", 3],
	["Land_BagFence_Round_F", 2],
	["Land_BagFence_Short_F", 2],
	["Land_BarGate_F", 3],
	["Land_Canal_WallSmall_10m_F", 4],
	["Land_Canal_Wall_Stairs_F", 3],
	["Land_CargoBox_V1_F", 5],
	["Land_Cargo_Patrol_V1_F", 7],
	["Land_Cargo_Tower_V1_F", 30],
	["Land_CncBarrier_F", 4],
	["Land_CncBarrierMedium_F", 4],
	["Land_CncBarrierMedium4_F", 4],
	["Land_CncShelter_F", 2],
	["Land_CncWall1_F", 3],
	["Land_CncWall4_F", 5],
	["Land_Crash_barrier_F", 5],
	["Land_HBarrierBig_F", 5],
	["Land_HBarrierTower_F", 8],
	["Land_HBarrierWall4_F", 4],
	["Land_HBarrierWall6_F", 6],
	["Land_HBarrier_1_F", 3],
	["Land_HBarrier_3_F", 4],
	["Land_HBarrier_5_F", 5],
	["Land_LampHarbour_F", 2],
	["Land_LampShabby_F", 2],
	["Land_MetalBarrel_F", 2],
	["Land_Mil_ConcreteWall_F", 5],
	["Land_Mil_WallBig_4m_F", 5],
	["Land_Obstacle_Ramp_F", 5],
	["Land_Pipes_large_F", 5],
	["Land_RampConcreteHigh_F", 6],
	["Land_RampConcrete_F", 5],
	["Land_Razorwire_F", 5],
	["Land_Sacks_goods_F", 2],
	["Land_Scaffolding_F", 5],
	["Land_Shoot_House_Wall_F", 3],
	["Land_Stone_8m_F", 5],
	["Land_ToiletBox_F", 2],
	["Land_WaterBarrel_F", 2],
        
        //Custom Buildings
	["Land_Airport_Tower_F",25],
	["Land_i_Barracks_V2_F",30],
	["Land_Cargo_House_V1_F",25],
	["Land_Cargo_HQ_V1_F",25],
	["Land_Castle_01_tower_F",30],
	["Land_CarService_F",25],
	["Land_City_Gate_F",5],
	["Land_Crane_F",30],
	["Land_Dome_Big_F",40],
	["Land_Dome_Small_F",30],
	["Land_i_Garage_V1_F",10],
	["Land_Hangar_F",25],
	["Land_TentHangar_V1_F",20],
	["Land_Hospital_main_F",75],
	["Land_Hospital_side1_F",75],
	["Land_Hospital_side2_F",75],
	["Land_i_House_Big_01_V1_F",25],
	["Land_i_House_Big_02_V1_F",25],
	["Land_i_House_Small_01_V1_F",15],
	["Land_i_Addon_02_V1_F",10],
	["Land_LightHouse_F",35],
	["Land_MilOffices_V1_F",55],
	["Land_Net_Fence_Gate_F",5],
        ["Land_Offices_01_V1_F",60],
	["Land_Shed_Big_F",10],
        ["Land_i_Shed_Ind_F",25],
        ["Land_nav_pier_m_F",20],
	["Land_Radar_Small_F",30],
	["Land_i_Shop_01_V1_F",30],
	["Land_i_Shop_02_V1_F",30],
	["Land_cargo_house_slum_F",5],
	["MetalBarrel_burning_F",2],
	["Land_WIP_F",60],
	["Land_Pier_F", 25],
	["Land_Pier_Box_F", 25],
	["Land_Pier_Addon", 15]



];

/****** MOVABLE-BY-PLAYER OBJECTS / OBJETS DEPLACABLES PAR LE JOUEUR ******/

R3F_LOG_CFG_objets_deplacables =
[
	"StaticWeapon",

        "B_HMG_01_A_F",
        "O_HMG_01_A_F",
        "I_HMG_01_A_F",
        "I_HMG_01_A_F",
        "B_GMG_01_A_F",
        "O_GMG_01_A_F",
        "I_GMG_01_A_F",

        "Box_IND_AmmoVeh_F",
        "B_supplyCrate_F",
        "Land_BarrelWater_F",
	"ReammoBox_F",
        "Box_East_WpsSpecial_F",
	"Kart_01_Base_F",
	"Quadbike_01_base_F",
	"Rubber_duck_base_F",
	"SDV_01_base_F",
	"UAV_01_base_F",
	"Land_BagBunker_Large_F",
	"Land_BagBunker_Small_F",
	"Land_BagBunker_Tower_F",
	"Land_BagFence_Corner_F",
	"Land_BagFence_End_F",
	"Land_BagFence_Long_F",
	"Land_BagFence_Round_F",
	"Land_BagFence_Short_F",
	"Land_BarGate_F",
	"Land_Canal_WallSmall_10m_F",
	"Land_Canal_Wall_Stairs_F",
	"Land_CargoBox_V1_F",
	"Land_Cargo_Patrol_V1_F",
	"Land_Cargo_Tower_V1_F",
	"Land_CncBarrier_F",
	"Land_CncBarrierMedium_F",
	"Land_CncBarrierMedium4_F",
	"Land_CncShelter_F",
	"Land_CncWall1_F",
	"Land_CncWall4_F",
	"Land_Crash_barrier_F",
	"Land_HBarrierBig_F",
	"Land_HBarrierTower_F",
	"Land_HBarrierWall4_F",
	"Land_HBarrierWall6_F",
	"Land_HBarrier_1_F",
	"Land_HBarrier_3_F",
	"Land_HBarrier_5_F",
	"Land_LampHarbour_F",
	"Land_LampShabby_F",
	"Land_MetalBarrel_F",
	"Land_Mil_ConcreteWall_F",
	"Land_Mil_WallBig_4m_F",
	"Land_Obstacle_Ramp_F",
	"Land_Pipes_large_F",
	"Land_RampConcreteHigh_F",
	"Land_RampConcrete_F",
	"Land_Razorwire_F",
	"Land_Sacks_goods_F",
	"Land_Scaffolding_F",
	"Land_Shoot_House_Wall_F",
	"Land_Stone_8m_F",
	"Land_ToiletBox_F",
	"Land_WaterBarrel_F",

        //Custom Buildings
	"Land_Airport_Tower_F",
	"Land_i_Barracks_V2_F",
	"Land_Cargo_House_V1_F",
	"Land_Cargo_HQ_V1_F",
	"Land_CarService_F",
	"Land_Castle_01_tower_F",
	"Land_City_Gate_F",
	"Land_Crane_F",
	"Land_Dome_Big_F",
	"Land_Dome_Small_F",
	"Land_i_Garage_V1_F",
	"Land_Hangar_F",
	"Land_TentHangar_V1_F",
	"Land_Hospital_main_F",
	"Land_Hospital_side1_F",
	"Land_Hospital_side2_F",
	"Land_i_House_Big_01_V1_F",
	"Land_i_House_Big_02_V1_F",
	"Land_i_House_Small_01_V1_F",
	"Land_i_Addon_02_V1_F",
	"Land_LightHouse_F",
	"Land_MilOffices_V1_F",
	"Land_Net_Fence_Gate_F",
        "Land_Offices_01_V1_F",
	"Land_Shed_Big_F",
        "Land_i_Shed_Ind_F",
        "Land_nav_pier_m_F",
	"Land_Radar_Small_F",
	"Land_i_Shop_01_V1_F",
	"Land_i_Shop_02_V1_F",
	"Land_cargo_house_slum_F",
	"MetalBarrel_burning_F",
	"Land_WIP_F",
	"Land_Pier_F",
	"Land_Pier_Box_F",
        "Land_Pier_Addon"
];