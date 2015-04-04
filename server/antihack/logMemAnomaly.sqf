// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: logMemAnomaly.sqf
//	@file Author: AgentRev

// For debugging purposes, in order to implement memory validation later on

if (typeName _this == "ARRAY" && {count _this > 1}) then
{
	private "_sentChecksum";
	_sentChecksum = _this select 1;

	if (_sentChecksum == _flagChecksum) then
	{
		private "_buffer";
		_buffer = toArray ("ANTI-HACK - Memory anomaly detected, send full log to AgentRev - " + str (_this select 0));

		while {count _buffer > 0} do
		{
			diag_log toString (_buffer select [0, 1021]);
			_buffer deleteRange [0, 1021];
		};
	};
};
