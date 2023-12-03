package substates;


import backend.Difficulty;
import backend.MusicBeatState;
import backend.WeekData;
import backend.Highscore;
import backend.Song;

import states.editors.ChartingState;
import states.FreeplayState;
import states.StoryMenuState;

//import options.OptionsMenu;
import options.OptionsState;

import flixel.util.FlxStringUtil;
import flixel.addons.transition.FlxTransitionableState;

/*

    PauseSubState made by TieGuo, code optimized by Beihu.
    it used at NF Engine
    有一说一我感觉就是在屎山上加屎山，很无语 --beihu
    别骂了 -- TieGuo
*/

class PauseSubState extends MusicBeatSubstate
{

    var filePath:String = 'pauseState/';
    var font:String = Paths.font('montserrat.ttf');

    var back:FlxSprite;
    var backShadow:FlxSprite;
    var front:FlxSprite;
    var backButton:FlxSprite;
    var blackback:FlxSprite;
    var missingText:FlxText;
    var missingTextTimer:FlxTimer;
    var missingTextTween:FlxTween;
    var boolText:FlxText;
    var camPause:FlxCamera;
    var pauseMusic:FlxSound;
    public static var songName:String = '';
    var holdTime:Float = 0;
    var skipTimeText:FlxText;
    var curTime:Float = Math.max(0, Conductor.songPosition);
    
    public static var goToOptions:Bool = false; //work for open option 
	public static var goToGameplayChangers:Bool = false; // work for open GameplayChangers 
	public static var goBack:Bool = false; //work for close option or GameplayChangers then open pause state
    public static var reOpen:Bool = false; // change bg alpha fix    //修改，换成(变量)
    
    public static var curOptions:Bool = false; // curSelected fix
	public static var curGameplayChangers:Bool = false; // curSelected fix

    var stayinMenu:String = 'isChanging'; // base, difficulty, debug, isChanging or options
    // isChanging = in transition animation

    var options:Array<String> = ['Continue', 'Restart', 'Difficulty', 'Debug', 'Editor', 'Options', 'Exit'];
    var optionsAlphabet:Array<FlxText> = [];
    var optionsBars:Array<FlxSprite> = [];
    var curSelected:Int = 0;
        
    var difficultyChoices = [];
    var difficultyCurSelected:Int = 0;
    var difficultyAlphabet:Array<FlxText> = [];
    var difficultyBars:Array<FlxSprite> = [];

    var debugType:Array<String> = ['Leave', 'Practice', 'Botplay', 'Back'];
    var debugCurSelected:Int = 0;
    var debugAlphabet:Array<FlxText> = [];
    var debugBars:Array<FlxSprite> = [];

    var optionsType:Array<String> = ['Instant Setup', 'Entirety Setup', 'Back'];
    var optionsCurSelected:Int = 0;
    var optionsOptionsAlphabet:Array<FlxText> = [];
    var optionsOptionsBars:Array<FlxSprite> = [];

    var menuColor:Array<Int> = [
    	0xFFFF26C0,
    	0xFFAA0044,
    	0xFFFF2E00,
    	0xFFFF7200,
    	0xFFE9FF00,
    	0xFF00FF8C,
    	0xFF00B2FF,
    	0xFF3C00C9
    ];
	
    var menuShadowColor:Array<Int> = [
    	0xFFCA0083,
    	0xFF77002F,
    	0xFFBF2300,
    	0xFFBF5600,
    	0xFFE0ED55,
    	0xFF00BF69,
    	0xFF0085BF,
    	0xFF25007C
    ];
    //紫→酒红→红→橙→黄→青→蓝→深蓝→紫
    //渐变暂停界面

    var curColor:Int = 0;
    var curColorAgain:Int = 0;
    var colorTween:FlxTween;
    var colorTweenShadow:FlxTween;

    public function new(x:Float, y:Float)
	{
	    super();
    	camPause = new FlxCamera();
    	camPause.bgColor = 0x00;
    	FlxG.cameras.add(camPause, false);
	
    	pauseMusic = new FlxSound();
    	if(songName != null) {
    		pauseMusic.loadEmbedded(Paths.music(songName), true, true);
    	} else if (songName != 'None') {
    		pauseMusic.loadEmbedded(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), true, true);
    	}
    	pauseMusic.volume = 0;
    	FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
    	pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

