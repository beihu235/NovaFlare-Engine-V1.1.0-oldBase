package options;

import states.MainMenuState;
import substates.PauseSubState;

import options.Option;

import options.ControlsSubState;
import options.NoteOffsetState;
import options.NotesSubState;

import backend.ClientPrefs;

import flixel.addons.display.FlxBackdrop;

import backend.StageData;

import flixel.addons.transition.FlxTransitionableState;
import flixel.input.gamepad.FlxGamepad;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxSave;


class OptionCata extends FlxSprite
{
	public var title:String;
	public var options:Array<Option>;

	public var optionObjects:FlxTypedGroup<FlxText>;

	public var titleObject:FlxText;
	
	public var positionFix:Int;

	public var middle:Bool = false;

	public function new(x:Float, y:Float, _title:String, _options:Array<Option>, middleType:Bool = false)
	{
		super(x, y);
		title = _title;
		middle = middleType;
		if (!middleType)
			makeGraphic(295, 64, FlxColor.BLACK);
		alpha = 0.4;

		options = _options;

		optionObjects = new FlxTypedGroup();
		
		var langTTF:String = '';		
	    langTTF = OptionsName.setTTF();
		langTTF = langTTF + '.ttf'; //fix

		titleObject = new FlxText((middleType ? 1180 / 2 : x), y + (middleType ? 16 + 64 : 16), 1180, title);
		titleObject.setFormat(Paths.font(langTTF), 35, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleObject.antialiasing = ClientPrefs.data.antialiasing;
		titleObject.borderSize = 2;
        if (titleObject.fieldWidth > 295) titleObject.size -= 2;
		if (middleType)
		{
			titleObject.x = 50 + ((1180 / 2) - (titleObject.fieldWidth / 2));
		}
		else
			titleObject.x += (width / 2) - (titleObject.fieldWidth / 2);

		titleObject.scrollFactor.set();

		scrollFactor.set();
		
		positionFix = 40 + 64 + (middleType ? 16 + 64 + 16: 16); // work like titleObject.y but set line is two.
        //midd的40是16＋24
		for (i in 0...options.length)
		{
			var opt = options[i];
			var text:FlxText = new FlxText((middleType ? 1180 / 2 : 72), positionFix + 54 + (46 * i), 0, opt.getValue());
			if (middleType)
			{
				text.screenCenter(X);
			}
			text.setFormat(Paths.font(langTTF), 35, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.antialiasing = ClientPrefs.data.antialiasing;
			text.borderSize = 2;
			text.borderQuality = 1;
			text.scrollFactor.set();
			optionObjects.add(text);
		}
	}

	public function changeColor(color:FlxColor)
	{
		makeGraphic(295, 64, color);
	}
}

class OptionsState extends MusicBeatSubstate
{
	public static var instance:OptionsState;

	public var background:FlxSprite;

	public var selectedCat:OptionCata;

	public var selectedOption:Option;

	public var selectedCatIndex = 0;
	public var selectedOptionIndex = 0;
	
	public var saveSelectedCatIndex = 0;
	public var saveSelectedOptionIndex = 0;

	public var isInCat:Bool = false;

	public var options:Array<OptionCata>;

	public static var isInPause = false;	
	public static var langChange = false;

	var restoreSettingsText:FlxText;

	public var shownStuff:FlxTypedGroup<FlxText>;

	public static var visibleRange = [114, 640];

	var startSong = true;
	
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

	public var optionsImage:FlxSprite;
	public function new(pauseMenu:Bool = false, languageChange:Bool = false)
	{
		super();

		isInPause = pauseMenu;
		langChange = languageChange;
	}

	public var menu:FlxTypedGroup<FlxSprite>;

	public var descText:FlxText;
	public var descBack:FlxSprite;
	
	var Gameplay:String;
    var Appearance:String;
    var Misc:String;
    var OpponentMode:String;
    var MenuExtend:String;
    var Controls:String;
    
	override function create()
	{

		/*if (!isInPause)
		  if(!ControlsSubState.fromcontrols)
			if(startSong)
				FlxG.sound.playMusic(Paths.music('optionsSong'));
			else
				startSong = true;
        */      
        
        Gameplay = OptionsName.setGameplay();
        Appearance = OptionsName.setAppearance();
        Misc = OptionsName.setMisc();
        OpponentMode = OptionsName.setOpponentMode();
        MenuExtend = OptionsName.setMenuExtend();
        Controls = OptionsName.setControls();
        //reset name
        
		options = [
			new OptionCata(50, 40, Gameplay, [				
				new DownscrollOption("Toggle making the notes scroll down rather than up."),
				new MiddleScrollOption("Put your lane in the center or on the right."), 
				new HitSoundOption("Adds 'hitsound' on note hits."),
				new GhostTapOption("Toggle counting pressing a directional input when no arrow is there as a miss."),				
				//new InstantRespawn("Toggle if you instantly respawn after dying."),
				new AutoPause("Stops game, when its unfocused"),
				new NoReset("Toggle pressing R to gameover."),
				
				
                //new ControllerMode("Enables you to play with controller."),
                //new DFJKOption(),
                //new NotesOption(),
                //new Customizeption(),
				new Judgement("Create a custom judgement preset"),
				//new Shouldcameramove("Moves camera on opponent/player note hits."),
			]),
			new OptionCata(345, 40, Appearance, [
                //new NoteskinOption("Change your current noteskin"),
				//new AccTypeOption("Change your current accuracy type you want!"),
				//new SongNameOption("Shows to you name of song your playing on HUD"),			
				new HideOppStrumsOption("Shows/Hides opponent strums on screen.(RESTART SONG)"),
				//new MissSoundsOption("Toggle miss sounds playing when you don't hit a note."),
				//new MissAnimsOption("Toggle miss animations playing when you don't hit a note."),
                //new ShowSplashes("Show particles on SICK hit."),
               // new SustainsAlpha("Change Sustain Notes Alpha."),
				//new HealthBarOption("Toggles health bar visibility"),
				//new JudgementCounter("Show your judgements that you've gotten in the song"),
				//new LaneUnderlayOption("How transparent your lane is, higher = more visible."),
				new CamZoomOption("Toggle the camera zoom in-game."),
                new HideHud("Shows to you hud."),
                new ShowComboNum("Combo sprite appearance."),
				new ComboStacking("Ratings and Combo won't stack, saving on System Memory and making them easier to read."),
                new ScoreZoom("Zoom score on 2'nd beat."),
                new HealthBarAlpha("Healthbar Transparceny."),
                //new BlurNotes("(CONTAINS FPS ISSUES)/Make notes a bit 'blurred'."), // TODO: rework later - Snake
			    //new TimeBarType("Change the song's current position bar."),
			]),
			new OptionCata(640, 40, Misc, [
			    new Language("Change language to Chinese."),
				new FlashingLightsOption("Toggle flashing lights that can cause epileptic seizures and strain."),
				new QualityLow("Turn off some object on stages"),
				new AntialiasingOption("Toggle antialiasing, improving graphics quality at a slight performance penalty."),
				//new ColorBlindOption("You can set colorblind filter (makes the game more playable for colorblind people)."),
				new ShadersOption("Shaders used for some visual effects, and also CPU intensive for weaker PCs."),
				new GPUcacheOption("If checked, allows the GPU to be used for caching textures, decreasing RAM usage."),
				new FPSCapOption("Change your FPS Cap."),		
				new FPSRainbowOption("Make the FPS Counter flicker through rainbow colors."),
				new FPSOption("Toggle the FPS Counter."),
                new MEMOption("Toggle the MEM Counter."),
                new MSOption("Toggle the update time Counter."),
                
				//new VintageOption("Adds 'vintage' on game screen."),
                
                
				//new Imagepersist("Images loaded will stay in memory until the game is closed."),
        		]),
			new OptionCata(935, 40, OpponentMode, [
			    new HideHud("Shows to you hud."),
				//new ResetSettings("Reset some your settings. This is irreversible!")
				//new AutoSave("Turn AutoSaves your chating in Charting state."),
				//new AutoSaveInt("Change Chart AutoSave Interval."),               
			 //   new PauseCountDownOption("Toggle countdown after pressing 'Resume' in Pause Menu."),
			]),
			new OptionCata(50, 40 + 64, Controls, [
			    new HideHud("Shows to you hud."),				
			]),
			new OptionCata(345, 40 + 64, MenuExtend, [
			    new HideHud("Shows to you hud."),				
			]),
			new OptionCata(-1, 125, "Editing Judgements", [			
				new FrameOption("Changes how many frames you have for hitting a note earlier or late."),
				new OffsetThing("Change the note visual offset (how many milliseconds a note looks like it is offset in a chart)"),
				new SickMSOption("How many milliseconds are in the SICK hit window"),
				new GoodMsOption("How many milliseconds are in the GOOD hit window"),
				new BadMsOption("How many milliseconds are in the BAD hit window"),
			], true)
		];

		instance = this;

		menu = new FlxTypedGroup<FlxSprite>();

		shownStuff = new FlxTypedGroup<FlxText>();
        
		background = new FlxSprite(50, 40).makeGraphic(1180, 640, FlxColor.BLACK);
		background.alpha = 0.5;
		background.scrollFactor.set();
		menu.add(background);
        
		descBack = new FlxSprite(50, 640).makeGraphic(1180, 40, FlxColor.BLACK);
		descBack.alpha = 0.3;
		descBack.scrollFactor.set();
		menu.add(descBack);
        
		if (isInPause)
		{
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			bg.alpha = 0;
			bg.scrollFactor.set();
			menu.add(bg);

			background.alpha = 0.3;
			bg.alpha = 0.4;

			cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		}else{
		    var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
    		bg.scrollFactor.set(0,0);
    		bg.setGraphicSize(Std.int(bg.width));
    		bg.updateHitbox();
    		bg.screenCenter();
    		bg.antialiasing = ClientPrefs.data.antialiasing;
    		add(bg);
    		
        	var bgMove:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu_sprite/backdrop'), XY, 0, 0);
    		bgMove.alpha = 0.1;
    		bgMove.color = ColorArray[currentColor];
    		bgMove.screenCenter();
    		bgMove.velocity.set(FlxG.random.bool(50) ? 90 : -90, FlxG.random.bool(50) ? 90 : -90);
    		bgMove.antialiasing = ClientPrefs.data.antialiasing;
    		add(bgMove);	
		
		}

		selectedCat = langChange ? options[2] : options[0];

		//selectedOption = langChange ? selectedCat.options[2] : selectedCat.options[0];

		add(menu);

		add(shownStuff);

		for (i in 0...options.length - 1)
		{
			/*if (i >= 4)
				continue;*/
			var cat = options[i];
			add(cat);
			add(cat.titleObject);
		}
		
		var langTTF:String = '';		
	    langTTF = OptionsName.setTTF();
		langTTF = langTTF + '.ttf'; //fix

		descText = new FlxText(62, 648);
		descText.setFormat(Paths.font(langTTF), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.antialiasing = ClientPrefs.data.antialiasing;
		descText.borderSize = 2;

		add(descBack);
		add(descText);

		isInCat = langChange ? false : true;
		switchCat(selectedCat);
		selectedCatIndex = langChange ? 2 : 0;
		selectedOption = langChange ? selectedCat.options[0] : selectedCat.options[0];
		selectedOptionIndex = langChange ? 0 : 0;
		//相同变量值仅仅是为了以后好开发
        
        var resetText = 'Press' +  #if android ' C' #else ' Reset' #end + ' to reset settings';
		restoreSettingsText = new FlxText (62, 680, FlxG.width, resetText);
		restoreSettingsText.setFormat(Paths.font(langTTF), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		restoreSettingsText.scrollFactor.set();
		restoreSettingsText.antialiasing = ClientPrefs.data.antialiasing;
		restoreSettingsText.borderSize = 2;
		restoreSettingsText.borderQuality = 3;
		add(restoreSettingsText);

		#if android
        addVirtualPad(FULL, A_B_C);
        addPadCamera();
        #end
		
		super.create();
	}

	public function switchCat(cat:OptionCata, checkForOutOfBounds:Bool = true)
	{
		try
		{
			visibleRange = [Std.int(cat.positionFix + 64), 640]; /*
			/*变量乱七八糟的我都服了，显示你得加64px去修复到开始第2个格下面
			  因为text在positionFix那里还加了偏移
			*/
			/*if (cat.middle)
				visibleRange = [Std.int(cat.positionFix), 640];*/
				
			if (selectedOption != null)
			{
				var object = selectedCat.optionObjects.members[selectedOptionIndex];
				object.text = selectedOption.getValue();
			}

			if (selectedCatIndex > options.length - 2 && checkForOutOfBounds)
				selectedCatIndex = 0;

			if (selectedCat.middle)
				remove(selectedCat.titleObject);

			selectedCat.changeColor(FlxColor.BLACK);
			selectedCat.alpha = 0.4;

			for (i in 0...selectedCat.options.length)
			{
				var opt = selectedCat.optionObjects.members[i];
				opt.y = selectedCat.positionFix + 54 + (46 * i);
			}

			while (shownStuff.members.length != 0)
			{
				shownStuff.members.remove(shownStuff.members[0]);
			}
			selectedCat = cat;
			selectedCat.alpha = 0.2;
			selectedCat.changeColor(FlxColor.WHITE);

			if (selectedCat.middle)
				add(selectedCat.titleObject);

			for (i in selectedCat.optionObjects)
				shownStuff.add(i);

			selectedOption = selectedCat.options[0];

			if (selectedOptionIndex > options[selectedCatIndex].options.length - 1)
			{
				for (i in 0...selectedCat.options.length)
				{
					var opt = selectedCat.optionObjects.members[i];
					opt.y = selectedCat.positionFix + 54 + (46 * i);
				}
			}

			selectedOptionIndex = 0;

			if (!isInCat)
				selectOption(selectedOption);

			for (i in selectedCat.optionObjects.members)
			{
				if (i.y < visibleRange[0] - 24)
					i.alpha = 0;
				else if (i.y > visibleRange[1] - 24)
					i.alpha = 0;
				else
				{
					i.alpha = 0.4;
				}
			}
		}
	}

	public function selectOption(option:Option)
	{
		var object = selectedCat.optionObjects.members[selectedOptionIndex];

		selectedOption = option;

		if (!isInCat)
		{
			object.text = option.getValue();

			descText.text = option.getDescription();
		}
	}

	public static function openControllsState()
		{
			MusicBeatState.switchState(new ControlsSubState());
			ClientPrefs.saveSettings();
		}

	public static function openNotesState()
		{
			MusicBeatState.switchState(new NotesSubState());
			ClientPrefs.saveSettings();
		}

    public static function openAjustState()
		{
			LoadingState.loadAndSwitchState(new NoteOffsetState());
			ClientPrefs.saveSettings();
		}
    
     var accept = false;
     var back = false;
	 var reset = false;
	 
	 var right = false;
	 var left = false;
	 var up = false;
	 var down = false;
	 
	 var right_hold = false;
	 var left_hold = false;
	 var up_hold = false;
	 var down_hold = false;
	 
	 var anyKey = false;
	 
	 var holdTime:Float = 0;	
	 var updatePower:Float = 1;
	 
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (c in options) {
			c.titleObject.text = c.title;
			for (o in 0...c.optionObjects.length) {
				c.optionObjects.members[o].text = c.options[o].getValue();
			}
		}
        /*
		if(FlxG.keys.justPressed.F11)
			{
			FlxG.fullscreen = !FlxG.fullscreen;
			}
        */
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;		

		accept = controls.ACCEPT;
		right = controls.UI_RIGHT_P;
		left = controls.UI_LEFT_P;
		up = controls.UI_UP_P;
		down = controls.UI_DOWN_P;
		
		right_hold = false;
        left_hold = false;
	    up_hold = false;
		down_hold = false;
		
		if (controls.UI_RIGHT_P || controls.UI_LEFT_P || controls.UI_UP_P || controls.UI_DOWN_P)
		holdTime = 0;
		updatePower = 1;
		
		if(controls.UI_DOWN || controls.UI_UP || controls.UI_LEFT || controls.UI_RIGHT)
			{
			    if (Math.floor(holdTime) % 2 == 0) updatePower = updatePower * 1.5; //2秒增加1.5倍选择
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10 * updatePower);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10 * updatePower);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0){
				    right_hold = controls.UI_RIGHT;
				    left_hold = controls.UI_LEFT;
				    up_hold = controls.UI_UP;
				    down_hold = controls.UI_DOWN;
				}	            
			}

		anyKey = FlxG.keys.justPressed.ANY || (gamepad != null ? gamepad.justPressed.ANY : false);
		back = controls.BACK;
		reset = controls.RESET #if android || MusicBeatSubstate._virtualpad.buttonC.justPressed #end;

		try
		{
			if (isInCat)
			{
				descText.text = "Please select a category";
				if (right)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
					selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
					selectedCatIndex++;

					if (selectedCatIndex > options.length - 2)
						selectedCatIndex = 0;
					if (selectedCatIndex < 0)
						selectedCatIndex = options.length - 2;

					switchCat(options[selectedCatIndex]);
				}
				else if (left)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
					selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
					selectedCatIndex--;

					if (selectedCatIndex > options.length - 2)
						selectedCatIndex = 0;
					if (selectedCatIndex < 0)
						selectedCatIndex = options.length - 2;

					switchCat(options[selectedCatIndex]);
				}

				if (accept)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
					selectedOptionIndex = 0;
					isInCat = false;
					selectOption(selectedCat.options[0]);
				}

