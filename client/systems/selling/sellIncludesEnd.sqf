// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: sellIncludesEnd.sqf
//	@file Author: AgentRev

if (typeName storeSellingHandle == "SCRIPT") then
{
	private "_storeSellingHandle";
	_storeSellingHandle = storeSellingHandle;
	waitUntil {scriptDone _storeSellingHandle};
};

storeSellingHandle = nil;
