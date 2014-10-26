// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: Outpost2.sqf
//	@file Author: JoSchaap, AgentRev

[
	// Class, Position, Direction, Init (optional)
	["Land_LampShabby_F", [-0.298828, 9.40234, 0.00143814], 188.089],
	["Land_LampShabby_F", [-0.188477, 9.95068, -0.0161819], 1.90371],
	["Land_CncBarrierMedium4_F", [-0.232666, 10.4307, 0.153743], 359.72],
	["Land_BagBunker_Small_F", [-5.16577, 6.29346, 0.0585103], 180.219],
	["Land_BagFence_Long_F", [-0.163574, 1.57666, -0.0357904], 1.34008],
	["Land_BagBunker_Small_F", [4.52393, 6.37305, 0.0791397], 179.5],
	["Box_IND_WpsSpecial_F", [-1.04126, 0.24707, 0], 286.415, { [_this, ["mission_USSpecial", "mission_Main_A3snipers"] call BIS_fnc_selectRandom] call fn_refillbox }],
	["Land_CncWall4_F", [-6.46558, 2.6377, 0.0582647], 90.8417],
	["Land_LampShabby_F", [0, 0, -0.00534153], 0.243539],
	["Land_LampShabby_F", [-0.117188, -0.513672, -0.0352049], 186.35],
	["Box_East_WpsSpecial_F", [0.470947, -0.591309, 0], 85.8074, { [_this, "mission_USLaunchers"] call fn_refillbox }],
	["Land_HBarrier_5_F", [-7.76196, 2.66602, 0.0108471], 270.574],
	["Land_CncWall4_F", [5.80786, 2.78027, 0.100734], 269.176],
	["Land_BagFence_Long_F", [-0.246338, -1.82959, -0.0460205], 359.373],
	//["Land_CncBarrierMedium4_F", [-8.74731, 1.74219, -0.422749], 271.489],
	["Land_HBarrier_5_F", [7.11743, 3.08105, 0.0197954], 269.531],
	//["Land_CncBarrierMedium4_F", [8.08252, 2.17871, -0.377454], 269.773],
	["Land_CncWall4_F", [-6.46436, -2.58936, 0.0695257], 89.8022],
	//["Land_CncBarrierMedium4_F", [-8.71606, -1.99805, -0.405235], 269.972],
	["Land_CncWall4_F", [5.92725, -2.4458, 0.0815554], 269.256],
	["Land_HBarrier_5_F", [-7.75244, -2.91895, -0.0287189], 269.564],
	["Land_HBarrier_5_F", [7.14795, -2.55615, 0.016717], 269.598],
	//["Land_CncBarrierMedium4_F", [8.08228, -1.7876, -0.361892], 90.9182],
	["Land_BagBunker_Small_F", [-5.20874, -6.12061, 0.0614038], 359.567],
	["Land_BagBunker_Small_F", [4.69092, -6.15381, 0.0623822], 0.837728],
	["Land_LampShabby_F", [-0.244873, -9.31641, -0.042263], 353.13],
	["Land_LampShabby_F", [-0.268066, -9.83643, -0.123346], 179.672],
	["Land_CncBarrierMedium4_F", [-0.29248, -10.4473, 0.116841], 1.21038],
	["I_HMG_01_high_F", [4.2, 6.6, 0], 0, { if (random 1 < 0.5) exitWith { deleteVehicle _this }; [_this] call vehicleSetup }],
	["I_HMG_01_high_F", [-4.5, 6.6, 0], 0, { if (random 1 < 0.5) exitWith { deleteVehicle _this }; [_this] call vehicleSetup }],
	["I_HMG_01_high_F", [-4.9, -6.5, 0], 180, { if (random 1 < 0.5) exitWith { deleteVehicle _this }; [_this] call vehicleSetup }],
	["I_HMG_01_high_F", [4.1, -6.5, 0], 180, { if (random 1 < 0.5) exitWith { deleteVehicle _this }; [_this] call vehicleSetup }]
]