    	FlxG.sound.list.add(pauseMusic);
	
    	blackback = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    	blackback.camera = camPause;
    	add(blackback);
    	blackback.alpha = 0;
    	FlxTween.tween(blackback, {alpha: 0.5}, 0.75, {ease: FlxEase.quartOut});
	
    	backShadow = new FlxSprite(-800).loadGraphic(Paths.image(filePath + 'backShadow'));
    	backShadow.camera = camPause;
    	add(backShadow);
    	backShadow.updateHitbox();
    	FlxTween.tween(backShadow, {x: 0}, 1, {ease: FlxEase.quartOut});
	
    	back = new FlxSprite(-800).loadGraphic(Paths.image(filePath + 'back'));
    	back.camera = camPause;
    	add(back);
    	back.updateHitbox();
    	FlxTween.tween(back, {x: 0}, 1, {ease: FlxEase.quartOut});
	
    	front = new FlxSprite(-800).loadGraphic(Paths.image(filePath + 'front'));
    	front.camera = camPause;
    	add(front);
    	front.updateHitbox();
    	FlxTween.tween(front, {x: 0}, 1.3, {ease: FlxEase.quartOut});
	
    	backButton = new FlxSprite(1080, 600).loadGraphic(Paths.image(filePath + 'backButton'));
    	backButton.camera = camPause;
    	add(backButton);
    	backButton.scale.set(0.45, 0.45);
    	backButton.updateHitbox();
    	backButton.alpha = 0;
	
    	if (Difficulty.list.length < 2) options.remove('Change Difficulty');
	
    	for (i in 0...Difficulty.list.length) {
    		var diff:String = Difficulty.getString(i);
    		difficultyChoices.push(diff);
    	}
    	difficultyChoices.push('Back');
    	
