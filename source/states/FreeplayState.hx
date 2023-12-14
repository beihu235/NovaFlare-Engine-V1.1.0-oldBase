package states;

import backend.WeekData;
import backend.Highscore;
import backend.Song;
import backend.SongMetadata;

import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;

import objects.HealthIcon;
import states.editors.ChartingState;

import substates.GameplayChangersSubstate;
import substates.ResetScoreSubState;

import flixel.addons.ui.FlxInputText;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;

#if MODS_ALLOWED
import sys.FileSystem;
#end

class FreeplayState extends MusicBeatState
{
	var filePath:String = 'menuExtend/';
    var font:String = Paths.font('montserrat.ttf');
    
	var bg:FlxSprite;
	var bars:FlxSprite;
    public static var songs:Array<SongMetadata> = [];
    var songtextsGroup:Array<FlxText> = [];
    var iconsArray:Array<HealthIcon> = [];
    var songtextsLastY:Array<Float> = [];
    var barsArray:Array<FlxSprite> = [];
    var illustrationSize:Array<Float> = [1, 1];
    
    var baseX:Float = 200;
    var lastMouseY:Float = 0;
    var lastMouseX:Float = 0;
    private static var curSelectedels:Float = 0;
    private static var curSelected:Int = 0;
    public static var curDifficulty:Int = 0;
    private static var playSongTime:Float = 0;
    private static var playingSong:Int = -1;
    var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;
    var intendedColor:Int;
    var touchMoving:Bool = false;
    var haveMissText:Bool = false;
    
    var illustration:FlxSprite;
	var illustrationBG:FlxSprite;
	var illustrationOverlap:FlxSprite;
	var rightArrow:FlxSprite;
	var leftArrow:FlxSprite;
	var difficultieImage:FlxSprite;
	var difficultieText:FlxText;
	var underline:FlxSprite;
    var tipSearchText:FlxText;
    var searchText:FlxText;
    var searchTextBG:FlxSprite;
    var searchInput:FlxInputText;
    var camGame:FlxCamera;
    var camUI:FlxCamera;
    var scoreText:FlxText;
	
	var difficultySelectors:FlxGroup;
    
    var changingYTween:FlxTween;
    var changingXTween:FlxTween;
    var colorTween:FlxTween;
    var angleTween:FlxTween;
	var angleTweenBG:FlxTween;
	var angleTweenOverlap:FlxTween;
	var missTextTimer:FlxTimer;
    
