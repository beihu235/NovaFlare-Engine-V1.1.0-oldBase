package options;
import lime.app.Application;

class Option
{
	public function new()
	{
		display = updateDisplay();
	}

	private var description:String = "";
	private var display:String;
	
	private var acceptValues:Bool = false;
    
    public var onChange:Void->Void = null; //Pressed enter (on Bool type options) or pressed/held left/right (on other types)
    
	public var acceptType:Bool = false;

	public var waitingType:Bool = false;
	
	public function change()
	{
		if(onChange != null) {
			onChange();
		}
	}

	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	public function getValue():String
	{
		return updateDisplay();
	};

	public function onType(text:String)
	{
	}

	// Returns whether the label is to be updated.
	public function press():Bool
	{
		return true;
	}

	private function updateDisplay():String
	{
		return "";
	}

	public function left():Bool
	{
		return false;
	}

	public function right():Bool
	{
		return false;
	}
}

/*
class DFJKOption extends Option
{
	public function new()
	{
		super();
                if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = "Edit your keybindings";
	}

	public override function press():Bool
	{
		//OptionsState.instance.selectedCatIndex = 4;
		//OptionsState.instance.switchCat(OptionsState.instance.options[4], false);

        if (OptionsState.isInPause)
			return false;
		OptionsState.openControllsState();
        return true;
	}

	private override function updateDisplay():String
	{
		return "Edit Keybindings";
	}
}

class NotesOption extends Option
{
	public function new()
	{
		super();
        if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = "Edit notes colors";
	}

	public override function press():Bool
	{
		//OptionsState.instance.selectedCatIndex = 4;
		//OptionsState.instance.switchCat(OptionsState.instance.options[4], false);

        if (OptionsState.isInPause)
			return false;
		OptionsState.openNotesState();
        return true;
	}

	private override function updateDisplay():String
	{
		return "Edit Notes Colors";
	}
}

class Customizeption extends Option
{
	public function new()
	{
		super();
        if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = "Edit elements positions / beat offset";
	}

	public override function press():Bool
	{
		//OptionsState.instance.selectedCatIndex = 4;
		//OptionsState.instance.switchCat(OptionsState.instance.options[4], false);


        if (OptionsState.isInPause)
			return false;
		OptionsState.openAjustState();
	    return true;
	}

	private override function updateDisplay():String
	{
		return "Edit elements positions and beat offset";
	}
}*/

class SickMSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.data.sickWindow--;
		if (ClientPrefs.data.sickWindow < 0)
			ClientPrefs.data.sickWindow = 0;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.sickWindow++;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.data.sickWindow = 45;
	}

	private override function updateDisplay():String
	{
		return "SICK: < " + ClientPrefs.data.sickWindow + " ms >";
	}
}

class GoodMsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.data.goodWindow--;
		if (ClientPrefs.data.goodWindow < 0)
			ClientPrefs.data.goodWindow = 0;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.goodWindow++;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.data.goodWindow = 90;
	}

	private override function updateDisplay():String
	{
		return "GOOD: < " + ClientPrefs.data.goodWindow + " ms >";
	}
}

class BadMsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.data.badWindow--;
		if (ClientPrefs.data.badWindow < 0)
			ClientPrefs.data.badWindow = 0;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.badWindow++;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.data.badWindow = 135;
	}

	private override function updateDisplay():String
	{
		return "BAD: < " + ClientPrefs.data.badWindow + " ms >";
	}
}

/*class ShitMsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		FlxG.save.data.shitMs--;
		if (FlxG.save.data.shitMs < 0)
			FlxG.save.data.shitMs = 0;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			FlxG.save.data.shitMs = 160;
	}

	public override function right():Bool
	{
		FlxG.save.data.shitMs++;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "SHIT: < " + FlxG.save.data.shitMs + " ms >";
	}
}*/

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.downScroll = !ClientPrefs.data.downScroll;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Downscroll: < " + (ClientPrefs.data.downScroll ? "Enabled" : "Disabled") + " >";
	}
}

class GhostTapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.ghostTapping = !ClientPrefs.data.ghostTapping;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Ghost Tapping: < " + (ClientPrefs.data.ghostTapping ? "Enabled" : "Disabled") + " >";
	}
}
/*
class SkipTitleOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.skipTitleState = !ClientPrefs.data.skipTitleState;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "TitleState Skipping: < " + (ClientPrefs.data.skipTitleState ? "Enabled" : "Disabled") + " >";
	}
}

class KESustainsOption extends Option
{
	public function new(desc:String)
	{
		super();
         if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
		description = desc;
	}

	public override function left():Bool
	{
        if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.keSustains = !ClientPrefs.data.keSustains;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Kade Engine Sustains System: < " + (ClientPrefs.data.keSustains ? "Enabled" : "Disabled") + " >";
	}
}
*/
class ScoreZoom extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.scoreZoom = !ClientPrefs.data.scoreZoom;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Score zomming in beats: < " + (ClientPrefs.data.scoreZoom ? "Enabled" : "Disabled") + " >";
	}
}

class HideHud extends Option
{
	public function new(desc:String)
	{
		super();
        //if (OptionsState.isInPause)
		//	description = "This option cannot be toggled in the pause menu.";
		//else
			description = desc;

	}

	public override function left():Bool
	{
        //if (OptionsState.isInPause)
		//	return false;
		ClientPrefs.data.hideHud = !ClientPrefs.data.hideHud;

		if (Type.getClass(FlxG.state) == PlayState){

		/*PlayState.instance.healthBarBG.visible = !ClientPrefs.data.hideHud;
		PlayState.instance.healthBar.visible = !ClientPrefs.data.hideHud;
		PlayState.instance.healthBarWN.visible = !ClientPrefs.data.hideHud;
		PlayState.instance.healthStrips.visible  = !ClientPrefs.data.hideHud;
		PlayState.instance.iconP1.visible = !ClientPrefs.data.hideHud;
		PlayState.instance.iconP2.visible = !ClientPrefs.data.hideHud;
		PlayState.instance.songTxt.visible = !(ClientPrefs.data.hideHud || !ClientPrefs.data.songNameDisplay);
		PlayState.instance.scoreTxt.visible = (!ClientPrefs.data.hideHud && !PlayState.instance.cpuControlled);

		PlayState.instance.judgementCounter.visible = (ClientPrefs.data.showJudgement && !ClientPrefs.data.hideHud && !PlayState.instance.cpuControlled);

		if(!ClientPrefs.data.hideHud)
			for (helem in [PlayState.instance.healthBar, PlayState.instance.iconP1, PlayState.instance.iconP2, PlayState.instance.healthBarWN, PlayState.instance.healthBarBG, PlayState.instance.healthStrips]) {
				if (helem != null) {
					helem.visible = ClientPrefs.data.visibleHealthbar;
			}  
		}*/

	    }
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "HUD: < " + (!ClientPrefs.data.hideHud ? "Enabled" : "Disabled") + " >";
	}
}

class ShowComboNum extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.showComboNum = !ClientPrefs.data.showComboNum;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Combo Sprite: < " + (ClientPrefs.data.showComboNum ? "Enabled" : "Disabled") + " >";
	}
}
/*
class BlurNotes extends Option
{
	public function new(desc:String)
	{
		super();
              if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
           	if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.blurNotes = !ClientPrefs.data.blurNotes;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Blured Notes: < " + (ClientPrefs.data.blurNotes ? "Enabled" : "Disabled") + " >";
	}
}

class AutoSave extends Option
{
	public function new(desc:String)
	{
		super();

			description = desc;
	}

	public override function left():Bool
	{

		ClientPrefs.data.chartAutoSave = !ClientPrefs.data.chartAutoSave;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Chart AutoSave: < " + (ClientPrefs.data.chartAutoSave ? "Enabled" : "Disabled") + " >";
	}
}

class AutoSaveInt extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.chartAutoSaveInterval--;
		if (ClientPrefs.data.chartAutoSaveInterval < 1)
		ClientPrefs.data.chartAutoSaveInterval = 1;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.chartAutoSaveInterval++;
		if (ClientPrefs.data.chartAutoSaveInterval > 15)
			ClientPrefs.data.chartAutoSaveInterval = 15;
		display = updateDisplay();
		return true;
	}

	public override function getValue():String
	{
		return "Chart AutoSave Interval: < " + ClientPrefs.data.chartAutoSaveInterval + " Minutes >";
	}
}
*/

