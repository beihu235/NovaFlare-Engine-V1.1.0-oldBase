package backend;

import flixel.util.FlxGradient;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
	var isTransIn:Bool = false;
	var transBlack:FlxSprite;
	var transGradient:FlxSprite;

	public function new(duration:Float, isTransIn:Bool) {
		super();

		this.isTransIn = isTransIn;
		
		loadLeft = new FlxSprite(isTransIn ? 0 : -1280, 0).loadGraphic(Paths.image('loadingL'));
		loadLeft.scrollFactor.set();
		loadLeft.antialiasing = ClientPrefs.globalAntialiasing;
		add(loadLeft);
		
		loadRight = new FlxSprite(isTransIn ? 0 : 1280, 0).loadGraphic(Paths.image('loadingR'));
		loadRight.scrollFactor.set();
		loadRight.antialiasing = ClientPrefs.globalAntialiasing;
		add(loadRight);
		
		WaterMark = new FlxText(isTransIn ? 50 : -1230, 720 - 50 - 100 * 2, 0, 'NF ENGINE V1.0.1', 110);
		WaterMark.scrollFactor.set();
		WaterMark.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 113, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		WaterMark.antialiasing = ClientPrefs.globalAntialiasing;
		add(WaterMark);
        
        EventText= new FlxText(isTransIn ? 50 : -1230, 720 - 50 - 110, 0, 'LOADING . . . . . . ', 110);
		EventText.scrollFactor.set();
		EventText.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 113, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		EventText.antialiasing = ClientPrefs.globalAntialiasing;
		add(EventText);
		
		if(!isTransIn) {
			FlxG.sound.play(Paths.sound('loading_close'));
			loadLeftTween = FlxTween.tween(loadLeft, {x: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.quintInOut});
			
			loadRightTween = FlxTween.tween(loadRight, {x: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.quintInOut});
			
			loadTextTween = FlxTween.tween(WaterMark, {x: 50}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.quintInOut});
			
			EventTextTween = FlxTween.tween(EventText, {x: 50}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.quintInOut});
			
		} else {
			FlxG.sound.play(Paths.sound('loading_open'));
			EventText.text = 'COMPLETED !';
			
			loadLeftTween = FlxTween.tween(loadLeft, {x: -1280}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.quintInOut});
			
			loadRightTween = FlxTween.tween(loadRight, {x: 1280}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.quintInOut});
			
			loadTextTween = FlxTween.tween(WaterMark, {x: -1230}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.quintInOut});
			
			EventTextTween = FlxTween.tween(EventText, {x: -1230}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.quintInOut});
			
			
		}

		if(nextCamera != null) {
			loadRight.cameras = [nextCamera];
			loadLeft.cameras = [nextCamera];
			WaterMark.cameras = [nextCamera];
			EventText.cameras = [nextCamera];
		}
		nextCamera = null;
	}

	override function destroy() {
		if(leTween != null) {
			finishCallback();
			leTween.cancel();
			loadLeftTween.cancel();
			loadRightTween.cancel();
			loadTextTween.cancel();
			EventTextTween.cancel();
		}
		super.destroy();
	}
}