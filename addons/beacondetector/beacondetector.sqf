//	@file Version: 1.0
//	@file Name: beacondetector.sqf
//	@file Author: wiking.at
//	Allows tracking of spawn beacons

// Check if script is already active
if (BeaconScanInProgress) exitWith
{
	["You are already performing another beacon scan.", 5] call mf_notify_client;
};

_beaconsnear = nearestObjects [player, ["Land_Tentdome_F"], 100];

if ((count _beaconsnear) > 0 ) then 
	{
	
	playsound "beep9"; ["Spawn beacon found - tracking started.", 5] call mf_notify_client;
	BeaconScanInProgress = true;
	Beaconscanstop = false;
	
	_distance = 0; //init distance
	
	while {_distance < 100} do
		{	
		_beaconsnear = nearestObjects [player, ["Land_Tentdome_F"], 100];
		
		if (Beaconscanstop) exitwith 
			{
			playsound "beep9";
			["Spawn beacon scan interrupted.", 5] call mf_notify_client;
			BeaconScanInProgress = false;
			};
		
		if (count _beaconsnear == 0) exitwith 
			{
			playsound "beep9";
			["No spawn beacon in detector range.", 5] call mf_notify_client;
			BeaconScanInProgress = false;
			};
		
		_nearestbeacon = _beaconsnear select 0;
		_distance = player distance _nearestbeacon;
		_dir = getdir (vehicle player);
		_degree = ((getpos _nearestbeacon select 0) - (getpos player select 0)) atan2 ((getpos _nearestbeacon select 1) - (getpos player select 1));
		if (_degree < 0) then { _degree = _degree + 360};
		_difference = _degree - _dir;
		if (_difference > 180) then { _difference = _difference - 360};
		if (_difference < -180) then { _difference = _difference + 360};
		_adjusteddiff = (abs _difference);
		_beepfreq = ((_adjusteddiff / 50) + 0.25);	
		
		
		
			switch (true) do 
				{
				case (_distance < 6) : {playsound "beep6";};
				case (_distance < 10) : {playsound "beep5";};
				case (_distance < 20) : {playsound "beep4";};
				case (_distance < 30) : {playsound "beep3";};
				case (_distance < 50) : {playsound "beep2";};
				case (_distance < 100) : {playsound "beep";};
				default {
						//default case should not happen
						playsound "beep9";
						["There was a malfunction of your beacon detector.", 5] call mf_notify_client;
						};
				};
			sleep _beepfreq;
			
		};
	}
else
{
playsound "beep9";
["No Spawn beacon in detector range.", 5] call mf_notify_client;
};