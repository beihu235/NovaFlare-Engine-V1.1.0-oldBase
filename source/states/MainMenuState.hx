package states;

import backend.WeekData;
import backend.Achievements;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;

import flixel.addons.display.FlxBackdrop;

import flixel.input.keyboard.FlxKey;
import lime.app.Application;

import objects.AchievementPopup;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import openfl.Lib;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;
	public var camAchievement:FlxCamera;
	var optionTween:Array<FlxTween> = [];
	var cameraTween:Array<FlxTween> = [];
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		//#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		//#if !switch 'donate', #end
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	
	var logoBl:FlxSprite;
	
	var bgMove:FlxBackdrop;
	public static var Mainbpm:Float = 0;
	public static var bpm:Float = 0;
	var SoundTime:Float = 0;
	var BeatTime:Float = 0;
	
	var ColorArray:Array<Int> = [
		0xFF9400D3,
		0xFF4B0082,
		0xFF0000FF,
		0xFF00FF00,
		0xFFFFFF00,
		0xFFFF7F00,
		0xFFFF0000
	                                
	    ];
	public static var currentColor:Int = 1;    
	public static var currentColorAgain:Int = 0;    
	

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		Lib.application.window.title = "NF Engine - MainMenuState";
		
        Mainbpm = TitleState.bpm;
        bpm = TitleState.bpm;
        
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		CustomFadeTransition.nextCamera = camHUD;
        //CustomFadeTransition.nextCamera = camAchievement;
        
		//transIn = FlxTransitionableState.defaultTransIn;
		//transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;
		
		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0,0);
		bg.setGraphicSize(Std.int(bg.width));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		
	    bgMove = new FlxBackdrop(Paths.image('mainmenu_sprite/backdrop'), XY, 0, 0);
		bgMove.alpha = 0.1;
		bgMove.color = ColorArray[currentColor];
		bgMove.screenCenter();
		bgMove.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		bgMove.antialiasing = ClientPrefs.data.antialiasing;
		add(bgMove);
		/*
		logoBl = new FlxSprite(0, 0);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.data.antialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.offset.x = 0;
		logoBl.offset.y = 0;
		logoBl.scale.x = (640 / logoBl.frameWidth);
		logoBl.scale.y = logoBl.scale.x;
		//add(logoBl);
		logoBl.x = 320 - logoBl.width / 2;
		logoBl.y = 360 - logoBl.height / 2;
		logoBl.updateHitbox();
        */
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 0.8;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 130 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(-1950, (i * 135)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
			
			
			if (menuItem.ID == curSelected){
			menuItem.animation.play('selected');
			menuItem.updateHitbox();
			}
			
		}
		
		for (i in 0...optionShit.length)
		{
			var option:FlxSprite = menuItems.members[i];
				optionTween[i] = FlxTween.tween(option, {x: 100}, 0.7 + 0.08 * i , {
					ease: FlxEase.backInOut
			    });
		}

		FlxG.camera.follow(camFollow, null, 0);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "NF Engine v" + '1.1.0' + ' (PSYCH v0.7.1h)', 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.antialiasing = ClientPrefs.data.antialiasing;
		add(versionShit);
		versionShit.cameras = [camHUD];
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + '0.2.8', 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		versionShit.antialiasing = ClientPrefs.data.antialiasing;
        versionShit.cameras = [camHUD];
		// NG.core.calls.event.logEvent('swag').send();

		//changeItem();
        /*
		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end*/
		
		#if !android
		FlxG.mouse.visible = true;
		#end
        
		#if android
		addVirtualPad(MainMenuState, A_B_E);
		MusicBeatState._virtualpad.cameras = [camHUD];
		#end
		
		
        
		super.create();
		CustomFadeTransition.nextCamera = camHUD;
	}

    /*
	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end
    */
    
	
	var canClick:Bool = true;
	var canBeat:Bool = true;
	var usingMouse:Bool = true;
	
	var endCheck:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);
		
        if(!endCheck){
		    
		menuItems.forEach(function(spr:FlxSprite)
		{
			if (usingMouse)
			{
				if (!FlxG.mouse.overlaps(spr) && canClick)
					spr.animation.play('idle');
			        spr.updateHitbox();
			        			
    			if (FlxG.mouse.overlaps(spr)){
                    if (FlxG.mouse.justPressed && canClick && spr.animation.curAnim.name != 'idle')
    				{
    				    if (curSelected == spr.ID) {
    				        selectSomething();
    				    }
    				    else    { 
    					    curSelected = spr.ID;
					    		
    					    if (spr.animation.curAnim.name == 'idle') FlxG.sound.play(Paths.sound('scrollMenu'));	    
    					    spr.animation.play('selected');
    					}
    				}
    				if (FlxG.mouse.pressed && canClick){
        			    curSelected = spr.ID;
			    	
        			    if (spr.animation.curAnim.name == 'idle') FlxG.sound.play(Paths.sound('scrollMenu'));	 
        			    spr.animation.play('selected');				    
    			    }
			    }
			}
		});
		
		    if (FlxG.mouse.justPressed) usingMouse = true;
		    
		    if (controls.UI_UP_P)
			{
			    usingMouse = false;
				FlxG.sound.play(Paths.sound('scrollMenu'));				
				curSelected--;
				checkChoose();
			}

			if (controls.UI_DOWN_P)
			{
			    usingMouse = false;
				FlxG.sound.play(Paths.sound('scrollMenu'));
				curSelected++;
				checkChoose();
			}
			
			    
			if (controls.ACCEPT) {
			    usingMouse = false;	
			    canClick = false;
				selectSomething();
		    }
		    
			if (controls.BACK)
			{
				endCheck = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}		
	
			
			#if (desktop || android)
			else if (controls.justPressed('debug_1') #if android || MusicBeatState._virtualpad.buttonE.justPressed #end)
			{
				endCheck = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end 
		
        }
      
        SoundTime = FlxG.sound.music.time / 1000;
        BeatTime = 60 / bpm;
        
        if ( Math.floor(SoundTime/BeatTime) % 4  == 0 && canClick && canBeat) {
        
            canBeat = false;
           
            currentColor++;            
            if (currentColor > 6) currentColor = 1;
            currentColorAgain = currentColor - 1;
            if (currentColorAgain <= 0) currentColorAgain = 6;
            
            FlxTween.color(bgMove, 0.6, ColorArray[currentColorAgain], ColorArray[currentColor], {ease: FlxEase.cubeOut});
           
			camGame.zoom = 1 + 0.015;
			
			//logoBl.animation.play('bump');
			
			//FlxTween.tween(camGame, {zoom: 1}, 0.6, {ease: FlxEase.cubeOut});
			cameraTween[0] = FlxTween.tween(camGame, {zoom: 1}, 0.6, {ease: FlxEase.cubeOut});
		    
			menuItems.forEach(function(spr:FlxSprite)	{
				spr.scale.x = 0.83;
				spr.scale.y = 0.83;
				    FlxTween.tween(spr.scale, {x: 0.8}, 0.6, {ease: FlxEase.cubeOut});
				    FlxTween.tween(spr.scale, {y: 0.8}, 0.6, {ease: FlxEase.cubeOut});
			
				
            });
            
        }
        if ( Math.floor(SoundTime/BeatTime + 0.5) % 4  == 2) canBeat = true;        
        
        bgMove.alpha = 0.1;
   
		

		menuItems.forEach(function(spr:FlxSprite)
		{
		    spr.updateHitbox();
		    spr.centerOffsets();
		    spr.centerOrigin();
		});
		
		
		
		super.update(elapsed);
	}
    
	
    
    function selectSomething()
	{
		endCheck = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		
		
		for (i in 0...optionShit.length)
		{
			var option:FlxSprite = menuItems.members[i];
			if(optionTween[i] != null) optionTween[i].cancel();
			if( i != curSelected)
				optionTween[i] = FlxTween.tween(option, {x: -800}, 0.6 + 0.1 * Math.abs(curSelected - i ), {
					ease: FlxEase.backInOut,
					onComplete: function(twn:FlxTween)
					{
						option.kill();
					}
			    });
		}
		
		if (cameraTween[0] != null) cameraTween[0].cancel();

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (curSelected == spr.ID)
			{				
				
				//spr.animation.play('selected');
			
			    FlxTween.tween(spr, {y: 360 - spr.height / 2}, 0.6, {
					ease: FlxEase.backInOut
			    });
			
			    FlxTween.tween(spr, {x: 640 - spr.width / 2}, 0.6, {
					ease: FlxEase.backInOut				
				});													
			}
		});
		
		
		FlxTween.tween(camGame, {zoom: 2}, 1.2, {ease: FlxEase.cubeInOut});
		FlxTween.tween(camGame, {angle: 0}, 0.8, { //not use for now
		ease: FlxEase.cubeInOut,
		onComplete: function(twn:FlxTween)
				{
			    var daChoice:String = optionShit[curSelected];

				    switch (daChoice)
					    {
						case 'story_mode':
							MusicBeatState.switchState(new StoryMenuState());
						case 'freeplay':
							MusicBeatState.switchState(new FreeplayState());	
						case 'mods':
							MusicBeatState.switchState(new ModsMenuState());									
						case 'options':
							MusicBeatState.switchState(new options.OptionsState());
						case 'credits':
							MusicBeatState.switchState(new CreditsState());	
					    }
				}    
		});
	}
	
	function checkChoose()
	{
	    if (curSelected >= menuItems.length)
	        curSelected = 0;
		if (curSelected < 0)
		    curSelected = menuItems.length - 1;
		    
	    menuItems.forEach(function(spr:FlxSprite){
			spr.animation.play('idle');
		    spr.updateHitbox();

            if (spr.ID == curSelected  && spr.animation.curAnim.name != 'selected')
			{
			    spr.animation.play('selected');
			    spr.centerOffsets();
		    }
        });
	}
}
