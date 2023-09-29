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

class DisplayObject extends FlxSprite
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	

	public function new(x:Float = 10, y:Float = 10)
	{
		super();

		this.x = x;
		this.y = y;

	}
}
