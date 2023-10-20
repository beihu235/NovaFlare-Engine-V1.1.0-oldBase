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
    
    public var onChange:Void->Void = null;
    
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
		return "Note offset: < " + ClientPrefs.data.noteOffset + " MS >";
	}

	public override function getValue():String
	{
		return "Note offset: < " + ClientPrefs.data.noteOffset + " MS >";
	}
}

class FrameOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.data.safeFrames -= 0.1 ;
		if (ClientPrefs.data.safeFrames < 0)
			ClientPrefs.data.safeFrames = 0;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.safeFrames += 0.1;
		if (ClientPrefs.data.safeFrames > 10)
			ClientPrefs.data.safeFrames = 10;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.data.safeFrames = 10;
	}

	private override function updateDisplay():String
	{
		return "safeFrames: < " + ClientPrefs.data.safeFrames + " >";
	}
}

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
		if (ClientPrefs.data.sickWindow > 45)
			ClientPrefs.data.sickWindow = 45;
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
		return "Sick Hit Window: < " + ClientPrefs.data.sickWindow + " ms >";
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
		if (ClientPrefs.data.goodWindow > 90)
			ClientPrefs.data.goodWindow = 90;
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
		return "Good Hit Window: < " + ClientPrefs.data.goodWindow + " ms >";
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
		if (ClientPrefs.data.badWindow > 135)
			ClientPrefs.data.badWindow = 135;
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
		return "Bad Hit Window: < " + ClientPrefs.data.badWindow + " ms >";
	}
}


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
            onChangeAntiAliasing();
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

    function onChangeAntiAliasing()
	{
	    /*
		for (sprite in members)
		{
			var sprite:FlxSprite = cast sprite;
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.data.antialiasing;
			}
		}*/
	}
}

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

class FPSRainbowOption extends Option
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
        ClientPrefs.data.rainbowFPS = !ClientPrefs.data.rainbowFPS;
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
		return "FPS Rainbow: < " + (ClientPrefs.data.rainbowFPS ? "Enabled" : "Disabled") + " >";
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
*/ //修改

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
*/
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
		return "GPU Cache: < " + (ClientPrefs.data.cacheOnGPU ? "Enabled" : "Disabled") + " >";
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
