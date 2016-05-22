//Client Menu Building for Airdrop Assistance 
//Builds client commanding menus dynamically based on config file arrays
//Author: Apoc
//Credits to Cre4mpie for the command menu approach and static structure of menus

AirdropMenu = 
[
	["Airdrop",true],
			["Vehicles", [2], "#USER:VehicleMenu", -5, [["expression", ""]], "1", "1"],
			["Supplies", [3], "#USER:SupplyMenu", -5, [["expression", ""]], "1", "1"],
			["Cancel Airdrop", [4], "", -3, [["expression", ""]], "1", "1"]
];
//////////////////////////////////////////////////////
//Setting up the Vehicle Menu ///////////////////////
/////////////////////////////////////////////////////
VehicleMenu = [];
_startVehMenu = ["Vehicles",true];
VehicleMenu pushback _startVehMenu;

_i=0;
{
_optionVehMenu = [];
_lineElement1=format ["%1 ($%2)",(APOC_AA_VehOptions select _i) select 0, (APOC_AA_VehOptions select _i) select 2];
_type = (APOC_AA_VehOptions select _i) select 3;
_optionVehMenu pushback _lineElement1;

_optionVehMenu append [[_i+2], "", -5];

_optionVehMenu pushback [["expression", format ['["%1",%2,player] execVM "addons\APOC_Airdrop_Assistance\APOC_cli_startAirdrop.sqf"',_type,_i]]];

_optionVehMenu append ["1","1"];

VehicleMenu pushback _optionVehMenu;
//diag_log format["Here's the menu structure: %1",VehicleMenu];
_i=_i+1;
}forEach APOC_AA_VehOptions;

_endVehMenu = ["Cancel Airdrop", [_i+2], "", -3, [["expression", ""]], "1", "1"];
VehicleMenu pushback _endVehMenu;
///////////////////////////////////////////////////////

//////////////////////////////////////////////////////
//Setting up the Supply Menu ////////////////////////
/////////////////////////////////////////////////////
SupplyMenu = [];
_startSupMenu = ["Supplies",true];
SupplyMenu pushback _startSupMenu;

_i=0;
{
_optionSupMenu = [];
_lineElement1=format ["%1 ($%2)",(APOC_AA_SupOptions select _i) select 0, (APOC_AA_SupOptions select _i) select 2];
_type = (APOC_AA_SupOptions select _i) select 3;
_optionSupMenu pushback _lineElement1;

_optionSupMenu append [[_i+2], "", -5];

_optionSupMenu pushback [["expression", format ['["%1",%2,player] execVM "addons\APOC_Airdrop_Assistance\APOC_cli_startAirdrop.sqf"',_type,_i]]];

_optionSupMenu append ["1","1"];

SupplyMenu pushback _optionSupMenu;
//diag_log format["Here's the menu structure: %1",SupplyMenu];
_i=_i+1;
}forEach APOC_AA_SupOptions;

_endSupMenu = ["Cancel Airdrop", [_i+2], "", -3, [["expression", ""]], "1", "1"];
SupplyMenu pushback _endSupMenu;
///////////////////////////////////////////////////////


showCommandingMenu "#USER:AirdropMenu";