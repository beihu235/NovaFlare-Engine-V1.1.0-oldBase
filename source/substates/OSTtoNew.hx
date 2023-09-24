package substates;

import lime.app.Application;
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
	
    var sampleRate:Float;
    var frequencyBandCount:Int;
    var frequencyBandwidth:Float;
    var audioData:Array<Float>;
    var currentTime:Float;
    var frequencyRanges:Int = 10;
    
    var sample:Float = 0;
		
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
        
        audioData = [];
        currentTime = 0;
        
        updateAudioData();
    }
    
    override function update(elapsed:Float)
	{
	    updateAudioData();
	    var text:String = '' + sample;
	    scoreText.text = text;
	    for (i in 1...frequencyRanges){
	    scoreText.text += '\n' + audioData[i];
	    }
	    scoreText.text += '\n';
	    
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
	
	public function updateAudioData():Void {
        audioData = [];
        getSample();
        var startTime:Float = currentTime;
        var endTime:Float = startTime; // 假设你想获取当前帧的数据

        for (i in 0...frequencyRanges) {
            //var startIndex:Float = frequencyRanges[i] * frequencyBandwidth;
            var endIndex:Float = (i + 1) * frequencyBandwidth;

            // 计算当前时间段内的音频数据范围
            var startSample:Int = Math.floor(startTime * sampleRate);
            var endSample:Int = Math.floor(endTime * sampleRate);
        
            var amplitude:Float = sample; /*/ 32768.0;*/ // 将样本值映射到-1.0到1.0之间
            var phase:Float = Math.PI * endSample / sampleRate; // 计算当前样本的相位

            // 生成正弦波数据
            var sineWave:Float = Math.abs(Math.sin(phase) * 1);

            // 将正弦波数据添加到音频数据向量中
            audioData.push(sineWave);
        }
    }
    
    public function getSample(){
    
        var snd = FlxG.sound.music;
        var audioBuffer = snd._sound.__buffer;
    	var bytes = audioBuffer.data.buffer;
		
    	var khz = (audioBuffer.sampleRate / 1000);
    	var channels = audioBuffer.channels;
    	var index = Math.floor(currentTime * khz);				
    	var byte = bytes.getUInt16(index * channels * 2);
    	
    	currentTime = snd.time;
    	
    	if (byte > 44100 / 2) byte -= 44100;
        sample = Math.abs((byte / 44100)); 
        
        sampleRate = audioBuffer.sampleRate;
        frequencyBandCount = frequencyRanges;
        frequencyBandwidth = sampleRate / frequencyBandCount;
        
    }
    
    public static function destroyVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}
}


