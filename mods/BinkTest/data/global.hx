import funkin.backend.utils.NdllUtil;
import Paths;
import lime.system.CFFI;
import cpp.Lib;
//public static var ndll = 'mods/BinkTest/ndlls/test-'+NdllUtil.os;


public static var raw_globalStorySingleStep   = NdllUtil.getFunction("test", "globalStorySingleStep", 0);
public static var raw_getCurrentStep          = NdllUtil.getFunction("test", "getCurrentStep", 0);
public static var raw_initGlobalStory         = NdllUtil.getFunction("test", "initGlobalStory", 1);
public static var raw_setNextChoiceIndex      = NdllUtil.getFunction("test", "setNextChoice", 1);
public static var raw_getCurrentBuffer        = NdllUtil.getFunction("test", "getCurrentBuffer", 0);
public static var raw_clearCurrentBuffer      = NdllUtil.getFunction("test", "clearCurrentBuffer", 0);
public static var raw_getCurrentError         = NdllUtil.getFunction("test", "getCurrentError", 0);
public static var raw_globalHasError          = NdllUtil.getFunction("test", "globalHasError", 0);
public static var raw_setNextChoice           = NdllUtil.getFunction("test", "setNextChoice", 1);

//Apparently there's a bug with lime so everything from an ndll needs to use Reflection now or it self-destructs after changing FlxStates
public static var globalStorySingleStep     = function(){ return Reflect.callMethod(null,raw_globalStorySingleStep,[]); }
public static var getCurrentStep            = function(){ return Reflect.callMethod(null,raw_getCurrentStep,[]); }
public static var initGlobalStory           = function(inputFile:String){ return Reflect.callMethod(null,raw_initGlobalStory,[inputFile]); }
public static var setNextChoice             = function(inputChoice:Int){ return Reflect.callMethod(null,raw_setNextChoiceIndex,[inputChoice]); }
public static var getCurrentBuffer          = function(){ return Reflect.callMethod(null,raw_getCurrentBuffer,[]); }
public static var clearCurrentBuffer        = function(){ return Reflect.callMethod(null,raw_clearCurrentBuffer,[]); }
public static var getCurrentError           = function(){ return Reflect.callMethod(null,raw_getCurrentError,[]); }
public static var globalHasError            = function(){ return Reflect.callMethod(null,raw_globalHasError,[]); }

//Lib._loadPrime(Assets.getPath(ndll), "getCurrentError", "void", 0);


trace("library bink should work now");