				if(reset)
				{
					if (!isInPause)
					{
						resetOptions();
						restoreSettingsText.text = 'Settings restored // Restarting game';
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							
                            FlxG.sound.music.fadeOut(0.3);
                            FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
						});
					}
					else
					{
						restoreSettingsText.text = 'Unable in PauseMenu';
					}
				}

				if (back)
				{
					if (!isInPause) {
					    ClientPrefs.saveSettings();
					    FlxTransitionableState.skipNextTransIn = true;
			            FlxTransitionableState.skipNextTransOut = true;
						MusicBeatState.switchState(new MainMenuState());
                        //FlxG.sound.music.stop();
					    }
					else
					{
						PauseSubState.goBack = true;
						ClientPrefs.saveSettings();
						close();
					}
				}
			}
			else
			{
				if (selectedOption != null)
					if (selectedOption.acceptType)
					{
						if (back && selectedOption.waitingType)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
							selectedOption.waitingType = false;
							var object = selectedCat.optionObjects.members[selectedOptionIndex];
							object.text = selectedOption.getValue();
							//Debug.logTrace("New text: " + object.text);
							return;
						}
						else if (anyKey)
						{
							var object = selectedCat.optionObjects.members[selectedOptionIndex];
							selectedOption.onType(gamepad == null ? FlxG.keys.getIsDown()[0].ID.toString() : gamepad.firstJustPressedID());
							object.text = selectedOption.getValue();
						//	Debug.logTrace("New text: " + object.text);
						}
					}
				if (selectedOption.acceptType || !selectedOption.acceptType) //这啥玩意这
				{
					if (accept)
					{
						var prev = selectedOptionIndex;
						var object = selectedCat.optionObjects.members[selectedOptionIndex];																		
           				
						selectedOption.press();
                        selectedOption.change();
						if (selectedOptionIndex == prev)
						{
							ClientPrefs.saveSettings();

							object.text = selectedOption.getValue();
						}
					}

					if (down || down_hold)
					{
						if (selectedOption.acceptType)
							selectedOption.waitingType = false;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						selectedOptionIndex++;

						if (selectedOptionIndex > options[selectedCatIndex].options.length - 1)
						{
							for (i in 0...selectedCat.options.length)
							{
								var opt = selectedCat.optionObjects.members[i];
								opt.y = selectedCat.positionFix + 54 + (46 * i);
							}
							selectedOptionIndex = 0;
						}

						if (selectedOptionIndex != 0
							&& selectedOptionIndex != options[selectedCatIndex].options.length - 1
							&& options[selectedCatIndex].options.length > 6)
						{
							if (selectedOptionIndex >= (options[selectedCatIndex].options.length - 1) / 2)
								for (i in selectedCat.optionObjects.members)
								{
									i.y -= 46;
								}
						}

						selectOption(options[selectedCatIndex].options[selectedOptionIndex]);
					}
					else if (up || up_hold)
					{
						if (selectedOption.acceptType)
							selectedOption.waitingType = false;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						selectedOptionIndex--;

						if (selectedOptionIndex < 0)
						{
							selectedOptionIndex = options[selectedCatIndex].options.length - 1;
							
                            if (options[selectedCatIndex].options.length > 6)
							for (i in 0...selectedCat.options.length)
							{
								var opt = selectedCat.optionObjects.members[i];
								opt.y = selectedCat.positionFix + 54 + (46 * (i - Math.floor(selectedCat.options.length / 2 + 0.5)));
							}
						}

						if (selectedOptionIndex != 0 && options[selectedCatIndex].options.length > 6)
						{
							if (selectedOptionIndex >= (options[selectedCatIndex].options.length - 1) / 2)
								for (i in selectedCat.optionObjects.members)
								{
									i.y += 46;
								}
						}

						if (selectedOptionIndex < (options[selectedCatIndex].options.length - 1) / 2)
						{
							for (i in 0...selectedCat.options.length)
							{
								var opt = selectedCat.optionObjects.members[i];
								opt.y = selectedCat.positionFix + 54 + (46 * i);
							}
						}

						selectOption(options[selectedCatIndex].options[selectedOptionIndex]);
					}

					if (right || right_hold)
					{
						if (!right_hold) FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.right();
                        selectedOption.change();
						ClientPrefs.saveSettings();

						object.text = selectedOption.getValue();
					}
					else if (left || left_hold)
					{
						if (!left_hold) FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.left();
                        selectedOption.change();
						ClientPrefs.saveSettings();

						object.text = selectedOption.getValue();
					}

					if(reset)
					{
						if (!isInPause)
						{
							resetOptions();
							restoreSettingsText.text = 'Settings restored // Restarting game';
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
							new FlxTimer().start(1.5, function(tmr:FlxTimer)
							{
								
                                FlxG.sound.music.fadeOut(0.3);
                                FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
							});
						}
						else
						{
							restoreSettingsText.text = 'Unable in PauseMenu';
						}
					}

					if (back)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
                        
						if (selectedCatIndex >= 9)  //这是干啥用的
							selectedCatIndex = 0;

						for (i in 0...selectedCat.options.length)
						{
							var opt = selectedCat.optionObjects.members[i];
							opt.y = selectedCat.positionFix + 54 + (46 * i);
						}
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();													
						
						if (selectedCat.middle){
						    isInCat = false;
							switchCat(options[saveSelectedCatIndex]);        					        					
        					selectOption(selectedCat.options[saveSelectedOptionIndex]);	
        					selectedOptionIndex = saveSelectedOptionIndex;
        					
        					
								for (i in selectedCat.optionObjects.members)
								{
									i.y -= (46 * ((options[selectedCatIndex].options.length - 1) / 2));
								}
						    
        					
        					saveSelectedOptionIndex = 0;
        					saveSelectedCatIndex = 0;
						}
						else{
						    isInCat = true;
						}
						
						if (selectedCat.optionObjects != null){ //别删这个if包含的代码，会出问题
							for (i in selectedCat.optionObjects.members)
							{
								if (i != null)
								{
									if (i.y < visibleRange[0] - 24)
										i.alpha = 0;
									else if (i.y > visibleRange[1] - 24)
										i.alpha = 0;
									else
									{
										i.alpha = 0.4;
									}
								}
						    }
						}    
					}
				}
			}
		}//毫无意义的try		
		
		//descText.text = '' + ClientPrefs.data.language;
		
		if (selectedCat != null && !isInCat)
		{
			for (i in selectedCat.optionObjects.members)
			{
				if (selectedCat.middle)
				{
					i.screenCenter(X);
				}

				// I wanna die!!!
				if (i.y < visibleRange[0] - 24)
					i.alpha = 0;
				else if (i.y > visibleRange[1] - 24)
					i.alpha = 0;
				else
				{
					if (selectedCat.optionObjects.members[selectedOptionIndex].text != i.text)
						i.alpha = 0.4;
					else
						i.alpha = 1;
				}
			}
		}
	}

	public static function resetOptions()
	{

	}
}

