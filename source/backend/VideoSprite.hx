package backend;

import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;

#if VIDEOS_ALLOWED 
import backend.VideoHandler_Title as VideoHandler;

/**
 * This class allows you to play videos using sprites (FlxSprite).
 */

class VideoSprite extends FlxSprite
{
	public var bitmap:VideoHandler;
	public var canvasWidth:Int;
	public var canvasHeight:Int;
	public var fillScreen:Bool = false;

	public var openingCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	public function new(X:Float = 0, Y:Float = 0, Width:Int = 0, Height:Int = 0)
	{
		super(X, Y);
		
		canvasWidth = Width;
	    canvasHeight = Height;

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
			oneTime = false;
			if (finishCallback != null)
				finishCallback();

			kill();
		}
	}

	private var oneTime:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);
        
		if (bitmap.isPlaying && bitmap.isDisplaying && bitmap.bitmapData != null && !oneTime)
		{
			
			if (graphic.imageFrame.frame == null)
			{
				trace('the frame of the image is null?');
				return;
			}
			
            if (canvasWidth != 0 && canvasHeight != 0)
			{
			bitmap.videoWidth = canvasWidth;
			bitmap.videoHeight = canvasHeight;
				
			}            
            graphic.bitmap = bitmap.bitmapData;
			loadGraphic(graphic);
			
			oneTime = true;
		}
		
	}

	/**
	 * Native video support for Flixel & OpenFL
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 * @param PauseMusic Pause music until the video ends.
	 */
	public function playVideo(Path:String, Loop:Bool = false, PauseMusic:Bool = false):Void
		bitmap.playVideo(Path, Loop, PauseMusic);
}
#end