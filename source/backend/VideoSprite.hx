package backend;

import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;

#if VIDEOS_ALLOWED 
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end

/**
 * This class allows you to play videos using sprites (FlxSprite).
 */

class VideoSprite extends FlxSprite
{
	public var bitmap:VideoHandler;
	public var canvasWidth:Null<Int>;
	public var canvasHeight:Null<Int>;
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
                        
            graphic.bitmap = bitmap.bitmapData;
			loadGraphic(graphic);
			if (canvasWidth != 0 && canvasHeight != 0)
			{
				setGraphicSize(canvasWidth, canvasHeight);
				updateHitbox();

				//var size:Float = (fillScreen ? Math.max : Math.min)(scale.x, scale.y);
				//scale.set(size, size); // lol
			}
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