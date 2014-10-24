//load the logging library
call compile preProcessFileLineNumbers "persistence\sock\log.sqf";

//load the socket rpc library
call compile preProcessFileLineNumbers "persistence\sock\sock.sqf";

//load the generic stats library
call compile preProcessFileLineNumbers "persistence\sock\stats.sqf";

//load the stats extra function library
call compile preProcessFileLineNumbers "persistence\sock\stats_extra.sqf";