	override function create()
	{
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		
		songs = [];
		#if !mobile
		FlxG.mouse.visible = true;
		#end
		
		camGame = new FlxCamera();
		camGame.bgColor = 0x00;
		camUI = new FlxCamera();
		camUI.bgColor = 0x00;
		
		FlxG.cameras.add(camGame, false);
		FlxG.cameras.add(camUI, false);

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
    	bg.antialiasing = ClientPrefs.data.antialiasing;
    	bg.camera = camGame;
    	add(bg);
    	intendedColor = bg.color;
    	bg.screenCenter();
    	
    	loadSong();
		addSongTxt();
    	
    	/*illustrationBG = new FlxSprite(780+20, 100+20).makeGraphic(425, 425, FlxColor.GRAY);
    	illustrationBG.antialiasing = ClientPrefs.data.antialiasing;
    	illustrationBG.updateHitbox();
    	illustrationBG.camera = camUI;
    	add(illustrationBG);
    	
    	illustration = new FlxSprite(780, 100).loadGraphic(Paths.image('unknownMod'));
    	illustration.antialiasing = ClientPrefs.data.antialiasing;
    	illustration.scale.x = 425/illustration.width;
    	illustration.scale.y = 425/illustration.height;
    	illustration.updateHitbox();
    	illustration.camera = camUI;
    	add(illustration);
    	
    	illustrationOverlap = new FlxSprite(780, 100).makeGraphic(425, 425, FlxColor.WHITE);
    	illustrationOverlap.antialiasing = ClientPrefs.data.antialiasing;
    	illustrationOverlap.updateHitbox();
    	illustrationOverlap.camera = camUI;
    	add(illustrationOverlap);
    	illustrationOverlap.alpha = 0;*/
    	
    	bars = new FlxSprite().loadGraphic(Paths.image('menus/freeplaybars'));
    	bars.antialiasing = ClientPrefs.data.antialiasing;
    	bars.screenCenter();
    	bars.camera = camUI;
    	//bars.alpha = 0.75;
    	add(bars);
    	
    	scoreText = new FlxText(FlxG.width * 0.7, 2.5, 0, "", 32);
		scoreText.setFormat(Language.font(), 32, FlxColor.WHITE, 'right');
		scoreText.camera = camUI;
		add(scoreText);
    	
    	difficultySelectors = new FlxGroup();
		add(difficultySelectors);
    	
    	var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
	
    	leftArrow = new FlxSprite(0, 615);
    	leftArrow.antialiasing = ClientPrefs.data.antialiasing;
    	leftArrow.frames = ui_tex;
    	leftArrow.animation.addByPrefix('idle', "arrow left");
    	leftArrow.animation.addByPrefix('press', "arrow push left");
    	leftArrow.animation.play('idle');
    	leftArrow.camera = camUI;
    	difficultySelectors.add(leftArrow);
    	
    	rightArrow = new FlxSprite(0, 615);
    	rightArrow.antialiasing = ClientPrefs.data.antialiasing;
    	rightArrow.frames = ui_tex;
    	rightArrow.animation.addByPrefix('idle', 'arrow right');
    	rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
    	rightArrow.animation.play('idle');
    	rightArrow.camera = camUI;
    	difficultySelectors.add(rightArrow);
    	
    	difficultieImage = new FlxSprite(0, 625).loadGraphic(Paths.image('menudifficulties/hard'));
    	difficultieImage.camera = camUI;
    	add(difficultieImage);
    	
    	difficultieText = new FlxText(0, 625, 0, '', 60);
    	difficultieText.camera = camUI;
    	add(difficultieText);
    	
    	searchInput = new FlxInputText(50, 50, 400, '', 20, 0x00FFFFFF);
    	searchInput.focusGained = () -> FlxG.stage.window.textInputEnabled = true;
    	searchInput.backgroundColor = FlxColor.TRANSPARENT;
    	searchInput.fieldBorderColor = FlxColor.TRANSPARENT;
    	searchInput.font = Language.font();
    	searchInput.camera = camUI;
    	add(searchInput);
    	
    	tipSearchText = new FlxText(50, 50, 0, 'Name...', 20);
    	tipSearchText.setFormat(Paths.font("syht.ttf"), 20, FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	tipSearchText.alpha = 0.5;
    	tipSearchText.camera = camUI;
    	add(tipSearchText);
    		
    	underline = new FlxSprite(50, 80).makeGraphic(400, 6, FlxColor.WHITE);
    	underline.alpha = 0.6;
    	underline.camera = camUI;
    	add(underline);
    	
    	searchText = new FlxText(465, 50, 0, 'Search', 20);
    	searchText.setFormat(Paths.font("syht.ttf"), 20, FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	searchText.alpha = 0.75;
    	searchText.camera = camUI;
    	add(searchText);
    	
    	searchTextBG = new FlxSprite(460, 45).makeGraphic(80, 40, FlxColor.WHITE);
    	searchTextBG.alpha = 0;
    	searchTextBG.camera = camUI;
    	add(searchTextBG);
    	
    	bg.color = songs[curSelected].color;
    	changeSelection(0);
    	
    	#if android
			addVirtualPad(NONE, NONE);
		#end
	
		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}
	
	function doSearch()
	{
		var oldSong:Array<SongMetadata> = songs;

		loadSong();
		
		var suitedSong:Array<SongMetadata> = [];
		var searchString = searchInput.text.toLowerCase();
		for (i in 0...songs.length)
		{
			var name:String = songs[i].songName.toLowerCase();
			if (name.indexOf(searchString) != -1)
			{
				suitedSong.push(songs[i]);
			}
		}
		
		if (suitedSong.length < 1) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			return;
		}
		
		if (oldSong == suitedSong) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			return;
		}
		
		for (i in 0...oldSong.length)
		{
    		remove(songtextsGroup[i]);
    		remove(iconsArray[i]);
		}
		
		songs = suitedSong;
    	
    	addSongTxt();
    	changeSelection(0);
    	moveByCurSelected();
	}
	
