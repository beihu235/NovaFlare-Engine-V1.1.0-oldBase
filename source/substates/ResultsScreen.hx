package substates;

/*
    ResultsScreen made by NF|beihu (北狐丶逐梦)
    youtube: https://b23.tv/SnqG443
    bilbil: https://youtube.com/@beihu235?si=NHnWxcUWPS46EqUt
    discord: beihu235
    
    you can use it but must give me credit(dont forget my icon)
    logic is very easy so I think everyone can understand it
    
    Who cares about rudy's hscript so I continue to choose to use my lua logic
    Her hscript weren't worth stole and I didn't stole it
    
    by the way dont move this to hscript,I dont allow it
*/

import flixel.addons.transition.FlxTransitionableState;

import states.PlayState;
import states.FreeplayState;

import backend.Conductor;

import flixel.util.FlxSpriteUtil;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.utils.Assets;

class ResultsScreen extends MusicBeatSubstate
{
	public var background:FlxSprite;	
    public var graphBG:FlxSprite;
    public var lostPNGText:FlxText;
    public var graphSizeUp:FlxSprite;
	public var graphSizeDown:FlxSprite;
	public var graphSizeLeft:FlxSprite;
	public var graphSizeRight:FlxSprite;
	
	public var graphJudgeCenter:FlxSprite;
	public var graphMarvelousUp:FlxSprite;
	public var graphMarvelousDown:FlxSprite;
	public var graphSickUp:FlxSprite;
	public var graphSickDown:FlxSprite;
	public var graphGoodUp:FlxSprite;
	public var graphGoodDown:FlxSprite;
	public var graphBadUp:FlxSprite;
	public var graphBadDown:FlxSprite;
	public var graphShitUp:FlxSprite;
	public var graphShitDown:FlxSprite;
    public var graphMiss:FlxSprite;
    
    public var clearText:FlxText;
	public var judgeText:FlxText;
	public var setGameText:FlxText;
	public var setMsText:FlxText;
	public var backText:FlxText;
	public var backBG:FlxSprite;
	
	public var camOther:FlxCamera;
    
    //public var NoteTypeColor:NoteTypeColorData;
    
