package substates;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import flixel.addons.transition.FlxTransitionableState;

import flixel.util.FlxStringUtil;

import states.StoryMenuState;
import states.FreeplayState;
import options.OptionsState;
import states.editors.ChartingState;

import haxe.ds.StringMap;
import flixel.math.FlxMath;
import psychlua.CustomSubstate as Substate;
import flixel.text.FlxText;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import Type;
import backend.Difficulty;
import backend.CoolUtil;
import flixel.sound.FlxSound;
import backend.Controls;
import flixel.util.FlxColor;
import openfl.display.Sprite;
import flixel.FlxSprite;

class ResultsScreen extends MusicBeatSubstate
{
	public var background:FlxSprite;
	public var text:FlxText;

	public var anotherBackground:FlxSprite;
	public var graph:HitGraph;
	public var graphSprite:OFLSprite;

	public var comboText:FlxText;
	public var contText:FlxText;
	public var settingsText:FlxText;

	public var music:FlxSound;

	public var graphData:BitmapData;

	public var ranking:String;
	public var accuracy:String;

	public function new(x:Float, y:Float)
	{
		super();
		
		background = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.scrollFactor.set();
		add(background);
		
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		
	}

	function deleteSkipTimeText()
	{
		
	}

	

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	
	
}
