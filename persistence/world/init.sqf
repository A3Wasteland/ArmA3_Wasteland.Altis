//Persistent Scripts by ZA-Gamers. www.za-gamers.co.za
//Author: {ZAG}Ed!
//Email: edwin(at)vodamail(dot)co(dot)za
//Date: 26/03/2013
//Thanx to iniDB's author SicSemperTyrannis! May you have many wives and children!
//changes to persistentdb for arma3 and GoT Wasteland mission by JoSchaap (got2dayz.nl)

// WARNING! This is a modified version for use with the GoT Wasteland v2 missionfile!
// This is NOT a default persistantdb script!
// changes by: JoSchaap (GoT2DayZ.nl)

if(!isServer) exitWith {};

execVM "persistence\world\oSave.sqf";
execVM "persistence\world\oLoad.sqf";
