//	@file Version: 1.0
//	@file Name: init.sqf
//	@file Author: AgentRev
//	@file Created: 29/06/2013 12:09

// Add custom scripts you wish to be executed on server start here
// config.sqf, admins.sqf, and serverRules.sqf are already loaded automatically

execVM (externalConfigFolder + "\bannedNames.sqf");