    public var ColorArray:Array<FlxColor> = [];
    public var color:FlxColor;
	public function new(x:Float, y:Float)
	{
	    
		super();	
	    cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	    
	    camOther = new FlxCamera();
	    camOther.bgColor.alpha = 0;
	    FlxG.cameras.add(camOther, false);
	    
		ColorArray = [
		0xFFFFFF00, //marvelous
		0xFF00FFFF, //sick
	    0xFF00FF00, //good
	    0xFFFF7F00, //bad
	    0xFFFF5858, //shit
	    0xFFFF0000 //miss
		];
		
		var safeZoneOffset:Float = (ClientPrefs.data.safeFrames / 60) * 1000; //fix playBackRate shit
		
		background = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		background.scrollFactor.set();
		background.alpha = 0;
		add(background);
		
		var graphWidth = 550;
		var graphHeight = 300;
		
		var lossImage:Bool;
		var image:String = Paths.modFolders('images/menuExtend/ResultsScreen/ResultsScreenBG.png');		
		
		if (FileSystem.exists(image)){
		    lossImage = false;
		    graphBG = new FlxSprite(FlxG.width - 550 - 50, 50).loadGraphic(Paths.image('menuExtend/ResultsScreen/ResultsScreenBG'));		    
		}else{
		    lossImage = true;
		    graphBG = new FlxSprite(FlxG.width - 550 - 50, 50).makeGraphic(graphWidth, graphHeight, 0x7F000000); //0x7F000000 is black for 60% alpha
		}
		graphBG.scrollFactor.set();
		graphBG.alpha = 0;		
		graphBG.setGraphicSize(graphWidth, graphHeight);
		graphBG.updateHitbox();
		
		var noteSpr = FlxSpriteUtil.flashGfx;		
		FlxSpriteUtil.beginDraw(0xFFFFFFFF);
	    
	    var noteSize = 2.3;
	    var MoveSize = 0.8;
		for (i in 0...PlayState.rsNoteTime.length - 1){
		    if (Math.abs(PlayState.rsNoteMs[i]) <= ClientPrefs.data.marvelousWindow && ClientPrefs.data.marvelousRating) color = ColorArray[0];
		    else if (Math.abs(PlayState.rsNoteMs[i]) <= ClientPrefs.data.sickWindow) color = ColorArray[1];
		    else if (Math.abs(PlayState.rsNoteMs[i]) <= ClientPrefs.data.goodWindow) color = ColorArray[2];
		    else if (Math.abs(PlayState.rsNoteMs[i]) <= ClientPrefs.data.badWindow) color = ColorArray[3];
		    else if (Math.abs(PlayState.rsNoteMs[i]) <= safeZoneOffset) color = ColorArray[4];
		    else color = ColorArray[5];		    		    		    
		    		    
		    FlxSpriteUtil.beginDraw(color);
		    if (Math.abs(PlayState.rsNoteMs[i]) <= safeZoneOffset){
    		    noteSpr.drawCircle(graphWidth * (PlayState.rsNoteTime[i] / PlayState.rsSongLength), graphHeight * 0.5 + graphHeight * 0.5 * MoveSize * (PlayState.rsNoteMs[i] / safeZoneOffset), noteSize);
    		}
    		else{
    		    noteSpr.drawCircle(graphWidth * (PlayState.rsNoteTime[i] / PlayState.rsSongLength), graphHeight * 0.5 + graphHeight * 0.5 * 0.9, noteSize);		
    		}
    		
		    graphBG.pixels.draw(FlxSpriteUtil.flashGfxSprite);
		}
		graphBG.updateHitbox();
		add(graphBG);
		
		lostPNGText = new FlxText(graphBG.x + graphBG.width / 2, graphBG.y + graphBG.height + 5, 0, "Error load: image/ResultsScreen/ResultsScreenBG.png");
		lostPNGText.size = 20;
		lostPNGText.alignment = CENTER;
		lostPNGText.font = Paths.font('vcr.ttf');
		lostPNGText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		lostPNGText.scrollFactor.set();
	    lostPNGText.alpha = 0;	
		lostPNGText.antialiasing = ClientPrefs.data.antialiasing;
		lostPNGText.color = FlxColor.RED;
		lostPNGText.x -= lostPNGText.width / 2;
		lostPNGText.visible = lossImage;
		add(lostPNGText);
		
		var judgeHeight = 2;
		graphJudgeCenter = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.WHITE);
		graphJudgeCenter.scrollFactor.set();
		graphJudgeCenter.alpha = 0;		
		add(graphJudgeCenter);
		
		graphMarvelousUp = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - graphHeight * 0.5 * MoveSize * (ClientPrefs.data.marvelousWindow / safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, ColorArray[0]);
		graphMarvelousUp.scrollFactor.set();
		graphMarvelousUp.alpha = 0;		
		add(graphMarvelousUp);
		if (!ClientPrefs.data.marvelousRating) graphMarvelousUp.visible = false;
		
		graphMarvelousDown = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 + graphHeight * 0.5 * MoveSize * (ClientPrefs.data.marvelousWindow / safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, ColorArray[0]);
		graphMarvelousDown.scrollFactor.set();
		graphMarvelousDown.alpha = 0;		
		add(graphMarvelousDown);
		if (!ClientPrefs.data.marvelousRating) graphMarvelousDown.visible = false;
		
		graphSickUp = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - graphHeight * 0.5 * MoveSize * (ClientPrefs.data.sickWindow / safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, ColorArray[1]);
		graphSickUp.scrollFactor.set();
		graphSickUp.alpha = 0;		
		add(graphSickUp);
		if ((ClientPrefs.data.marvelousWindow >= ClientPrefs.data.sickWindow && ClientPrefs.data.marvelousRating)) graphSickUp.visible = false;
		
