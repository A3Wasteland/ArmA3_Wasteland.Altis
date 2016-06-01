// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
// @file Name: applyPlayerTexture.sqf
// @file Author: LouD
// @file Description: Small script to apply the uniform texture outside of applyPlayerData.sqf

_player = _this select 0;
_texture = _this select 1;

sleep 1;
waitUntil {local _player};
_player setObjectTextureGlobal _texture;