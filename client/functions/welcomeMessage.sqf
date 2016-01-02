// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
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
		_teamcol = "#0066ff";
	};
	case OPFOR: {
		_teamrules = "STR_WL_YouAreInTeam";
		_teamicon = "client\icons\igui_side_opfor_ca.paa";
		_teamcol = "#ff1111";
	};
	default {
		_teamrules = "STR_WL_YouAreInFFA";
		_teamicon = "client\icons\igui_side_indep_ca.paa";
		_teamcol = "#00ff00";
	};
};

_message = format ["<t shadow=""1"">%1<br/>%2<br/>%3<br/></t>",
	localize "STR_WL_WelcomeToWasteland",
	localize "STR_WL_MapMoreInfo",
	format [localize _teamrules,
		_teamicon,
		_teamcol,
		localize format ["STR_WL_Gen_Team%1", str playerSide],
		localize format ["STR_WL_Gen_Team%1_2", str playerSide]
	]
];

_control ctrlSetStructuredText (parseText _message);

sleep 20;

_control ctrlSetFade 1;
_control ctrlCommit 2;

waitUntil {ctrlCommitted _control};

_control ctrlShow false;
_control ctrlCommit 0;
