// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: loadTOParmaInfo.sqf
//	@file Author: Lodac

#include "dialog\TOParmaInfo_defines.hpp"


//private ["_display", "_map", "_mission", "_player", "_newsOnline", "_newsOffline", "_ctrlHTML", "_htmlLoaded"];

disableSerialization;

_uid = getPlayerUID player;

createDialog "TOParmaInfoD";

_display = (findDisplay TOParmaInfo_dialog);

_serverInfoText = _display displayCtrl TOParmaInfo_Server_Info;
_serverInfoString = format ["<t color='#A0FFFF'>40-1 #%1 %2 Wasteland</t>", call A3W_extDB_ServerID, worldName];
_serverInfoText ctrlSetStructuredText parseText _serverInfoString;

_generalInfoText = _display displayCtrl TOParmaInfo_General_Info_BG;
_generalInfoString = "Website: <t color='#0091CD'><a href='http://www.40-1.net'>40-1.net</a></t> Forums: <t color='#0091CD'><a href='http://www.40-1.net'>40-1 Forum</a></t> TeamSpeak: 40-1.teamspeak3.40-1.net";
_generalInfoText ctrlSetStructuredText parseText _generalInfoString;


_rulesOnline = "http://arma.40-1.net/r";
_rulesOffline = "addons\TOParmaInfo\rules.html";
_newsOnline = "http://arma.40-1.net.php";
_newsOffline = "addons\TOParmaInfo\news.html";
_statsOnline = "http://arma.40-1.net/stats.php?uid=" + _uid;
_statsOnline = "http://arma.40-1.net/stats.php";
_statsOffline = "addons\TOParmaInfo\stats.html";


//Load the correct HTML into the control
_ctrlHTML = _display displayCtrl TOParmaInfo_Content_Rules;
_ctrlHTML htmlLoad _rulesOnline;
_htmlLoaded = ctrlHTMLLoaded _ctrlHTML;
if (!_htmlLoaded) then 
{
	_ctrlHTML htmlLoad _rulesOffline;
};
_ctrlHTML = _display displayCtrl TOParmaInfo_Content_News;
_ctrlHTML htmlLoad _newsOnline;
_htmlLoaded = ctrlHTMLLoaded _ctrlHTML;
if (!_htmlLoaded) then 
{
	_ctrlHTML htmlLoad _newsOffline;
};
_ctrlHTML = _display displayCtrl TOParmaInfo_Content_Stats;
_ctrlHTML htmlLoad _statsOnline;
_htmlLoaded = ctrlHTMLLoaded _ctrlHTML;
if (!_htmlLoaded) then 
{
	_ctrlHTML htmlLoad _statsOffline;
};

_control = _display displayCtrl TOParmaInfo_Content_A3W;
private ["_teamrules", "_teamicon", "_teamcol"];

switch (playerSide) do {
	case BLUFOR: {
		_teamrules = "STR_WL_YouAreInTeam";
		_teamicon = "client\icons\igui_side_blufor_ca.paa";
		_teamcol = "#0066ff";
	};
	case OPFOR: {
		_teamrules = "STR_WL_YouAreInTeam";
		_teamicon = "client\icons\igui_side_opfor_ca.paa";
		_teamcol = "#ff1111";
	};
	case INDEPENDENT: {
		_teamrules = "STR_WL_YouAreInFFA";
		_teamicon = "client\icons\igui_side_indep_ca.paa";
		_teamcol = "#00ff00";
	};
	case sideEnemy: {
		_teamrules = "STR_WL_YouAreInFFA";
		_teamicon = "client\icons\igui_side_indep_ca.paa";
		_teamcol = "#00ff00";
	};
};

_message = format ["<t shadow=""1"">%1<br/>%2<br/>%3<br/></t>",
	//localize "STR_WL_WelcomeToWasteland",
	localize "STR_WL_MapMoreInfo",
	format [localize _teamrules,
		_teamicon,
		_teamcol,
		localize format ["STR_WL_Gen_Team%1", str playerSide],
		localize format ["STR_WL_Gen_Team%1_2", str playerSide]
	]
];

_control ctrlSetStructuredText (parseText _message);
