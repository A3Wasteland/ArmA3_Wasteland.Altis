// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: missionHint.sqf
//	@file Author: AgentRev
//	@file Created: 09/01/2014 20:30

private ["_title", "_subTitle", "_picture", "_text", "_titleColor"];

_title = param [0, "?"];
_subtitle = param [1, ""];
_picture = param [2, "", [""]];
_text = param [3, ""];
_titleColor = param [4, "", [""]];

[
	parseText format
	[
		"<t color='%5' shadow='2' size='1.75'>%1</t><br/>" +
		"<t color='%5'>--------------------------------</t><br/>" +
		(if (_subtitle != "") then { "<t size='1.25'>%2</t><br/>" } else { "" }) +
		(if (_picture != "") then { "<img size='5' image='%3'/><br/>" } else { "" }) +
		"%4",
		_title,
		_subtitle,
		_picture,
		_text,
		_titleColor
	]
] call hintBroadcast;