class NoReset extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.noReset = !ClientPrefs.data.noReset;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Reset Button: < " + (!ClientPrefs.data.noReset ? "Enabled" : "Disabled") + " >";
	}
}
/*
class DistractionsAndEffectsOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.isInPause)
			return false;
		FlxG.save.data.distractions = !FlxG.save.data.distractions;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Distractions: < " + (!FlxG.save.data.distractions ? "off" : "on") + " >";
	}
}

class Shouldcameramove extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.shouldCameraMove = !ClientPrefs.data.shouldCameraMove;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Dynamic Camera: < " + (ClientPrefs.data.shouldCameraMove ? "Enabled" : "Disabled") + " >";
	}
}

class InstantRespawn extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.instantRespawn = !ClientPrefs.data.instantRespawn;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Instant Respawn: < " + (ClientPrefs.data.instantRespawn ? "Enabled" : "Disabled") + " >";
	}
}
*/
class FlashingLightsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.flashing = !ClientPrefs.data.flashing;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Flashing Lights: < " + (ClientPrefs.data.flashing ? "Enabled" : "Disabled") + " >";
	}
}

class AntialiasingOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.antialiasing = !ClientPrefs.data.antialiasing;
               // onChangeAntiAliasing();
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Antialiasing: < " + (ClientPrefs.data.antialiasing ? "Enabled" : "Disabled") + " >";
	}

       /* function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:Dynamic = sprite; //Make it check for FlxSprite instead of FlxBasic
			var sprite:FlxSprite = sprite; //Don't judge me ok
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.data.globalAntialiasing;
			}
		}
	} */
}
/*
class MissSoundsOption extends Option
{
	public function new(desc:String)
	{
		super();
			description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.playMissSounds = !ClientPrefs.data.playMissSounds;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Miss Sounds: < " + (ClientPrefs.data.playMissSounds ? "Enabled" : "Disabled") + " >";
	}
}

class MissAnimsOption extends Option
{
	public function new(desc:String)
	{
		super();
			description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.playMissAnims = !ClientPrefs.data.playMissAnims;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Miss Animations: < " + (ClientPrefs.data.playMissAnims ? "Enabled" : "Disabled") + " >";
	}
}

class PauseCountDownOption extends Option
{
	public function new(desc:String)
	{
		super();
			description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.countDownPause = !ClientPrefs.data.countDownPause;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "AfterPause CountDown: < " + (ClientPrefs.data.countDownPause ? "Enabled" : "Disabled") + " >";
	}
}

class Judgement extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		if (OptionsState.isInPause)
			return false;
		OptionsState.instance.selectedCatIndex = 5;
		OptionsState.instance.switchCat(OptionsState.instance.options[5], false);
		return true;
	}

	private override function updateDisplay():String
	{
		return "Edit Judgements";
	}
}
*/
class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{	
		ClientPrefs.data.showFPS = !ClientPrefs.data.showFPS;
		
		if(Main.fpsVar != null)
		Main.fpsVar.visible = ClientPrefs.data.showFPS;
			
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}
	
	public override function press():Bool
	{
	    left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter: < " + (ClientPrefs.data.showFPS ? "Enabled" : "Disabled") + " >";
	} 
}

class MEMOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
	    ClientPrefs.data.showMEM = !ClientPrefs.data.showMEM;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Memory Counter: < " + (ClientPrefs.data.showMEM ? "Enabled" : "Disabled") + " >";
	} 
}

class MSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
	    ClientPrefs.data.showMS = !ClientPrefs.data.showMS;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Update time Counter: < " + (ClientPrefs.data.showMS ? "Enabled" : "Disabled") + " >";
	} 
}

class AutoPause extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.autoPause = !ClientPrefs.data.autoPause;
        FlxG.autoPause = ClientPrefs.data.autoPause;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "AutoPause: < " + (ClientPrefs.data.autoPause ? "Enabled" : "Disabled") + " >";
	} 
}
/*
class ShowSplashes extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
        ClientPrefs.data.noteSplashes = !ClientPrefs.data.noteSplashes;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "NoteSplashes: < " + (ClientPrefs.data.noteSplashes ? "Enabled" : "Disabled") + " >";
	} 
}*/
class QualityLow extends Option
{
	public function new(desc:String)
	{
		super();
              if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
             		if (OptionsState.isInPause)
			return false;
        ClientPrefs.data.lowQuality = !ClientPrefs.data.lowQuality;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Low Quality: < " + (ClientPrefs.data.lowQuality ? "Enabled" : "Disabled") + " >";
	} 
}

class FPSCapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "FPS Cap: < " + ClientPrefs.data.framerate + " >";
	}

	override function right():Bool
	{
		if (ClientPrefs.data.framerate >= 290)
		{
			ClientPrefs.data.framerate = 290;
                        onChangeFramerate();
		}
		else
			ClientPrefs.data.framerate = ClientPrefs.data.framerate + 1;
		    onChangeFramerate();

		return true;
	}

	override function left():Bool
	{
		if (ClientPrefs.data.framerate > 290)
			ClientPrefs.data.framerate = 290;
		else if (ClientPrefs.data.framerate <= 60)
			ClientPrefs.data.framerate = Application.current.window.displayMode.refreshRate;
		else
			ClientPrefs.data.framerate = ClientPrefs.data.framerate - 1;
			onChangeFramerate();
		return true;
	}

    function onChangeFramerate()
	{
		if(ClientPrefs.data.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.drawFramerate = ClientPrefs.data.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.data.framerate;
			FlxG.updateFramerate = ClientPrefs.data.framerate;
		}
	}

	override function getValue():String
	{
		return updateDisplay();
	}
}

class HideOppStrumsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.opponentStrums = !ClientPrefs.data.opponentStrums;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Opponent Strums: < " + (!ClientPrefs.data.opponentStrums ? "Enabled" : "Disabled") + " >";
	}
}
/*
class OffsetMenu extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");

		PlayState.SONG = Song.loadFromJson('tutorial', '');
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = 0;
		PlayState.storyWeek = 0;
		//PlayState.offsetTesting = true;
		trace('CUR WEEK' + PlayState.storyWeek);
		LoadingState.loadAndSwitchState(new PlayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Time your offset";
	}
}*/
class OffsetThing extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.noteOffset--;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.noteOffset++;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note offset: < " + ClientPrefs.data.noteOffset + " >";
	}

	public override function getValue():String
	{
		return "Note offset: < " + ClientPrefs.data.noteOffset + " >";
	}
} 

class CamZoomOption extends Option
{
	public function new(desc:String)
	{
		super();
        description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.camZooms = !ClientPrefs.data.camZooms;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Camera Zooming: < " + (ClientPrefs.data.camZooms ? "Enabled" : "Disabled") + " >";
	}
}
/*
class JudgementCounter extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.showJudgement = !ClientPrefs.data.showJudgement;

		if (Type.getClass(FlxG.state) == PlayState){
		if(ClientPrefs.data.showJudgement) 
			PlayState.instance.judgementCounter.visible = (!ClientPrefs.data.hideHud && !PlayState.instance.cpuControlled);
		else
			PlayState.instance.judgementCounter.visible = false;
	    }

		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Judgement Counter: < " + (ClientPrefs.data.showJudgement ? "Enabled" : "Disabled") + " >";
	}
}

class Imagepersist extends Option
{
	public function new(desc:String)
	{
		super();
			description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.imagesPersist = !ClientPrefs.data.imagesPersist;
        FlxGraphic.defaultPersist = ClientPrefs.data.imagesPersist;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Persistent Cached Data: < " + (ClientPrefs.data.imagesPersist ? "Enabled" : "Disabled") + " >";
	}
}

class ControllerMode extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.controllerMode = !ClientPrefs.data.controllerMode;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Controller Mode: < " + (ClientPrefs.data.controllerMode ? "Enabled" : "Disabled") + " >";
	}
}*/

class MiddleScrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.middleScroll = !ClientPrefs.data.middleScroll;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Middle Scroll: < " + (ClientPrefs.data.middleScroll ? "Enabled" : "Disabled") + " >";
	}
}

/*
class NoteskinOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.noteSkinNum--;
		if (ClientPrefs.data.noteSkinNum < 0)
			ClientPrefs.data.noteSkinNum = OptionsHelpers.noteskinArray.length - 4;
     	OptionsHelpers.ChangeNoteSkin(ClientPrefs.data.noteSkinNum);
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.noteSkinNum++;
		if (ClientPrefs.data.noteSkinNum > OptionsHelpers.noteskinArray.length - 1)
			ClientPrefs.data.noteSkinNum = OptionsHelpers.noteskinArray.length - 1;
        OptionsHelpers.ChangeNoteSkin(ClientPrefs.data.noteSkinNum);
		display = updateDisplay();
		return true;
	}

	public override function getValue():String
	{
		return "Current Noteskin: < " + OptionsHelpers.getNoteskinByID(ClientPrefs.data.noteSkinNum) + " >";
	}
}

class AccTypeOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.ratingSystemNum--;
		if (ClientPrefs.data.ratingSystemNum < 0)
			ClientPrefs.data.ratingSystemNum = OptionsHelpers.AccuracyTypeArray.length - 6;
     	OptionsHelpers.ChangeAccType(ClientPrefs.data.ratingSystemNum);
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.ratingSystemNum++;
		if (ClientPrefs.data.ratingSystemNum > OptionsHelpers.AccuracyTypeArray.length - 1)
			ClientPrefs.data.ratingSystemNum = OptionsHelpers.AccuracyTypeArray.length - 1;
        OptionsHelpers.ChangeAccType(ClientPrefs.data.ratingSystemNum);
		display = updateDisplay();
		return true;
	}

	public override function getValue():String
	{
		return "Current Accuracy Type: < " + OptionsHelpers.getAccTypeID(ClientPrefs.data.ratingSystemNum) + " >";
	}
}
*/
class ColorBlindOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.ColorBlindTypeNum--;
		if (ClientPrefs.data.ColorBlindTypeNum < 0)
			ClientPrefs.data.ColorBlindTypeNum = OptionsHelpers.ColorBlindArray.length - 1;
        OptionsHelpers.ChangeColorBlind(ClientPrefs.data.ColorBlindTypeNum);
		ColorblindFilters.applyFiltersOnGame();
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.ColorBlindTypeNum++;
		if (ClientPrefs.data.ColorBlindTypeNum > OptionsHelpers.ColorBlindArray.length - 1)
			ClientPrefs.data.ColorBlindTypeNum = OptionsHelpers.ColorBlindArray.length - 4;
        OptionsHelpers.ChangeColorBlind(ClientPrefs.data.ColorBlindTypeNum);
		ColorblindFilters.applyFiltersOnGame();
		display = updateDisplay();
		return true;
	}

	public override function getValue():String
	{
		return "Color Blindness Type: < " + OptionsHelpers.getColorBlindByID(ClientPrefs.data.ColorBlindTypeNum) + " >";
	}
}
/*
class TimeBarType extends Option
{
	public function new(desc:String)
	{
		super();
        description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.timeBarTypeNum--;
		if (ClientPrefs.data.timeBarTypeNum < 0)
			ClientPrefs.data.timeBarTypeNum = OptionsHelpers.TimeBarArray.length - 3;
     	OptionsHelpers.ChangeTimeBar(ClientPrefs.data.timeBarTypeNum);
		display = updateDisplay();
		if (Type.getClass(FlxG.state) == PlayState){
		PlayState.instance.timeBarBG.visible = (ClientPrefs.data.timeBarType != 'Disabled');
		PlayState.instance.timeBar.visible = (ClientPrefs.data.timeBarType != 'Disabled');
		PlayState.instance.timeTxt.visible = (ClientPrefs.data.timeBarType != 'Disabled');
		}
		return true;
	}

	public override function right():Bool
	{
        ClientPrefs.data.timeBarTypeNum++;
		if (ClientPrefs.data.timeBarTypeNum > OptionsHelpers.TimeBarArray.length - 1)
			ClientPrefs.data.timeBarTypeNum = OptionsHelpers.TimeBarArray.length - 1;
        OptionsHelpers.ChangeTimeBar(ClientPrefs.data.timeBarTypeNum);
		display = updateDisplay();
		if (Type.getClass(FlxG.state) == PlayState){
		PlayState.instance.timeBarBG.visible = (ClientPrefs.data.timeBarType != 'Disabled');
		PlayState.instance.timeBar.visible = (ClientPrefs.data.timeBarType != 'Disabled');
		PlayState.instance.timeTxt.visible = (ClientPrefs.data.timeBarType != 'Disabled');
		}
		return true;
	}

	public override function getValue():String
	{
		return "Time bar type: < " + OptionsHelpers.getTimeBarByID(ClientPrefs.data.timeBarTypeNum) + " >";
	}
}

class HealthBarOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.visibleHealthbar = !ClientPrefs.data.visibleHealthbar;
		display = updateDisplay();

		if (Type.getClass(FlxG.state) == PlayState){
		if(!ClientPrefs.data.hideHud)
			for (helem in [PlayState.instance.healthBar, PlayState.instance.iconP1, PlayState.instance.iconP2, PlayState.instance.healthBarWN, PlayState.instance.healthBarBG, PlayState.instance.healthStrips]) {
				if (helem != null) {
					helem.visible = ClientPrefs.data.visibleHealthbar;
			}  
		}
	    }
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Health Bar: < " + (ClientPrefs.data.visibleHealthbar ? "Enabled" : "Disabled") + " >";
	}
}*/

