//null abstraction
#define _undefined objNull

#define isARRAY(x) \
(not(isNil {x}) && {typeName x == typeName []})

#define isSTRING(x) \
(not(isNil {x}) && {typeName x == typeName ""})

#define isSCALAR(x) \
(not(isNil {x}) && {typeName x == typeName 0})

#define isBOOLEAN(x) \
(not(isNil {x}) && {typeName x == typeName true})

#define isOBJECT(x) \
(not(isNil {x}) && {typeName x == typeName objNull})

#define isCODE(x) \
(not(isNil {x}) && {typeName x == typeName {}})

#define isSIDE(x) \
(not(isNil {x}) && {typeName x == typeName sideUnknown})

#define isPOS(x) \
(isARRAY(x) && {count(x) == 3})

#define isSCRIPT(x) \
(not(isNil {x}) && {typeName x == typeName scriptNull})


#define isNullable(x) (false ||{ \
  not(isNil {x}) &&{ \
  private["_t"]; \
  _t = typeName x; \
  _t == typeName controlNull ||{ \
  _t == typeName displayNull ||{ \
  _t == typeName locationNull ||{ \
  _t == typeName taskNull ||{ \
  _t == typeName grpNull ||{ \
  _t == typeName objNull \
  }}}}}}})

//safer version of isNull that will not crap out when passed number, array, code, string
#define _isNull(x) (isNil {x} || ({isNullable(x) && {isNull x}}))
#define undefined(x) _isNull(x)
#define defined(x) (not(undefined(x)))

#define getIf(cond,v1,v2) \
(if (cond) then {v1} else {v2})

#define getUnless(cond,v1,v2) \
getIf(not(cond),v1,v2)


#define OR(x,y) \
getIf(defined(x),x,y)

#define OR_ARRAY(v,d) (if (isARRAY(v)) then {v} else {d})
#define OR_SCALAR(v,d) (if(isSCALAR(v)) then {v} else {d})
#define OR_STRING(v,d) (if (isSTRING(v)) then {v} else {d})
#define OR_BOOLEAN(v,d) (if(isBOOLEAN(v)) then {v} else {d})
#define OR_OBJECT(v,d) (if(isOBJECT(v)) then {v} else {d})
#define OR_SIDE(v,d) (if(isSIDE(v)) then {v} else {d})
#define OR_CODE(v,d) (if(isCODE(v)) then {v} else {d})

#define OR_POSITIVE(v,d) (if (isSCALAR(v) && {v > 0}) then {v} else {d})


#define AND(x,y) \
OR(v,y)

#define def(x) \
private[#x]

#define init(x,v) def(x); \
x = v

#define setIf(cond,x,v1,v2) \
x = if (cond) then {v1} else {v2}

#define assignIf setIf

#define setUnless(cond,x,v1,v2) \
x = if (cond) then {v2} else {v1}


#define assignUnless setUnless

#define initIf(cond,x,v1,v2) \
def(x); \
setIf(cond,x,v1,v2)

#define initUnless(cond,x,v1,v2) \
def(x); \
setUnless(cond,x,v1,v2)


//Assign argument at index o to variable v if it's of type t, else default to d
#define ARGV4(o,v,t,d) \
private[#v]; \
if (undefined(_this) ||{ \
   typeName _this != typeName [] ||{ \
   o >= (count _this) ||{ \
   v = _this select o; undefined(v) ||{ \
   (#t != "nil" && {typeName v != typeName t}) \
   }}}}) then { \
  v = d; \
};

//Assign argument at index o, to variable v if it's of type t, else default to nil
#define ARGV3(o,v,t) ARGV4(o,v,t,nil)

//Assign argument at index o to variable v, else default to nil
#define ARGV2(o,v) ARGV3(o,v,nil)


//Assign argument at index o to variable v if it's of type t, else exit with d
#define ARGVX4(o,v,t,d) \
private[#v]; \
if (undefined(_this) ||{ \
   typeName _this != typeName [] ||{ \
   o >= (count _this) ||{ \
   v = _this select o; undefined(v) ||{ \
   (#t != "nil" && {typeName v != typeName t}) \
   }}}}) exitWith { \
  d \
};

//Assign argument at index o, to variable v if it's of type t, else exit with nil
#define ARGVX3(o,v,t) ARGVX4(o,v,t,nil)

//Assign argument at index o to variable v, else exit with nil
#define ARGVX2(o,v) ARGVX3(o,v,nil)





#define DO if (true) then

#define xGet(x,o) (if (o >= count(x)) then {nil} else {x select o})
#define xSet(x,o,v) (x set [o, OR(v,nil)])
#define xPush(x,v) (xSet(x,count(x),v))
#define xPushIf(cond,x,v) if (cond) then {xPush(x,v);}
#define xPushUnless(cond,x,v) xPushIf(not(cond),x,v)


#define isClient not(isServer) || {isServer && not(isDedicated)}

#define IMPORT_FINALIZER if (isNil "finalize") then { \
  finalizer = { \
    if (isNil "_this" || {typeName _this != typeName {}}) exitWith {}; \
    \
    private["_str_data"]; \
    _str_data = toArray str(_this); \
    \
    private["_space"];  \
    _space = (toArray " ") select 0;\
    _str_data set [0, _space]; \
    _str_data set [((count _str_data)-1), _space]; \
    \
    (compileFinal (toString _str_data)) \
  }; \
  finalizer = finalizer call finalizer; \
};