	function addSongTxt()
	{
		songtextsLastY = [];
    	songtextsGroup = [];
    	iconsArray = [];
    	
    	if (bars != null) remove(bars);
		for (i in 0...songs.length)
    	{
    		var songText = new FlxText((i <= curSelected) ? baseX - (curSelected-i)*25 : baseX - (i-curSelected)*25, 320+(i-curSelected)*115, 0, songs[i].songName, 60);
    		songText.setFormat(Paths.font("syht.ttf"), 60, FlxColor.WHITE, 'left', FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		songText.camera = camGame;
    		if (songs[i].songName.length >= 17) {
    			songText.scale.x = 10 / songs[i].songName.length;
    			songText.updateHitbox();
    		}
    		
    		songtextsLastY.push(songText.y);
    		songtextsGroup.push(songText);
    		
    		Mods.currentModDirectory = songs[i].folder;
    		
    		var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
    		icon.scale.set(0.8, 0.8);
    		icon.camera = camGame;
    		iconsArray.push(icon);
    		
    		var barShadow:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'barShadow'));
    		add(barShadow);
    		barShadow.scale.set(1, 1);
    		barShadow.x = songText.x - 200 ;
    		barShadow.y = songText.y - 15;
    		barShadow.updateHitbox();
    		barShadow.color = songs[i].color;
    		barsArray.push(barShadow);
		
    		var bar:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'bar'));
    		add(bar);
    		bar.scale.set(1, 1);
    		bar.x = songText.x - 200 ;
    		bar.y = songText.y - 15;
    		bar.updateHitbox();
    		barsArray.push(bar);
    		
    		add(songText);
    		add(icon);
    	}
    	add(bars);
	}
	
	function loadSong()
	{
		songs = [];
		for (i in 0...WeekData.weeksList.length) {
    		if(weekIsLocked(WeekData.weeksList[i])) continue;
    
    		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
    		var leSongs:Array<String> = [];
    		var leChars:Array<String> = [];
    
    		for (j in 0...leWeek.songs.length)
    		{
    			leSongs.push(leWeek.songs[j][0]);
    			leChars.push(leWeek.songs[j][1]);
    		}
    
    		WeekData.setDirectoryFromWeek(leWeek);
    		for (song in leWeek.songs)
    		{
    			var colors:Array<Int> = song[2];
    			if(colors == null || colors.length < 3)
    			{
    				colors = [146, 113, 253];
    			}
    			addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
    		}
       	}
	}
	
	override function destroy()
	{
		for (i in iconsArray)
		{
			FlxTween.tween(i, {alpha: 0}, 0.1, {ease: FlxEase.quadOut});
		}
	}

	public static var vocals:FlxSound = null;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, FlxMath.bound(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, FlxMath.bound(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(CoolUtil.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'Score: ' + lerpScore + ' | Accuracy: ' + ratingSplit.join('.') + '%';
		
		scoreText.x = FlxG.width - scoreText.width - 15;
		
		if (controls.UI_UP_P && !touchMoving)
		{
			changeSelection(-1);
			moveByCurSelected();
		}
		if (controls.UI_DOWN_P && !touchMoving)
		{
			changeSelection(1);
			moveByCurSelected();
		}

		if ( (FlxG.mouse.overlaps(leftArrow) && FlxG.mouse.justReleased) || controls.UI_LEFT_R) changeDiff(-1);
		if ( (FlxG.mouse.overlaps(rightArrow) && FlxG.mouse.justReleased) || controls.UI_RIGHT_R) changeDiff(1);
	
		if ( (FlxG.mouse.overlaps(leftArrow) && FlxG.mouse.pressed) || controls.UI_LEFT) leftArrow.animation.play('press');
		else leftArrow.animation.play('idle');
		if ( (FlxG.mouse.overlaps(rightArrow) && FlxG.mouse.pressed) || controls.UI_RIGHT) rightArrow.animation.play('press');
		else rightArrow.animation.play('idle');
		
		if (curSelectedels > (songs.length + 2))
			curSelectedels = 0;
		else if (curSelectedels < -3)
			curSelectedels = songs.length - 1;
		
		if (curSelectedels > (songs.length - 1))
    		curSelectedels = songs.length - 1;
    	else if (curSelectedels < 0)
    		curSelectedels = 0;
    		
    	if (searchInput.text.length > 0) tipSearchText.visible = false;
		else tipSearchText.visible = true;

    	
    	if (FlxG.mouse.justPressed)
        {
    		lastMouseY = FlxG.mouse.y;
    		lastMouseX = FlxG.mouse.x;
    		playSongTime = 0;
    		
    		if (FlxG.mouse.overlaps(searchTextBG))
			{
				searchTextBG.alpha = 0.75;
				FlxTween.tween(searchTextBG, {alpha: 0}, 0.25);
				doSearch();
			}
    	}
    		
    	if (FlxG.mouse.justPressed && FlxG.mouse.x < 600)
    	{
    		curSelectedels = curSelected;
    		touchMoving = true;
    		
    		if (changingYTween != null && changingXTween != null)
    		{
    			changingYTween.cancel;
    			changingXTween.cancel;
    		}
    	}
    	
    	if (FlxG.mouse.pressed && touchMoving)
    	{	
    		for (i in 0...songs.length)
    		{
    			var songY = songtextsLastY[i];
    			curSelectedels = curSelected - (FlxG.mouse.y - lastMouseY) / 115;
    		
    			songtextsGroup[i].y =  320+(i-curSelectedels)*115;
    			if (i <= curSelectedels)
    				songtextsGroup[i].x = baseX - (curSelectedels-i)*25;
    			else
    				songtextsGroup[i].x = baseX - (i-curSelectedels)*25;
    				
    			barsArray[i*2].x = songtextsGroup[i].x - 200;
    			barsArray[i*2].y = songtextsGroup[i].y - 15;
			
    			barsArray[i*2+1].x = songtextsGroup[i].x - 200;
    			barsArray[i*2+1].y = songtextsGroup[i].y - 15;
    		}
    	}
    	
    	if (FlxG.mouse.justReleased && touchMoving)
    	{
    		if (Math.round(curSelectedels) != curSelected) {
    			curSelected = Math.round(curSelectedels);
    			changeSelection(0);
    		}
    		
    		touchMoving = false;
    		
    		if (changingYTween != null && changingXTween != null)
    		{
    			changingYTween.cancel;
    			changingXTween.cancel;
    		}
    		
    		if (FlxG.mouse.y > lastMouseY - 10 && FlxG.mouse.y < lastMouseY + 10)
    		{
    			for (i in 0...songs.length) {
    				if (FlxG.mouse.overlaps(songtextsGroup[i]))
    				{
    					curSelected = i;
    					if (curSelected != i) changeSelection();
    					break;
    				}
    			}
    		}
    		
    		moveByCurSelected();
    	}
    	
    	for (i in 0...songs.length) {
			iconsArray[i].x = songtextsGroup[i].x - 150;
			iconsArray[i].y = songtextsGroup[i].y - 25;
		}
		
		if ((FlxG.mouse.pressed && FlxG.mouse.overlaps(illustration)) || FlxG.keys.pressed.SPACE)
		{
			playSongTime += elapsed;
			if ((playingSong != curSelected) && playSongTime >= 2)
			{
				try {
    				#if PRELOAD_ALL
    				destroyFreeplayVocals();
    				FlxG.sound.music.volume = 0;
    				Mods.currentModDirectory = songs[curSelected].folder;
    				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
    				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
    				if (PlayState.SONG.needsVoices)
    					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
    				else
    					vocals = new FlxSound();
    
    				FlxG.sound.list.add(vocals);
    				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
    				vocals.play();
    				vocals.persist = true;
    				vocals.looped = true;
    				vocals.volume = 0.7;
    				playingSong = curSelected;
				} catch(e:Dynamic) {
					var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
    				var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
    				
        			var errorStr:String = Mods.currentModDirectory + '/data/' + songLowercase + '/' + poop + '.json';
        			var missingText:FlxText = new FlxText(0, 680, 0, 'ERROR WHILE LOADING CHART: $errorStr', 20);
        			missingText.setFormat(Paths.font("syht.ttf"), 20, FlxColor.WHITE, LEFT);
        			missingText.camera = camUI;
        			if (!haveMissText) add(missingText);
        			
        			missingText.visible = true;
        			haveMissText = true;
        			
        			new FlxTimer().start(4, function(tmr:FlxTimer) {
        			if(tmr.finished) {
        					missingText.visible = false;
        					haveMissText = false;
        				}
        			});
        			FlxG.sound.play(Paths.sound('cancelMenu'));
        
        			return;
        		}
        		#end
			}
			illustration.scale.x = FlxMath.lerp(illustrationSize[0]*0.95, illustration.scale.x, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
			illustration.scale.y = FlxMath.lerp(illustrationSize[1]*0.95, illustration.scale.y, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
			
			illustrationBG.scale.x = FlxMath.lerp(0.95, illustrationBG.scale.x, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
			illustrationBG.scale.y = FlxMath.lerp(0.95, illustrationBG.scale.y, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
		} else {
			illustration.scale.x = FlxMath.lerp(illustrationSize[0], illustration.scale.x, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
			illustration.scale.y = FlxMath.lerp(illustrationSize[1], illustration.scale.y, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
			
			illustrationBG.scale.x = FlxMath.lerp(1, illustrationBG.scale.x, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
			illustrationBG.scale.y = FlxMath.lerp(1, illustrationBG.scale.y, FlxMath.bound(1 - (elapsed * 8.5), 0, 1));
		}
		
		if ((controls.ACCEPT || (FlxG.mouse.justReleased && FlxG.mouse.overlaps(illustration)) ) && playSongTime < 2)
    	{
    		var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
    		var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
    		try
    		{
    			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
    			PlayState.isStoryMode = false;
    			PlayState.storyDifficulty = curDifficulty;
    
    			if(colorTween != null) {
    				colorTween.cancel();
    			}
    		}
    		catch(e:Dynamic)
    		{
    			var errorStr:String = Mods.currentModDirectory + '/data/' + songLowercase + '/' + poop + '.json';
    			var missingText:FlxText = new FlxText(0, 680, 0, 'ERROR WHILE LOADING CHART: $errorStr', 20);
    			missingText.setFormat(Paths.font("syht.ttf"), 20, FlxColor.WHITE, LEFT);
    			missingText.camera = camUI;
    			if (!haveMissText) add(missingText);
    			
    			missingText.visible = true;
    			haveMissText = true;
        			
        		if (missTextTimer == null)
        		missTextTimer = new FlxTimer().start(4, function(tmr:FlxTimer) {
        		if(tmr.finished) {
        				missingText.visible = false;
        				haveMissText = false;
        				missTextTimer = null;
        			}
        		});
        		
    			FlxG.sound.play(Paths.sound('cancelMenu'));
    
    			return;
    		}
    		
    		LoadingState.loadAndSwitchState(new PlayState());
    		FlxG.mouse.visible = false;
    
    		FlxG.sound.music.volume = 0;
    				
    		destroyFreeplayVocals();
    		#if desktop
    		DiscordClient.loadModRPC();
    		#end
    	}
    	
    	if (controls.BACK #if android || ((FlxG.mouse.x > lastMouseX + 700) && FlxG.mouse.justReleased && playSongTime < 2) #end)
		{
			persistentUpdate = false;
			FlxG.mouse.visible = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}
	
    function changeDiff(value:Int)
    {
    	curDifficulty += value;
    	if (curDifficulty < 0)
    		curDifficulty = Difficulty.list.length-1;
    	if (curDifficulty >= Difficulty.list.length)
    		curDifficulty = 0;
    		
    	var newDiffName:String = Difficulty.list[curDifficulty];
    	if ( Paths.image('menudifficulties/' + Paths.formatToSongPath(newDiffName)) != null) {
    		if (difficultieImage != null) {
    			difficultieImage.loadGraphic(Paths.image('menudifficulties/' + Paths.formatToSongPath(newDiffName)));
    			difficultieImage.updateHitbox();
    		}
    		
    		difficultieImage.x = 1025 - difficultieImage.width/2;
    		rightArrow.x = difficultieImage.x + difficultieImage.width + 15;
    		leftArrow.x = difficultieImage.x - 65;
    		
    		if (difficultieImage != null) difficultieImage.alpha = 1;
    		if (difficultieText != null) difficultieText.alpha = 0;
    	} else {
    		if (difficultieText != null) {
    			difficultieText.text = newDiffName;
    			difficultieText.setFormat(Paths.font("syht.ttf"), 60);
    			difficultieText.updateHitbox();
    		}
    		
    		difficultieText.x = 1025 - difficultieText.width/2;
    		rightArrow.x = difficultieText.x + difficultieText.width + 15;
    		leftArrow.x = difficultieText.x - 65;
    		
    		if (difficultieImage != null) difficultieImage.alpha = 0;
    		if (difficultieText != null) difficultieText.alpha = 1;
    	}
    	
    	if (Difficulty.list.length <= 1) {
    		rightArrow.visible = false;
    		leftArrow.visible = false;
    	} else {
    		rightArrow.visible = true;
    		leftArrow.visible = true;
    	}
    	
    	intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
    }

	function changeSelection(value:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
		curSelected += value;
    	if (curSelected > (songs.length - 1))
    		curSelected = 0;
    	else if (curSelected < 0)
    		curSelected = songs.length - 1;
    		 
    	for (i in 0...songs.length) {
    		iconsArray[i].alpha = 0.5;
    		songtextsGroup[i].alpha = 0.5;
    	}
    	
    	iconsArray[curSelected].alpha = 1;
    	songtextsGroup[curSelected].alpha = 1;
    	
    	resetIllustration();
    	
    	var newColor:Int = songs[curSelected].color;
    	if(newColor != intendedColor) {
    		if(colorTween != null) {
    			colorTween.cancel();
    		}
    		intendedColor = newColor;
    		colorTween = FlxTween.color(bg, 0.5, bg.color, intendedColor, {
    			onComplete: function(twn:FlxTween) {
    				colorTween = null;
    			}
    		});
    	}
    	
    	Mods.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;
		Difficulty.loadFromWeek();
	
		changeDiff(0);
	}
	
    /*function resetIllustration()
    {
    	Mods.currentModDirectory = songs[curSelected].folder;
    	
    	var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
    	if (Paths.image('illustrations/' + songLowercase) != null) {
    		illustration.loadGraphic(Paths.image('illustrations/' + songLowercase));
    		illustration.scale.x = 425/illustration.width;
    		illustration.scale.y = 425/illustration.height;
    		illustration.updateHitbox();
    	} else {
    		illustration.loadGraphic(Paths.image('illustrations/default'));
    		illustration.scale.x = 425/illustration.width;
    		illustration.scale.y = 425/illustration.height;
    		illustration.updateHitbox();
    	}
    	
    	illustrationSize = [illustration.scale.x, illustration.scale.y];
    	
    	illustration.angle = 0;
    	illustrationBG.angle = 0;
    	illustrationOverlap.angle = 0;
    	
    	if (angleTween != null)
    		angleTween.cancel;
    		angleTweenBG.cancel;
    		angleTweenOverlap.cancel;
    	
    	angleTween = FlxTween.tween(illustration, {angle: -5}, 0.25, {ease: FlxEase.quadOut});
    	angleTweenBG = FlxTween.tween(illustrationBG, {angle: -5}, 0.25, {ease: FlxEase.quadOut});
    	angleTweenOverlap = FlxTween.tween(illustrationOverlap, {angle: -5}, 0.25, {ease: FlxEase.quadOut});
    	
    	illustrationOverlap.alpha = 0.75;
    	FlxTween.tween(illustrationOverlap, {alpha: 0}, 0.25, {ease: FlxEase.quadOut});
    }*/
    
	
	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}
	
	function moveByCurSelected()
	{
		for (songnum in 0...songs.length) {
			changingXTween = FlxTween.tween(songtextsGroup[songnum], {x: (songnum <= curSelected) ? baseX - (curSelected-songnum)*25 : baseX - (songnum-curSelected)*25}, 0.4, {ease: FlxEase.quadOut});
			changingYTween = FlxTween.tween(songtextsGroup[songnum], {y: 320+(songnum-curSelected)*115}, 0.4, {ease: FlxEase.quadOut});
		}
	}
}


class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var lastDifficulty:String = null;

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Mods.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}