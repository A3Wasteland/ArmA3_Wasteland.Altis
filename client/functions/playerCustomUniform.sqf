// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: playerCustomUniform.sqf
//	@file Author: Lodac
//	@file Created: 2/23/2015


if (isDedicated) exitWith {};

private ["_player", "_side", "_customUniformEnabled", "_uniformNumber"];

_player = getPlayerUID player;
_side = playerSide;
_uniformNumber = 0;
_customUniformEnabled = ["A3W_customUniformEnabled"] call isConfigOn;
_uniformNumber = player getVariable ["uniform", 0];

if (!(_customUniformEnabled) || _uniformNumber < 1) exitWith {};


switch (_side) do
{
/*
	case BLUFOR:
	{
		[] spawn
		{
			while {true} do
			{
				_uniformNumber = player getVariable ["uniform", 0];
				waitUntil {uniform player == "U_B_CombatUniform_mcam"};
				player setObjectTextureGlobal [0,format["client\images\uniformTextures\%1_B.jpg", _uniformNumber]];
				sleep 1;
				waitUntil {uniform player != "U_B_CombatUniform_mcam"};
			};
		};
	};
	
	case OPFOR:
	{
		[] spawn
		{
			while {true} do
			{
				_uniformNumber = player getVariable ["uniform", 0];
				waitUntil {uniform player == "U_O_CombatUniform_ocamo"};
				player setObjectTextureGlobal [0,format["client\images\uniformTextures\%1_O.jpg", _uniformNumber]];
				sleep 1;
				waitUntil {uniform player != "U_O_CombatUniform_ocamo"};
			};
		};	
	};
*/
	case INDEPENDENT:
	{
		[] spawn
		{
			while {true} do
			{
				_uniformNumber = player getVariable ["uniform", 0];
				waitUntil {uniform player == "U_I_CombatUniform"};
				player setObjectTextureGlobal [0, format["client\images\uniformTextures\%1_I.jpg", _uniformNumber]];
				sleep 1;
				waitUntil {uniform player != "U_I_CombatUniform"};
			};
		};
	};

};

