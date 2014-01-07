


private ["_currentdatetime", "_day", "_month", "_year", "_ hour", "_ minute", "_subDays", "_return"];

_currentdatetime = _this select 0;
_subDays = _this select 1;

_day = _currentdatetime select 1;
_month = _currentdatetime select 2;
_year = _currentdatetime select 3;
_hour = _currentdatetime select 4;
_minute = _currentdatetime select 5;
_MOD = _minute + (_hour * 60);
_day = _day - _subDays; 
if (_day < 1) then
{
    switch ( _month) do
    {
        case 3: {_day = _day + 29};
        case 5:{_day = _day + 30};
        case 7:{_day = _day + 30};
        case 10:{_day = _day + 30};
        case 12:{_day = _day + 30};
        default {_day = _day + 31};
    };
    _month = _month -1;
};
if (_month < 1) then 
{
    _month = _month + 12;
    _year = _year -1 ;
};

_return = ["date", _day, _month, _year, _hour, _minute];
diag_log format["Processed data is %1", _return];
_return