class HealthBarAlpha extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function right():Bool
	{
		ClientPrefs.data.healthBarAlpha += 0.1;
		if (ClientPrefs.data.healthBarAlpha > 1)
			ClientPrefs.data.healthBarAlpha = 1;
		if (Type.getClass(FlxG.state) == PlayState){
		/*PlayState.instance.healthBarBG.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.healthBar.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.healthBarWN.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.healthStrips.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.iconP1.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.iconP2.alpha = ClientPrefs.data.healthBarAlpha;*/
		}
		return true;
	}

	override function left():Bool
	{
		ClientPrefs.data.healthBarAlpha -= 0.1;

		if (ClientPrefs.data.healthBarAlpha < 0)
			ClientPrefs.data.healthBarAlpha = 0;
		if (Type.getClass(FlxG.state) == PlayState){
		/*PlayState.instance.healthBarBG.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.healthBar.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.healthBarWN.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.healthStrips.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.iconP1.alpha = ClientPrefs.data.healthBarAlpha;
		PlayState.instance.iconP2.alpha = ClientPrefs.data.healthBarAlpha;*/
		}
		return true;
	}

	private override function updateDisplay():String
		{
			return "Healthbar Transparceny: < " + ClientPrefs.data.healthBarAlpha + " >";
		}
	
}
/*
class SustainsAlpha extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
		acceptValues = true;
	}

	override function right():Bool
	{
		if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.susTransper += 0.1;

		if (ClientPrefs.data.susTransper > 1)
			ClientPrefs.data.susTransper = 1;
		return true;
	}

	override function left():Bool
	{
		if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.susTransper -= 0.1;

		if (ClientPrefs.data.susTransper < 0)
			ClientPrefs.data.susTransper = 0;

		return true;
	}

	private override function updateDisplay():String
		{
			return "Sustain Notes Transparceny: < " + Utils.truncateFloat(ClientPrefs.data.susTransper, 1) + " >";
		}
	
}*/

class HitSoundOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	private override function updateDisplay():String
	{
		return "HitSound volume: < " + ClientPrefs.data.hitsoundVolume + " >";
	}

	override function right():Bool
	{
		ClientPrefs.data.hitsoundVolume += 0.1;
		if (ClientPrefs.data.hitsoundVolume > 1)
			ClientPrefs.data.hitsoundVolume = 1;
                FlxG.sound.play(Paths.sound('note_click'), ClientPrefs.data.hitsoundVolume);
		return true;

	}

	override function left():Bool
	{
		ClientPrefs.data.hitsoundVolume -= 0.1;
		if (ClientPrefs.data.hitsoundVolume < 0)
			ClientPrefs.data.hitsoundVolume = 0;
                FlxG.sound.play(Paths.sound('note_click'), ClientPrefs.data.hitsoundVolume);
		return true;
	}
}
/*
class LaneUnderlayOption extends Option
{
	public function new(desc:String)
	{
		super();
	    description = desc;
		acceptValues = true;
	}

	private override function updateDisplay():String
	{
		return "Lane Transparency: < " + Utils.truncateFloat(ClientPrefs.data.underDelayAlpha, 1) + " >";
	}

	override function right():Bool
	{
		ClientPrefs.data.underDelayAlpha += 0.1;

		if (ClientPrefs.data.underDelayAlpha > 1)
			ClientPrefs.data.underDelayAlpha = 1;

		if (Type.getClass(FlxG.state) == PlayState){
			PlayState.instance.laneunderlay.alpha = ClientPrefs.data.underDelayAlpha;
			PlayState.instance.laneunderlayOpponent.alpha = ClientPrefs.data.underDelayAlpha;
		}

		return true;
	}

	override function left():Bool
	{
		ClientPrefs.data.underDelayAlpha -= 0.1;

		if (ClientPrefs.data.underDelayAlpha < 0)
			ClientPrefs.data.underDelayAlpha = 0;

		if (Type.getClass(FlxG.state) == PlayState){
			PlayState.instance.laneunderlay.alpha = ClientPrefs.data.underDelayAlpha;
			PlayState.instance.laneunderlayOpponent.alpha = ClientPrefs.data.underDelayAlpha;
		}

		return true;
	}
}

class SongNameOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.songNameDisplay = !ClientPrefs.data.songNameDisplay;
		display = updateDisplay();
		if (Type.getClass(FlxG.state) == PlayState)
		PlayState.instance.songTxt.visible = !(ClientPrefs.data.hideHud || !ClientPrefs.data.songNameDisplay);
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "SongName Displayed: < " + (ClientPrefs.data.songNameDisplay ? "Enabled" : "Disabled") + " >";
	}
}

class VintageOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.vintageOnGame = !ClientPrefs.data.vintageOnGame;
		display = updateDisplay();
		if (Type.getClass(FlxG.state) == PlayState)
		PlayState.instance.vintage.visible = ClientPrefs.data.vintageOnGame;
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Vintage: < " + (ClientPrefs.data.vintageOnGame ? "Enabled" : "Disabled") + " >";
	}
}*/

class ShadersOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.shaders = !ClientPrefs.data.shaders;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Shaders: < " + (ClientPrefs.data.shaders ? "Enabled" : "Disabled") + " >";
	}
}

class GPUcacheOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.isInPause)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.isInPause)
			return false;
		ClientPrefs.data.cacheOnGPU = !ClientPrefs.data.cacheOnGPU;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Shaders: < " + (ClientPrefs.data.cacheOnGPU ? "Enabled" : "Disabled") + " >";
	}
}

class ComboStacking extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.comboStacking = !ClientPrefs.data.comboStacking;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		left();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Combo Stacking: < " + (ClientPrefs.data.comboStacking ? "Enabled" : "Disabled") + " >";
	}
}
