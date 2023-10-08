package;

import lime.app.Application;
import lime.system.DisplayMode;
import flixel.util.FlxColor;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class OptionCategory
{
	private var _options:Array<Option> = new Array<Option>();

	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Category";

	public final function getName()
	{
		return _name;
	}

	public function new(catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}

	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;

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
		return throw "stub!";
	};

	// Returns whether the label is to be updated.
	public function press():Bool
	{
		return throw "stub!";
	}

	private function updateDisplay():String
	{
		return throw "stub!";
	}

	public function left():Bool
	{
		return throw "stub!";
	}

	public function right():Bool
	{
		return throw "stub!";
	}
}

class DFJKOption extends Option
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
	}

	public override function press():Bool
	{
		OptionsState.instance.openSubState(new KeyBindMenu());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Key Bindings";
	}
}

class CpuStrums extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.cpuStrums = !ClientPrefs.data.cpuStrums;

		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return ClientPrefs.data.cpuStrums ? "Light CPU Strums" : "CPU Strums stay static";
	}
}

class GraphicLoading extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.cacheImages = !ClientPrefs.data.cacheImages;

		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return ClientPrefs.data.cacheImages ? "Preload Characters" : "Do not Preload Characters";
	}
}

class EditorRes extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.editorBG = !ClientPrefs.data.editorBG;

		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return ClientPrefs.data.editorBG ? "Show Editor Grid" : "Do not Show Editor Grid";
	}
}

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.downscroll = !ClientPrefs.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return ClientPrefs.data.downscroll ? "Downscroll" : "Upscroll";
	}
}

class GhostTapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.ghost = !ClientPrefs.data.ghost;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return ClientPrefs.data.ghost ? "Ghost Tapping" : "No Ghost Tapping";
	}
}

class AccuracyOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.accuracyDisplay = !ClientPrefs.data.accuracyDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Accuracy " + (!ClientPrefs.data.accuracyDisplay ? "off" : "on");
	}
}

class SongPositionOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.songPosition = !ClientPrefs.data.songPosition;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Song Position " + (!ClientPrefs.data.songPosition ? "off" : "on");
	}
}

class DistractionsAndEffectsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.distractions = !ClientPrefs.data.distractions;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Distractions " + (!ClientPrefs.data.distractions ? "off" : "on");
	}
}

class Colour extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.colour = !ClientPrefs.data.colour;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return ClientPrefs.data.colour ? "Character Colored HP Bars" : "Normal HP Bars";
	}
}

class StepManiaOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.stepMania = !ClientPrefs.data.stepMania;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Colors by quantization " + (!ClientPrefs.data.stepMania ? "off" : "on");
	}
}

class ResetButtonOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.resetButton = !ClientPrefs.data.resetButton;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Reset Button " + (!ClientPrefs.data.resetButton ? "off" : "on");
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
		ClientPrefs.data.InstantRespawn = !ClientPrefs.data.InstantRespawn;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Instant Respawn " + (!ClientPrefs.data.InstantRespawn ? "off" : "on");
	}
}

class FlashingLightsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.flashing = !ClientPrefs.data.flashing;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Flashing Lights " + (!ClientPrefs.data.flashing ? "off" : "on");
	}
}

class AntialiasingOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.antialiasing = !ClientPrefs.data.antialiasing;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Antialiasing " + (!ClientPrefs.data.antialiasing ? "off" : "on");
	}
}

class MissSoundsOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.missSounds = !ClientPrefs.data.missSounds;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Miss Sounds " + (!ClientPrefs.data.missSounds ? "off" : "on");
	}
}

class ShowInput extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.inputShow = !ClientPrefs.data.inputShow;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return (ClientPrefs.data.inputShow ? "Extended Score Info" : "Minimalized Info");
	}
}