		graphSickDown = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 + graphHeight * 0.5 * MoveSize * (ClientPrefs.data.sickWindow / safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, ColorArray[1]);
		graphSickDown.scrollFactor.set();
		graphSickDown.alpha = 0;		
		add(graphSickDown);
		if ((ClientPrefs.data.marvelousWindow >= ClientPrefs.data.sickWindow && ClientPrefs.data.marvelousRating)) graphSickDown.visible = false;
		
		graphGoodUp = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - graphHeight * 0.5 * MoveSize * (ClientPrefs.data.goodWindow / safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, ColorArray[2]);
		graphGoodUp.scrollFactor.set();
		graphGoodUp.alpha = 0;		
		add(graphGoodUp);
		if ((ClientPrefs.data.marvelousWindow >= ClientPrefs.data.goodWindow && ClientPrefs.data.marvelousRating) || ClientPrefs.data.sickWindow >= ClientPrefs.data.goodWindow) graphGoodUp.visible = false;
		
		graphGoodDown = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 + graphHeight * 0.5 * MoveSize * (ClientPrefs.data.goodWindow / safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, ColorArray[2]);
		graphGoodDown.scrollFactor.set();
		graphGoodDown.alpha = 0;		
		add(graphGoodDown);
		if ((ClientPrefs.data.marvelousWindow >= ClientPrefs.data.goodWindow && ClientPrefs.data.marvelousRating) || ClientPrefs.data.sickWindow >= ClientPrefs.data.goodWindow) graphGoodDown.visible = false;
		
		graphBadUp = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - graphHeight * 0.5 * MoveSize * (ClientPrefs.data.badWindow / safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, ColorArray[3]);
		graphBadUp.scrollFactor.set();
		graphBadUp.alpha = 0;		
		add(graphBadUp);
		if ((ClientPrefs.data.marvelousWindow >= ClientPrefs.data.badWindow && ClientPrefs.data.marvelousRating) || ClientPrefs.data.sickWindow >= ClientPrefs.data.badWindow || ClientPrefs.data.goodWindow >= ClientPrefs.data.badWindow) graphBadUp.visible = false;
		
		graphBadDown = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 + graphHeight * 0.5 * MoveSize * (ClientPrefs.data.badWindow / safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, ColorArray[3]);
		graphBadDown.scrollFactor.set();
		graphBadDown.alpha = 0;		
		add(graphBadDown);
		if ((ClientPrefs.data.marvelousWindow >= ClientPrefs.data.badWindow && ClientPrefs.data.marvelousRating) || ClientPrefs.data.sickWindow >= ClientPrefs.data.badWindow || ClientPrefs.data.goodWindow >= ClientPrefs.data.badWindow) graphBadDown.visible = false;
		
		graphShitUp = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - graphHeight * 0.5 * MoveSize * (safeZoneOffset / safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, ColorArray[4]);
		graphShitUp.scrollFactor.set();
		graphShitUp.alpha = 0;		
		add(graphShitUp);
		
