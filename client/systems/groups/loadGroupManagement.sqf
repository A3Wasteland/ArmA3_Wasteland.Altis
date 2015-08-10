// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: loadGroupManagement.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

#define groupManagementDialog 55510
#define groupManagementPlayerList 55511
#define groupManagementGroupList 55512
#define groupManagementPromoteButton 55513
#define groupManagementInviteButton 55514
#define groupManagementKickButton 55515
#define groupManagementDisbandButton 55516
#define groupManagementLeaveButton 55517
#define groupManagementAcceptButton 55518
#define groupManagementDeclineButton 55519
#define groupManagementInviteText 55520

disableSerialization;

private ["_start","_dialog","_myGroup","_playerListBox","_groupListBox","_uid","_namestr","_index","_groupCreate","_groupPromote","_groupInvite","_groupKick","_groupDisband","_groupLeaveButton","_inGroup","_isLeader","_name"];

//closeDialog 0;
_start = createDialog "GroupManagement";
waitUntil{!isNull(findDisplay groupManagementDialog)};
_dialog = findDisplay groupManagementDialog;
//_dialog displayAddEventHandler ["KeyDown", "_return = false; if(groupManagmentActive && (_this select 1) == 1) then {_return = true;}; _return"];
groupManagmentActive = true;
_playerListBox = _dialog displayCtrl groupManagementPlayerList;
_groupListBox = _dialog displayCtrl groupManagementGroupList;
_groupPromote = _dialog displayCtrl groupManagementPromoteButton;
_groupInvite = _dialog displayCtrl groupManagementInviteButton;
_groupKick = _dialog displayCtrl groupManagementKickButton;
_groupDisband = _dialog displayCtrl groupManagementDisbandButton;
_groupLeaveButton = _dialog displayCtrl groupManagementLeaveButton;
_groupAcceptInvite = _dialog displayCtrl groupManagementAcceptButton;
_groupDeclineInvite = _dialog displayCtrl groupManagementDeclineButton;
_groupInviteText = _dialog displayCtrl groupManagementInviteText;

_groupInvite ctrlShow false;
_groupKick ctrlShow false;
_groupDisband ctrlShow false;
_groupLeaveButton ctrlShow false;
_groupDeclineInvite ctrlShow false;
_groupAcceptInvite ctrlShow false;
_hasInvite = false;
while{groupManagmentActive} do
{
	_groupPromote ctrlShow (player == leader player);

	//Check if player has invite.
	{ if (_x select 1 == getPlayerUID player) exitWith { _hasInvite = true } } forEach currentInvites;

	//Member Controls
	if(count units player > 1) then
	{
		if(player == leader player) then
		{
			_groupDisband ctrlShow true;
			_groupKick ctrlShow true;
			_groupLeaveButton ctrlShow true;
		} else {
			_groupLeaveButton ctrlShow true;
		};
	} else {
		_groupKick ctrlShow false;
		_groupDisband ctrlShow false;
		_groupLeaveButton ctrlShow false;
	};

	//Sort Invite Controls
	if(_hasInvite) then
	{
		_groupInviteText ctrlShow true;
		_groupAcceptInvite ctrlShow true;
		_groupDeclineInvite ctrlShow true;

		//Get Invite Text and Set it.
		{
			_invite = _x;
			if (_invite select 1 == getPlayerUID player) then
			{
				{
					if (_invite select 0 == getPlayerUID _x) exitWith
					{
						_name = name _x;
					};
				} forEach allPlayers;
			};
		} forEach currentInvites;

		if (isStreamFriendlyUIEnabled) then {
			_name = "Censored(StreamFriendly:ON)";
		};
		_groupInviteText ctrlSetStructuredText parseText (format ["Group Invite From<br/>%1",_name]);
	} else {
		_groupAcceptInvite ctrlShow false;
		_groupDeclineInvite ctrlShow false;
		_groupInviteText ctrlShow false;
	};

	//Update player list
	{
		if (side group _x == playerSide && _x != player) then
	    {
	        //Add to list
			if (isStreamFriendlyUIEnabled) then {
				_namestr = "[PLAYER]";
			} else {
				_namestr = name _x;
			};
			_index = _playerListBox lbAdd _namestr;
			_playerListBox lbSetData [_index, getPlayerUID _x];
	    };
	} forEach allPlayers;

	//Update group player list
	{
		if (isStreamFriendlyUIEnabled) then {
			_namestr = "[PLAYER]";
		} else {
			_namestr = name _x;
		};
		_index = _groupListBox lbAdd _namestr;
		_groupListBox lbSetData [_index, getPlayerUID _x];
	} forEach units player;

	sleep 0.5;
	_hasInvite = false;
	lbClear _playerListBox;
	lbClear _groupListBox;
}