class Judgement extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return true;
	}

	private override function updateDisplay():String
	{
		return "Safe Frames";
	}

	override function left():Bool
	{
		if (Conductor.safeFrames == 1)
			return false;

		Conductor.safeFrames -= 1;
		ClientPrefs.data.frames = Conductor.safeFrames;

		Conductor.recalculateTimings();
		return false;
	}

	override function getValue():String
	{
		return "Safe Frames: "
			+ Conductor.safeFrames
			+ " - SIK: "
			+ HelperFunctions.truncateFloat(45 * Conductor.timeScale, 0)
			+ "ms GD: "
			+ HelperFunctions.truncateFloat(90 * Conductor.timeScale, 0)
			+ "ms BD: "
			+ HelperFunctions.truncateFloat(135 * Conductor.timeScale, 0)
			+ "ms SHT: "
			+ HelperFunctions.truncateFloat(166 * Conductor.timeScale, 0)
			+ "ms TOTAL: "
			+ HelperFunctions.truncateFloat(Conductor.safeZoneOffset, 0)
			+ "ms";
	}

	override function right():Bool
	{
		if (Conductor.safeFrames == 20)
			return false;

		Conductor.safeFrames += 1;
		ClientPrefs.data.frames = Conductor.safeFrames;

		Conductor.recalculateTimings();
		return true;
	}
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.fps = !ClientPrefs.data.fps;
		(cast(Lib.current.getChildAt(0), Main)).toggleFPS(ClientPrefs.data.fps);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter " + (!ClientPrefs.data.fps ? "off" : "on");
	}
}

class ScoreScreen extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.scoreScreen = !ClientPrefs.data.scoreScreen;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return (ClientPrefs.data.scoreScreen ? "Show Score Screen" : "No Score Screen");
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
		return "FPS Cap";
	}

	override function right():Bool
	{
		if (ClientPrefs.data.fpsCap >= 290)
		{
			ClientPrefs.data.fpsCap = 290;
			(cast(Lib.current.getChildAt(0), Main)).setFPSCap(290);
		}
		else
			ClientPrefs.data.fpsCap = ClientPrefs.data.fpsCap + 10;
		(cast(Lib.current.getChildAt(0), Main)).setFPSCap(ClientPrefs.data.fpsCap);

		return true;
	}

	override function left():Bool
	{
		if (ClientPrefs.data.fpsCap > 290)
			ClientPrefs.data.fpsCap = 290;
		else if (ClientPrefs.data.fpsCap < 60)
			ClientPrefs.data.fpsCap = Application.current.window.displayMode.refreshRate;
		else
			ClientPrefs.data.fpsCap = ClientPrefs.data.fpsCap - 10;
				(cast(Lib.current.getChildAt(0), Main)).setFPSCap(ClientPrefs.data.fpsCap);
		return true;
	}

	override function getValue():String
	{
		return "Current FPS Cap: "
			+ ClientPrefs.data.fpsCap
			+ (ClientPrefs.data.fpsCap == Application.current.window.displayMode.refreshRate ? "Hz (Refresh Rate)" : "");
	}
}

class ScrollSpeedOption extends Option
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
		return "Scroll Speed";
	}

	override function right():Bool
	{
		ClientPrefs.data.scrollSpeed += 0.1;

		if (ClientPrefs.data.scrollSpeed < 1)
			ClientPrefs.data.scrollSpeed = 1;

		if (ClientPrefs.data.scrollSpeed > 4)
			ClientPrefs.data.scrollSpeed = 4;
		return true;
	}

	override function getValue():String
	{
		return "Current Scroll Speed: " + HelperFunctions.truncateFloat(ClientPrefs.data.scrollSpeed, 1);
	}

	override function left():Bool
	{
		ClientPrefs.data.scrollSpeed -= 0.1;

		if (ClientPrefs.data.scrollSpeed < 1)
			ClientPrefs.data.scrollSpeed = 1;

		if (ClientPrefs.data.scrollSpeed > 4)
			ClientPrefs.data.scrollSpeed = 4;

		return true;
	}
}

class RainbowFPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.fpsRain = !ClientPrefs.data.fpsRain;
		(cast(Lib.current.getChildAt(0), Main)).changeFPSColor(FlxColor.WHITE);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Rainbow " + (!ClientPrefs.data.fpsRain ? "off" : "on");
	}
}

class Optimization extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.optimize = !ClientPrefs.data.optimize;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Optimization " + (ClientPrefs.data.optimize ? "ON" : "OFF");
	}
}

class NPSDisplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.npsDisplay = !ClientPrefs.data.npsDisplay;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "NPS Display " + (!ClientPrefs.data.npsDisplay ? "off" : "on");
	}
}

class ReplayOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new LoadReplayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Load replays";
	}
}

class AccuracyDOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.accuracyMod = ClientPrefs.data.accuracyMod == 1 ? 0 : 1;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Accuracy Mode: " + (ClientPrefs.data.accuracyMod == 0 ? "Accurate" : "Complex");
	}
}

