_pathtovehicles = "addons\airdrop\veh\";
_EXECscript5 = 'player execVM "'+_pathtovehicles+'%1"';


AirdropMenu = 
[
	["Airdrop",true],
			["Vehicles", [2], "#USER:VehicleMenu", -5, [["expression", ""]], "1", "1"],
			["Supports", [3], "#USER:SupportsMenu", -5, [["expression", ""]], "1", "1"],
			["Cancel Airdrop", [4], "", -3, [["expression", ""]], "1", "1"]
];

VehicleMenu = 
[
	["Vehicles",true],
		["ATV ($1,500)", [2],  "", -5, [["expression", format[_EXECscript5,"ATV.sqf"]]], "1", "1"],
		["M900 Civilian Heli ($7,500)", [3],  "", -5, [["expression", format[_EXECscript5,"m900.sqf"]]], "1", "1"],
		["Offroad HMG .50 ($5,000)", [4],  "", -5, [["expression", format[_EXECscript5,"offroad.sqf"]]], "1", "1"],
		["Boxer Refuel Truck ($10,000)", [5],  "", -5, [["expression", format[_EXECscript5,"boxerfuel.sqf"]]], "1", "1"],
		["Offroad Repair Vehicle ($10,000)", [6],  "", -5, [["expression", format[_EXECscript5,"repairoffroad.sqf"]]], "1", "1"],
		["Hunter HMG .50 ($30,000)", [7],  "", -5, [["expression", format[_EXECscript5,"hunter.sqf"]]], "1", "1"],
		["HEMTT Ammo Truck ($50,000)", [8],  "", -5, [["expression", format[_EXECscript5,"hemttammo.sqf"]]], "1", "1"],
		["AFV-4 Gorgon ($60,000)", [9],  "", -5, [["expression", format[_EXECscript5,"gorgon.sqf"]]], "1", "1"],
		["IFV-6a Cheetah AA ($80,000)", [10],  "", -5, [["expression", format[_EXECscript5,"cheetah.sqf"]]], "1", "1"],
		["M2A1 Slammer ($80,000)", [11],  "", -5, [["expression", format[_EXECscript5,"m2a1slammer.sqf"]]], "1", "1"],
			["Cancel Airdrop", [13], "", -3, [["expression", ""]], "1", "1"]
];

SupportsMenu = 
[
	["Supports",true],
		["Food Support Drop ($10,000)", [2],  "", -5, [["expression", format[_EXECscript5,"food.sqf"]]], "1", "1"],
		["Water Support Drop ($10,000)", [3],  "", -5, [["expression", format[_EXECscript5,"water.sqf"]]], "1", "1"],
		["Random Weapon Crate ($25,000)", [4],  "", -5, [["expression", format[_EXECscript5,"crate.sqf"]]], "1", "1"],
		["Cancel Airdrop", [5], "", -3, [["expression", ""]], "1", "1"]
];

		
showCommandingMenu "#USER:AirdropMenu";