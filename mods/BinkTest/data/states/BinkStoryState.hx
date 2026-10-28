import funkin.backend.system.Controls;
import funkin.backend.utils.NdllUtil;


var globalStorySingleStep   = NdllUtil.getFunction("test", "globalStorySingleStep", 0);
var getCurrentStep          = NdllUtil.getFunction("test", "getCurrentStep", 0);
var initGlobalStory         = NdllUtil.getFunction("test", "initGlobalStory", 1);
var setNextChoiceIndex      = NdllUtil.getFunction("test", "setNextChoice", 1);

var getCurrentBuffer        = NdllUtil.getFunction("test", "getCurrentBuffer", 0);
var clearCurrentBuffer      = NdllUtil.getFunction("test", "clearCurrentBuffer", 0);
var getCurrentError         = NdllUtil.getFunction("test", "getCurrentError", 0);
var globalHasError          = NdllUtil.getFunction("test", "globalHasError", 0);
var setNextChoice          = NdllUtil.getFunction("test", "setNextChoice", 1);

var loop = Paths.music('locationBGM/LobbyLoop');

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

function postCreate() {
    CoolUtil.playMusic(loop);
    FlxG.state.bgColor = 0xFF444444;

    var newLine = new FlxText(20,20,0,">", 30);
    newLine.screenCenter();
    newLine.x  = 50;
    newLine.y += (lineHeight+lineSpacing) * positioning -  (lineHeight+lineSpacing)*8;

    initGlobalStory("./mods/BinkTest/stories/test.ink.json");
}

var positioning =  0;
var lineHeight  = 30;
var lineSpacing = 10;

var lines:Array<FlxText> = [];


function addLine(lineInput:String){
    var newLine = new FlxText(20,20,0,lineInput, 30);
    lines.push(newLine);
    FlxG.state.add(newLine);
    newLine.screenCenter();
    newLine.y+= (lineHeight+lineSpacing) * positioning -  (lineHeight+lineSpacing)*8;
    positioning++;
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
			addLine(buffer);
			//trace("Stepped: " + getInt + "; Lines: "+ buffer);
			clearCurrentBuffer();
		}
    }
}

function clearLines(){
    positioning = 0;
}

function update(elapsed:Float) {
    if (controls.BACK)
        FlxG.switchState(new MainMenuState());

    if (FlxG.keys.justPressed.B) {
        doOneStep();
	}
}
