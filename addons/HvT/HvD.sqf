//	@file Version: 1.0
//	@file Name: HvD.sqf
//	@file Author: Based on HvT.sqf by Cael817, CRE4MPIE. Rewrite by LouD.
//	@file Info:

if (isDedicated) exitWith {};
waitUntil {!isNull player};
waitUntil {!isNil "playerSpawning" && {!playerSpawning}};

for "_i" from 0 to 1 step 0 do 
{
	_lsdInv = "lsd" call mf_inventory_get; _lsd = _lsdInv select 1;
	_marInv = "marijuana" call mf_inventory_get; _mar = _marInv select 1;
	_cocInv = "cocaine" call mf_inventory_get; _coc = _cocInv select 1;
	_herInv = "heroin" call mf_inventory_get; _her = _herInv select 1;
	
	"lsd" call mf_inventory_get;
	
	if (isNil "createDrugsMarker" && _lsd > 3 || isNil "createDrugsMarker" && _mar > 3 || isNil "createDrugsMarker" && _coc > 3 || isNil "createDrugsMarker" && _her > 3) then
		{
			_title  = "<t color='#ff0000' size='1.2' align='center'>Drugsrunner! </t><br />";
			_name = format ["%1<br /> ",name player];     
			_text = "<t color='#FFFFFF' shadow='1' shadowColor='#000000' align='center'>Someone has spotted you carrying drugs and has marked your location on the map!</t><br />";     
			hint parsetext (_title +  _name +  _text); 
			playsound "Topic_Done";

			createDrugsMarker = 
			{
				_markerName = format ["%1_drugsMarker",name player];     
				_drugMarker = createMarker [_markerName, getPos (vehicle player)];
				_drugMarker setMarkerShape "ICON";
				_drugMarker setMarkerText (format ["Drugsrunner: %1", name player]);
				_drugMarker setMarkerColor "ColorRed";
				_drugMarker setMarkerType "mil_dot";
				sleep 45;
				deleteMarker _markerName;
				createDrugsMarker = nil;
			};
		[] spawn createDrugsMarker;	
		};
}; //will run infinitely
