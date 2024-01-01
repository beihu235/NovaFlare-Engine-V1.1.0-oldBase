package options;

import lime.app.Application;
import backend.MusicBeatState;

import flixel.addons.transition.FlxTransitionableState;
import options.OptionsHelpers;

import shaders.ColorblindFilter;

class Option
{
	public function new()
	{
	    disable_O = OptionsName.funcDisable();
	    enable_O = OptionsName.funcEnable();
	    MS_O = OptionsName.funcMS();
	    grid_O = OptionsName.funcGrid();
		display = updateDisplay();
	}

	private var description:String = "";
	private var display:String;
	
	private var acceptValues:Bool = false;
	
	private var disable_O:String = '';
	private var enable_O:String = '';
	private var MS_O:String = '';
	private var grid_O:String = '';
    
    //public var onChange:Void->Void = null;
    
	public var acceptType:Bool = false;

	public var waitingType:Bool = false;
	
	public function change():Void
	{
	    //nothing
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
	
	public function left():Bool
	{
		return false;
	}

	public function right():Bool
	{
		return false;
	}
	
	private function updateDisplay():String
	{
		return "";
	}
}

class Judgement extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		if (OptionsState.onPlayState)
			return false;
			
		//OptionsState.instance.saveSelectedOptionIndex = OptionsState.instance.selectedOptionIndex;
		//OptionsState.instance.saveSelectedCatIndex = OptionsState.instance.selectedCatIndex;
		
		var num:Int = 8;	
		OptionsState.instance.selectedCatIndex = num;
		OptionsState.instance.switchCat(OptionsState.instance.options[num], false);
		
		return true;
	}

	private override function updateDisplay():String
	{
		return "Edit Judgements";
	}
}

class OffsetThing extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		ClientPrefs.data.noteOffset--;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		ClientPrefs.data.noteOffset++;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note offset: < " + ClientPrefs.data.noteOffset + MS_O + " >";
	}

	public override function getValue():String
	{
		return "Note offset: < " + ClientPrefs.data.noteOffset + MS_O + " >";
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

class MarvelousMsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.data.marvelousWindow--;
		if (ClientPrefs.data.marvelousWindow < 0)
			ClientPrefs.data.marvelousWindow = 0;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.marvelousWindow++;
		if (ClientPrefs.data.marvelousWindow > 166)
			ClientPrefs.data.marvelousWindow = 166;
		display = updateDisplay();
		return true;
	}

	public override function onType(char:String)
	{
		if (char.toLowerCase() == "r")
			ClientPrefs.data.marvelousWindow = 45;
	}

	private override function updateDisplay():String
	{
		return "Marvelous Hit Window: < " + ClientPrefs.data.marvelousWindow + MS_O + " >";
	}
}

class SickMsOption extends Option
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
			ClientPrefs.data.sickWindow = 166;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.sickWindow++;
		if (ClientPrefs.data.sickWindow > 166)
			ClientPrefs.data.sickWindow = 166;
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
		return "Sick Hit Window: < " + ClientPrefs.data.sickWindow + MS_O + " >";
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
		if (ClientPrefs.data.goodWindow > 166)
			ClientPrefs.data.goodWindow = 166;
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
		return "Good Hit Window: < " + ClientPrefs.data.goodWindow + MS_O + " >";
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
		if (ClientPrefs.data.badWindow > 166)
			ClientPrefs.data.badWindow = 166;
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
		return "Bad Hit Window: < " + ClientPrefs.data.badWindow + MS_O + " >";
	}
}


class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
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
		return "DownScroll" + ": < " + (ClientPrefs.data.downScroll ? enable_O : disable_O) + " >";
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
		return "Ghost Tapping: < " + (ClientPrefs.data.ghostTapping ? enable_O : disable_O) + " >";
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
		return "Score zomming in beats: < " + (ClientPrefs.data.scoreZoom ? enable_O : disable_O) + " >";
	}
}

class HideHud extends Option
{
	public function new(desc:String)
	{
		super();
        //if (OptionsState.onPlayState)
		//	description = "This option cannot be toggled in the pause menu.";
		//else
			description = desc;

	}

	public override function left():Bool
	{
        //if (OptionsState.onPlayState)
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
		return "HUD: < " + (!ClientPrefs.data.hideHud ? enable_O : disable_O) + " >";
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
		return "Combo Sprite: < " + (ClientPrefs.data.showComboNum ? enable_O : disable_O) + " >";
	}
}

