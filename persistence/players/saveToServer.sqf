private ["_save"];
_save =
"
	accountToServerSave = _this;
	publicVariableServer 'accountToServerSave';
";

fn_SaveToServer = compile _save;