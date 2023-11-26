package backend;

import flixel.util.FlxGradient;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import flixel.FlxSprite;
import openfl.utils.Assets;
import flixel.FlxObject;


 
class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
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

	public function new(duration:Float, isTransIn:Bool) {
		super();

		this.isTransIn = isTransIn;
		
		
		if(ClientPrefs.data.CustomFade == 'Move'){
		loadRight = new FlxSprite(isTransIn ? 0 : 1280, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingR'));
		loadRight.scrollFactor.set();
		loadRight.antialiasing = ClientPrefs.data.antialiasing;		
		add(loadRight);
		loadRight.setGraphicSize(FlxG.width, FlxG.height);
		loadRight.updateHitbox();
		
		loadLeft = new FlxSprite(isTransIn ? 0 : -1280, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingL'));
		loadLeft.scrollFactor.set();
		loadLeft.antialiasing = ClientPrefs.data.antialiasing;
		add(loadLeft);
		loadLeft.setGraphicSize(FlxG.width, FlxG.height);
		loadLeft.updateHitbox();
		
		WaterMark = new FlxText(isTransIn ? 50 : -1230, 720 - 50 - 50 * 2, 0, 'NF ENGINE V1.1.0', 50);
		WaterMark.scrollFactor.set();
		WaterMark.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		WaterMark.antialiasing = ClientPrefs.data.antialiasing;
		add(WaterMark);
        
        EventText= new FlxText(isTransIn ? 50 : -1230, 720 - 50 - 50, 0, 'LOADING . . . . . . ', 50);
		EventText.scrollFactor.set();
		EventText.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		EventText.antialiasing = ClientPrefs.data.antialiasing;
		add(EventText);
		
		if(!isTransIn) {
			FlxG.sound.play(Paths.sound('loading_close'),ClientPrefs.data.CustomFadeSound);
			if (!ClientPrefs.data.CustomFadeText) {
			    EventText.text = '';
			    WaterMark.text = '';
			}
			loadLeftTween = FlxTween.tween(loadLeft, {x: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
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
			
		} else {
			FlxG.sound.play(Paths.sound('loading_open'),ClientPrefs.data.CustomFadeSound);
			EventText.text = 'COMPLETED !';
			if (!ClientPrefs.data.CustomFadeText) {
			    EventText.text = '';
			    WaterMark.text = '';
			}
			loadLeftTween = FlxTween.tween(loadLeft, {x: -1280}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.expoInOut});
			
			loadRightTween = FlxTween.tween(loadRight, {x: 1280}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.expoInOut});
			
			loadTextTween = FlxTween.tween(WaterMark, {x: -1230}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.expoInOut});
			
			EventTextTween = FlxTween.tween(EventText, {x: -1230}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.expoInOut});
			
			
		}
		}
		else{
		loadAlpha = new FlxSprite( 0, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingAlpha'));
		loadAlpha.scrollFactor.set();
		loadAlpha.antialiasing = ClientPrefs.data.antialiasing;		
		add(loadAlpha);
		loadAlpha.setGraphicSize(FlxG.width, FlxG.height);
		loadAlpha.updateHitbox();
		
		WaterMark = new FlxText( 50, 720 - 50 - 50 * 2, 0, 'NF ENGINE V1.1.0', 50);
		WaterMark.scrollFactor.set();
		WaterMark.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		WaterMark.antialiasing = ClientPrefs.data.antialiasing;
		add(WaterMark);
        
        EventText= new FlxText( 50, 720 - 50 - 50, 0, 'LOADING . . . . . . ', 50);
		EventText.scrollFactor.set();
		EventText.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		EventText.antialiasing = ClientPrefs.data.antialiasing;
		add(EventText);
		
		if(!isTransIn) {
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
					if(finishCallback != null) {
						finishCallback();
					}
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
			
		} else {
			FlxG.sound.play(Paths.sound('loading_open'),ClientPrefs.data.CustomFadeSound);
			EventText.text = 'COMPLETED !';
			if (!ClientPrefs.data.CustomFadeText) {
			    EventText.text = '';
			    WaterMark.text = '';
			}
			loadAlphaTween = FlxTween.tween(loadAlpha, {alpha: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						close();
					}
				},
			ease: FlxEase.sineInOut});
			
			loadTextTween = FlxTween.tween(WaterMark, {alpha: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						close();
					}
				},
			ease: FlxEase.sineInOut});
			
			EventTextTween = FlxTween.tween(EventText, {alpha: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						close();
					}
				},
			ease: FlxEase.sineInOut});
			
			
		}
		}

		if(nextCamera != null) {
		    if (loadLeft != null) loadLeft.cameras = [nextCamera];
			if (loadRight != null) loadRight.cameras = [nextCamera];			
			if (loadAlpha != null) loadAlpha.cameras = [nextCamera];
			
			WaterMark.cameras = [nextCamera];
			EventText.cameras = [nextCamera];
		}
		nextCamera = null;
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