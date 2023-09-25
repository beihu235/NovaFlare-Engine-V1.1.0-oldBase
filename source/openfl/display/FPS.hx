package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end


import openfl.Lib;
import haxe.io.Path;
import haxe.io.Eof;
import sys.io.File;
import sys.FileSystem;

import openfl.utils.Assets;

#if openfl
import openfl.system.System;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Float;
    public var logicFPStime(default, null):Float;
    public var DisplayFPS(default, null):Float;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/montserrat.ttf").fontName, 12, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";
				

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}
	
	public static var currentColor = 0;    
	 var skippedFrames = 0;
	 
     var logicFPSnum = 0;
	
    var ColorArray:Array<Int> = [
		0xFF9400D3,
		0xFF4B0082,
		0xFF0000FF,
		0xFF00FF00,
		0xFFFFFF00,
		0xFFFF7F00,
		0xFFFF0000
	                                
	    ];

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
	
	//var elapsed = FlxG.elapsed;    		    		
		/*currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}
		*/
		
		if (ClientPrefs.data.rainbowFPS)
	    {
	        if (skippedFrames >= 6)
		    {
		    	if (currentColor >= ColorArray.length)
    				currentColor = 0;
    			textColor = ColorArray[currentColor];
    			currentColor++;
    			skippedFrames = 0;
    		}
    		else
    		{
    			skippedFrames++;	
    		}
		}
		else
		{
		textColor = 0xFFFFFFFF;		
		}
        
        
        
        logicFPStime += deltaTime;
        logicFPSnum ++;
        if (logicFPStime >= 200) //update data for 0.2s
        {
        currentFPS = Math.ceil(currentFPS * 0.5 + 1 / (logicFPStime / logicFPSnum / 1000) * 0.5) ;
        logicFPStime = 0;
        logicFPSnum = 0;
        }

		
		if (currentFPS > ClientPrefs.data.framerate) currentFPS = ClientPrefs.data.framerate;
		
		
        if ( DisplayFPS > currentFPS ){
            if (Math.abs(DisplayFPS - currentFPS) > 10) DisplayFPS = DisplayFPS - 2;
            else DisplayFPS = DisplayFPS - 1;
        }
        else if ( DisplayFPS < currentFPS ){
            if (Math.abs(DisplayFPS - currentFPS) > 10) DisplayFPS = DisplayFPS + 2;
            else DisplayFPS = DisplayFPS + 1;
        }
            
        
        
	
		
			text = "FPS: " + DisplayFPS + "/" + ClientPrefs.data.framerate;
			var memoryMegas:Float = 0;
			//memoryMegas = Math.round(actualMem / 1024 / 1024 * 100) / 100;			
			memoryMegas = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));
			text += "\nMemory: " + memoryMegas + " MB";
						
            var newmemoryMegas:Float = 0;

			if (memoryMegas > 1000)
			{
			newmemoryMegas = Math.ceil( Math.abs( System.totalMemory ) / 10000000 / 1.024)/100;
			
				text = "FPS: " + DisplayFPS + "/" + ClientPrefs.data.framerate;
				text += "\nMemory: " + newmemoryMegas + " GB";            
			}
						
            text += "\nNF Engine V1.1.0(bata)\n"  + Math.floor(1 / DisplayFPS * 10000 + 0.5) / 10 + "ms";
                     
			
	    var gpuCpuUsage = getGPUCPUUsage();
	    text += gpuCpuUsage;
	    text += "\n";
	}
	
	public function getGPUCPUUsage() {
        var gpuUsage = getGPUUsage();
        //var cpuUsage = getCPUUsage();
        return gpuUsage;
    }

    private function getGPUUsage(): Float {
        var gpuUsage:Float = 0;
        try {
            var file = File.read(Path.withoutExtension(Assets.getPath("assets/gpu_busy_percent")));
            gpuUsage = Std.parseFloat(file.readLine());
        } catch (e: Eof) {}
        return gpuUsage;
    }
    /*
    private function getCPUUsage(): Float {
        var cpuUsage = Lib.getCpuUsage() / 100;
        return cpuUsage;
    }
    */
    
}




/*
class FPS extends TextField {
    // ... existing code ...

    

var gpuCpuUsage = fpsText.getGPUCPUUsage(FlxG.getGame().create());
*/