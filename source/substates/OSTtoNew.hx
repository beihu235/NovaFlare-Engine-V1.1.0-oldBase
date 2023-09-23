package substates;

//import haxe.audio.AudioBuffer;
import lime.media.AudioBuffer;
import haxe.io.Path;

@:access(flixel.sound.FlxSound._sound)
@:access(openfl.media.Sound.__buffer)

class OSTtoNew extends MusicBeatSubstate
{
    public static var vocals:FlxSound;
    var frequencyBandwidth:Float = 1000;
    
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
        
        // 获取音频数据的字节数组
        var audioData:Array<Int> = audioBuffer.toByteArray();

        // 设定音频数据的采样率和位深度
        var sampleRate:Int = 44100;
        var bitsPerSample:Int = 16;

        // 设置频率段大小（以赫兹为单位）
        

        // 计算音频数据的长度（以秒为单位）
        var length:Float = audioData.length / (sampleRate * bitsPerSample / 8);

        // 创建一个Vector对象来存储音乐可视化数据
        var visualizationData:Array<Float> = new Array();

        // 计算频率段数量
        var frequencyBandCount:Int = Std.int(sampleRate / frequencyBandwidth);

        updateVisualizationData();
        
        

        // 在控制台中打印可视化数据
        for (i in 0...visualizationData.length) {
            trace(visualizationData[i]);
        }
    }
    
    override function update(elapsed:Float)
	{
	
	    frequencyBandCount();
	}
	
	private function updateVisualizationData():Void {
        // 遍历音频数据，并为每个样本生成一个正弦波
        for (i in 0...frequencyBandCount) {
            var startIndex:Float = i * frequencyBandwidth;
            var endIndex:Float = (i + 1) * frequencyBandwidth;
            var frequencyBandData:Array<Int> = Std.int(audioData.slice(startIndex, endIndex));

            for (j in 0...frequencyBandData.length) {
                var sample:Int = frequencyBandData[j];
                var amplitude:Float = sample / 32768.0; // 将样本值映射到-1.0到1.0之间
                var phase:Float = Math.PI * j / sampleRate; // 计算当前样本的相位

                // 生成正弦波数据
                var sineWave:Float = Math.sin(phase) * amplitude;

                // 将正弦波数据添加到可视化数据向量中
                visualizationData.push(sineWave);
            }
        }
    }
}


/*
import haxe.io.Path;
import haxe.ui.Toolkit;
***ponentMacros;

class AudioVisualizerComponent extends Component {
    private var audio***
    ***
    ***
    ***
    ***
    ***
    ***<Float>;

    public function new(needVoices:Bool, songBpm:Float) {
        super();

        // 读取音频文件
        audioFile = Paths.inst(PlayState.SONG.song);
        var audioData:Array<Int> = audioFile.getBytes();

        // 设定音频数据的采样率和位深度
        sampleRate = 44100;
        bitsPerSample = 16;

        // 设置频率段大小（以赫兹为单位）
        frequencyBandwidth = 1000;

        // 计算音频数据的长度（以秒为单位）
        length = audioData.length / (sampleRate * bitsPerSample / 8);

        // 创建一个Vector对象来存储音乐可视化数据
        visualizationData = new Array();

        // 计算频率段数量
        frequencyBandCount = Std.int(sampleRate / frequencyBandwidth);

        // 更新可视化数据
        updateVisualizationData();
    }

    private function updateVisualizationData():Void {
        // 遍历音频数据，并为每个样本生成一个正弦波
        for (i in 0...frequencyBandCount) {
            var startIndex:Float = i * frequencyBandwidth;
            var endIndex:Float = (i + 1) * frequencyBandwidth;
            var frequencyBandData:Array<Int> = Std.int(audioData.slice(startIndex, endIndex));

            for (j in 0...frequencyBandData.length) {
                var sample:Int = frequencyBandData[j];
                var amplitude:Float = sample / 32768.0; // 将样本值映射到-1.0到1.0之间
                var phase:Float = Math.PI * j / sampleRate; // 计算当前样本的相位

                // 生成正弦波数据
                var sineWave:Float = Math.sin(phase) * amplitude;

                // 将正弦波数据添加到可视化数据向量中
                visualizationData.push(sineWave);
            }
        }

        // 更新组件
        update();
    }

    override function update() {
        // 在控制台中打印可视化数据
        for (i in 0...visualizationData.length) {
            trace(visualizationData[i]);
        }
    }
}
*/