class CustomizeGameplay extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		trace("switch");
		FlxG.switchState(new GameplayCustomizeState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Customize Gameplay";
	}
}

class WatermarkOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		Main.watermarks = !Main.watermarks;
		ClientPrefs.data.watermark = Main.watermarks;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Watermarks " + (Main.watermarks ? "on" : "off");
	}
}

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
		var poop:String = Highscore.formatSong("Tutorial", 1);

		PlayState.SONG = Song.loadFromJson(poop, "Tutorial");
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = 0;
		PlayState.storyWeek = 0;
		PlayState.offsetTesting = true;
		trace('CUR WEEK' + PlayState.storyWeek);
		LoadingState.loadAndSwitchState(new PlayState());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Time your offset";
	}
}

class BotPlay extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.botplay = !ClientPrefs.data.botplay;
		trace('BotPlay : ' + ClientPrefs.data.botplay);
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
		return "BotPlay " + (ClientPrefs.data.botplay ? "on" : "off");
}

class CamZoomOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		ClientPrefs.data.camzoom = !ClientPrefs.data.camzoom;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Camera Zoom " + (!ClientPrefs.data.camzoom ? "off" : "on");
	}
}

class LockWeeksOption extends Option
{
	var confirm:Bool = false;

	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		if (!confirm)
		{
			confirm = true;
			display = updateDisplay();
			return true;
		}
		ClientPrefs.data.weekUnlocked = 1;
		StoryMenuState.weekUnlocked = [true, true];
		confirm = false;
		trace('Weeks Locked');
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return confirm ? "Confirm Story Reset" : "Reset Story Progress";
	}
}

class ResetScoreOption extends Option
{
	var confirm:Bool = false;

	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		if (!confirm)
		{
			confirm = true;
			display = updateDisplay();
			return true;
		}
		ClientPrefs.data.songScores = null;
		for (key in Highscore.songScores.keys())
		{
			Highscore.songScores[key] = 0;
		}
		ClientPrefs.data.songCombos = null;
		for (key in Highscore.songCombos.keys())
		{
			Highscore.songCombos[key] = '';
		}
		confirm = false;
		trace('Highscores Wiped');
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return confirm ? "Confirm Score Reset" : "Reset Score";
	}
}

class ResetSettings extends Option
{
	var confirm:Bool = false;

	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		if (!confirm)
		{
			confirm = true;
			display = updateDisplay();
			return true;
		}
		ClientPrefs.data.weekUnlocked = null;
		ClientPrefs.data.newInput = null;
		ClientPrefs.data.downscroll = null;
		ClientPrefs.data.antialiasing = null;
		ClientPrefs.data.missSounds = null;
		ClientPrefs.data.dfjk = null;
		ClientPrefs.data.accuracyDisplay = null;
		ClientPrefs.data.offset = null;
		ClientPrefs.data.songPosition = null;
		ClientPrefs.data.fps = null;
		ClientPrefs.data.changedHit = null;
		ClientPrefs.data.fpsRain = null;
		ClientPrefs.data.fpsCap = null;
		ClientPrefs.data.scrollSpeed = null;
		ClientPrefs.data.npsDisplay = null;
		ClientPrefs.data.frames = null;
		ClientPrefs.data.accuracyMod = null;
		ClientPrefs.data.watermark = null;
		ClientPrefs.data.ghost = null;
		ClientPrefs.data.distractions = null;
		ClientPrefs.data.colour = null;
		ClientPrefs.data.stepMania = null;
		ClientPrefs.data.flashing = null;
		ClientPrefs.data.resetButton = null;
		ClientPrefs.data.botplay = null;
		ClientPrefs.data.cpuStrums = null;
		ClientPrefs.data.strumline = null;
		ClientPrefs.data.customStrumLine = null;
		ClientPrefs.data.camzoom = null;
		ClientPrefs.data.scoreScreen = null;
		ClientPrefs.data.inputShow = null;
		ClientPrefs.data.optimize = null;
		ClientPrefs.data.cacheImages = null;
		ClientPrefs.data.editor = null;

		KadeEngineData.initSave();
		confirm = false;
		trace('All settings have been reset');
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return confirm ? "Confirm Settings Reset" : "Reset Settings";
	}
}
