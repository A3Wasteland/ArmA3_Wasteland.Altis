//ALL FUNCTIONS MADE BY JTS

waitUntil {!isNull player}; // Do not remove that


// EDITABLE VARIABLES (BEGIN)

JTS_MSG_STR = "Messenger";		// Text, which will be displayed in action menu
JTS_ALLOW_PM = 0; 				// if 0 - receiving of personal messages on mission start is allowed. If 1 - receiving of personal messages on mission start is prohibited
JTS_SIDES = 0; 				// if 0 - list for player will be filled with all players, no matter on which side they are. If 1 - list for player will be filled only with players on the same side
JTS_MSG_COLOR = "#980000";			// Color of the text in action menu. The colors you can find here: http://www.w3schools.com/html/html_colors.asp

// EDITABLE VARIABLES (END)

player setVariable ["JTS_PM_STAT",JTS_ALLOW_PM,true];

JTS_DLPM = 0;
JTS_SUBJECT = 0;
JTS_PM_ARRAY = [];

if (JTS_SIDES > 0) then {JTS_ALLOWED_SIDES = {(side _x == side player)}} else {JTS_ALLOWED_SIDES = true};

JTS_FNC_PM =
{
	private "_Find";

	JTS_PM_UNP = playAbleUnits;
	JTS_DLPM = 1;

	lbClear 00002;
	lbClear 00003;
	lbClear 00005;

	ctrlEnable [00002, false];
	ctrlEnable [00003, false];
	ctrlEnable [00005, false];
	ctrlEnable [00008, false];
	ctrlEnable [00009, false];
	ctrlEnable [00010, false];
	ctrlEnable [00011, false];

	for "_i" from 0 to (count JTS_PM_ARRAY) do
	{
		lbAdd [00002, (JTS_PM_ARRAY select _i) select 0];
		lbSetData [00002, (lbSize 00002) - 1, (JTS_PM_ARRAY select _i) select 1];
	};

	_Find = 0;
	{
     		if (!isNull _x) then
     		{
          		if (alive _x && isPlayer _x && JTS_ALLOWED_SIDES) then
          		{

               		lbAdd [00003, name _x];
               		lbSetValue [00003, (lbSize 00003) - 1, _Find];
        		};	_Find = _Find + 1;
     		};
	} forEach JTS_PM_UNP;

	lbsetcursel [00002, (lbSize 00002)];
	lbsetcursel [00003, 0];

	ctrlEnable [00002, true];
	ctrlEnable [00003, true];
	ctrlEnable [00005, true];
	ctrlEnable [00009, true];
	ctrlEnable [00010, true];
	ctrlEnable [00011, true];

	ctrlsettext [00007, Format ["Inbox: %1", lbSize 00002]];

	JTS_DLPM = 0;
};

JTS_FNC_SENT =
{
	_Title = _this select 0;
	_PM = _this select 1;

	JTS_PM_ARRAY set [count JTS_PM_ARRAY, [_Title, _PM]];
	hint parsetext "<t align='center'><img image='addons\JTS_PM\icons\Message.paa' size='1' shadow='false'/></t><br/><br/><t size='1.0'>You've Got a Text Message!</t>";

	if (alive player && dialog && JTS_DLPM < 1) then
	{
		{[] spawn _x} foreach [JTS_FNC_PM,JTS_FNC_PM_ENABLED,JTS_FNC_STATUS]
	}

	else
	{
		closedialog 0
	};
};

JTS_FNC_SEND =
{
	private ["_Size","_Title","_Message","_PM","_Receiver","_Validating","_Verify"];

	_Size = count (toArray (ctrltext 00006));
	_Title = ctrltext 00006;
	_Message = ctrltext 00004;
	_PM = Format ["From: %1\n\n%2", name player, ctrlText 00004];
	_Receiver = JTS_PM_UNP select (lbValue [00003, lbCursel 00003]);
	_Verify = 0;

	if (_Size > 15 || lbSize 00003 < 1) then
	{
		ctrlsettext [00007, "Error sending PM"];
		{ctrlsettext [_x, ""]} foreach [00004, 00006];
	}

	else
	{
		if (!(_Receiver call JTS_FNC_VALID)) then
		{
			ctrlsettext [00007, "Player doesn't respond"];
			{ctrlsettext [_x, ""]} foreach [00004,00006];
		}

		else
		{
			if (count (toArray _Title) < 2) then
			{
				ctrlsettext [00007, "Title is too small"];
			}

			else
			{
				if (_Receiver getVariable "JTS_PM_STAT" > 0) then
				{
					ctrlsettext [00007, "Player does not receive PM's"];
				}

				else
				{
					_Validating = toArray _Title;

					for "_i" from 0 to count _Validating do
					{
						if (_Validating select _i == 32) then
						{
							_Verify = _Verify + 1
						}
					};

					if (_Verify == count _Validating) then
					{
						_Title = Format ["No subject [%1] [%2]", name player, JTS_SUBJECT];
						JTS_SUBJECT = JTS_SUBJECT + 1;
					};

					ctrlsettext [00007, Format ["PM sent to %1", name _Receiver]];
					[[_Title, _PM],"JTS_FNC_SENT",_Receiver,false] spawn BIS_fnc_MP;
					{ctrlsettext [_x, ""]} foreach [00004, 00006];
				};
			};
		};
	};				[] spawn {JTS_DLPM = 1;ctrlEnable [00009, false];ctrlEnable [00011, false];sleep 3;ctrlEnable [00009, true];ctrlEnable [00011, true];JTS_DLPM = 0;if (alive player && dialog) then {{[] spawn _x} foreach [JTS_FNC_PM,JTS_FNC_PM_ENABLED,JTS_FNC_STATUS]}}
};

JTS_FNC_PM_ENABLED =
{
	{lbAdd [00005, _x]} foreach ["Enabled","Disabled"];
	{lbSetValue [00005, (lbSize 00005) - 1, _x]} foreach [(lbSize 00005) - 1];
	lbsetcursel [00005, player getVariable "JTS_PM_STAT"];
};

JTS_FNC_STATUS =
{
	while {alive player && dialog} do
	{
		_sz = count (toArray (ctrltext 00006));
		ctrlsettext [00008, Format ["%1/15", _sz]];
		sleep 0.1;
	};
};


JTS_FNC_VALID =
{
	if (isNull _this ||!alive player) then 
	{
		false
	}

	else
	{
		if (!alive _this || _this == player || !isPlayer _this || !alive player) then
		{
			false
		}

		else
		{
			true
		}
	}
};

JTS_FNC_PM_DELETE =
{
	if (lbSize 00002 < 1) then
	{
		ctrlsettext [00007, "Your inbox is empty"];
	}

	else
	{
		_Data = lbData [00002, lbCursel 00002];
		_Subject = lbText [00002, lbCursel 00002];
		JTS_PM_ARRAY = JTS_PM_ARRAY - [[_Subject,_Data]];
		{[] spawn _x} foreach [JTS_FNC_PM,JTS_FNC_PM_ENABLED,JTS_FNC_STATUS]
	};
};