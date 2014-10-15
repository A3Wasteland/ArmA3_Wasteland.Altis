//	@file Name: sellIncludesEnd.sqf
//	@file Author: AgentRev

if (typeName storeSellingHandle == "SCRIPT") then
{
	private "_storeSellingHandle";
	_storeSellingHandle = storeSellingHandle;
	waitUntil {scriptDone _storeSellingHandle};
};

storeSellingHandle = nil;
