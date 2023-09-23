package substates;

import hxmath.Math;
//import haxmath.*;
//import sys.io.File;

class OST-new extends MusicBeatSubstate
{
    public function new(needVoices:Bool,songBpm:Float)
	{
        // 读取音频文件
        var audioFile = Paths.inst(PlayState.SONG.song);
        var audioData:Array<Int> = audioFile.getBytes();

        // 设定音频数据的采样率和位深度
        var sampleRate:Int = 44100;
        var bitsPerSample:Int = 16;

        // 设置频率段大小（以赫兹为单位）
        var frequencyBandwidth:Float = 1000;

        // 计算音频数据的长度（以秒为单位）
        var length:Float = audioData.length / (sampleRate * bitsPerSample / 8);

        // 创建一个Vector对象来存储音乐可视化数据
        var visualizationData:Vector<Float> = new Vector();

        // 计算频率段数量
        var frequencyBandCount:Int = Std.int(sampleRate / frequencyBandwidth);

        // 遍历音频数据，并为每个样本生成一个正弦波
        for (i in 0...frequencyBandCount) {
            var startIndex:Int = i * frequencyBandwidth;
            var endIndex:Int = (i + 1) * frequencyBandwidth;
            var frequencyBandData:Array<Int> = audioData.slice(startIndex, endIndex);

            for (j in 0...frequencyBandData.length) {
                var sample:Int = frequencyBandData[j];
                var amplitude:Float = sample / 32768.0; // 将样本值映射到-1.0到1.0之间
                var phase:Float = Math.TAU * j / sampleRate; // 计算当前样本的相位

                // 生成正弦波数据
                var sineWave:Float = Math.sin(phase) * amplitude;

                // 将正弦波数据添加到可视化数据向量中
                visualizationData.add(sineWave);
            }
        }

        // 在控制台中打印可视化数据
        for (i in 0...visualizationData.length) {
            trace(visualizationData[i]);
        }
    }
}