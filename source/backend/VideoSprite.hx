package backend;

import flixel.FlxSprite;
import flixel.util.FlxColor;

import backend.VideoHandler_Title as VideoHandler;

/**
 * This class allows you to play videos using sprites (FlxSprite).
 */
class VideoSprite extends FlxSprite
{
	public var bitmap:VideoHandler;
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

		bitmap = new VideoHandler();
		bitmap.canUseAutoResize = false;
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

		if (bitmap.isPlaying && bitmap.isDisplaying && bitmap.bitmapData != null)
			pixels = bitmap.bitmapData;
	}

	/**
	 * Native video support for Flixel & OpenFL
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 * @param PauseMusic Pause music until the video ends.
	 */
	public function playVideo(Path:String, Loop:Bool = false, PauseMusic:Bool = false):Void
		bitmap.playVideo(Path, Loop, PauseMusic, newWidth, newHeight);
}
