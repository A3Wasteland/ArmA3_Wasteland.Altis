// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: killFeed.sqf
//	@file Author: AgentRev

scriptName "killFeed";

while {true} do
{
	call fn_killFeedRefresh;
	waitUntil {uiSleep 0.1; scriptDone ([missionNamespace getVariable "A3W_killFeed_refreshThread"] param [0,scriptNull,[scriptNull]])};
	uiSleep 0.9;
};
