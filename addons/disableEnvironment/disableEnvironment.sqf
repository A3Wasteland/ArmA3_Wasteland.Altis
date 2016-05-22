//	@file Name: disableEnvinronment.sqf
//	@file Author: CRE4MPIE


waitUntil {time > 0};
if (soundVolume > 0.99) then
		{
			0.5 fadeSound 0.98;
			enableEnvironment false;
			["Environment effects Disabled.", 5] call mf_notify_client;
		}
		else
		{
			0.5 fadeSound 1;
			enableEnvironment true;
			["Environment effects Enabled.", 5] call mf_notify_client;
		};



