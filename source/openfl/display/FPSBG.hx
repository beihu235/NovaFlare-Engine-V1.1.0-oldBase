package openfl.display;

import haxe.Timer;
import openfl.events.Event;

#if flash
import openfl.Lib;
#end

import openfl.utils.Assets;

#if openfl
import openfl.system.System;
#end

class FPSBG extends FlxSprite
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Float;
    public var logicFPStime(default, null):Float;
    public var DisplayFPS(default, null):Float;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10)
	{
		super();

		this.x = x;
		this.y = y;
				

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}
	
	

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
	
	
	}
}
