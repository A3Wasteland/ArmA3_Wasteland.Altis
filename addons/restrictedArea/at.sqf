if ((getPlayerUID player) in (call ATIDArray)) then {
titleText ["Welcome in the (AT) Safezone!", "PLAIN DOWN", 3]; titleFadeOut 4;
}
else{
// Everyone Else
titleText ["You have 30 seconds to leave this area!!", "PLAIN DOWN",3]; titleFadeOut 4;
sleep 10;
playsound "counter";
sleep 2;
titleText ["Go away!", "PLAIN DOWN", 3]; titleFadeOut 4;
sleep 5;
titleText ["If you don´t leave this area in 20 second you will be punished and loosing all your weapons!", "PLAIN DOWN", 3]; titleFadeOut 4;
sleep 20;
removeAllWeapons player;
sleep 1;
titleText ["You get awake far far away without your weapon! Stay away from that bases!", "PLAIN DOWN", 3]; titleFadeOut 4;
sleep 1;
player setPos [4109.0576, 10807.444, 0];
sleep 1;
};