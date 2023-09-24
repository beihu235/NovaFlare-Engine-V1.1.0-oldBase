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
	
    var audioBuffer:AudioBuffer;
    var frequencyData:Array<Float>;
    var frequencySegments:Int = 10;
    var snd = FlxG.sound.music;
		
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
		
		scoreText = new FlxText(FlxG.width * 0.5, FlxG.height * 0.2, 0, '', 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        scoreText.scrollFactor.set();
        add(scoreText);        
       
       
       
       updateFrequencyData();
    }
    
    override function update(elapsed:Float)
	{
	    updateFrequencyData();
	    
	    var text:String = '' + frequencyData.length;
	    scoreText.text = text;
	    for (i in 1...frequencySegments){
	    scoreText.text += '\n' + frequencyData[i];
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
	
	public function updateFrequencyData() {
    frequencyData = [];
    audioBuffer = snd._sound.__buffer;
    var audioData = audioBuffer.data;
    var sampleRate = audioBuffer.sampleRate;
    var numSegments = 10;
    //var length = audioBuffer.samples.length;

    var frequencySegmentWidth = sampleRate / numSegments;
    var maxPossibleIntensity = 255; // or any other maximum possible value

    for (i in 0...numSegments) {
        var startSample:Int = Std.int(i * frequencySegmentWidth);
        var endSample:Int = Std.int((i + 1) * frequencySegmentWidth);
        var sum = 0;

        for (j in startSample...endSample) {
            sum += audioData[j];
        }

        // 获取该分段的音量大小
        var frequencyFrameData = sum / (endSample - startSample) / maxPossibleIntensity;
        frequencyData.push(frequencyFrameData);
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
import lime.media.AudioBuffer;

class VisualMusic {
    public var audioBuffer:AudioBuffer;
    public var frequencyData:Array<Float>;
    public var frequencySegments:Int;

    public function new(audioBuffer:AudioBuffer, frequencySegments:Int) {
        this.audioBuffer = audioBuffer;
        this.frequencySegments = frequencySegments;
        this.frequencyData = new Array();

        for (i in 0...frequencySegments) {
            frequencyData.push(0);
        }

        image = new Image(0, 0);
        isPlaying = false;
    }

    public function updateFrequencyData() {
    frequencyData = [];
    var audioData = audioBuffer.data;
    audioBuffer = snd._sound.__buffer;
    var sampleRate = audioBuffer.sampleRate;
    //var length = audioBuffer.samples.length;
    var frequencySegmentWidth = (sampleRate / frequencySegments);
    var maxPossibleIntensity = 255; // or any other maximum possible value
    
    for (i in 0...frequencySegments) {
        var startSample:Int = Std.int(i * frequencySegmentWidth);
        var endSample:Int = Std.int((i + 1) * frequencySegmentWidth);
        var sum = 0;

        for (j in startSample...endSample) {
            sum += audioData[j];
        }

        frequencyData.push(sum / (endSample - startSample) / maxPossibleIntensity);
    }
}


    public function draw(renderContext:RenderContext) {
        renderContext.drawImage(image);
    }

    public function onMouseDown(event:MouseEvent) {
        if (!isPlaying) {
            isPlaying = true;
            audioBuffer.play();
        }
    }

    public function onMouseUp(event:MouseEvent) {
        if (isPlaying) {
            isPlaying = false;
            audioBuffer.stop();
        }
    }
}
*/