		graphShitDown = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 + graphHeight * 0.5 * MoveSize * (safeZoneOffset / safeZoneOffset) - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, ColorArray[4]);
		graphShitDown.scrollFactor.set();
		graphShitDown.alpha = 0;		
		add(graphShitDown);
		
		graphMiss = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 + graphHeight * 0.5 * 0.9 - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, ColorArray[5]);
		graphMiss.scrollFactor.set();
		graphMiss.alpha = 0;		
		add(graphMiss);
		
		graphJudgeCenter = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.WHITE);
		graphJudgeCenter.scrollFactor.set();
		graphJudgeCenter.alpha = 0;		
		add(graphJudgeCenter);
		
		graphJudgeCenter = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.WHITE);
		graphJudgeCenter.scrollFactor.set();
		graphJudgeCenter.alpha = 0;		
		add(graphJudgeCenter);
		
		graphJudgeCenter = new FlxSprite(graphBG.x, graphBG.y + graphHeight * 0.5 - judgeHeight * 0.5).makeGraphic(graphWidth, judgeHeight, FlxColor.WHITE);
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
		var opponentExtend:String = '';
		if (ClientPrefs.data.playOpponent) opponentExtend = ' - Opponent';
		clearText = new FlxText(20, -180, 300, 'Song Cleared!\n' + PlayState.SONG.song + '\n'  + Difficulty.getString() + opponentExtend + '\n');
		clearText.size = 30;
		clearText.font = Paths.font('vcr.ttf');
		clearText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		clearText.scrollFactor.set();
		clearText.antialiasing = ClientPrefs.data.antialiasing;
		add(clearText);		
	    
	    var ACC = Math.ceil(PlayState.rsACC * 10000) / 100;
	    var marvelousRate = ClientPrefs.data.marvelousRating ? '\nMarvelous: ' + PlayState.reMarvelouss : '';
		judgeText = new FlxText(-400, 200, 0, 
		'Judgements:'
		+ marvelousRate
		+ '\nSick: ' + PlayState.rsSicks
		+ '\nGood: ' + PlayState.rsGoods 
		+ '\nBad: ' + PlayState.rsBads 
		+ '\nShit: ' + PlayState.rsShits 
		+ '\n\nCombe Break: ' + PlayState.rsMisses 
		+ '\nHighest Combe: ' + PlayState.highestCombo 
		+ '\nScore: ' + PlayState.rsScore 
		+ '\nAccuracy: ' + ACC + '%'
		+ '\nRank: ' + PlayState.rsRatingName + '(' + PlayState.rsRatingFC + ')\n'
		);
		judgeText.size = 25;
		judgeText.font = Paths.font('vcr.ttf');
		judgeText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		judgeText.scrollFactor.set();
		judgeText.antialiasing = ClientPrefs.data.antialiasing;
		add(judgeText);
		
		var botplay:String = 'Disable';
		if (ClientPrefs.getGameplaySetting('botplay')) botplay = 'Enable';
		var practice:String = 'Disable';
		if (ClientPrefs.getGameplaySetting('practice')) practice = 'Enable';
		
		var speed:String = ClientPrefs.getGameplaySetting('scrollspeed');
		if (ClientPrefs.getGameplaySetting('scrolltype') == 'multiplicative')
        speed = 'X' + speed;
        
		setGameText = new FlxText(FlxG.width + 400, 420, 0,
		'healthGain: X' + ClientPrefs.getGameplaySetting('healthgain')
		+ '  healthLoss: X' + ClientPrefs.getGameplaySetting('healthloss')
		+ '\n'
		+ 'SongSpeed: ' + speed
		+ '  PlaybackRate: X' + ClientPrefs.getGameplaySetting('songspeed')
		+ '\n'
		+ 'BotPlay: ' + botplay
		+ '  PracticeMode: ' + practice
		+ '\n'
		+ 'Finished time: ' + Date.now().toString()
		+ '\n'
		);
		setGameText.size = 25;
		setGameText.alignment = RIGHT;
		setGameText.font = Paths.font('vcr.ttf');
		setGameText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		setGameText.scrollFactor.set();
		setGameText.antialiasing = ClientPrefs.data.antialiasing;
		add(setGameText);
		
		var Main:Float = 0;
		var allowData:Int = 0;
		for (i in 0...PlayState.rsNoteTime.length - 1){
		    if (Math.abs(PlayState.rsNoteMs[i]) <= safeZoneOffset){
    		    Main = Main + Math.abs(PlayState.rsNoteMs[i]);
    		    allowData = allowData + 1;
		    }
		}
		var showMain = Math.ceil((Main / allowData) * 100) / 100;
        var safeZoneOffsetFix:Float = Math.ceil(safeZoneOffset * 10) / 10;
        
        var marvelousRate = '';
        if (ClientPrefs.data.marvelousRating) marvelousRate = 'MAR:' + ClientPrefs.data.marvelousWindow + 'ms,';
          
		setMsText = new FlxText(20, FlxG.height + 150, 0, 
		'Main: ' + showMain + 'ms'
		+ '\n'
		+ '('
		+ marvelousRate
		+ 'SICK:' + ClientPrefs.data.sickWindow + 'ms,'
		+ 'GOOD:' + ClientPrefs.data.goodWindow + 'ms,'
		+ 'BAD:' + ClientPrefs.data.badWindow + 'ms,'
		+ 'SHIT:' + safeZoneOffsetFix + 'ms'
		+ ')'		
		+ '\n'
		);
		setMsText.size = 16;
		setMsText.font = Paths.font('vcr.ttf');
		setMsText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		setMsText.scrollFactor.set();
		setMsText.antialiasing = ClientPrefs.data.antialiasing;
		add(setMsText);		

		var backTextShow:String = 'Press Enter to continue';
		#if android backTextShow = 'Press Text to continue'; #end
		
		backText = new FlxText(FlxG.width, 0, backTextShow);
		backText.size = 28;
		backText.font = Paths.font('vcr.ttf');
		backText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		backText.scrollFactor.set();
		backText.antialiasing = ClientPrefs.data.antialiasing;
	    backText.alignment = RIGHT;			    

		backBG = new FlxSprite(FlxG.width, FlxG.height - 30).loadGraphic(Paths.image('menuExtend/ResultsScreen/backBG'));
		backBG.scrollFactor.set(0, 0);
		backBG.scale.x = 0.5;
		backBG.scale.y = 0.5;
		backBG.updateHitbox();
		backBG.antialiasing = ClientPrefs.data.antialiasing;
		backBG.y -= backBG.height;		
		add(backBG);
		add(backText);		
		backBG.cameras = [camOther];
		backText.cameras = [camOther];
		backText.y = backBG.y + backBG.height / 2 - backText.height / 2;
		
		//--------------text
		
		//time = 0
		FlxTween.tween(background, {alpha: 0.5}, 0.5);		
		
		new FlxTimer().start(0.5, function(tmr:FlxTimer){
			FlxTween.tween(clearText, {y: ClientPrefs.data.showFPS ? 60 : 5}, 0.5, {ease: FlxEase.backInOut});
		});
		
		
		new FlxTimer().start(1, function(tmr:FlxTimer){
			FlxTween.tween(setMsText, {y: FlxG.height - 25 * 2}, 0.5, {ease: FlxEase.backInOut});			
		});
		
		new FlxTimer().start(1.5, function(tmr:FlxTimer){
		    FlxTween.tween(judgeText, {x: 20}, 0.5, {ease: FlxEase.backInOut});		
		    FlxTween.tween(setGameText, {x: FlxG.width - setGameText.width - 20}, 0.5, {ease: FlxEase.backInOut});		
		});
		
		new FlxTimer().start(2, function(tmr:FlxTimer){
			FlxTween.tween(graphBG, {alpha: 1}, 0.5);
			
			FlxTween.tween(lostPNGText, {alpha: 1}, 0.5);
			if (lossImage)  new FlxTimer().start(5, function(tmr:FlxTimer){ FlxTween.tween(lostPNGText, {alpha: 0}, 1); });
			
			FlxTween.tween(graphJudgeCenter, {alpha: 0.3}, 0.5);	
			FlxTween.tween(graphMarvelousUp, {alpha: 0.3}, 0.5);	
			FlxTween.tween(graphMarvelousDown, {alpha: 0.3}, 0.5);	
			FlxTween.tween(graphSickUp, {alpha: 0.3}, 0.5);	
			FlxTween.tween(graphSickDown, {alpha: 0.3}, 0.5);	
			FlxTween.tween(graphGoodUp, {alpha: 0.3}, 0.5);	
			FlxTween.tween(graphGoodDown, {alpha: 0.3}, 0.5);	
			FlxTween.tween(graphBadUp, {alpha: 0.3}, 0.5);	
			FlxTween.tween(graphBadDown, {alpha: 0.3}, 0.5);	
			FlxTween.tween(graphShitUp, {alpha: 0.3}, 0.5);
			FlxTween.tween(graphShitDown, {alpha: 0.3}, 0.5);	
			FlxTween.tween(graphMiss, {alpha: 0.3}, 0.5);	
				
		    FlxTween.tween(graphSizeUp, {alpha: 0.75}, 0.5);
		    FlxTween.tween(graphSizeDown, {alpha: 0.75}, 0.5);
		    FlxTween.tween(graphSizeLeft, {alpha: 0.75}, 0.5);
		    FlxTween.tween(graphSizeRight, {alpha: 0.75}, 0.5);	
		});
		
		new FlxTimer().start(2.5, function(tmr:FlxTimer){
			FlxTween.tween(backBG, {x:  1280 - backBG.width}, 1, {ease: FlxEase.quintInOut});
			FlxTween.tween(backText, {x: 1280 - backText.width - 50}, 1.2, {ease: FlxEase.quintInOut});
		});
				
								
	}
	
	var getReadyClose:Bool = false;    
	var closeCheck:Bool = false;
	override function update(elapsed:Float)
	{ 					
		if(!closeCheck && (FlxG.keys.justPressed.ENTER || ((FlxG.mouse.getScreenPosition(camOther).x > backBG.x && FlxG.mouse.getScreenPosition(camOther).x < backBG.x + backBG.width && FlxG.mouse.getScreenPosition(camOther).y > backBG.y && FlxG.mouse.getScreenPosition(camOther).y < backBG.y + backBG.height) && FlxG.mouse.justPressed) #if android || FlxG.android.justReleased.BACK #end))
		{
		    if (getReadyClose){
    		    NewCustomFadeTransition();
                PlayState.cancelMusicFadeTween();
                closeCheck = true;
            }else{
                getReadyClose = true;
                FlxG.sound.play(Paths.sound('scrollMenu'));
                
                backText.text = 'Press Again to continue';
                
                new FlxTimer().start(1, function(tmr:FlxTimer){    		        		                        		
		            var backTextShow:String = 'Press Enter to continue';
            		#if android backTextShow = 'Press Text to continue'; #end		
            		backText.text = backTextShow;
            		
		            getReadyClose = false;
        		});
            }
		}		    
	}
	
	//NewCustomFadeTransition is work for better close Substate

	var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	
	var isTransIn:Bool = false;
	
	var loadLeft:FlxSprite;
	var loadRight:FlxSprite;
	var loadAlpha:FlxSprite;
	var WaterMark:FlxText;
	var EventText:FlxText;
	
	var loadLeftTween:FlxTween;
	var loadRightTween:FlxTween;
	var loadAlphaTween:FlxTween;
	var EventTextTween:FlxTween;
	var loadTextTween:FlxTween;

	function NewCustomFadeTransition(duration:Float = 0.6, TransIn:Bool = false) {
		
		isTransIn = TransIn;
				
		if(ClientPrefs.data.CustomFade == 'Move'){
    		loadRight = new FlxSprite(isTransIn ? 0 : 1280, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingR'));
    		loadRight.scrollFactor.set();
    		loadRight.antialiasing = ClientPrefs.data.antialiasing;		
    		add(loadRight);
    		loadRight.cameras = [camOther];
    		loadRight.setGraphicSize(FlxG.width, FlxG.height);
    		loadRight.updateHitbox();
    		
    		loadLeft = new FlxSprite(isTransIn ? 0 : -1280, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingL'));
    		loadLeft.scrollFactor.set();
    		loadLeft.antialiasing = ClientPrefs.data.antialiasing;
    		add(loadLeft);
    		loadLeft.cameras = [camOther];
    		loadLeft.setGraphicSize(FlxG.width, FlxG.height);
    		loadLeft.updateHitbox();
		
    		WaterMark = new FlxText(isTransIn ? 50 : -1230, 720 - 50 - 50 * 2, 0, 'NF ENGINE V1.1.0', 50);
    		WaterMark.scrollFactor.set();
    		WaterMark.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		WaterMark.antialiasing = ClientPrefs.data.antialiasing;
    		add(WaterMark);
    		WaterMark.cameras = [camOther];
        
            EventText = new FlxText(isTransIn ? 50 : -1230, 720 - 50 - 50, 0, 'LOADING . . . . . . ', 50);
    		EventText.scrollFactor.set();
    		EventText.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		EventText.antialiasing = ClientPrefs.data.antialiasing;
    		add(EventText);
    		EventText.cameras = [camOther];
		
			FlxG.sound.play(Paths.sound('loading_close'),ClientPrefs.data.CustomFadeSound);
			if (!ClientPrefs.data.CustomFadeText) {
			    EventText.text = '';
			    WaterMark.text = '';
			}
			loadLeftTween = FlxTween.tween(loadLeft, {x: 0}, duration, {
				onComplete: function(twn:FlxTween) {
				    FlxTransitionableState.skipNextTransIn = true;
					MusicBeatState.switchState(new FreeplayState());
				},
			ease: FlxEase.expoInOut});
			
			loadRightTween = FlxTween.tween(loadRight, {x: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.expoInOut});
			
			loadTextTween = FlxTween.tween(WaterMark, {x: 50}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.expoInOut});
			
			EventTextTween = FlxTween.tween(EventText, {x: 50}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.expoInOut});					
		}else{
    		loadAlpha = new FlxSprite( 0, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingAlpha'));
    		loadAlpha.scrollFactor.set();
    		loadAlpha.antialiasing = ClientPrefs.data.antialiasing;		
    		add(loadAlpha);
    		loadAlpha.cameras = [camOther];
    		loadAlpha.setGraphicSize(FlxG.width, FlxG.height);
    		loadAlpha.updateHitbox();
		
    		WaterMark = new FlxText( 50, 720 - 50 - 50 * 2, 0, 'NF ENGINE V1.1.0', 50);
    		WaterMark.scrollFactor.set();
    		WaterMark.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		WaterMark.antialiasing = ClientPrefs.data.antialiasing;
    		add(WaterMark);
            WaterMark.cameras = [camOther];
            
            EventText = new FlxText( 50, 720 - 50 - 50, 0, 'LOADING . . . . . . ', 50);
    		EventText.scrollFactor.set();
    		EventText.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		EventText.antialiasing = ClientPrefs.data.antialiasing;
        	add(EventText);
		    EventText.cameras = [camOther];
		
			FlxG.sound.play(Paths.sound('loading_close'),ClientPrefs.data.CustomFadeSound);
			if (!ClientPrefs.data.CustomFadeText) {
			    EventText.text = '';
			    WaterMark.text = '';
			}
			WaterMark.alpha = 0;
			EventText.alpha = 0;
			loadAlpha.alpha = 0;
			loadAlphaTween = FlxTween.tween(loadAlpha, {alpha: 1}, duration, {
				onComplete: function(twn:FlxTween) {
				    FlxTransitionableState.skipNextTransIn = true;
					MusicBeatState.switchState(new FreeplayState());
				},
			ease: FlxEase.sineInOut});
			
			loadTextTween = FlxTween.tween(WaterMark, {alpha: 1}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.sineInOut});
			
			EventTextTween = FlxTween.tween(EventText, {alpha: 1}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.sineInOut});
		}

	}

	override function destroy() {
		if(leTween != null) {
			finishCallback();
			leTween.cancel();
			
			if (loadLeftTween != null) loadLeftTween.cancel();
			if (loadRightTween != null) loadRightTween.cancel();
			if (loadAlphaTween != null) loadAlphaTween.cancel();
			
			loadTextTween.cancel();
			EventTextTween.cancel();
		}
		super.destroy();
	}
}
