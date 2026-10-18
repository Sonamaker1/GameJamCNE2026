import funkin.backend.MusicBeatState;
import funkin.backend.utils.NdllUtil;

function create(){

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


function postCreate()
{
    
    //var doStuff = NdllUtil.getFunction("test", "sum", 2);
    //var getTeapotIfNumber = NdllUtil.getFunction("test", "teapot", 1);    
    //var iterate = NdllUtil.getFunction("test", "iterate", 2);    
    var doThings = NdllUtil.getFunction("test", "doThings", 0);    
    //trace(doStuff(1,2));

    
    //trace(getTeapotIfNumber(1));
    //trace(getTeapotIfNumber("a"));

	//var getInt = 99;
	//while(getInt!=BINK_HAXE_END && getInt!=BINK_HAXE_FAILURE && getInt!=BINK_HAXE_UNKNOWN){
	//	getInt = iterate(getInt,1);
	//	trace(getInt);
	//}

	doThings();
	
}
/**
 * TODO:
 * add language selector
 * add title screen
 */


