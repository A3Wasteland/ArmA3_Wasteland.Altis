#define welcomeText 3200

10 cutrsc["WelcomeMessage", "PLAIN"];

disableSerialization;

_display = uiNamespace getVariable "WelcomeMessage";
_control = _display displayCtrl welcomeText;

private ["_teamrules", "_teamicon", "_teamcol"];

switch (playerSide) do {
	case BLUFOR: { 
		_teamrules = "STR_WL_YouAreInTeam";
		_teamicon = "client\icons\igui_side_blufor_ca.paa";
		_teamcol = "#3333ff";
	};
	case OPFOR: {
		_teamrules = "STR_WL_YouAreInTeam";
		_teamicon = "client\icons\igui_side_opfor_ca.paa";
		_teamcol = "#cc0000";
	};
	case INDEPENDENT: {
     _teamrules = "STR_WL_YouAreInFFA";
     _teamicon = "client\icons\igui_side_indep_ca.paa";
     _teamcol = "#00cc00";
	};
	case sideEnemy: { 
		_teamrules = "STR_WL_YouAreInFFA";
		_teamicon = "client\icons\igui_side_indep_ca.paa";
		_teamcol = "#00cc00";
	};
};

_message = format ["<t shadow=""1""><t size=""2"">%1</t> (%2)<br/>%4<br/>%3<br/><img size=""6"" image=""client\icons\logo.paa""></t>",
	localize "STR_WL_WelcomeToWasteland",
	versionName,
	format [localize _teamrules, 
		_teamicon,
		_teamcol,
		localize format ["STR_WL_Gen_Team%1", str playerSide],
		localize format ["STR_WL_Gen_Team%1_2", str playerSide] 
	],
	localize "STR_WL_MapMoreInfo"
];

_control ctrlSetStructuredText (parseText _message);

sleep 20;

_control ctrlSetFade 1;
_control ctrlCommit 2;

waitUntil {ctrlCommitted _control};

_control ctrlShow false;
_control ctrlCommit 0;