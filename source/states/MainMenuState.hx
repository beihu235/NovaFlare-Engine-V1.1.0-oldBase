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

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	//private var camHUD:FlxCamera;
	private var camAchievement:FlxCamera;
	
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
	var camFollowPos:FlxObject;
	/*
	
	var test1:FlxText;
	var test3:FlxText;
	var test2:FlxText;
	*/
	
	
	
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
		//camHUD = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;
		//camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		
        //CustomFadeTransition.nextCamera = camAchievement;
        
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;
		
		

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0,0);
		bg.setGraphicSize(Std.int(bg.width));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		
	    bgMove = new FlxBackdrop(Paths.image('mainmenu_sprite/backdrop'), XY, true, true, 0, 0);
		//bgMove.scrollFactor.set();
		bgMove.alpha = 0.1;
		bgMove.color = ColorArray[currentColor];
		bgMove.screenCenter();
		bgMove.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
		//bgMove.antialiasing = ClientPrefs.data.antialiasing;
		add(bgMove);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

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
			
			//menuItem.x = menuItem.x - menuItem.width;
			
			//menuItem.screenCenter(X);
			//menuItem.centerOrigin();
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
			//menuItem.offset.x = menuItem.offset.x * 0.8;
			//menuItem.offset.y = menuItem.offset.y * 0.8;
			
			if (menuItem.ID == curSelected){
			menuItem.animation.play('selected');
			menuItem.updateHitbox();
			//menuItem.centerOffsets();
			//menuItem.offset.x = menuItem.offset.x * 0.8;
			//menuItem.offset.y = menuItem.offset.y * 0.8 + menuItem.width / 2;
			}
			
			FlxTween.tween(menuItem, {x: 100}, (0.5 + 0.06 * i), {
			    ease: FlxEase.quadOut,
			    type: ONESHOT,
				onComplete: function(twn:FlxTween)
				    {

				    }
				});                                   
		}

		FlxG.camera.follow(camFollow, null, 0);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "NF Engine v" + '1.0.1' + ' (PSYCH v0.6.3)', 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.antialiasing = ClientPrefs.data.antialiasing;
		add(versionShit);
		//versionShit.cameras = [camHUD];
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + '0.2.8', 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		versionShit.antialiasing = ClientPrefs.data.antialiasing;
        //versionShit.cameras = [camHUD];
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
		/*
		 test1 = new FlxText(12, FlxG.height - 84, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		test1.scrollFactor.set();
		test1.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(test1);
		
	test2 = new FlxText(12, FlxG.height - 72, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		test2.scrollFactor.set();
		test2.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(test2);
		
		test3 = new FlxText(12, FlxG.height - 60, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		test3.scrollFactor.set();
		test3.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(test3);
        */
        
		#if android
		addVirtualPad(NONE, A_B_E);
		//_virtualpad.cameras = [camHUD];
		#end
		
		

		super.create();
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
    
	var selectedSomethin:Bool = false;
	
	var canClick:Bool = true;
	var canBeat:Bool = true;
	var usingMouse:Bool = true;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		if (FlxG.mouse.justPressed) usingMouse = true;
		
		if (controls.UI_UP_P)
			{
			    usingMouse = false;
				FlxG.sound.play(Paths.sound('scrollMenu'));				
				curSelected--;
			}

			if (controls.UI_DOWN_P)
			{
			    usingMouse = false;
				FlxG.sound.play(Paths.sound('scrollMenu'));
				curSelected++;
			}
			
			if (curSelected >= menuItems.length)
			    curSelected = 0;
		    if (curSelected < 0)
			    curSelected = menuItems.length - 1;
			    
			if (controls.ACCEPT) selectSomething();
		
		menuItems.forEach(function(spr:FlxSprite)
		{
			if (usingMouse)
			{
				if (!FlxG.mouse.overlaps(spr) && canClick)
					spr.animation.play('idle');
					//spr.offset.x = spr.offset.x * 0.8;
			        //spr.offset.y = spr.offset.y * 0.8;
			        spr.updateHitbox();
			        
			

			if (FlxG.mouse.overlaps(spr))
			{
			    //usingMouse = true;
                if (FlxG.mouse.justPressed && canClick && spr.animation.curAnim.name != 'idle')
				{
				    if (curSelected == spr.ID) {
				        selectSomething();
				    }
				    else    {					    
					    curSelected = spr.ID;
					    
					    		
					    if (spr.animation.curAnim.name == 'idle') FlxG.sound.play(Paths.sound('scrollMenu'));	    
					    spr.animation.play('selected');						    
					   
					    //spr.offset.x = spr.offset.x * 0.8;
			            //spr.offset.y = spr.offset.y * 0.8 + spr.width / 2;
			            
			            
					}
				}
				if (FlxG.mouse.pressed && canClick){
			    curSelected = spr.ID;
			    	
			    if (spr.animation.curAnim.name == 'idle') FlxG.sound.play(Paths.sound('scrollMenu'));	 
			    spr.animation.play('selected');	
			    //spr.offset.x = spr.offset.x * 0.8;
			    //spr.offset.y = spr.offset.y * 0.8 + spr.width / 2;
			    
			    
			    }
			    }
			}
			else{
	
				    menuItems.forEach(function(spr:FlxSprite){
			        spr.animation.play('idle');
			        //spr.updateHitbox();

			        if (spr.ID == curSelected)
			        {
			        	spr.animation.play('selected');
			        	//spr.centerOffsets();
			        }
		        });
			}
		});
		
		if (!selectedSomethin)
		{
			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}		
	
			
			#if (desktop || android)
			else if (controls.justPressed('debug_1') #if android || MusicBeatState._virtualpad.buttonE.justPressed #end)
			{
				selectedSomethin = true;
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
           
			//camGame.zoom = 1 + 0.03;
			//camGame.scale.y = 1 + 0.015;
			//FlxTween.tween(camGame, {zoom: 1}, 0.6, {ease: FlxEase.cubeOut});
			
			menuItems.forEach(function(spr:FlxSprite)	{
			/*	spr.scale.x = 0.83;
				spr.scale.y = 0.83;
				    FlxTween.tween(spr.scale, {x: 0.8}, 0.6, {ease: FlxEase.cubeOut});
				    FlxTween.tween(spr.scale, {y: 0.8}, 0.6, {ease: FlxEase.cubeOut});
			*/
				
            });
            
        }
        if ( Math.floor(SoundTime/BeatTime + 0.5) % 4  == 2) canBeat = true;        
        
        bgMove.alpha = 0.1;
        /*
        test1.text = "time: " + SoundTime;
        test2.text = "beatTime: " + BeatTime;
        test3.text = "startbeat: " + ((SoundTime / BeatTime) % 4);
        */
		

		menuItems.forEach(function(spr:FlxSprite)
		{
		    spr.updateHitbox();
		    spr.centerOffsets();
		    spr.centerOrigin();
		});
		
		//CustomFadeTransition.nextCamera = camHUD;
		
		super.update(elapsed);
	}
    
	
    
    function selectSomething()
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		canClick = false;

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (curSelected != spr.ID)
			{
				FlxTween.tween(spr, {x: -800}, 0.6 + 0.1 * Math.abs(curSelected - spr.ID), {
					ease: FlxEase.backInOut,
					onComplete: function(twn:FlxTween)
					{
						spr.kill();
					}
			    });
			}
			else
			{				
				//
			
			    FlxTween.tween(spr, {y: 360 - spr.height / 2}, 0.6, {
					ease: FlxEase.backInOut,
					onComplete: function(twn:FlxTween)
					{
						//spr.kill();
					}
			    });
			
			    FlxTween.tween(spr, {x: 640 - spr.width / 2}, 0.6, {
					ease: FlxEase.backInOut				
				});													
			}
		});
		
		
		//FlxTween.tween(camGame, {zoom: 2}, 1.2, {ease: FlxEase.cubeInOut});
		//camGame.fade(FlxColor.BLACK, 1.2, false);
		//camHUD.fade(FlxColor.BLACK, 1.2, false);
		FlxTween.tween(camGame, {angle: 0}, 0.8, {
		ease: FlxEase.cubeInOut,
		onComplete: function(twn:FlxTween)
				{
				
				//CustomFadeTransition.nextCamera = camGame;
				
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
}