class ShowRating extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.showRating = !ClientPrefs.data.showRating;
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
		return "Rating Sprite: < " + (ClientPrefs.data.showRating ? enable_O : disable_O) + " >";
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
		return "Reset Button: < " + (!ClientPrefs.data.noReset ? enable_O : disable_O) + " >";
	}
}

class Language extends Option
{
    
	public function new(desc:String)
	{
		super();
		description = desc;
	}		

	public override function left():Bool
	{
		ClientPrefs.data.language--;
		if (ClientPrefs.data.language < 0)
		ClientPrefs.data.language = OptionsHelpers.languageArray.length -1;
		
		FlxTransitionableState.skipNextTransIn = true;
		MusicBeatState.switchState(new options.OptionsState()); //reset substate for real
		
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.language++;
		if (ClientPrefs.data.language > OptionsHelpers.languageArray.length -1)
		ClientPrefs.data.language = 0;
		
		FlxTransitionableState.skipNextTransIn = true;
		MusicBeatState.switchState(new options.OptionsState());	//reset substate for real		
		        
		return true;
	}

	private override function updateDisplay():String
	{
		return "Language: < " + OptionsHelpers.languageArray[ClientPrefs.data.language] + " >";
	}
}

class ColorblindModeOption extends Option
{
    
	public function new(desc:String)
	{
		super();
		description = desc;
	}		

	public override function left():Bool
	{
		ClientPrefs.data.colorblindMode--;
		if (ClientPrefs.data.colorblindMode < 0)
		ClientPrefs.data.colorblindMode = OptionsHelpers.colorblindFilterArray.length -1;		
		ColorblindFilter.UpdateColors();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.colorblindMode++;
		if (ClientPrefs.data.colorblindMode > OptionsHelpers.colorblindFilterArray.length -1)
		ClientPrefs.data.colorblindMode = 0;
	    ColorblindFilter.UpdateColors();
		return true;
	}
	
	public override function change()
	{
	    ColorblindFilter.UpdateColors();
	}

	private override function updateDisplay():String
	{
		return "ColorblindFilter: < " + OptionsHelpers.colorblindFilterArray[ClientPrefs.data.colorblindMode] + " >";
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
		return "Flashing Lights: < " + (ClientPrefs.data.flashing ? enable_O : disable_O) + " >";
	}
}

class AntialiasingOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
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
		return "Antialiasing: < " + (ClientPrefs.data.antialiasing ? enable_O : disable_O) + " >";
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
		return "FPS Counter: < " + (ClientPrefs.data.showFPS ? enable_O : disable_O) + " >";
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
		return "Memory Counter: < " + (ClientPrefs.data.showMEM ? enable_O : disable_O) + " >";
	} 
}

class MEMType extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
	    ClientPrefs.data.memoryType--;
	    if (ClientPrefs.data.memoryType < 0) ClientPrefs.data.memoryType = OptionsHelpers.memoryTypeArray.length - 1;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.memoryType++;
		if (ClientPrefs.data.memoryType > OptionsHelpers.memoryTypeArray.length - 1) ClientPrefs.data.memoryType = 0;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Memory Data: < " + OptionsHelpers.memoryTypeArray[ClientPrefs.data.memoryType] + " >";
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
		return "Update time Counter: < " + (ClientPrefs.data.showMS ? enable_O : disable_O) + " >";
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
		return "AutoPause: < " + (ClientPrefs.data.autoPause ? enable_O : disable_O) + " >";
	} 
}

class ShowSplashes extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
        ClientPrefs.data.showSplash = !ClientPrefs.data.showSplash;
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
		return "showSplash: < " + (ClientPrefs.data.showSplash ? enable_O : disable_O) + " >";
	} 
}
class QualityLow extends Option
{
	public function new(desc:String)
	{
		super();
              if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
             		if (OptionsState.onPlayState)
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
		return "Low Quality: < " + (ClientPrefs.data.lowQuality ? enable_O : disable_O) + " >";
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
		else if (ClientPrefs.data.framerate <= 24)
			ClientPrefs.data.framerate = 24;
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
              if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
        if (OptionsState.onPlayState)
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
		return "FPS Rainbow: < " + (ClientPrefs.data.rainbowFPS ? enable_O : disable_O) + " >";
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
		return "Opponent Strums: < " + (!ClientPrefs.data.opponentStrums ? 'Show' : 'Hide') + " >";
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
		return "Camera Zooming: < " + (ClientPrefs.data.camZooms ? enable_O : disable_O) + " >";
	}
}

