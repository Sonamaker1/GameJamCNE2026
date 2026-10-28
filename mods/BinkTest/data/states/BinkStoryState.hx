import funkin.backend.system.Controls;

var loop = Paths.music('locationBGM/LobbyLoop');

function create() {
    CoolUtil.playMusic(loop);
}

function update(elapsed:Float) {
    if (controls.BACK)
        FlxG.switchState(new MainMenuState());

    if (FlxG.keys.justPressed.A) {
		//doOneStep();
		FlxG.switchState(new MainMenuState());
	}
}
