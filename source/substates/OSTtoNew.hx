package substates;


import lime.graphics.RenderContext;
import lime.media.AudioBuffer;
import lime.system.System;

import haxe.io.Path;
import haxe.io.Bytes;

import flixel.addons.transition.FlxTransitionableState;

@:access(flixel.sound.FlxSound._sound)
@:access(openfl.media.Sound.__buffer)

class OSTtoNew extends MusicBeatSubstate
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
	
    public var audioBuffer:AudioBuffer;
    public var sampleRate:Float;
    public var frequencyBandCount:Int;
    public var frequencyBandwidth:Float;
    public var audioData:Array<Float>;
    public var currentTime:Float;
    public var frequencyRanges:Array<Float>;
    public function new(needVoices:Bool,songBpm:Float)
	{
	    super();		
        
        camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camLogo = new FlxCamera();
		camLogo.bgColor.alpha = 0;
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camLogo, false);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		
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
		
		scoreText = new FlxText(FlxG.width * 0.5, FlxG.height * 0.5, 0, '', 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        scoreText.scrollFactor.set();
        add(scoreText);

		
        var snd = FlxG.sound.music;
        var audioBuffer:AudioBuffer = snd._sound.__buffer;
        
        sampleRate = audioBuffer.sampleRate;
        frequencyBandCount = 128;
        frequencyBandwidth = sampleRate / frequencyBandCount;
        audioData = [];
        currentTime = 0;
        frequencyRanges = [0.0, 1000.0, 2000.0, 3000.0, 4000.0, 5000.0, 6000.0, 7000.0, 8000.0, 9000.0, 10000.0]; // 假设你想获取10个频率段的音量大小
    }
    
    override function update(elapsed:Float)
	{
	    updateVisualizationData();
	    var text:String = '' + visualizationData.length;
	    scoreText.text = text;
	    
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
	}
	
	public function updateVisualizationData():Void {
        audioData = [];
        var startTime:Float = currentTime;
        var endTime:Float = startTime + 1; // 假设你想获取1秒的数据

        for (i in 0...frequencyRanges.length) {
            var startIndex:Float = frequencyRanges[i] * frequencyBandwidth;
            var endIndex:Float = (i + 1) * frequencyBandwidth;

            // 计算当前时间段内的音频数据范围
            var startSample:Int = Math.floor(startTime * sampleRate);
            var endSample:Int = Math.floor(endTime * sampleRate);

            // 获取当前时间段内的音频数据
            var frequencyBandData:Float = 0.0;
            for (j in startSample...endSample) {
                var sample:Int = audioBuffer.readSample();
                frequencyBandData += sample / (endSample - startSample);
            }

            // 将频率段数据添加到音频数据向量中
            audioData.push(frequencyBandData);
        }
    }

    
    public static function destroyVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}
}


/*
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.media.AudioBuffer;
import lime.system.System;

class Visualization {
    public var app:Application;
    public var audioBuffer:AudioBuffer;
    public var sampleRate:Float;
    public var frequencyBandCount:Int;
    public var frequencyBandwidth:Float;
    public var audioData:Array<Float>;
    public var currentTime:Float;
    public var frequencyRanges:Array<Float>;

    public function new(app:Application, audioBuffer:AudioBuffer) {
        this.app = app;
        this.audioBuffer = audioBuffer;
        this.sampleRate = audioBuffer.sampleRate;
        this.frequencyBandCount = 128;
        this.frequencyBandwidth = sampleRate / frequencyBandCount;
        this.audioData = [];
        this.currentTime = 0;
        this.frequencyRanges = [0.0, 1000.0, 2000.0, 3000.0, 4000.0, 5000.0, 6000.0, 7000.0, 8000.0, 9000.0, 10000.0]; // 假设你想获取10个频率段的音量大小
    }

    public function updateAudioData():Void {
        audioData = [];
        var startTime:Float = currentTime;
        var endTime:Float = startTime + 1; // 假设你想获取1秒的数据

        for (i in 0...frequencyRanges.length) {
            var startIndex:Float = frequencyRanges[i] * frequencyBandwidth;
            var endIndex:Float = (i + 1) * frequencyBandwidth;

            // 计算当前时间段内的音频数据范围
            var startSample:Int = Math.floor(startTime * sampleRate);
            var endSample:Int = Math.floor(endTime * sampleRate);

            // 获取当前时间段内的音频数据
            var frequencyBandData:Float = 0.0;
            for (j in startSample...endSample) {
                var sample:Int = audioBuffer.readSample();
                frequencyBandData += sample / (endSample - startSample);
            }

            // 将频率段数据添加到音频数据向量中
            audioData.push(frequencyBandData);
        }
    }

    public function setCurrentTime(time:Float):Void {
        currentTime = time;
    }

    public function setFrequencyRanges(ranges:Array<Float>):Void {
        frequencyRanges = ranges;
    }
}
*/
