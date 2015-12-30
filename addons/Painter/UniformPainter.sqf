// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: UniformPainter.sqf
//	@file Author: LouD
//	@file Created: 14-02-2015

_texDir = "client\images\vehicleTextures\";
_paint = _this select 0;

_price = 500;
_playerMoney = player getVariable "cmoney";

if (_price > _playerMoney) exitWith
	{
		_text = format ["Not enough money! You need $%1 to paint your clothes.",_price];
		[_text, 10] call mf_notify_client;
		playSound "FD_CP_Not_Clear_F";
	};

if (_price < _playerMoney) then	
	{
		player setVariable["cmoney",(player getVariable "cmoney")-_price,true];
		_text = format ["You paid $%1 to paint your clothes.",_price];
		[_text, 10] call mf_notify_client;		
		player spawn fn_savePlayerData;
	};

if (_paint == 0) then {
player setObjectTextureGlobal  [0, _texDir + "bloodshot.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "bloodshot.paa"];
};

if (_paint == 1) then {
player setObjectTextureGlobal  [0, _texDir + "camo_orange.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "camo_orange.paa"];
};

if (_paint == 2) then {
player setObjectTextureGlobal  [0, _texDir + "camo_pink.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "camo_pink.paa"];
};

if (_paint == 3) then {
player setObjectTextureGlobal  [0, _texDir + "camo_red.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "camo_red.paa"];
};

if (_paint == 4) then {
player setObjectTextureGlobal  [0, _texDir + "digi.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "digi.paa"];
};

if (_paint == 5) then {
player setObjectTextureGlobal  [0, _texDir + "digi_black.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "digi_black.paa"];
};

if (_paint == 6) then {
player setObjectTextureGlobal  [0, _texDir + "digi_desert.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "digi_desert.paa"];
};

if (_paint == 7) then {
player setObjectTextureGlobal  [0, _texDir + "digi_wood.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "digi_wood.paa"];
};

if (_paint == 8) then {
player setObjectTextureGlobal  [0, _texDir + "drylands.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "drylands.paa"];
};

if (_paint == 9) then {
player setObjectTextureGlobal  [0, _texDir + "hex.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "hex.paa"];
};

if (_paint == 10) then {
player setObjectTextureGlobal  [0, _texDir + "sand.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "sand.paa"];
};

if (_paint == 11) then {
player setObjectTextureGlobal  [0, _texDir + "swamp.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "swamp.paa"];
};

if (_paint == 12) then {
player setObjectTextureGlobal  [0, _texDir + "urban.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "urban.paa"];
};

if (_paint == 13) then {
player setObjectTextureGlobal  [0, _texDir + "woodland.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "woodland.paa"];
};

if (_paint == 14) then {
player setObjectTextureGlobal  [0, _texDir + "wooddark.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "wooddark.paa"];
};

if (_paint == 15) then {
player setObjectTextureGlobal  [0, _texDir + "woodtiger.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "woodtiger.paa"];
};

if (_paint == 16) then {
player setObjectTextureGlobal  [0, _texDir + "weed.paa"]; backpackContainer player setObjectTextureGlobal  [0, _texDir + "weed.paa"];
};