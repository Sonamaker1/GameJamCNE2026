import funkin.backend.MusicBeatState;
import funkin.backend.utils.NdllUtil;
import funkin.menus.TitleState;

function create(){
	//MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
}

var BINK_HAXE_NOT_FOUND:Int = 404;
var BINK_HAXE_CAN_CONTINUE:Int = 302;
var BINK_HAXE_CHOICE_FOUND:Int = 200;
var BINK_HAXE_PARTIAL_CHOICE:Int = 206;
var BINK_HAXE_UNKNOWN:Int = 321;
var BINK_HAXE_FAILURE:Int = 417;
var BINK_HAXE_TEAPOT:Int = 418;
var BINK_HAXE_END:Int = 204;
var BINK_HAXE_INIT:Int = 99;

var valueStep:Int = BINK_HAXE_INIT;

/*
DEFINE_PRIM( sum, 2 );
DEFINE_PRIM( getStringTest, 1 );
DEFINE_PRIM( doThings, 0 );
DEFINE_PRIM( setNextChoice, 1 );
DEFINE_PRIME1(stringVal);

DEFINE_PRIME0(getCurrentBuffer);
DEFINE_PRIME0(getCurrentError);
DEFINE_PRIME0(globalHasError);

DEFINE_PRIM(globalStorySingleStep, 0);
DEFINE_PRIME0(getCurrentStep);
DEFINE_PRIME1(initGlobalStory);
*/

var globalStorySingleStep   = NdllUtil.getFunction("test", "globalStorySingleStep", 0);    
var getCurrentStep          = NdllUtil.getFunction("test", "getCurrentStep", 0);    
var initGlobalStory         = NdllUtil.getFunction("test", "initGlobalStory", 1);    
var setNextChoiceIndex      = NdllUtil.getFunction("test", "setNextChoice", 1);

var getCurrentBuffer        = NdllUtil.getFunction("test", "getCurrentBuffer", 0);    
var clearCurrentBuffer      = NdllUtil.getFunction("test", "clearCurrentBuffer", 0);    
var getCurrentError         = NdllUtil.getFunction("test", "getCurrentError", 0);    
var globalHasError          = NdllUtil.getFunction("test", "globalHasError", 0);    
var setNextChoice          = NdllUtil.getFunction("test", "setNextChoice", 1);    
    
function lazyReadInk(filename:String){
    trace(filename);
}

function doOneStep(){
	var error = getCurrentError();
    if( error == "no errors"){
        var getInt = 99;
		var buffer = "";
		if(getInt!= null && getInt!=0 && getInt!=BINK_HAXE_END && getInt!=BINK_HAXE_FAILURE && getInt!=BINK_HAXE_UNKNOWN){
			setNextChoice(0);
			globalStorySingleStep();
			getInt = getCurrentStep();
			buffer = getCurrentBuffer();
			trace("Stepped: " + getInt + "; Lines: "+ buffer);
			clearCurrentBuffer();		
		}
    }
}

function postCreate()
{
	
    
    //var doStuff = NdllUtil.getFunction("test", "sum", 2);
    //var getTeapotIfNumber = NdllUtil.getFunction("test", "teapot", 1);    
    //var iterate = NdllUtil.getFunction("test", "iterate", 2);    
    //initGlobalStory("./mods/BinkTest/stories/test.ink.json");

    //doOneStep();
	//doThings("print this out");
	
}

function update(){
	if (FlxG.keys.justPressed.B) {
		//doOneStep();
		FlxG.switchState(new ModState("BinkStoryState"));
	}
}

/**
 * TODO:
 * add language selector
 * add title screen
 */


