//	@file Name: init.sqf
//	@file Author: xx-LSD-xx

#define MAIN_DISPLAY (findDisplay 46)
#define PAGE_UP 201
#define PAGE_DOWN 209
#define MIN_SENSITIVITY 1
#define MAX_SENSITIVITY 20
#define INCREMENT 1

if (!hasInterface) exitWith {};

lsd_nvOn = false;
lsd_nvSensitivity = 20;
lsd_nvSensitivityBar =
[
	"Dummy",
	"|<t color='#666666'>||||||||||||||||||</t>",
	"||<t color='#666666'>|||||||||||||||||</t>",
	"|||<t color='#666666'>||||||||||||||||</t>",
	"||||<t color='#666666'>|||||||||||||||</t>",
	"|||||<t color='#666666'>||||||||||||||</t>",
	"||||||<t color='#666666'>|||||||||||||</t>",
	"|||||||<t color='#666666'>||||||||||||</t>",
	"||||||||<t color='#666666'>|||||||||||</t>",
	"|||||||||<t color='#666666'>||||||||||</t>",
	"||||||||||<t color='#666666'>|||||||||</t>",
	"|||||||||||<t color='#666666'>||||||||</t>",
	"||||||||||||<t color='#666666'>|||||||</t>",
	"|||||||||||||<t color='#666666'>||||||</t>",
	"||||||||||||||<t color='#666666'>|||||</t>",
	"|||||||||||||||<t color='#666666'>||||</t>",
	"||||||||||||||||<t color='#666666'>|||</t>",
	"|||||||||||||||||<t color='#666666'>||</t>",
	"||||||||||||||||||<t color='#666666'>|</t>",
	"|||||||||||||||||||<t color='#666666'></t>",
	"Auto"
];

// wait until in game before adding the keyEH
waitUntil {!isNull MAIN_DISPLAY};

MAIN_DISPLAY displayAddEventHandler ["KeyDown",
{
	private ["_ctrlID", "_dikCode", "_shift", "_ctrl", "_alt", "_handled"];

	_ctrlID = _this select 0;
	_dikCode = _this select 1;
	_shift = _this select 2;
	_ctrl = _this select 3;
	_alt = _this select 4;
	_handled = false;

	// if there's a dialog or map up, or there is no nv, just quit
	// 	shift is required now
	if ( dialog || visibleMap || !lsd_nvOn || !_shift) exitWith { false };

	switch (_dikCode) do
	{
		case PAGE_UP:
		{
			if (lsd_nvSensitivity < MAX_SENSITIVITY) then
			{
				lsd_nvSensitivity = lsd_nvSensitivity + INCREMENT;
				_handled = true;
			};
		};
		case PAGE_DOWN:
		{
			if (lsd_nvSensitivity > MIN_SENSITIVITY) then
			{
				lsd_nvSensitivity = lsd_nvSensitivity - INCREMENT;
				_handled = true;
			};
		};
	};

	if (_handled) then
	{
		if (lsd_nvSensitivity >= MAX_SENSITIVITY) then // go to auto mode
		{
			setAperture -1;
		}
		else // manual mode
		{
			setAperture (lsd_nvSensitivity / 2);
		};

		playSound "FD_Timer_F";

		("lsd_Rsc_nvHint" call BIS_fnc_rscLayer) cutRsc ["LSD_Rsc_nvHint","PLAIN"];
		((uiNamespace getVariable "LSD_Rsc_nvHint") displayCtrl 1) ctrlSetStructuredText parseText(lsd_nvSensitivityBar select lsd_nvSensitivity);
	};

	_handled
}];

0 spawn
{
	waitUntil
	{
		if !(isNull player) then
		{
			if (currentVisionMode player == 1) then
			{
				if (!lsd_nvOn) then
				{
					if (lsd_nvSensitivity >= MAX_SENSITIVITY) then // go to auto mode
					{
						setAperture -1;
					}
					else // manual mode
					{
						setAperture (lsd_nvSensitivity / 2);
					};

					lsd_nvOn = true;
				};
			}
			else
			{
				if (lsd_nvOn) then
				{
					setAperture -1;
					lsd_nvOn = false
				};
			};
		};

		sleep 0.1;
		false
	};
};
