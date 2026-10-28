import funkin.backend.system.Controls;

var loop = Paths.music('locationBGM/LobbyLoop');

function create() {
    CoolUtil.playMusic(loop);
    FlxG.state.bgColor = 0xFF444444;
}

var positioning =  0;
var lineHeight  = 30;
var lineSpacing = 10;

var lines:Array<FlxText> = [];

function addLine(lineInput:String){
    newLine = new FlxText(20,20,0,lineInput, 30);
    lines.push(newLine);
    FlxG.state.add(newLine);
    newLine.screenCenter();
    newLine.y+= (lineHeight+lineSpacing) * positioning -  (lineHeight+lineSpacing)*8;
    positioning++;
}

function clearLines(){
    positioning = 0;
}

function update(elapsed:Float) {
    if (controls.BACK)
        FlxG.switchState(new MainMenuState());

    if (FlxG.keys.justPressed.B) {
        addLine("Hi");
	}
}
