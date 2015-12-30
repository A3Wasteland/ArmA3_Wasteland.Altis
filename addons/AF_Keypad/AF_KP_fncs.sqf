//This checks the variables passed in the execVM statments("number","enter" or "clear")
switch (_this select 0) do {
	case "number": {
		InputText = InputText + format["%1", _this select 1];
		ctrlSetText[1000, InputText];
	};
	
	case "clear": {
		InputText = "";
		ctrlSetText[1000, ClearText];
	};
	
	case "enter": {
		OutputText = InputText;
		//hint format["Keycode is %1", OutputText];
		closeDialog 0;
		InputText = "";
	};
};