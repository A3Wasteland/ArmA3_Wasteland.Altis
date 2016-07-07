// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_isMineSaveable.sqf
//	@file Author: AgentRev

params ["_dummy"];
private _linkedBomb = _dummy getVariable ["A3W_stickyCharges_linkedBomb",0];

// exclude RemoteTrigger = don't save remote charges since they are useless after restart
(_linkedBomb isEqualType objNull && {mineActive _linkedBomb && {
	private _class = typeOf _linkedBomb;
	(toLower _class) in A3W_mineSaving_ammoClasses && getText (configfile >> "CfgAmmo" >> _class >> "mineTrigger") != "RemoteTrigger"
}})
