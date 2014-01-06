#include "defs.hpp"
#define GET_DISPLAY (findDisplay balca_debug_WC_IDD)
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)
#define GET_SELECTED_DATA(a) ([##a] call {_idc = _this select 0;_selection = (lbSelection GET_CTRL(_idc) select 0);if (isNil {_selection}) then {_selection = 0};(GET_CTRL(_idc) lbData _selection)})
#define __cfgWeap configFile >> "cfgWeapons"


_mode = _this select 0;
_item_type = _this select 1;
switch (_mode) do {
case 0: {//fill weapon list
		_cfgweapons = configFile >> "cfgWeapons";
		_type = 1;
		switch (_item_type) do {
			case 0: {_type = [1];};//rifles
			case 1: {_type = [1];};//scoped rifles
			case 2: {_type = [1,5];};//heavy
			case 3: {_type = [4];};//secondary weapon
			case 4: {_type = [2];};//pistol
			case 5: {_type = [0];};//put/throw
			case 6: {_type = [4096];};//BinocularSlot
			case 7: {_type = [131072];};//SmallItems
			default {_type = [1];};
		};
		lbClear GET_CTRL(balca_WC_weaplist_IDC);
		for "_i" from 0 to (count _cfgweapons)-1 do {
			_weapon = _cfgweapons select _i;
			if (isClass _weapon) then {
				_weap_type = configName(_weapon);
				_cur_type = getNumber(_weapon >> "type");
				_display_name = getText(_weapon >> "displayName");
				_no_pack = getNumber(_weapon >> "ACE_nopack");
				_optics = getText(_weapon >> "ModelOptics");
				//diag_log format ["%1",[_weap_type,_cur_type,_no_pack]];
				if (((((getNumber(_weapon >> "scope")==2)&&(getText(_weapon >> "model")!="")&&(_display_name!=""))||((_item_type==5)&&(getNumber(_weapon >> "scope")>0)))&&(_cur_type in _type)&&(_display_name!=""))
				&&
				((_item_type in [3,4,5,6,7])||((_item_type==0)&&(_no_pack!=1)&&((_optics=="-")))||((_item_type==1)&&(_no_pack!=1)&&((_optics!="-")))||((_item_type==2)&&((_cur_type==5)||((_no_pack==1)&&(_cur_type in _type)))))) then {
					GET_CTRL(balca_WC_weaplist_IDC) lbAdd _display_name;
					GET_CTRL(balca_WC_weaplist_IDC) lbSetData [(lbSize GET_CTRL(balca_WC_weaplist_IDC))-1,_weap_type];
					GET_CTRL(balca_WC_weaplist_IDC) lbSetPicture [(lbSize GET_CTRL(balca_WC_weaplist_IDC))-1,getText(_weapon >> "picture")];
				
				
				
				};
			};
		};
		lbSort GET_CTRL(balca_WC_weaplist_IDC);		


	};
case 1: {//weap info, fill magazines
		_weap_type = GET_SELECTED_DATA(balca_WC_weaplist_IDC);
		_weapon = (configFile >> "cfgWeapons" >> _weap_type);
		_displayName = getText(_weapon >> "displayName");
		_picture = getText(_weapon >> "picture");
		_library = getText(_weapon >> "Library" >> "libTextDesc");
		_dispersion = getNumber(_weapon >> "dispersion");
		_magazines = [];
		{
			_magazines = _magazines + getArray( (if ( _x == "this" ) then { _weapon } else { _weapon >> _x }) >> "magazines")
		} forEach getArray(_weapon >> "muzzles");
		_dispersion = getNumber(_weapon >> "dispersion");
		{
			_dispersion =  getNumber(_weapon >> _x >> "dispersion")
		} forEach getArray (_weapon >> "modes");
		GET_CTRL(balca_WC_weapon_shortcut_IDC) ctrlSetText (_picture);
		_lb = parseText "<br/>";
		_text = composeText ["Class: ",str configName(_weapon),_lb,
			"DisplayName: ",str _displayName,_lb,
			"Dispersion: ",str _dispersion,_lb,_lb,
			 parseText _library];
		GET_CTRL(balca_WC_weap_info_IDC) ctrlSetStructuredText _text;
		lbClear GET_CTRL(balca_WC_magazinelist_IDC);
		{
			GET_CTRL(balca_WC_magazinelist_IDC) lbAdd (getText(configFile >> "cfgMagazines" >> _x >> "displayName"));
			GET_CTRL(balca_WC_magazinelist_IDC) lbSetData [(lbSize GET_CTRL(balca_WC_magazinelist_IDC))-1,configName(configFile >> "cfgMagazines" >> _x)];
			GET_CTRL(balca_WC_magazinelist_IDC) lbSetPicture [(lbSize GET_CTRL(balca_WC_magazinelist_IDC))-1,getText(configFile >> "cfgMagazines" >> _x >> "picture")];
		} forEach _magazines;

	};

case 2: {//addweapon
		PG_set(MAGS,[]);
		[GET_SELECTED_DATA(balca_WC_weaplist_IDC)] call PG_get(FNC_ADD_WEAPON);
		PG_set(WEAPONS,weapons player);
	};

case 3: {//ammo info
		_mag = GET_SELECTED_DATA(balca_WC_magazinelist_IDC);
		_count = getNumber(configFile>>"CfgMagazines">>_mag>>"count");
		_displayName = getText (configFile >> "CfgMagazines" >> _mag >> "displayName");
		_initSpeed = getNumber(configFile >> "cfgMagazines" >> _mag >> "initSpeed");
		_shell = getText(configFile >> "cfgMagazines" >> _mag >> "ammo");
		_displayName = getText (configFile >> "CfgAmmo" >> _shell >> "displayName");
		_hit = getNumber(configFile >> "cfgAmmo" >> _shell >> "hit");
		_indirectHit = getNumber(configFile >> "cfgAmmo" >> _shell >> "indirectHit");
		_indirectHitRange = getNumber(configFile >> "cfgAmmo" >> _shell >> "indirectHitRange");
		_ACE_damage = getNumber(configFile >> "cfgAmmo" >> _shell >> "ACE_hit");
		_timeToLive = getNumber(configFile >> "cfgAmmo" >> _shell >> "timeToLive");
		_airFriction = getNumber(configFile >> "cfgAmmo" >> _shell >> "airFriction");

		_lb = parseText "<br/>";
		_text = composeText ["Class: ",str _mag,_lb,
			"Ammo class: ",str _shell,_lb,
			"DisplayName: ",str _displayName,_lb,
			"Count: ",str _count,_lb,
			"Damage: ", str _hit,_lb];
		if (_ACE_damage >0) then {
		_text = composeText [_text,"ACE damage: ",str _ACE_damage,_lb];
		};
		if (_indirectHit >0) then {
		_text = composeText [_text,"Indirect damage: ",str _indirectHit,_lb,"Explosion radius: ", str _indirectHitRange,_lb];
		};
		_text = composeText [_text,"InitSpeed: ",str _initSpeed,_text,"AirFriction: ",str _airFriction,_lb,"LifeTime: ", str _timeToLive];
		GET_CTRL(balca_WC_magazine_info_IDC) ctrlSetStructuredText _text;
	};

case 4: {//addMagazine
		_mag = GET_SELECTED_DATA(balca_WC_magazinelist_IDC);
		player addMagazine _mag;
		PG_set(MAGS,magazines player);
	};

case 5: {//weap to clipboard
	copyToClipboard (""""+GET_SELECTED_DATA(balca_WC_weaplist_IDC)+"""");
	};

case 6: {//ammo to clipboard
	copyToClipboard (""""+GET_SELECTED_DATA(balca_WC_magazinelist_IDC)+"""");
	};
};