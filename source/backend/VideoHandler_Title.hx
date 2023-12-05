package backend;

import flixel.FlxG;
import openfl.Lib;
import openfl.events.Event;
import sys.FileSystem;
import vlc.VLCBitmap;

import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * Handles video playback.
 * Use bitmap to connect to a graphic or use `VideoSprite`.
 */
class VideoHandler_Title extends VLCBitmap
{
	public var canSkip:Bool = true;
	public var canUseSound:Bool = true;
	public var canUseAutoResize:Bool = true;

	public var openingCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	private var pauseMusic:Bool = false;

	public function new(IndexModifier:Int = 0):Void
	{
		super();

		onOpening = onVLCOpening;
		onEndReached = onVLCEndReached;
		onEncounteredError = onVLCEncounteredError;

		FlxG.addChildBelowMouse(this, IndexModifier);
	}

	private function onVLCOpening():Void 
	{        
		trace("the video is opening!");
		if (openingCallback != null)
		    openingCallback();
	}

	private function onVLCEncounteredError():Void
	{
		Lib.application.window.alert('Error cannot be specified', "VLC Error!");
		onVLCEndReached();
	}

	private function onVLCEndReached():Void
	{
		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.resume();

		if (FlxG.stage.hasEventListener(Event.ENTER_FRAME))
			FlxG.stage.removeEventListener(Event.ENTER_FRAME, update);

		if (FlxG.autoPause)
		{
			if (FlxG.signals.focusGained.has(resume))
				FlxG.signals.focusGained.remove(resume);

			if (FlxG.signals.focusLost.has(pause))
				FlxG.signals.focusLost.remove(pause);
		}

		dispose();

		FlxG.removeChild(this);

		if (finishCallback != null)
			finishCallback();
	}

	/**
	 * Plays a video.
	 *
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 * @param PauseMusic Pause music until the video ends.
	 */
	public function playVideo(Path:String, Loop:Bool = false, PauseMusic:Bool = false, Width:Int, Height:Int):Void
	{
		pauseMusic = PauseMusic;

		if (FlxG.sound.music != null && PauseMusic)
			FlxG.sound.music.pause();

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);

		if (FlxG.autoPause)
		{
			FlxG.signals.focusGained.add(resume);
			FlxG.signals.focusLost.add(pause);
		}

		// in case if you want to use another dir then the application one.
		// android can already do this, it can't use application's storage.
		if (FileSystem.exists(Sys.getCwd() + Path))
			play(Sys.getCwd() + Path, Loop);
		else
			play(Path, Loop);
	}

	private function update(?E:Event):Void
	{
		#if FLX_KEYBOARD
		if (canSkip && (FlxG.keys.justPressed.SPACE #if android || FlxG.android.justReleased.BACK #end) && (isPlaying && isDisplaying))
			onVLCEndReached();
		#elseif android
		if (canSkip && FlxG.android.justReleased.BACK && (isPlaying && isDisplaying))
			onVLCEndReached();
		#end

		if (canUseAutoResize && (videoWidth > 0 && videoHeight > 0))
		{
			width = calcSize(0);
			height = calcSize(1);
		}

		volume = #if FLX_SOUND_SYSTEM Std.int(((FlxG.sound.muted || !canUseSound) ? 0 : 1) * (FlxG.sound.volume * 100)) #else FlxG.sound.volume * 100 #end;
	}

	public function calcSize(Ind:Int):Int
	{
		var appliedWidth:Float = Lib.current.stage.stageHeight * (FlxG.width / FlxG.height);
		var appliedHeight:Float = Lib.current.stage.stageWidth * (FlxG.height / FlxG.width);

		if (appliedHeight > Lib.current.stage.stageHeight)
			appliedHeight = Lib.current.stage.stageHeight;

		if (appliedWidth > Lib.current.stage.stageWidth)
			appliedWidth = Lib.current.stage.stageWidth;

		switch (Ind)
		{
			case 0:
				return Std.int(appliedWidth);
			case 1:
				return Std.int(appliedHeight);
		}

		return 0;
	}
}

/**
 * This class allows you to play videos using sprites (FlxSprite).
 */
class VideoSprite extends FlxSprite
{
	public var bitmap:VideoHandler_Title;
	public var openingCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;
	
	public var newWidth = 0;
    public var newHeight = 0;
    
	public function new(X:Float = 0, Y:Float = 0, Width:Int = 1280, Height:Int = 720)
	{
		super(X, Y);
		
		newWidth = Width;
        newHeight = Height;
        
		makeGraphic(1, 1, FlxColor.TRANSPARENT);

		bitmap = new VideoHandler_Title();		
		bitmap.alpha = 0;
		bitmap.openingCallback = function()
		{
			if (openingCallback != null)
				openingCallback();
		}
		bitmap.finishCallback = function()
		{
			if (finishCallback != null)
				finishCallback();

			kill();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (bitmap.isPlaying && bitmap.isDisplaying && bitmap.bitmapData != null){
			pixels = bitmap.bitmapData;
		
		var size:Float = Math.min(newWidth / bitmap.bitmapData.width, newHeight / bitmap.bitmapData.height);
		scale.set(size, size); // lol	
		updateHitbox();
		}	
	}

	/**
	 * Native video support for Flixel & OpenFL
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 * @param PauseMusic Pause music until the video ends.
	 */
	public function playVideo(Path:String, Loop:Bool = false, PauseMusic:Bool = false):Void{
		bitmap.playVideo(Path, Loop, PauseMusic, newWidth, newHeight);
		
		
	}
}