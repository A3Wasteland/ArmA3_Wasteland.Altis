//ARMA3Alpha function LV_fnc_ACskills v0.8 - by SPUn / lostvar
//adjusts AI skills
private ["_group","_skills","_skillArray"];
_group = _this select 0;
_skills = _this select 1;

if(typeName _skills == "SCALAR")then{
	_skillArray = [_skills,_skills,_skills,_skills,_skills,_skills,_skills,_skills,_skills,_skills];
}else{
	_skillArray = [(_skills select 0),(_skills select 1),(_skills select 2),(_skills select 3),(_skills select 4),(_skills select 5),(_skills select 6),(_skills select 7),(_skills select 8),(_skills select 9)];
};

{
	_x setSkill ["aimingAccuracy",(_skillArray select 0)];
	_x setSkill ["aimingShake",(_skillArray select 1)];
    _x setSkill ["aimingSpeed",(_skillArray select 2)];
    _x setSkill ["spotDistance",(_skillArray select 3)];
    _x setSkill ["spotTime",(_skillArray select 4)];
    _x setSkill ["courage",(_skillArray select 5)];
    _x setSkill ["commanding",(_skillArray select 6)];
    _x setSkill ["general",(_skillArray select 7)];
	_x setSkill ["endurance",(_skillArray select 8)];
	_x setSkill ["reloadspeed",(_skillArray select 9)];
}forEach units group _group;