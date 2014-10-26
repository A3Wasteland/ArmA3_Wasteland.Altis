// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: onMouseWheel.sqf

private ["_playerMenuAction", "_veh", "_playerMenuID"]

_playerMenuAction = [format ["<img image='client\icons\playerMenu.paa' color='%1'/> <t color='%1'>[</t>Player Menu<t color='%1'>]</t>", "#FF8000"], "client\systems\playerMenu\init.sqf", [], -10, false]; //, false, "", ""];

waitUntil {!isNull player};

while {true} do
{
	_playerMenuID = player addAction _playerMenuAction;

	waitUntil {sleep 0.1; _veh = vehicle player; _veh != player};

	player removeAction _playerMenuID;
	_playerMenuID = _veh addAction _playerMenuAction;

	waitUntil {sleep 0.1; vehicle player == player};

	_veh removeAction _playerMenuID;
};
