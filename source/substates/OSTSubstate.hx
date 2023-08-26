package substates;

import flash.geom.Rectangle;
import tjson.TJSON as Json;
import haxe.format.JsonParser;
import haxe.io.Bytes;

import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxSort;
import lime.media.AudioBuffer;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.utils.Assets as OpenFlAssets;

import flixel.addons.transition.FlxTransitionableState

import backend.Song;
import backend.Section;
import backend.StageData;


import objects.AttachedSprite;
import substates.Prompt;

#if sys
import flash.media.Sound;
import sys.io.File;
import sys.FileSystem;
#end

#if android
import android.flixel.FlxButton;
#else
import flixel.ui.FlxButton;
#end

@:access(flixel.sound.FlxSound._sound)
@:access(openfl.media.Sound.__buffer)



class OSTSubstate extends MusicBeatSubstate
{


	public function new(Song:String,vocals:String)
	{
		super();
		
		FlxG.sound.list.add(vocals);
		FlxG.sound.playMusic(Paths.inst(Song), 0.7);
		vocals.play();
		vocals.persist = true;
		vocals.looped = true;
		vocals.volume = 0.7;
		
		
	}

	
	override function update(elapsed:Float)
	{
		if(FlxG.keys.justPressed.ESCAPE #if android || FlxG.android.justReleased.BACK #end)
		{
			#if android
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
			#else
			FlxG.sound.play(Paths.sound('cancelMenu'));
			close();
			#end
		}
		
		super.update(elapsed);
	}

	
}