import funkin.backend.system.Controls;
import flixel.addons.display.FlxSliceSprite;
import flixel.math.FlxRect;
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
    initGlobalStory("./"+Paths.getAssetsRoot()+"/stories/QuickEnd.json"); //Not needed but a good stress test

    initGlobalStory("./"+Paths.getAssetsRoot()+"/stories/test.ink.json");
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

var x =lineHeight+lineSpacing;

var lines:Array<FlxText> = [];
var positions:Array<Array<Int>> = [[],[],[],[],[],[],[],[-200, x+50],[200,50],[0,-x-20],[0,20]];
var sizes:Array<Array<Int>> = [
    [],[],[],[],[],[],[],
    [lineHeight*10,lineHeight*2],
    [lineHeight*10,lineHeight*2],
    [lineHeight*10,lineHeight*2],
    [lineHeight*10,lineHeight*2]
];

var boxes:Array<FlxSliceSprite> = [];
var choices:Array<Int> = [];
var mainHint = new FlxText(FlxG.width/6,30,0, "Press number keys to advance story (or click boxes)", 30);
FlxG.state.add(mainHint);


function addLine(lineInput:String){
    //new FlxSprite();
    //bgText.makeGraphic(1, 1, 0xFFFFFFFF);

    //bgText.scale.set(FlxG.width*2/3, lineHeight*2.7);
    var size = [FlxG.width*2/3,lineHeight];
    if(sizes[lines.length] != null && sizes[lines.length].length==2){
        size = sizes[lines.length];
    }
    else{
        sizes[lines.length] = size;
    }

    var newLine = new FlxText(20,20,size[0],lineInput, lineHeight);
    newLine.setFormat(Paths.font("UnitBlock.ttf"), lineHeight*1.5);
    lines.push(newLine);
    newLine.screenCenter();
    //newLine.offset.x = -FlxG.width/2;
    //newLine.x = FlxG.width/6;
    newLine.y+= (lineHeight+lineSpacing) * positioning -  (lineHeight+lineSpacing)*5;

    choice_set = 0;

    positioning++;

    var bgText = new FlxSliceSprite(Paths.image("BorderSlice.png"), new FlxRect(15, 15, 20, 20), size[0], size[1]*2.9);

    bgText.stretchBottom = true;
    bgText.stretchTop = true;
    bgText.stretchLeft = true;
    bgText.stretchRight = true;
    bgText.stretchCenter = true;
    bgText.updateHitbox();
    bgText.offset.x = -FlxG.width/2;
    bgText.x = -bgText.width/2;
    bgText.y -= -bgText.height/2+4;

    bgText.offset.y = lineHeight*2.9/2;
    //bgText.screenCenter();
    //bgText.x = FlxG.width; //FlxG.width/6 + FlxG.width*2/6;
    bgText.y += FlxG.height/2;
    bgText.y += -8+ (lineHeight+lineSpacing) * (positioning-1) -  (lineHeight+lineSpacing)*5;

    if(positions[lines.length-1] != null && positions[lines.length-1].length==2){
        bgText.x+= positions[lines.length-1][0];
        bgText.y+= positions[lines.length-1][1];
        newLine.x+= positions[lines.length-1][0];
        newLine.y+= positions[lines.length-1][1];
    }
    //bgText.color = 0xFF333333;
    //bgText.setColorTransform(0.2,0.2,0.2,0.2,0,0,0,0);

    boxes.push(bgText);

    FlxG.state.add(bgText);
    FlxG.state.add(newLine);
}

function changeLine(index:Int, lineInput:String, choiceInput:Int){
    if( index < lines.length){
        lines[index].text = lineInput;
        choices[index] = choiceInput;
    }
}

function blankLines(){
    for (index in 0...lines.length){
        lines[index].text = "";
        lines[index].color = 0xFFFFFFFF;
        boxes[index].color = 0x00333333;
        boxes[index].alpha = 0.0001;
        choices[index] = -1;
        //boxes[index].setColorTransform(0.2,0.2,0.2,0.2,0,0,0,0);

    }
}

function setDirectionals(){
    for (index in lines.length-5...lines.length){
        lines[index].text = "";
        lines[index].color = 0xFFFFFFFF;
        boxes[index].color = 0x00333333;
        boxes[index].alpha = 0.0001;
        choices[index] = -1;
        //boxes[index].setColorTransform(0.2,0.2,0.2,0.2,0,0,0,0);

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
			if(buffer != null && buffer.length>1){
                iterate++;
                if(getInt == BINK_HAXE_PARTIAL_CHOICE){
                    if(iterate%lines.length < lines.length-5){
                        iterate = lines.length-5;
                    }
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

                var tempIndex = iterate%lines.length;
                changeLine(
                    tempIndex,
                    (getInt == BINK_HAXE_PARTIAL_CHOICE?'<[ ${partial_number} ]>\n':"")+ buffer,
                    (getInt == BINK_HAXE_PARTIAL_CHOICE?partial_number:0)
                );
                if(getInt == BINK_HAXE_PARTIAL_CHOICE){
                    lines[tempIndex].color = 0xFFDDDD00;
                    boxes[tempIndex].color = 0xFF6699AA;
                    boxes[tempIndex].alpha = 1;
                }
                else{
                    lines[tempIndex].color =  0xFFFFFFFF;
                }
                lastStepCode = getInt;
			}
			else if(lastStepCode!=BINK_HAXE_END && getInt == BINK_HAXE_END){
                iterate++;
                changeLine(
                    iterate%lines.length,
                    "STORY HAS ENDED! Press R to Restart!",
                    321
                );
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
    //FlxG.switchState(new MainMenuState());
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

    if(FlxG.keys.justPressed.THREE){
        setNextChoice( Math.min(3, partial_number_max) );
        choice_set = 3;
	}

    if(FlxG.keys.justPressed.FOUR){
        setNextChoice( Math.min(4, partial_number_max) );
        choice_set = 4;
	}

    for (index in 0...boxes.length){
        if(
            (FlxG.mouse.y < boxes[index].y - boxes[index].offset.y + boxes[index].height) &&
            (FlxG.mouse.y > boxes[index].y - boxes[index].offset.y) &&
            (FlxG.mouse.x < boxes[index].x - boxes[index].offset.x + boxes[index].width) &&
            (FlxG.mouse.x > boxes[index].x - boxes[index].offset.x)
        ){
            if(choices[index]>0){
                boxes[index].color = 0xFF9977AA;
                if(FlxG.mouse.justPressed){
                    //boxes[index].setColorTransform(0.3,0.85,0.85,1,0,0,0,0);
                    //boxes[index].color = 0xFF8899FF;
                    choice_set = choices[index];
                    setNextChoice(choices[index]);
                }
            }
            else{
                boxes[index].color = 0xFFA4A4A4;
            }
            //boxes[index].setColorTransform(0.3,0.85,0.85,1,0,0,0,0);


        }
        else{
            if(choices[index]>0){
                boxes[index].color = 0xFF6699AA;
                boxes[index].alpha = 1;
            }
            else{
                boxes[index].color = 0xFF333333;
                boxes[index].alpha = 0.0001;
            }
        }
    }

    if (choice_set!=321 && (FlxG.keys.justPressed.B || choice_set >= 0)) {
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


    if (FlxG.keys.justPressed.R || choice_set == 321) {
        initGlobalStory("./"+Paths.getAssetsRoot()+"/stories/test.ink.json");
        blankLines();
        iterate = 0;
        partial_number = 0;
        partial_number_max = 0;
        choice_set = 0;
        lastStepCode = BINK_HAXE_INIT;
    }



}
