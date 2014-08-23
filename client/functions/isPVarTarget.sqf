//	@file Name: isPVarTarget.sqf
//	@file Author: AgentRev

switch (typeName _this) do
{
	case "BOOL":   { _this };
	case "OBJECT": { local _this };
	case "STRING": { local objectFromNetId _this };
	case "GROUP":  { group player == _this };
	case "SIDE":   { playerSide == _this };
	case "ARRAY":
	{
		_result = false;
		{ _result = _result || (_x call isPVarTarget) } forEach _this;
		_result
	};
	default { false };
}
