#define __autor_prefix c_
#define __addon_prefix proving_ground_reloader_
#define __quoted(str) #str
#define __concat2(var1,var2) ##var1####var2
#define __concat3(var1,var2,var3) ##var1####var2####var3
#define __concat4(var1,var2,var3,var4) ##var1####var2####var3####var4
#define __scriptName(a) __concat4(__autor_prefix,__addon_prefix,fnc_,a)
#define __prepFnc(a) __scriptName(a) = __preprocess __scriptPath(a)
#define __preprocess compile preprocessFileLineNumbers
#define GVAR(a) __concat3(__autor_prefix,__addon_prefix,a)
#define GFNC(a) __concat4(__autor_prefix,__addon_prefix,fnc_,a)