package substates;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import flixel.addons.transition.FlxTransitionableState;




import states.FreeplayState;
import flixel.util.FlxSpriteUtil;
import openfl.display.Sprite;
import openfl.geom.Rectangle;


class ResultsScreen extends MusicBeatSubstate
{
	public var background:FlxSprite;
	public var clearText:FlxText;
    public var graphBackground:FlxSprite;
	

	public function new(x:Float, y:Float)
	{
		super();
		
		background = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.scrollFactor.set();
		background.alpha = 0;
		add(background);
		
		graphBackground = new FlxSprite(FlxG.width - 50, 50).makeGraphic(550, 300, FlxColor.BLACK);
		graphBackground.scrollFactor.set();
		graphBackground.alpha = 0.5;
		add(graphBackground);
		
		var what = FlxSpriteUtil.flashGfx;		
		var _rect = new Rectangle(0, 0, graphBackground.width, graphBackground.height);
		graphBackground.pixels.lock();
		graphBackground.pixels.fillRect(_rect, 0xFF000000);
		FlxSpriteUtil.beginDraw(0xFFFFFFFF);
		
		for (i in 0...1){
		what.drawRect(10, 10, 10, 10);		
		}
		graphBackground.pixels.draw(FlxSpriteUtil.flashGfxSprite);
		
		clearText = new FlxText(20, -55, 0, 'Song Cleared!\n' + PlayState.SONG.song + ' - ' + Difficulty.getString() + '\n');
		clearText.size = 34;
		clearText.font = Paths.font('vcr.ttf');
		clearText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4, 1);
		clearText.scrollFactor.set();
		add(clearText);
		
		
		FlxTween.tween(background, {alpha: 0.5}, 0.5);
		FlxTween.tween(clearText, {y: ClientPrefs.data.showFPS ? 35 : 5}, 0.5, {ease: FlxEase.expoInOut});
		
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
