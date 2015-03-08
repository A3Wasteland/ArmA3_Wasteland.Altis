Missles = 10;//Ammount Off missiles
_price = 100000;//Price to call in missile strike

_money = (player getVariable "cmoney");
if(_price > (player getVariable "cmoney")) exitWith {hint "You do not have enough money"};//if player dosent have enough money inform them that they dont
if(_price < (player getVariable "cmoney")) exitWith //if the player has enough money then start the script
{
	_money = (player getVariable "cmoney");//how much money the player has
	_removeMoneh = _price;//remove the same amount of money as the price 
	player setVariable["cmoney",_money-_removeMoneh,false];//remove the money
	hint format ["$%1 Removed", _removeMoneh];//tell the player his moneys been removed
	sleep 2;//give the player time to read the previouse hint
	missle1 = 
	{
		openMap [false, false];// if the maps open close it
		[_pos] spawn // start the script with the _pos as the array
		{
			for '_i' from 0 to Missles do //loop the script for the amount of missile defined in Missiles at the top of the script
			{
				_missle = "M_AT";//type of missile to launch
				_mpos = 
				[
					(_this select 0 select 0) + random 30,//a random number between 0 - 30 will be chosen and that number in meters
					(_this select 0 select 1) + random 30,//is the area/radius of the missile strike so higher number = more spread out
					(_this select 0 select 2) + 200//the hight in witch the missiles are launched from in meters
				];
			
				_launch = createVehicle [_missle, _mpos, [], 0, "CAN_COLLIDE"];//create the missile
				_launch setvelocity [0,0,0];//set velocity to 0
				[_launch,-90,0] call BIS_fnc_setPitchBank;// set angle of missile
				hint format ["%1 Missiles Launched",_i];// tell the player how many missiles have launched
				sleep (random 1.00);// select a random time between 0 - 1 to delay each missile
			};
		};
	};
	titleText ["Click on the map to drop 10 missiles","PLAIN"]; titlefadeout 7;
	hint "Click on thew map to drop 10 missiles";
	onMapSingleClick "_pos call missle1; onMapSingleClick '';true;";//wait until player clicks then get the position of the click and call the script then Disables further map-click actions.
	openMap [true, false];//open the map
};
