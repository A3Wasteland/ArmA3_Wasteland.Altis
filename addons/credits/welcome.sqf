//	@file Version: 1.0
//	@file Name: intro.sqf
//	@file Author: Cael817, original file by HellsGateGaming.com and IT07
//	@file Created: 20140724 19:34

_onScreenTime = 20;

sleep 90;

_role1 = "Welcome to Ultra A3wasteland";
_role1names = ["Server Hosted in Dallas"];
_role2 = "Please report hackers to";
_role2names = ["Ftnwo.clan@gmail.com"];
_role3 = "Supported Mods";
_role3names = ["Install JSRS3: DragonFyre,Blastcore A3 Phoenix (v1 or v2)  for a better gaming experience *CBA v1.1.22.150602 Required* "];
_role4 = "TeamSpeak";
_role4names = ["tsdal1.vilayer.com:4071"];
_role5 = "Steam Group";
_role5names = ["Come join our Steam community. Search for UltraA3Wasteland on Steam"];

{
sleep 2;
_memberFunction = _x select 0;
_memberNames = _x select 1;
_finalText = format ["<t size='0.50' color='#f2cb0b' align='left'>%1<br /></t>", _memberFunction];
_finalText = _finalText + "<t size='0.70' color='#FFFFFF' align='left'>";
{_finalText = _finalText + format ["%1<br />", _x]} forEach _memberNames;
_finalText = _finalText + "</t>";
_onScreenTime + (((count _memberNames) - 1) * 0.5);
[
_finalText,
[safezoneX + safezoneW - 0.8,0.50], //DEFAULT: 0.5,0.35
[safezoneY + safezoneH - 0.8,0.7], //DEFAULT: 0.8,0.7
_onScreenTime,
0.5
] spawn BIS_fnc_dynamicText;
sleep (_onScreenTime);
} forEach [

[_role1, _role1names],
[_role2, _role2names],
[_role3, _role3names],
[_role4, _role4names],
[_role5, _role5names]
];