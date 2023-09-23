package substates;

//import haxe.audio.AudioBuffer;
import lime.media.AudioBuffer;
import haxe.io.Path;
import haxe.io.Bytes;

@:access(flixel.sound.FlxSound._sound)
@:access(openfl.media.Sound.__buffer)

class OSTtoNew extends MusicBeatSubstate
{
    public static var vocals:FlxSound;
    // 设置频率段大小（以赫兹为单位）
    var frequencyBandwidth:Float = 1000;
    
    var frequencyBandCount:Int = 0;
    // 设定音频数据的采样率和位深度
    var sampleRate:Int = 44100;
    var bitsPerSample:Int = 16;
    var visualizationData:Array<Float> = [];
    var audioDataArray:Array<Int> = [];
    public function new(needVoices:Bool,songBpm:Float)
	{
	    super();		
        
        /*
        var audioFile = PlayState.SONG.song;
        var audioBuffer:AudioBuffer = AudioBuffer.fromFile(audioFile);
        */
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
		

		
        var snd = FlxG.sound.music;
        var audioBuffer:AudioBuffer = snd._sound.__buffer;
        
        //var audioData:Bytes = audioBuffer.getData();
        
        // 获取音频数据的字节数组
        //audioDataArray = audioData.toArray();


        // 计算音频数据的长度（以秒为单位）
        //var length:Float = audioDataArray.length / (sampleRate * bitsPerSample / 8);
        var length:Float = snd.length;
      

        // 计算频率段数量
        frequencyBandCount = Std.int(sampleRate / frequencyBandwidth);

        updateVisualizationData();
        
        

        // 在控制台中打印可视化数据
        for (i in 0...visualizationData.length) {
            trace(visualizationData[i]);
        }
    }
    
    override function update(elapsed:Float)
	{
	    updateVisualizationData();
	}
	
	function updateVisualizationData():Void {
	    visualizationData = [];
        // 遍历音频数据，并为每个样本生成一个正弦波
        for (i in 0...frequencyBandCount) {
            var startIndex:Float = i * frequencyBandwidth;
            var endIndex:Float = (i + 1) * frequencyBandwidth;
            var frequencyBandData:Array<Int> = audioDataArray.slice(Std.int(startIndex), Std.int(endIndex));
            
            for (j in 0...frequencyBandData.length) {
                var sample:Int = frequencyBandData[j];
                var amplitude:Float = sample / 32768.0; // 将样本值映射到-1.0到1.0之间
                var phase:Float = Math.PI * j / sampleRate; // 计算当前样本的相位

                // 生成正弦波数据
                var sineWave:Float = Math.abs(Math.sin(phase) * amplitude);

                // 将正弦波数据添加到可视化数据向量中
                visualizationData.push(sineWave);
            }
        }
    }
}


