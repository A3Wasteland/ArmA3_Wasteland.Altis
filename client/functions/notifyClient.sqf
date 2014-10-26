// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: notifyClient.sqf
//	@file Author: MercyfulFate
//  @file Description: Display a message to the client for a set number of seconds
//	@file Args: [_text, _time] the text and duration of the message

assert (count _this == 2);

private ["_text", "_time"];

_text = _this select 0;
_time = _this select 1;

titleText [_text, "PLAIN DOWN", _time / 10];
