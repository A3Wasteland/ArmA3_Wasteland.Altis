// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: init.sqf
//@file Author: micovery
//@file Argument: the path to the directory holding this file.
private ["_path"];
_path = _this;

call compile preprocessFileLineNumbers format["%1\functions.sqf", _path];

MF_ITEMS_LSD = "lsd";
MF_ITEMS_LSD_TYPE = "Land_WaterPurificationTablets_F";
MF_ITEMS_LSD_ICON = "client\icons\lsd.paa";
[MF_ITEMS_LSD, "LSD", {[player,60] call drug_lsd_effects; true}, MF_ITEMS_LSD_TYPE, MF_ITEMS_LSD_ICON, 15] call mf_inventory_create;

MF_ITEMS_MARIJUANA = "marijuana";
MF_ITEMS_MARIJUANA_TYPE = "Land_VitaminBottle_F";
MF_ITEMS_MARIJUANA_ICON = "client\icons\marijuana.paa";
[MF_ITEMS_MARIJUANA, "Marijuana", {[player,90] call drug_marijuana_effects; true}, MF_ITEMS_MARIJUANA_TYPE, MF_ITEMS_MARIJUANA_ICON, 15] call mf_inventory_create;


MF_ITEMS_COCAINE = "cocaine";
MF_ITEMS_COCAINE_TYPE = "Land_PowderedMilk_F";
MF_ITEMS_COCAINE_ICON = "client\icons\cocaine.paa";
[MF_ITEMS_COCAINE, "Cocaine", {[player,90] call drug_cocaine_effects; true}, MF_ITEMS_COCAINE_TYPE, MF_ITEMS_COCAINE_ICON, 15] call mf_inventory_create;

MF_ITEMS_HEROIN = "heroin";
MF_ITEMS_HEROIN_TYPE = "Land_PainKillers_F";
MF_ITEMS_HEROIN_ICON = "client\icons\heroin.paa";
[MF_ITEMS_HEROIN, "Heroin", {[player,60] call drug_heroin_effects; true}, MF_ITEMS_HEROIN_TYPE, MF_ITEMS_HEROIN_ICON, 15] call mf_inventory_create;