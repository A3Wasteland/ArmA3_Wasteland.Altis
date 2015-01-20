// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: logBankTransfer.sqf
//	@file Author: AgentRev

#define FILTERED_CHARS [58] // colon

private ["_senderName", "_senderUID", "_senderSide", "_recipientName", "_recipientUID", "_recipientSide", "_amount", "_fee"];
_senderName = _this select 0;
_senderUID = _this select 1;
_senderSide = _this select 2;
_recipientName = _this select 3;
_recipientUID = _this select 4;
_recipientSide = _this select 5;
_amount = _this select 6;
_fee = _this select 7;

[format ["addBankTransferLog:%1:%2:%3:%4:%5:%6:%7:%8:%9", call A3W_extDB_ServerID, toString (toArray _senderName - FILTERED_CHARS), _senderUID, _senderSide, toString (toArray _recipientName - FILTERED_CHARS), _recipientUID, _recipientSide, _amount, _fee]] call extDB_Database_async;
