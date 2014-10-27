private ["_objs"];
_objs =
[
	["Land_LampShabby_F",[3.50317,2.47949,0],325,1,0,{}],
	["Land_LampShabby_F",[-4.50623,2.23486,0],35,1,0,{}],
	["Land_BagFence_Long_F",[3.52722,4.10938,0],90,1,0,{}],
	["Land_BarGate_F",[-4.38623,5.86182,0],180,1,0,{_this animate ['Land_BarGate_F',1]}],  // this should open the gate :) TEST FIRST!
	["Land_LampShabby_F",[3.95813,-4.55029,0],210,1,0,{}],
	["Land_LampShabby_F",[-3.84167,-4.69043,0],150,1,0,{}],
	["Land_BagFence_Long_F",[-4.8949,3.82715,0],90,1,0,{}],
	["Land_BagFence_Long_F",[4.29211,-6.27881,0],90,1,0,{}],
	["Land_BagFence_Long_F",[-4.06665,-6.43359,0],90,1,0,{}],
	["Land_BarGate_F",[-3.25195,-7.94873,0],180,1,0,{}],
	["Land_BagBunker_Small_F",[5.96436,7.86963,0],180,1,0,{}],
	["Box_IND_WpsSpecial_F",[-6.74817,7.19141,0],180,1,0,{[_this,'mission_Main_A3snipers'] call fn_refillbox}],
	["Land_BagBunker_Small_F",[-6.35974,7.86914,-0.353401],180,1,0,{}],
	["Land_BagBunker_Small_F",[-6.06433,-10.0005,0],0,1,0,{}],
	["Land_BagBunker_Small_F",[5.77478,-10.3975,0.614847],0,1,0,{}],
	["Box_East_WpsSpecial_F",[6.76294,-9.82422,0],180,1,0,{[_this,'mission_USLaunchers'] call fn_refillbox}],
	["Land_HBarrierBig_F",[10.9138,4.86182,0],45,1,0,{}],
	["Land_HBarrierBig_F",[-12.4873,4.40869,0],315,1,0,{}],
	["Land_HBarrierBig_F",[11.8104,-6.33154,0],315,1,0,{}],
	["Land_HBarrierBig_F",[-11.583,-6.92871,0],45,1,0,{}],
	["Land_BagBunker_Small_F",[14.4102,-1.2915,0],270,1,0,{}],
	["Land_BagBunker_Small_F",[-15.6963,-0.902344,0],90,1,0,{}],
	["Land_LampShabby_F",[14.8219,1.71777,0],85,1,0,{}],
	["Land_LampShabby_F",[-15.5142,-4.27295,0],275,1,0,{}]
];
_objs
