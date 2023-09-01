package substates;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import flixel.addons.transition.FlxTransitionableState;

import flixel.util.FlxStringUtil;


import states.FreeplayState;



class ResultsScreen extends MusicBeatSubstate
{
	public var background:FlxSprite;
	public var clearText:FlxText;

	

	public function new(x:Float, y:Float)
	{
		super();
		
		background = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.scrollFactor.set();
		background.alpha = 0;
		add(background);
		
		clearText = new FlxText(20, -55, 0, "Song Cleared!");
		clearText.size = 34;
		clearText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4, 1);
		clearText.color = FlxColor.WHITE;
		clearText.scrollFactor.set();
		add(clearText);
		
		
		FlxTween.tween(background, {alpha: 0.5}, 0.5);
		FlxTween.tween(clearText, {y: 20}, 0.5, {ease: FlxEase.expoInOut});
		
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

		super.destroy();
	}

	
	
}
