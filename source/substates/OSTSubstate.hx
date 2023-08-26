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

import flixel.addons.transition.FlxTransitionableState;

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
    public static var vocals:FlxSound = null;

	public function new(needVoices:Bool,bpm:Float)
	{
		super();				
		
		if (needVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();
		
		FlxG.sound.list.add(vocals);
		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
		vocals.play();
		vocals.persist = true;
		vocals.looped = true;
		vocals.volume = 0.7;		
		
		left = new FlxSprite().makeGraphic(1280, 720, 0xFF000000, false, "lchannelw");
		left.alpha = 0.5;
		add(left);
		
		
		
		game.add(right);
		
		flashGFX = FlxSpriteUtil.flashGfx;
		
		_rect = new Rectangle(0, 0, 1280, 720);
		_temprect = new Rectangle(0, 0, 0, 0);
		midx = 720 / 2;
		
	}

	
	override function update(elapsed:Float)
	{
		if(FlxG.keys.justPressed.ESCAPE #if android || FlxG.android.justReleased.BACK #end)
		{
		    FlxG.sound.music.volume = 0;
		    destroyVocals();
		
		    FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);		
		    
			#if android
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
			#else
			FlxG.sound.play(Paths.sound('cancelMenu'));
			close();
			#end
		}
		
		left.pixels.lock();
		left.pixels.fillRect(_rect, 0xFF000000);
		
		right.pixels.lock();
		right.pixels.fillRect(_rect, 0xFF000000);

		FlxSpriteUtil.beginDraw(0xFFFFFFFF);
		flashGFX2.clear(); flashGFX2.beginFill(0xFFFFFF, 1);
		
		var snd = FlxG.sound.music;

		var currentTime = snd.time;
		
		var buffer = snd._sound.__buffer;
		var bytes = buffer.data.buffer;
		
		var length = bytes.length - 1;
		var khz = (buffer.sampleRate / 1000);
		var channels = buffer.channels;
		var stereo = channels > 1;
		
		var index = Math.floor(currentTime * khz);
		var samples = 720;//Math.floor((currentTime + (((60 / Conductor.bpm) * 1000 / 4) * 16)) * khz - index);
		var samplesPerRow = samples / 720;

		var lmin = 0;
		var lmax = 0;

		var rmin = 0;
		var rmax = 0;

		var rows = 0;
		var render = 0;
		var prevRows = 0;
		
		while (index < length) {
			if (index >= 0) {
				var byte = bytes.getUInt16(index * channels * 2);

				if (byte > 65535 / 2) byte -= 65535;

				var sample = (byte / 65535);

				if (sample > 0) {
					if (sample > lmax) lmax = sample;
				} else if (sample < 0) {
					if (sample < lmin) lmin = sample;
				}

				if (stereo) {
					var byte = bytes.getUInt16((index * channels * 2) + 2);

					if (byte > 65535 / 2) byte -= 65535;

					var sample = (byte / 65535);

					if (sample > 0) {
						if (sample > rmax) rmax = sample;
					} else if (sample < 0) {
						if (sample < rmin) rmin = sample;
					}
				}
			}
			
			if (rows - prevRows >= samplesPerRow) {
				prevRows = rows + ((rows - prevRows) - 1);
				
				flashGFX.drawRect(render, midx + (rmin * midx * 2), 1, (rmax - rmin) * midx * 2);
				//flashGFX2.drawRect(midx + (rmin * midx * 2), render, (rmax - rmin) * midx * 2, 1);
				
				
				
				lmin = lmax = rmin = rmax = 0;
				render++;
			}
			
			index++;
			rows++;
			if (render > 720-1) break;
		}
		
		flashGFX.endFill(); //flashGFX2.endFill();
		left.pixels.draw(FlxSpriteUtil.flashGfxSprite); //right.pixels.draw(flashSpr2);
		left.pixels.unlock(); //right.pixels.unlock();
		//left.dirty = true;
		
		return;
		
		super.update(elapsed);
	}

	public static function destroyVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}
}