package substates;
/*
import backend.WeekData;
import backend.Highscore;
import backend.Song;
*/
import flixel.addons.transition.FlxTransitionableState;

import states.PlayState;
import states.FreeplayState;

import flixel.util.FlxSpriteUtil;
import openfl.display.Sprite;
import openfl.geom.Rectangle;


class ResultsScreen extends MusicBeatSubstate
{
	public var background:FlxSprite;	
    public var graphBG:FlxSprite;
    public var graphSizeUp:FlxSprite;
	public var graphSizeDown:FlxSprite;
	public var graphSizeLeft:FlxSprite;
	public var graphSizeRight:FlxSprite;
	
	public var graphJudgeCenter:FlxSprite;
	public var graphSickUp:FlxSprite;
	public var graphSickDown:FlxSprite;
	public var graphGoodUp:FlxSprite;
	public var graphGoodDown:FlxSprite;
	public var graphBadUp:FlxSprite;
	public var graphBadDown:FlxSprite;
	public var graphShitUp:FlxSprite;
	public var graphShitDown:FlxSprite;
    
    public var clearText:FlxText;
	public var judgeText:FlxText;
	public var satDataText:FlxText;
	public var backText:FlxText;
    

	public function new(x:Float, y:Float)
	{
		super();
		
		background = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.scrollFactor.set();
		background.alpha = 0;
		add(background);
		
		var graphWidth = 550;
		var graphHeight = 300;
		graphBG = new FlxSprite(FlxG.width - 550 - 50, 50).makeGraphic(550, 300, FlxColor.BLACK);
		graphBG.scrollFactor.set();
		graphBG.alpha = 0;		
		add(graphBG);
		
		var noteSpr = FlxSpriteUtil.flashGfx;		
		var _rect = new Rectangle(0, 0, graphWidth, graphHeight);
		graphBG.pixels.fillRect(_rect, 0xFF000000);
		FlxSpriteUtil.beginDraw(0xFFFFFFFF);
	    
	    var noteSize = 1;
		for (i in 0...PlayState.rsNoteTime.length){
		
		noteSpr.drawCircle(graphWidth * (PlayState.rsNoteTime[i] / PlayState.rsSongLength) - noteSize / 2 , graphHeight * 0.5 + graphHeight * 0.5 * 0.6 * (PlayState.rsNoteMs[i] / 166.6) - noteSize / 2, noteSize);		
		
		graphBG.pixels.draw(FlxSpriteUtil.flashGfxSprite);
		}
		
		var judgeWidth = 2;
		graphJudgeCenter = new FlxSprite(graphBG.x, graphBG.y + graphWidth * 0.5 - judgeWidth * 0.5).makeGraphic(graphWidth, judgeWidth, FlxColor.WHITE);
		graphJudgeCenter.scrollFactor.set();
		graphJudgeCenter.alpha = 0;		
		add(graphJudgeCenter);
		
		graphSizeUp = new FlxSprite(graphBG.x, graphBG.y - 2).makeGraphic(graphWidth + 2, 2, FlxColor.WHITE);
		graphSizeUp.scrollFactor.set();
		graphSizeUp.alpha = 0;		
		add(graphSizeUp);
		
		graphSizeDown = new FlxSprite(graphBG.x - 2, graphBG.y + graphHeight).makeGraphic(graphWidth + 2, 2, FlxColor.WHITE);
		graphSizeDown.scrollFactor.set();
		graphSizeDown.alpha = 0;		
		add(graphSizeDown);
		
		graphSizeLeft = new FlxSprite(graphBG.x - 2, graphBG.y - 2).makeGraphic(2, graphHeight + 2, FlxColor.WHITE);
		graphSizeLeft.scrollFactor.set();
		graphSizeLeft.alpha = 0;		
		add(graphSizeLeft);
		
		graphSizeRight = new FlxSprite(graphBG.x + graphWidth, graphBG.y).makeGraphic(2, graphHeight + 2, FlxColor.WHITE);
		graphSizeRight.scrollFactor.set();
		graphSizeRight.alpha = 0;		
		add(graphSizeRight);		
		
		//-----------------------BG
		
		clearText = new FlxText(20, -155, 0, 'Song Cleared!\n' + PlayState.SONG.song + ' - ' + Difficulty.getString() + '\n');
		clearText.size = 34;
		clearText.font = Paths.font('vcr.ttf');
		clearText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4, 1);
		clearText.scrollFactor.set();
		clearText.antialiasing = ClientPrefs.data.antialiasing;
		add(clearText);		
	    
	    var ACC = Math.ceil(PlayState.rsACC * 10000) / 100;
		judgeText = new FlxText(-400, 150, 0, 
		'Judgements:\nSicks: ' + PlayState.rsSicks 
		+ '\nGoods: ' + PlayState.rsGoods 
		+ '\nBads: ' + PlayState.rsBads 
		+ '\nShits: ' + PlayState.rsShits 
		+ '\n\nCombe Breaks: ' + PlayState.rsMisses 
		+ '\nHighest Combe: ' + PlayState.highestCombo 
		+ '\nScore: ' + PlayState.rsScore 
		+ '\nAccuracy: ' + ACC + '%'
		+ '\nRank: ' + PlayState.rsRatingName + '(' + PlayState.rsRatingFC + ')\n'
		);
		judgeText.size = 25;
		judgeText.font = Paths.font('vcr.ttf');
		judgeText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4, 1);
		judgeText.scrollFactor.set();
		judgeText.antialiasing = ClientPrefs.data.antialiasing;
		add(judgeText);
		
		var Main:Float = 0;
		for (i in 0...PlayState.rsNoteTime.length){
		Main = Main + Math.abs(PlayState.rsNoteTime[i]);
		}
		Main = Main / PlayState.rsNoteTime.length;
		
		
		FlxTween.tween(background, {alpha: 0.5}, 0.5);		
		FlxTween.tween(clearText, {y: ClientPrefs.data.showFPS ? 60 : 5}, 0.5, {ease: FlxEase.backInOut});
		
		new FlxTimer().start(0.5, function(tmr:FlxTimer){
		FlxTween.tween(judgeText, {x: 20}, 0.5, {ease: FlxEase.backInOut});		
		});
		
		new FlxTimer().start(1, function(tmr:FlxTimer){
			FlxTween.tween(graphBG, {alpha: 0.5}, 0.5);
			FlxTween.tween(graphJudgeCenter, {alpha: 0.5}, 0.5);	
		    FlxTween.tween(graphSizeUp, {alpha: 0.5}, 0.5);
		    FlxTween.tween(graphSizeDown, {alpha: 0.5}, 0.5);
		    FlxTween.tween(graphSizeLeft, {alpha: 0.5}, 0.5);
		    FlxTween.tween(graphSizeRight, {alpha: 0.5}, 0.5);	
		});
		
		new FlxTimer().start(1.5, function(tmr:FlxTimer){
				
		});
		
		
		
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