    	for (i in 0...difficultyChoices.length) {
    		var optionText:FlxText = new FlxText(0, 0, 0, difficultyChoices[i], 50);
    		optionText.camera = camPause;
		
    		optionText.x = -1000;
    		optionText.y = (180 * (i - (difficultyChoices.length / 2))) + 400;
    		optionText.setFormat(font, 50, FlxColor.BLACK);
    		if (optionText.width > 300)
    		optionText.scale.set(300 / optionText.width, 300 / optionText.width);
    		optionText.updateHitbox();
    		difficultyAlphabet.push(optionText);
		
    		var barShadow:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'barShadow'));
    		add(barShadow);
    		barShadow.scale.set(0.5, 0.5);
    		barShadow.camera = camPause;
    		barShadow.x = -1000;
    		barShadow.y = optionText.y - 30;
    		barShadow.updateHitbox();
    		difficultyBars.push(barShadow);
		
    		var bar:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'bar'));
    		add(bar);
    		bar.scale.set(0.5, 0.5);
    		bar.camera = camPause;
    		bar.x = -1000;
    		bar.y = optionText.y - 30;
    		bar.updateHitbox();
    		difficultyBars.push(bar);
		
    		add(optionText);
    	}
    	
    	if(!PlayState.instance.startingSong)
			debugType.insert(1, 'Skip Time');
		
		if (!PlayState.chartingMode)
			options.remove('Debug');
	
    	for (i in 0...debugType.length) {
    		var optionText:FlxText = new FlxText(0, 0, 0, debugType[i], 50);
    		optionText.camera = camPause;
		
    		optionText.x = -1000;
    		optionText.y = (i - debugCurSelected) * 180 + 325;
    		optionText.setFormat(font, 50, FlxColor.BLACK);
    		debugAlphabet.push(optionText);
		
    		var barShadow:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'barShadow'));
    		add(barShadow);
    		barShadow.scale.set(0.5, 0.5);
    		barShadow.camera = camPause;
    		barShadow.x = -1000;
    		barShadow.y = optionText.y - 30;
    		barShadow.updateHitbox();
    		debugBars.push(barShadow);
		
    		var bar:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'bar'));
    		add(bar);
    		bar.scale.set(0.5, 0.5);
    		bar.camera = camPause;
    		bar.x = -1000;
    		bar.y = optionText.y - 30;
    		bar.updateHitbox();
    		debugBars.push(bar);
		
    		add(optionText);
    	}
	
    	for (i in 0...optionsType.length) {
    		var optionText:FlxText = new FlxText(0, 0, 0, optionsType[i], 50);
    		optionText.camera = camPause;
		
    		optionText.x = -1000;
    		optionText.y = (180 * (i - (optionsType.length / 2))) + 400;
    		optionText.setFormat(font, 50, FlxColor.BLACK);
    		optionsOptionsAlphabet.push(optionText);
		
    		var barShadow:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'barShadow'));
    		add(barShadow);
    		barShadow.scale.set(0.5, 0.5);
        	barShadow.camera = camPause;
    		barShadow.x = -1000;
    		barShadow.y = optionText.y - 30;
    		barShadow.updateHitbox();
    		optionsOptionsBars.push(barShadow);
		
    		var bar:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'bar'));
    		add(bar);
    		bar.scale.set(0.5, 0.5);
    		bar.camera = camPause;
    		bar.x = -1000;
    		bar.y = optionText.y - 30;
    		bar.updateHitbox();
    		optionsOptionsBars.push(bar);
		
    		add(optionText);
    	}
	
    	for (i in 0...options.length) {
    		var optionText:FlxText = new FlxText(0, 0, 0, options[i], 50);
    		optionText.camera = camPause;
		
    		optionText.x = -1000;
    		optionText.y = (i - curSelected) * 180 + 325;
    		optionText.setFormat(font, 50, FlxColor.BLACK);
    		optionsAlphabet.push(optionText);
		
    		var barShadow:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'barShadow'));
    		add(barShadow);
    		barShadow.scale.set(0.5, 0.5);
    		barShadow.camera = camPause;
    		barShadow.x = -1000;
    		barShadow.y = optionText.y - 30;
    		barShadow.updateHitbox();
    		optionsBars.push(barShadow);
		
    		var bar:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'bar'));
    		add(bar);
    		bar.scale.set(0.5, 0.5);
    		bar.camera = camPause;
    		bar.x = -1000;
    		bar.y = optionText.y - 30;
    		bar.updateHitbox();
    		optionsBars.push(bar);
    		
    		add(optionText);
    	}
	
    	missingText = new FlxText(0, 720, 0, '', 35);
    	missingText.camera = camPause;
    	missingText.setFormat(font, 24, FlxColor.WHITE, 'CENTER', null, FlxColor.BLACK);
    	add(missingText);
	
    	boolText = new FlxText(0, 720, 0, 'OFF', 24);
    	boolText.camera = camPause;
    	boolText.setFormat(font, 24, FlxColor.BLACK);
    	add(boolText);
	
    	skipTimeText = new FlxText(0, 720, 0, '', 24);
    	skipTimeText.camera = camPause;
    	skipTimeText.setFormat(font, 40, FlxColor.WHITE);
    	add(skipTimeText);
    	updateSkipTimeText();
    	
    	/*var textString:String = Date.now().toString() + '\n' +
    	'Song: ' + PlayState.SONG.song + ' - ' + Difficulty.getString().toUpperCase() + '\n' +
    	'Blueballed' + PlayState.deathCounter + '\n' + 
    	(PlayState.instance.practiceMode ? 'Practice: ON\n' : '') +
    	(PlayState.instance.cpuControlled ? 'Botplay: ON\n' : '') +
    	(PlayState.chartingMode ? 'Cheating: ON');
    	
    	var infoText:FlxText = new FlxText(0, 15, FlxG.width, textString, 32);
		infoText.setFormat(font, 32);
		infoText.camera = camPause;
		infoText.screenCenter(X);
		infoText.updateHitbox();
		add(infoText);*/
    	
    	new FlxTimer().start(0.4, function(tmr:FlxTimer) {
    		stayinMenu = 'base';
    		changeOptions(0);
    	});
    	
    	changeMenuColor();
    	
    	new FlxTimer().start(2, function(tmr:FlxTimer) {
    		changeMenuColor();
    	}, 0);
    	
    	cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    	
    	#if android
		    addVirtualPad(FULL, A_B);
		    addPadCamera();
		#end
    }

    override function update(elapsed:Float) {
        
        if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;
        super.update(elapsed);
        
        var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var leftP = controls.UI_LEFT_P;
		var rightP = controls.UI_RIGHT_P;
		var accept = controls.ACCEPT;
		
    	if (stayinMenu == 'base') {
    		if (upP)
    			changeOptions(-1);
    		else if (downP)
    			changeOptions(1);
    		
    		for (i in 0...options.length) {
    			optionsAlphabet[i].x = FlxMath.lerp((curSelected - i) * 15 + 75 + (i == curSelected ? 75 : 0), optionsAlphabet[i].x, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
    			optionsAlphabet[i].y = FlxMath.lerp((i - curSelected) * 180 + 325, optionsAlphabet[i].y, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
    			
    			optionsBars[i*2].x = optionsAlphabet[i].x - 300;
    			optionsBars[i*2].y = optionsAlphabet[i].y - 30;
    			
    			optionsBars[i*2+1].x = optionsAlphabet[i].x - 300;
    			optionsBars[i*2+1].y = optionsAlphabet[i].y - 30;
    		}
    		
    		if (accept)
    			doEvent();
    	} else if (stayinMenu == 'debug') {
    		if (upP)
    			changeOptions(-1);
    		else if (downP)
    			changeOptions(1);
		
    		for (i in 0...debugType.length) {
    			debugAlphabet[i].x = FlxMath.lerp((debugCurSelected - i) * 15 + 75 + (i == debugCurSelected ? 75 : 0), debugAlphabet[i].x, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
    			debugAlphabet[i].y = FlxMath.lerp((i - debugCurSelected) * 180 + 325, debugAlphabet[i].y, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
			
    			debugBars[i*2].x = debugAlphabet[i].x - 300;
    			debugBars[i*2].y = debugAlphabet[i].y - 30;
			
    			debugBars[i*2+1].x = debugAlphabet[i].x - 300;
    			debugBars[i*2+1].y = debugAlphabet[i].y - 30;
    		}
		
    		var text = debugAlphabet[debugCurSelected];
    		if ((text.text == 'Botplay' || text.text == 'Practice') && stayinMenu == 'debug')
    		{
    			boolText.x = text.x + text.width + 5;
    			boolText.y = text.y;
    		} else
    			boolText.y = 1000;
		
    		if (accept)
    			doEvent();
			
    		if (text.text == 'Skip Time' && stayinMenu == 'debug') {
    			skipTimeText.x = text.x + text.width + 125;
    			skipTimeText.y = text.y + 7.5;
    			if (leftP)
    			{
    				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
    				curTime -= 1000;
    				holdTime = 0;
    			}
    			if (rightP)
    			{
    				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
    				curTime += 1000;
    				holdTime = 0;
    			}

    			if(controls.UI_LEFT || controls.UI_RIGHT)
    			{
    				holdTime += elapsed;
    				if(holdTime > 0.5)
    				{
    					curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
    				}

    				if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
    				else if(curTime < 0) curTime += FlxG.sound.music.length;
    				updateSkipTimeText();
    			}
    		} else
    			skipTimeText.y = 1000;
    	} else if (stayinMenu == 'difficulty') {
    	    if (upP)
    			changeOptions(-1);
    		else if (downP)
    			changeOptions(1);
    			
    		for (i in 0...difficultyAlphabet.length) {
                difficultyAlphabet[i].x = FlxMath.lerp((difficultyCurSelected - i) * 15 + 75 + (i == difficultyCurSelected ? 75 : 0), difficultyAlphabet[i].x, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
    			difficultyAlphabet[i].y = FlxMath.lerp((i - difficultyCurSelected) * 180 + 325, difficultyAlphabet[i].y, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
    			
    			difficultyBars[i*2].x = difficultyAlphabet[i].x - 300;
    			difficultyBars[i*2].y = difficultyAlphabet[i].y - 30;
			
    			difficultyBars[i*2+1].x = difficultyAlphabet[i].x - 300;
    			difficultyBars[i*2+1].y = difficultyAlphabet[i].y - 30;
    		}
    		
    		if (accept)
    			doEvent();
		
    	} else if (stayinMenu == 'options') {
    	    if (upP)
    			changeOptions(-1);
    		else if (downP)
    			changeOptions(1);
    			
    		for (i in 0...optionsOptionsAlphabet.length) {
    			optionsOptionsAlphabet[i].x = FlxMath.lerp((curSelected - i) * 15 + 75, optionsOptionsAlphabet[i].x, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
    			optionsOptionsAlphabet[i].y = FlxMath.lerp((i - optionsCurSelected) * 180 + 325, optionsOptionsAlphabet[i].y, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
    			
    			optionsOptionsBars[i*2].x = optionsOptionsAlphabet[i].x - 525;
    			optionsOptionsBars[i*2].y = optionsOptionsAlphabet[i].y - 30;
    			
    			optionsOptionsBars[i*2+1].x = optionsOptionsAlphabet[i].x - 550;
    			optionsOptionsBars[i*2+1].y = optionsOptionsAlphabet[i].y - 30;
    		}

		    if (accept){
        		doEvent();
    		}
    	}
    }

    function changeOptions(num:Int) {
    	if (stayinMenu == 'base') {
    		curSelected += num;
    		if (curSelected > options.length - 1) curSelected = 0;
    		if (curSelected < 0) curSelected = options.length - 1;
    		
    		for (i in 0...options.length - 1) optionsAlphabet[i].alpha = 0.5;
    		
    		optionsAlphabet[curSelected].alpha = 1;
    	} else if (stayinMenu == 'debug') {
    		debugCurSelected += num;
    		if (debugCurSelected > debugType.length - 1) debugCurSelected = 0;
    		if (debugCurSelected < 0) debugCurSelected = debugType.length - 1;
    		
    		for (i in 0...debugType.length - 1) debugAlphabet[i].alpha = 0.5;
    		
    		debugAlphabet[debugCurSelected].alpha = 1;
    		
    		var text = debugAlphabet[debugCurSelected];
    		if (text.text == 'Botplay' || text.text == 'Practice')
    		{
    			boolText.text = (text.text == 'Botplay' ? (PlayState.instance.cpuControlled ? 'ON' : 'OFF') : (PlayState.instance.practiceMode ? 'ON' : 'OFF'));
    		}
    	} else if (stayinMenu == 'difficulty') {
    		difficultyCurSelected += num;
    		if (difficultyCurSelected > difficultyChoices.length - 1) difficultyCurSelected = 0;
    		if (difficultyCurSelected < 0) difficultyCurSelected = difficultyChoices.length - 1;
    		
    		for (i in 0...difficultyChoices.length) difficultyAlphabet[i].alpha = 0.5;
    		
    		difficultyAlphabet[difficultyCurSelected].alpha = 1;
    	} else if (stayinMenu == 'options') {
    		optionsCurSelected += num;
    		if (optionsCurSelected > options.length - 1) optionsCurSelected = 0;
    		if (optionsCurSelected < 0) optionsCurSelected = optionsType.length - 1;
    		
    		for (i in 0...optionsType.length - 1) optionsOptionsAlphabet[i].alpha = 0.5;
    		
    		optionsOptionsAlphabet[optionsCurSelected].alpha = 1;
    	}
    }

    function doEvent() {
    	if (stayinMenu == 'base') {
    		var daChoice:String = options[curSelected];
    		if (daChoice == 'Difficulty') {
    			for (i in optionsBars)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
    				
    			for (i in optionsAlphabet)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
    				
    			stayinMenu = 'isChanging';
    			setBackButton(false);
    			new FlxTimer().start(0.5, function(tmr:FlxTimer) {
    				stayinMenu = 'difficulty';
    			});
    		} else if (daChoice == 'Debug') {
    			for (i in optionsBars)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
				
    			for (i in optionsAlphabet)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
			
    			stayinMenu = 'isChanging';
    			setBackButton(false);
    			new FlxTimer().start(0.5, function(tmr:FlxTimer) {
    				stayinMenu = 'debug';
    				changeOptions(0);
    			});
			
    			PlayState.chartingMode = true;
    		} else if (daChoice == 'Options') {
    			for (i in optionsBars)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
				
    			for (i in optionsAlphabet)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
			
    			stayinMenu = 'isChanging';
    			setBackButton(false);
    			new FlxTimer().start(0.5, function(tmr:FlxTimer) {
    				stayinMenu = 'options';
    			});
    		} else if (daChoice == 'Continue') {
    			for (i in optionsBars)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
				
    			for (i in optionsAlphabet)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
			
    			stayinMenu = 'isChanging';
			
    			FlxTween.tween(backShadow, {x: -800}, 1, {ease: FlxEase.quartIn});
    			FlxTween.tween(back, {x: -800}, 1, {ease: FlxEase.quartIn});
    			FlxTween.tween(front, {x: -800}, 0.75, {ease: FlxEase.quartIn});
    			FlxTween.tween(blackback, {alpha: 0}, 0.75, {ease: FlxEase.quartOut});
    			new FlxTimer().start(3, function(tmr:FlxTimer) {
    				close();
    			});
    		} else if (daChoice == 'Restart') {
    			restartSong();
    		} else if  (daChoice == 'Exit') {
    			PlayState.deathCounter = 0;
    			PlayState.seenCutscene = false;

    			Mods.loadTopMod();
    			if(PlayState.isStoryMode) {
    				MusicBeatState.switchState(new StoryMenuState());
    			} else {
    				MusicBeatState.switchState(new FreeplayState());
    			}
    			PlayState.cancelMusicFadeTween();
    			FlxG.sound.playMusic(Paths.music('freakyMenu'));
    			PlayState.changedDifficulty = false;
    			PlayState.chartingMode = false;
    			FlxG.camera.followLerp = 0;
    		} else if  (daChoice == 'Editor') {
    			MusicBeatState.switchState(new ChartingState());
    			PlayState.chartingMode = true;
    		}
    	} else if (stayinMenu == 'debug') {
    		var daChoice:String = debugType[debugCurSelected];
    		if (daChoice == 'Botplay') {
    			PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
    			PlayState.changedDifficulty = true;
    			PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
    			PlayState.instance.botplayTxt.alpha = 1;
    			PlayState.instance.botplaySine = 0;
    			boolText.text = (PlayState.instance.cpuControlled ? 'ON' : 'OFF');
    		} else if (daChoice == 'Practice') {
    			PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
    			PlayState.changedDifficulty = true;
    			boolText.text = (PlayState.instance.practiceMode ? 'ON' : 'OFF');
        	} else if (daChoice == 'Skip Time') {
    			if(curTime < Conductor.songPosition)
    			{
    	    			PlayState.startOnTime = curTime;
    					restartSong(true);
    			}
    			else
    			{
    				if (curTime != Conductor.songPosition)
    				{
    					PlayState.instance.clearNotesBefore(curTime);			
    					PlayState.instance.setSongTime(curTime);
    				}
    				close();
    			}
    		} else if (daChoice == 'Leave') {
    			restartSong();
				PlayState.chartingMode = false;
    		} else if (daChoice == 'Back') {
    			for (i in debugBars)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
				
    			for (i in debugAlphabet)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
    			
    			stayinMenu = 'isChanging';
    			setBackButton(true);
    			new FlxTimer().start(0.5, function(tmr:FlxTimer) {
    				stayinMenu = 'base';
    				debugCurSelected = 0;
    			});
    		}
    	} else if (stayinMenu == 'options') {
			if (optionsType[optionsCurSelected] == 'Instant Setup')
      		{
    			PlayState.instance.paused = true; // For lua
    			PlayState.instance.vocals.volume = 0;
    			OptionsState.onPlayState = true;
    			if(ClientPrefs.data.pauseMusic != 'None'){
    				FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), pauseMusic.volume);
    				FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
    			    FlxG.sound.music.time = pauseMusic.time;
    			}
    			MusicBeatState.switchState(new OptionsState());
    		} else if (optionsType[optionsCurSelected] == 'Entirety Setup') {
    			close();
    			//openSubState(new optionsMenu());
    		} else if (optionsType[optionsCurSelected] == 'Back') {
    			for (i in optionsOptionsBars)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
    				
    			for (i in optionsOptionsAlphabet)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
    			
    			stayinMenu = 'isChanging';
    			setBackButton(true);
    			new FlxTimer().start(0.5, function(tmr:FlxTimer) {
				stayinMenu = 'base';
				optionsCurSelected = 0;
    			});
    		}
    	} else if (stayinMenu == 'difficulty') {
    		if (difficultyChoices[i] == 'Back') {
    			for (i in difficultyBars)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
				
    			for (i in difficultyAlphabet)
    				FlxTween.tween(i, {x: -1000}, 0.5, {ease: FlxEase.quartIn});
			
    			stayinMenu = 'isChanging';
    			setBackButton(true);
    			new FlxTimer().start(0.5, function(tmr:FlxTimer) {
    				stayinMenu = 'base';
    				difficultyCurSelected = 0;
    			});
    			return;
    		}
	        try{
        		var name:String = PlayState.SONG.song;
        		var poop = Highscore.formatSong(name, difficultyCurSelected);
        		PlayState.SONG = Song.loadFromJson(poop, name);
           		PlayState.storyDifficulty = difficultyCurSelected;
        		MusicBeatState.resetState();
        		FlxG.sound.music.volume = 0;
        		PlayState.changedDifficulty = true;
        		PlayState.chartingMode = false;
        	} catch(e:Dynamic) {
        		missingText.text = 'ERROR WHILE LOADING CHART: ' + PlayState.SONG.song + '-' + difficultyChoices[difficultyCurSelected];
        		missingText.screenCenter(XY);
        		FlxG.sound.play(Paths.sound('cancelMenu'));

        	    missingTextTween = FlxTween.tween(missingText, {y: 680}, 0.5, {ease: FlxEase.quartOut});
        		
        		if (missingTextTimer == null) {
        	    	missingTextTimer = new FlxTimer().start(2, function(tmr:FlxTimer) {
    		    	missingTextTween = FlxTween.tween(missingText, {y: 720}, 0.5, {ease: FlxEase.quartIn});
    	        		missingTextTimer = null;
                	}, 1);
                }
    	    }
        }
    }
    
    function setBackButton(hide:Bool) {
	    if (hide) {
    		FlxTween.tween(backButton, {alpha: 0}, 0.5, {ease: FlxEase.quartIn});
    		FlxTween.tween(backButton, {x: 1100}, 0.5, {ease: FlxEase.quartIn});
    	} else {
    		FlxTween.tween(backButton, {alpha: 1}, 0.5, {ease: FlxEase.quartIn});
    		FlxTween.tween(backButton, {x: 1080}, 0.5, {ease: FlxEase.quartIn});
	    }
    }

    override function destroy()
    {
    	pauseMusic.destroy();
    	if (colorTween != null && colorTweenShadow != null)
    	{
    		colorTween.cancel();
    		colorTweenShadow.cancel();
    	}
    }

    function changeMenuColor() {
	    if (colorTween != null && colorTweenShadow != null)
	    {
		    colorTween.cancel();
		    colorTweenShadow.cancel();
	    }
	
	    for (i in 0...Std.int(optionsBars.length/2))
		    colorTweenShadow = FlxTween.color(optionsBars[i*2], 2, optionsBars[i*2].color, menuShadowColor[curColor]);
	    for (i in 0...Std.int(debugBars.length/2))
		    colorTweenShadow = FlxTween.color(debugBars[i*2], 2, debugBars[i*2].color, menuShadowColor[curColor]);
	    for (i in 0...Std.int(difficultyBars.length/2))
    		colorTweenShadow = FlxTween.color(difficultyBars[i*2], 2, difficultyBars[i*2].color, menuShadowColor[curColor]);
    	for (i in 0...Std.int(optionsOptionsBars.length/2))
        	colorTweenShadow = FlxTween.color(optionsOptionsBars[i*2], 2, optionsOptionsBars[i*2].color, menuShadowColor[curColor]);
    	
    	colorTween = FlxTween.color(back, 2, menuColor[curColorAgain], menuColor[curColor]);
    	colorTweenShadow = FlxTween.color(backShadow, 2, menuColor[curColorAgain], menuColor[curColor]);
    	
    	curColor++;
    	curColorAgain = curColor - 1;
    	if (curColor > menuShadowColor.length -1) curColor = 0;
    	if (curColorAgain < 0) curColorAgain = menuShadowColor.length -1;
    }
	    
    public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
		}
		MusicBeatState.resetState();
	}

    function updateSkipTimeText()
    {
    	skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
    }
    
}