package substates;

import flash.geom.Rectangle;
import tjson.TJSON as Json;
import haxe.format.JsonParser;
import haxe.io.Bytes;

import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxSort;
import flixel.util.FlxSpriteUtil;
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


@:access(flixel.sound.FlxSound._sound)
@:access(openfl.media.Sound.__buffer)



class OSTSubstate extends MusicBeatSubstate
{
    var waveformVoiceSprite:FlxSprite;
    var logoBl:FlxSprite;
    var bpm:Float = 0;
    public static var vocals:FlxSound;
    var songVoice:Bool = false;
    
    public var camGame:FlxCamera;
	public var camHUD:FlxCamera;
	public var camLogo:FlxCamera;
	var scoreText:FlxText;
	
	public function new(needVoices:Bool,songBpm:Float)
	{
		super();		
		
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		
		//camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camLogo = new FlxCamera();
		camLogo.bgColor.alpha = 0;
		camHUD.bgColor.alpha = 0;

		//FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camLogo, false);
		FlxG.cameras.add(camHUD, false);
		//FlxG.cameras.setDefaultDrawTarget(camGame, true);
		
		camLogo.x = -320;
		
		bpm = songBpm;		
		
		songVoice = needVoices;
		
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
		
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0,0);
		bg.setGraphicSize(Std.int(bg.width));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		
		logoBl = new FlxSprite(0, 0);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.data.antialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.offset.x = 0;
		logoBl.offset.y = 0;
		logoBl.scale.x = (640 / logoBl.frameWidth);
		logoBl.scale.y = logoBl.scale.x;
		logoBl.updateHitbox();
		add(logoBl);
		logoBl.x = 320 - logoBl.width / 2;
		logoBl.y = 360 - logoBl.height / 2;
		//logoBl.cameras = [camLogo];
		//logoBl.screenCenter(Y);
		
		
		waveformVoiceSprite = new FlxSprite(1280 - 640, 50).makeGraphic(640 - 50, 100, 0xFF000000);
		waveformVoiceSprite.alpha = 0.5;
		add(waveformVoiceSprite);
	    
	}
    
    var SoundTime:Float = 0;
	var BeatTime:Float = 0;
	
	var canBeat:Bool = true;
	override function update(elapsed:Float)
	{

	//	FlxSpriteUtil.cameraBound(logoBl, camGame, ANY);
	
	    if(FlxG.keys.justPressed.ESCAPE #if android || FlxG.android.justReleased.BACK #end)
		{
		    FlxG.sound.music.volume = 0;
		    destroyVocals();
		
		    FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);		
		    
			FlxG.sound.play(Paths.sound('cancelMenu'));
		    
		    close();
		
		}
		
		updateVoiceWaveform();		
		
		SoundTime = FlxG.sound.music.time / 1000;
        BeatTime = 60 / bpm;
        
        if ( Math.floor(SoundTime/BeatTime) % 4  == 0 && canBeat){       
            canBeat = false;            
            //camBeat();
            logoBl.animation.play('bump');
        }
		
		if ( Math.floor(SoundTime/BeatTime + 0.5) % 4  == 2) canBeat = true;   
		
		
		
		//var volue:Float = Math.exp(-1 * 2 * Math.PI * 200 * FlxG.sound.music.time);
		//var volue2:Float = Math.exp(-1 * 2 * Math.PI * 44100 * FlxG.sound.music.time);
		/*
		var data:Float = FlxG.sound.music.amplitude;
		var data2:Float = FlxG.sound.music.amplitude;
		scoreText.text = 'data1:' + data + '\ndata2:' + data2 + '\n';
		
		*/
		super.update(elapsed);
	}
	


	function updateVoiceWaveform() {
	
	    var flashGFX = FlxSpriteUtil.flashGfx;
		
		var _rect = new Rectangle(0, 0, 640 - 50, 100);
		//var _temprect = new Rectangle(0, 0, 0, 0);
		var midx = 100 / 2;
	
	    waveformVoiceSprite.pixels.lock();
		waveformVoiceSprite.pixels.fillRect(_rect, 0xFF000000);

		FlxSpriteUtil.beginDraw(0xFFFFFFFF);
		
		
		var snd = FlxG.sound.music;

		var currentTime = snd.time;
		
		var buffer = snd._sound.__buffer;
		var bytes = buffer.data.buffer;
		
		var length = bytes.length - 1;
		var khz = (buffer.sampleRate / 1000);
		var channels = buffer.channels;
		var stereo = channels > 1;
		var src = buffer.src;
		var bitsPerSample = buffer.bitsPerSample;
		
		var index = Math.floor(currentTime * khz);
		var samples = 720;//Math.floor((currentTime + (((60 / Conductor.bpm) * 1000 / 4) * 16)) * khz - index);
		var samplesPerRow = samples / 720;

		var lmin:Float = 0;
		var lmax:Float = 0;
		
		var rmin:Float = 0;
		var rmax:Float = 0;

		var rows = 0;
		var render = 0;
		var prevRows = 0;
		
		var byte = 0;
		
		while (index < length) {
			if (index >= 0) {
				byte = bytes.getUInt16(index * channels * 2);

				if (byte > 65535 / 2) byte -= 65535;

				var sample = (byte / 65535);

				if (sample > 0) {
					if (sample > lmax) lmax = sample;
				} else if (sample < 0) {
					if (sample < lmin) lmin = sample;
				}

				if (stereo) {
					 byte = bytes.getUInt16((index * channels * 2) + 2);

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
				//flashGFX.drawRect(midx + (rmin * midx * 2), render, (rmax - rmin) * midx * 2, 1);
				
				
				
				lmin = lmax = rmin = rmax = 0;
				render++;
			}
			
			index++;
			rows++;
			if (render > (640 - 50 - 1)) break;
		}
		
		flashGFX.endFill(); 
		waveformVoiceSprite.pixels.draw(FlxSpriteUtil.flashGfxSprite);
		waveformVoiceSprite.pixels.unlock(); 
	}
	
	function camBeat() {
	    //camGame.zoom = 1 + 0.03;
	   // FlxTween.tween(camGame, {zoom: 1}, 0.6, {ease: FlxEase.cubeOut});
	
	}

	public static function destroyVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}
}