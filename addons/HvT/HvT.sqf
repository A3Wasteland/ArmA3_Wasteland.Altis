//	@file Version: 1.0
//	@file Name: HvT.sqf
//	@file Author: Cael817, CRE4MPIE, rewrite by LouD.
//	@file Info:

if (isDedicated) exitWith {};
waitUntil {!isNull player};
waitUntil {!isNil "playerSpawning" && {!playerSpawning}};

for "_i" from 0 to 1 step 0 do 
{
	if (isNil "createBountyMarker" && player getvariable "cmoney" > 74999) then
		{
			_title  = "<t color='#ff0000' size='1.2' align='center'>High Value Target! </t><br />";
			_name = format ["%1<br /> ",name player];     
			_text = "<t color='#FFFFFF' shadow='1' shadowColor='#000000' align='center'>Someone has spotted you carrying a large sum of money and has marked your location on the map!</t><br />";     
			hint parsetext (_title +  _name +  _text); 
			playsound "Topic_Done";

			createBountyMarker = 
			{
				_markerName = format ["%1_bountyMarker",name player];  
				_bountyMarker = createMarker [_markerName, getPos (vehicle player)];
				_bountyMarker setMarkerShape "ICON";
				_bounty = [player getVariable ["cmoney", 0]] call fn_numbersText;
				_bountyMarker setMarkerText (format ["High Value Target: %1 (%2$)", name player, _bounty]);
				_bountyMarker setMarkerColor "ColorRed";
				_bountyMarker setMarkerType "mil_dot";
				sleep 45;
				deleteMarker _markerName;
				createBountyMarker = nil;
			};
		[] spawn createBountyMarker;	
		};
}; //will run infinitely
