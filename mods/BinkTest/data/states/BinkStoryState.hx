import funkin.backend.system.Controls;
import Type;

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
    //reset();
    initGlobalStory("./mods/BinkTest/stories/QuickEnd.json");

    initGlobalStory("./mods/BinkTest/stories/test.ink.json");

    for (i in 0...12){
        addLine("line #"+(i+1));
    }
}

var positioning =  0;
var lineHeight  = 15;
var lineSpacing = 30;

var lines:Array<FlxText> = [];
FlxG.state.add(new FlxText(FlxG.width/2,30,0, "Press B to advance story.", 30));


function addLine(lineInput:String){
    var newLine = new FlxText(20,20,FlxG.width*2/3,lineInput, lineHeight);
    lines.push(newLine);
    FlxG.state.add(newLine);
    newLine.screenCenter();
    newLine.x = FlxG.width/6;
    newLine.y+= (lineHeight+lineSpacing) * positioning -  (lineHeight+lineSpacing)*5;
    positioning++;
}


function changeLine(index:Int, lineInput:String){
    if( index < lines.length){
        lines[index].text = lineInput;
    }
}

var iterate = 0;
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
			changeLine(iterate%lines.length, (getInt == 206?"        Choose>":"$")+ buffer);
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
        iterate++;
	}
}