class JudgementCounter extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		ClientPrefs.data.judgementCounter = !ClientPrefs.data.judgementCounter;
        /*
		if (Type.getClass(FlxG.state) == PlayState){
		if(ClientPrefs.data.showJudgement) 
			//PlayState.instance.judgementCounter.visible = (!ClientPrefs.data.hideHud && !PlayState.instance.cpuControlled);
		else
			//PlayState.instance.judgementCounter.visible = false;
	    }
        */
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
		return "Judgement Counter: < " + (ClientPrefs.data.judgementCounter ? enable_O : disable_O) + " >";
	}
}

class MiddleScrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
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
		return "Middle Scroll: < " + (ClientPrefs.data.middleScroll ? enable_O : disable_O) + " >";
	}
}


class NoteskinOption extends Option
{
    public static var chooseNum:Int;
    
	public function new(desc:String)
	{
		super();
		chooseNum = 0;
		OptionsHelpers.SetNoteSkin();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		chooseNum--;
		
     	OptionsHelpers.ChangeNoteSkin();
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		chooseNum++;
		
        OptionsHelpers.ChangeNoteSkin();
		display = updateDisplay();
		return true;
	}

	public override function getValue():String
	{
		return "Current Noteskin: < " + ClientPrefs.data.noteSkin + " >";
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
		return "Health Bar: < " + (ClientPrefs.data.visibleHealthbar ? enable_O : disable_O) + " >";
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

class ComboColor extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	private override function updateDisplay():String
	{
		return "Combe Color: < " + ClientPrefs.data.comboColor + " >";
	}

	override function right():Bool
	{
		ClientPrefs.data.comboColor = !ClientPrefs.data.comboColor;
		display = updateDisplay();
		return true;

	}

	override function left():Bool
	{
		right();
		return true;
	}
}
/*
class SustainsAlpha extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
		acceptValues = true;
	}

	override function right():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		ClientPrefs.data.susTransper += 0.1;

		if (ClientPrefs.data.susTransper > 1)
			ClientPrefs.data.susTransper = 1;
		return true;
	}

	override function left():Bool
	{
		if (OptionsState.onPlayState)
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
                FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);
		return true;

	}

	override function left():Bool
	{
		ClientPrefs.data.hitsoundVolume -= 0.1;
		if (ClientPrefs.data.hitsoundVolume < 0)
			ClientPrefs.data.hitsoundVolume = 0;
                FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);
		return true;
	}
}

class ShadersOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
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
		return "Shaders: < " + (ClientPrefs.data.shaders ? enable_O : disable_O) + " >";
	}
}

class GPUcacheOption extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
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
		return "GPU Cache: < " + (ClientPrefs.data.cacheOnGPU ? enable_O : disable_O) + " >";
	}
}

class ImagePersist extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}	

	override function right():Bool
	{
		ClientPrefs.data.imagePersist = !ClientPrefs.data.imagePersist;
		display = updateDisplay();
		return true;

	}

	override function left():Bool
	{
		right();
		return true;
	}
	
	private override function updateDisplay():String
	{
		return "ImagePersist: < " + ClientPrefs.data.imagePersist + " >";
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
		return "Combo Stacking: < " + (ClientPrefs.data.comboStacking ? enable_O : disable_O) + " >";
	}
}

class SplashAlpha extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function right():Bool
	{
		ClientPrefs.data.splashAlpha += 0.1;
		if (ClientPrefs.data.splashAlpha > 1)
			ClientPrefs.data.splashAlpha = 1;
			
		return true;
	}

	override function left():Bool
	{
		ClientPrefs.data.splashAlpha -= 0.1;

		if (ClientPrefs.data.splashAlpha < 0)
			ClientPrefs.data.splashAlpha = 0;
			
		return true;
	}

	private override function updateDisplay():String
		{
			return "Splash Transparceny: < " + ClientPrefs.data.splashAlpha + " >";
		}
	
}

class NoteRGB extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		ClientPrefs.data.noteRGB = !ClientPrefs.data.noteRGB;
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
		return "Note RGB: < " + (ClientPrefs.data.noteRGB ? enable_O : disable_O) + " >";
	}
}

class SplashRGB extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		ClientPrefs.data.splashRGB = !ClientPrefs.data.splashRGB;
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
		return "Splash RGB: < " + (ClientPrefs.data.splashRGB ? enable_O : disable_O) + " >";
	}
}

class CustomFadeType extends Option
{
	public function new(desc:String)
	{
		super();
		description = 'Change Custom Fade Type';
	}

	public override function left():Bool
	{
	   // ClientPrefs.data.CustomFade = !ClientPrefs.data.CustomFade;
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
		return "Custom Fade Type: < " + ClientPrefs.data.CustomFade + " >";
	}
}


class CustomFadeSound extends Option
{
	public function new(desc:String)
	{
		super();

		description = desc;
		acceptValues = true;
	}

	override function right():Bool
	{
		ClientPrefs.data.CustomFadeSound += 0.1;
		if (ClientPrefs.data.CustomFadeSound > 1)
			ClientPrefs.data.CustomFadeSound = 1;
			
		return true;
	}

	override function left():Bool
	{
		ClientPrefs.data.CustomFadeSound -= 0.1;

		if (ClientPrefs.data.CustomFadeSound < 0)
			ClientPrefs.data.CustomFadeSound = 0;
			
		return true;
	}

	private override function updateDisplay():String
		{
			return "CustomFadeSound: < " + ClientPrefs.data.CustomFadeSound + " >";
		}
	
}

class CustomFadeText extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
	    ClientPrefs.data.CustomFadeText = !ClientPrefs.data.CustomFadeText;
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
		return "Custom Fade Text: < " + ClientPrefs.data.CustomFadeText + " >";
	}
}

class TimeBarType extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
	   // ClientPrefs.data.timeBarType = !ClientPrefs.data.timeBarType;
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
		return "Time Bar: < " + ClientPrefs.data.timeBarType + " >";
	}
}

class PauseMusic extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function left():Bool
	{
		return true;
	}

	public override function right():Bool
	{
		return true;
	}

	private override function updateDisplay():String
	{
		return "Pause Music: < " + ClientPrefs.data.pauseMusic + " >";
	}
}

#if CHECK_FOR_UPDATES
class CheckForUpdates extends Option
{
	public function new(desc:String)
	{
		super();
	}

	public override function left():Bool
	{
		ClientPrefs.data.checkForUpdates = !ClientPrefs.data.checkForUpdates;
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
		return "Check for Updates: < " + (ClientPrefs.data.checkForUpdates ? enable_O : disable_O) + " >";
	}
}
#end


#if desktop
class DiscordRPC extends Option
{
	public function new(desc:String)
	{
		super();
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		ClientPrefs.data.discordRPC = !ClientPrefs.data.discordRPC;
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
		return "Discord Rich Presence: < " + (ClientPrefs.data.discordRPC ? enable_O : disable_O) + " >";
	}
}
#end

class FilpChart extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		ClientPrefs.data.filpChart = !ClientPrefs.data.filpChart;
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
		return "Filp Chart: < " + (ClientPrefs.data.filpChart ? enable_O : disable_O) + " >";
	}
}

class PlayOpponent extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		ClientPrefs.data.playOpponent = !ClientPrefs.data.playOpponent;
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
		return "Play Opponent: < " + (ClientPrefs.data.playOpponent ? enable_O : disable_O) + " >";
	}
}

class OpponentCodeFix extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		ClientPrefs.data.OpponentCodeFix = !ClientPrefs.data.OpponentCodeFix;
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
		return "Opponent Code Fix: < " + (ClientPrefs.data.OpponentCodeFix ? enable_O : disable_O) + " >";
	}
}

class FixLNL extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.data.fixLNL--;
		if (ClientPrefs.data.fixLNL < 0)
			ClientPrefs.data.fixLNL = 0;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.fixLNL++;
		if (ClientPrefs.data.fixLNL > 2)
			ClientPrefs.data.fixLNL = 2;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Long Note Length Reduce: < " + ClientPrefs.data.fixLNL + " >";
	}
}

class ResultsScreen extends Option
{
	public function new(desc:String)
	{
		super();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		ClientPrefs.data.ResultsScreen = !ClientPrefs.data.ResultsScreen;
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
		return "ResultsScreen: < " + (ClientPrefs.data.ResultsScreen ? enable_O : disable_O) + " >";
	}
}

class RatingOffset extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc + " (Press R to reset)";
		acceptType = true;
	}

	public override function left():Bool
	{
		ClientPrefs.data.ratingOffset--;
		if (ClientPrefs.data.ratingOffset < -30)
			ClientPrefs.data.ratingOffset = -30;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.ratingOffset++;
		if (ClientPrefs.data.ratingOffset > 30)
			ClientPrefs.data.ratingOffset = 30;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Rating Offset: < " + ClientPrefs.data.ratingOffset + " >";
	}
}

class SplashSkin extends Option
{
    public static var chooseNum:Int;
    
	public function new(desc:String)
	{
		super();
		chooseNum = 0;
		OptionsHelpers.SetNoteSkin();
		if (OptionsState.onPlayState)
			description = "This option cannot be toggled in the pause menu.";
		else
			description = desc;
	}

	public override function left():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		chooseNum--;
		
     	OptionsHelpers.ChangeNoteSkin();
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		if (OptionsState.onPlayState)
			return false;
		chooseNum++;
		
        OptionsHelpers.ChangeNoteSkin();
		display = updateDisplay();
		return true;
	}

	public override function getValue():String
	{
		return "Current SplashSkin: < " + ClientPrefs.data.splashSkin + " >";
	}
}

class MarvelousRating extends Option
{
	public function new(desc:String)
	{
		super();
	}

	public override function left():Bool
	{
		ClientPrefs.data.marvelousRating = !ClientPrefs.data.marvelousRating;
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
		return "Marvelous Rating: < " + (ClientPrefs.data.marvelousRating ? enable_O : disable_O) + " >";
	}
}

class MarvelousSprite extends Option
{
	public function new(desc:String)
	{
		super();
	}

	public override function left():Bool
	{
		ClientPrefs.data.marvelousSprite = !ClientPrefs.data.marvelousSprite;
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
		return "Marvelous Sprite: < " + (ClientPrefs.data.marvelousSprite ? enable_O : disable_O) + " >";
	}
}

class GuitarHeroSustains extends Option
{
	public function new(desc:String)
	{
		super();
	}

	public override function left():Bool
	{
		ClientPrefs.data.guitarHeroSustains = !ClientPrefs.data.guitarHeroSustains;
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
		return "Sustains Note Input: < " + (ClientPrefs.data.guitarHeroSustains ? 'New' : 'Classic') + " >";
	}

}


class SkipTitleVideo extends Option
{
	public function new(desc:String)
	{
		super();
	}

	public override function left():Bool
	{
		ClientPrefs.data.skipTitleVideo = !ClientPrefs.data.skipTitleVideo;
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
		return "Skip Intro Video: < " + (ClientPrefs.data.skipTitleVideo ? enable_O : disable_O) + " >";
	}

}


class BotOpponentFix extends Option
{
	public function new(desc:String)
	{
		super();
	}

	public override function left():Bool
	{
		ClientPrefs.data.botOpponentFix = !ClientPrefs.data.botOpponentFix;
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
		return "Bot Opponent Fix: < " + (ClientPrefs.data.botOpponentFix ? enable_O : disable_O) + " >";
	}

}



class HealthDrainOPPO extends Option
{
	public function new(desc:String)
	{
		super();
	}

	public override function left():Bool
	{
		ClientPrefs.data.HealthDrainOPPO = !ClientPrefs.data.HealthDrainOPPO;
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
		return "Guitar Hero Sustains: < " + (ClientPrefs.data.HealthDrainOPPO ? enable_O : disable_O) + " >";
	}

}

class HealthDrainOPPOMult extends Option
{
	public function new(desc:String)
	{
		super();
	}

	public override function left():Bool
	{
		ClientPrefs.data.HealthDrainOPPOMult += 0.1;
		display = updateDisplay();
		return true;
	}

	public override function right():Bool
	{
		ClientPrefs.data.HealthDrainOPPOMult -= 0.1;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Health Drain multipler: < " + ClientPrefs.data.HealthDrainOPPOMult + " >";
	}

}

