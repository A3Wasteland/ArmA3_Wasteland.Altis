//Client Function for Airdrop Assistance (not really a function, as it is called via ExecVM from command menu)
//This takes values from command menu, and some passed variables, and interacts with client and sends commands to server
//Author: Apoc
//Credits: Some methods taken from Cre4mpie's airdrop scripts, props for the idea!
#define APOC_coolDownTimer (["APOC_coolDownTimer", 900] call getPublicVar)

scriptName "APOC_cli_startAirdrop";
private ["_type","_selection","_player","_coolDownTimer"]; //Variables coming from command menu
_type 				= _this select 0;
_selectionNumber 	= _this select 1;
_player 			= _this select 2;



//diag_log format ["Player %1, Drop Type %2, Selection # %3",_player,_type,_selectionNumber];
//hint format ["Well we've made it this far! %1, %2, %3",_player,_type,_selectionNumber];
_selectionArray = [];
switch (_type) do {
	case "vehicle": {_selectionArray = APOC_AA_VehOptions};
	case "supply": 	{_selectionArray = APOC_AA_SupOptions};
	case "picnic":	{_selectionArray = APOC_AA_SupOptions};
	case "base":	{_selectionArray = APOC_AA_SupOptions};
	default 		{_selectionArray = APOC_AA_VehOptions; diag_log "AAA - Default Array Selected - Something broke";};
};
_selectionName =(_selectionArray select _selectionNumber) select 0;
_price =(_selectionArray select _selectionNumber) select 2;
_coolDownTimer =(_selectionArray select _selectionNumber)select 4;

/////////////  Cooldown Timer ////////////////////////
if (!isNil "APOC_AA_lastUsedTime") then
{
//diag_log format ["AAA - Last Used Time: %1; CoolDown Set At: %2; Current Time: %3",APOC_AA_lastUsedTime, APOC_AA_coolDownTime, diag_tickTime];
if (isNil {_coolDownTimer}) then
{
	_coolDownTimer = APOC_coolDownTimer;
};

_timeRemainingReuse = _coolDownTimer - (diag_tickTime - APOC_AA_lastUsedTime); //time is still in s
if ((_timeRemainingReuse) > 0) then 
	{
		hint format["Negative. Airdrop Offline. Online ETA: %1", _timeRemainingReuse call fn_formatTimer];
		playSound "FD_CP_Not_Clear_F";
		player groupChat format ["Negative. Airdrop Offline. Online ETA: %1",_timeRemainingReuse call fn_formatTimer];
		breakOut "APOC_cli_startAirdrop";
	};
};
////////////////////////////////////////////////////////

_playerMoney = _player getVariable ["bmoney", 0];
if (_price > _playerMoney) exitWith
	{
		hint format["You don't have enough money in the bank to request this airdrop!"];
		playSound "FD_CP_Not_Clear_F";
	};
			
_confirmMsg = format ["This airdrop will deduct $%1 from your bank account upon delivery<br/>",_price call fn_numbersText];
_confirmMsg = _confirmMsg + format ["<br/><t font='EtelkaMonospaceProBold'>1</t> x %1",_selectionName];
		
	// Display confirm message
	if ([parseText _confirmMsg, "Confirm", "DROP!", true] call BIS_fnc_guiMessage) then
	{
	_heliDirection = random 360;
	[[_type,_selectionNumber,_player,_heliDirection],"APOC_srv_startAirdrop",false,false,false] call BIS_fnc_MP;
	APOC_AA_lastUsedTime = diag_tickTime;
//	diag_log format ["AAA - Just Used Time: %1; CoolDown Set At: %2; Current Time: %3",APOC_AA_lastUsedTime, APOC_AA_coolDownTime, diag_tickTime];
	playSound3D ["a3\sounds_f\sfx\radio\ambient_radio17.wss",player,false,getPosASL player,1,1,25];
	sleep 1;
	hint format ["Inbound Airdrop %2 Heading: %1 ETA: 40s",ceil _heliDirection,_selectionName];
	player groupChat format ["Inbound Airdrop %2 Heading: %1 ETA: 40s",ceil _heliDirection,_selectionName];
	sleep 20;
	hint format ["Inbound Airdrop %2 Heading: %1 ETA: 20s",ceil _heliDirection,_selectionName];
	player groupChat format ["Inbound Airdrop %2 Heading: %1 ETA: 20s",ceil _heliDirection,_selectionName];
	};
	