import funkin.backend.system.Controls;
import Type;

var loop = Paths.music('locationBGM/LobbyLoop');

var BINK_HAXE_NOT_FOUND:Int         = 404;
var BINK_HAXE_CAN_CONTINUE:Int      = 302;
var BINK_HAXE_CHOICE_FOUND:Int      = 200;
var BINK_HAXE_CHOICE_MADE:Int       = 201;
var BINK_HAXE_PARTIAL_CHOICE:Int    = 206;
var BINK_HAXE_UNKNOWN:Int           = 321;
var BINK_HAXE_FAILURE:Int           = 417;
var BINK_HAXE_TEAPOT:Int            = 418;
var BINK_HAXE_END:Int               = 204;
var BINK_HAXE_INIT:Int              = 99;

var valueStep:Int = BINK_HAXE_INIT;

function postCreate() {
    CoolUtil.playMusic(loop);
    FlxG.state.bgColor = 0xFF444444;
    //reset();
    initGlobalStory("./mods/BinkTest/stories/QuickEnd.json"); //Not needed but a good stress test

    initGlobalStory("./mods/BinkTest/stories/test.ink.json");
    setNextChoice(-1);
    for (i in 0...12){
        addLine("line #"+(i+1));
    }
    blankLines();

    FlxG.mouse.visible = true;
}

var positioning =  0;
var lineHeight  = 15;
var lineSpacing = 30;

var lines:Array<FlxText> = [];
var boxes:Array<FlxSprite> = [];
var choices:Array<FlxSprite> = [];
var mainHint = new FlxText(FlxG.width/6,30,0, "Press number keys to advance story", 30);
FlxG.state.add(mainHint);


function addLine(lineInput:String){
    var bgText = new FlxSprite();
    bgText.makeGraphic(1, 1, 0xFFFFFFFF);
    bgText.color = 0xFF000000;
    bgText.scale.set(FlxG.width*2/3, lineHeight*2.7);
    bgText.screenCenter();
    bgText.x = FlxG.width/6 + FlxG.width*2/6;
    bgText.y+= 8+ (lineHeight+lineSpacing) * positioning -  (lineHeight+lineSpacing)*5;
    boxes.push(bgText);

    FlxG.state.add(bgText);

    var newLine = new FlxText(20,20,FlxG.width*2/3,lineInput, lineHeight);
    lines.push(newLine);
    FlxG.state.add(newLine);
    newLine.screenCenter();
    newLine.x = FlxG.width/6;
    newLine.y+= (lineHeight+lineSpacing) * positioning -  (lineHeight+lineSpacing)*5;

    choices = -1;

    positioning++;
}

function setChoiceBox(index:Int, choiceInput:Int){
    if( index < lines.length){
        boxes[index] = lineInput;
    }
}

function changeLine(index:Int, lineInput:String){
    if( index < lines.length){
        lines[index].text = lineInput;
    }
}

function blankLines(){
    for (index in 0...lines.length){
        lines[index].text = "";
        lines[index].color = 0xFFFFFFFF;
        boxes[index] = -1;
    }
}

var iterate = 0;
var lastStepCode =0;
var recordCode =0;
var getInt = 99;
var buffer = "";
var choice_set = 0;
var partial_number = 0;
var partial_number_max = 0;
function doOneStep(){
    var error = getCurrentError();
    if( error == "no errors"){
        if(getInt!= null && getInt!=0 && getInt!=BINK_HAXE_FAILURE && getInt!=BINK_HAXE_UNKNOWN){
			globalStorySingleStep();
			getInt = getCurrentStep();
			buffer = getCurrentBuffer();
			if(buffer != null){
                iterate++;
                if(getInt == BINK_HAXE_PARTIAL_CHOICE){
                    partial_number++;
                    partial_number_max++;
                }
                if(lastStepCode == BINK_HAXE_END || (lastStepCode == BINK_HAXE_PARTIAL_CHOICE && getInt == BINK_HAXE_CAN_CONTINUE)){
                    blankLines();
                    iterate = 0;
                    partial_number = 0;
                    partial_number_max = 0;
                    choice_set = 0; //Begin next frame
                }

                changeLine(iterate%lines.length, (getInt == BINK_HAXE_PARTIAL_CHOICE?'        [${partial_number}]>  ':"$  ")+ buffer);
                setChoiceBox(iterate%lines.length, (getInt == BINK_HAXE_PARTIAL_CHOICE?partial_number:0) );
                lines[iterate%lines.length].color = getInt == BINK_HAXE_PARTIAL_CHOICE?0xFFDDDD00:0xFFFFFFFF;
                lastStepCode = getInt;
			}
			else if(lastStepCode!=BINK_HAXE_END && getInt == BINK_HAXE_END){
                iterate++;
                changeLine(iterate%lines.length, "STORY HAS ENDED! Press R to Restart!");
                lines[iterate%lines.length].color = 0xFFFFAA33;
                lastStepCode = getInt;
			}
			recordCode = getInt;
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

    if(FlxG.keys.justPressed.ONE){
        setNextChoice( Math.min(1, partial_number_max) );
        choice_set = 1;
	}

    if(FlxG.keys.justPressed.TWO){
        setNextChoice( Math.min(2, partial_number_max) );
        choice_set = 2;
	}

    if (FlxG.keys.justPressed.B || choice_set >= 0) {
        buffer = "";
        while((buffer!=null || recordCode == BINK_HAXE_CHOICE_FOUND || recordCode == BINK_HAXE_CHOICE_MADE) && lastStepCode != BINK_HAXE_END){
            doOneStep();
        }
        setNextChoice(-1);
        choice_set  = -1 ;
        if(recordCode == BINK_HAXE_PARTIAL_CHOICE){
            choice_set = 0;
        }

	}


    if (FlxG.keys.justPressed.R) {
        initGlobalStory("./mods/BinkTest/stories/test.ink.json");
        blankLines();
        iterate = 0;
        partial_number = 0;
        partial_number_max = 0;
        choice_set = 0;
        lastStepCode = BINK_HAXE_INIT;
	}

    for (index in 0...boxes.length){
        //mainHint.text = index;
        if(FlxG.mouse.y < boxes[index].y ){
            boxes[index].color = 0xFF662233;
            //mainHint.text = index;
        }
        else{
            boxes[index].color = 0xFF000000;
        }
    }

}
