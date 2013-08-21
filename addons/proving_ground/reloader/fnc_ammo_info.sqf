#include "defs.hpp"
disableSerialization;
_ctrl = _this select 0 select 0;
_index = _this select 0 select 1;

_mag = _ctrl lbData _index;

_count = getNumber(configFile>>"CfgMagazines">>_mag>>"count");
_displayName = getText (configFile >> "CfgMagazines" >> _mag >> "displayName");
_initSpeed = getnumber(configFile >> "cfgMagazines" >> _mag >> "initSpeed");
_shell = gettext(configFile >> "cfgMagazines" >> _mag >> "ammo");
_displayName = getText (configFile >> "CfgAmmo" >> _shell >> "displayName");
_hit = getnumber(configFile >> "cfgAmmo" >> _shell >> "hit");
_indirectHit = getnumber(configFile >> "cfgAmmo" >> _shell >> "indirectHit");
_indirectHitRange = getnumber(configFile >> "cfgAmmo" >> _shell >> "indirectHitRange");
_ACE_damage = getnumber(configFile >> "cfgAmmo" >> _shell >> "ACE_hit");
_timeToLive = getnumber(configFile >> "cfgAmmo" >> _shell >> "timeToLive");


_lb = parseText "<br/>";
_text = composeText [str _shell,_lb,"Count: ",str _count,_lb,"Damage: ", str _hit,_lb];
if (_ACE_damage >0) then {
_text = composeText [_text,"ACE damage: ",str _ACE_damage,_lb];
};
if (_indirectHit >0) then {
_text = composeText [_text,"Indirect damage: ",str _indirectHit,_lb,"Explosion radius: ", str _indirectHitRange,_lb];
};
_text = composeText [_text,"InitSpeed: ",str _initSpeed,_lb,"LifeTime:", str _timeToLive];
GET_CTRL(balca_loader_ammo_info_IDC) ctrlSetStructuredText _text;