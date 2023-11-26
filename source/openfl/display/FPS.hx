package openfl.display;
import cpp.vm.Gc;
import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end

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

// https://imgur.com/a/LVkQmqe
#if windows
@:headerCode("
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <psapi.h>
// are you serious?? 
// do i have to include this after windows.h to not get outrageous compilation errors??????
// one side of my brains loves c++ and the other one hates it
")
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
		defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/montserrat.ttf").fontName, 16, color, false, null, null, LEFT, 0, 0);
		autoSize = LEFT;
		
		multiline = true; //多行文本
		wordWrap = false; //禁用自动换行
		
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
	
	#if windows // planning to do the same for linux but im lazy af so rn it'll use the hxcpp gc
	@:functionCode("
		// ily windows api <3
		auto memhandle = GetCurrentProcess();
		PROCESS_MEMORY_COUNTERS pmc;

		if (GetProcessMemoryInfo(memhandle, &pmc, sizeof(pmc)))
			return(pmc.WorkingSetSize);
		else
			return 0;
	")
	function obtainMemory():Dynamic
	{
		return 0;
	}
	#end
	
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
		
		logicFPStime += deltaTime;
        logicFPSnum ++;
        
        if (logicFPStime >= 200) //update data for 0.2s
        {
            currentFPS = Math.ceil(currentFPS * 0.5 + 1 / (logicFPStime / logicFPSnum / 1000) * 0.5) ;
            logicFPStime = 0;
                logicFPSnum = 0;
        }
        
        if (currentFPS > ClientPrefs.data.framerate) currentFPS = ClientPrefs.data.framerate;
		
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
        
        if (!ClientPrefs.data.rainbowFPS && currentFPS <= ClientPrefs.data.framerate / 2){
		    textColor = 0xFFFF0000;
		}				
		
		
        if ( DisplayFPS > currentFPS ){
            if (Math.abs(DisplayFPS - currentFPS) > 20) DisplayFPS = DisplayFPS - 4;
            else if (Math.abs(DisplayFPS - currentFPS) > 10) DisplayFPS = DisplayFPS - 2;
            else DisplayFPS = DisplayFPS - 1;
        }
        else if ( DisplayFPS < currentFPS ){
            if (Math.abs(DisplayFPS - currentFPS) > 20) DisplayFPS = DisplayFPS + 4;
            else if (Math.abs(DisplayFPS - currentFPS) > 10) DisplayFPS = DisplayFPS + 2;
            else DisplayFPS = DisplayFPS + 1;
        }                          	
		
			text = "FPS: " + DisplayFPS + "/" + ClientPrefs.data.framerate;

			var memoryMegas:Float = 0;
            var memType:String = ' MB';
						
			#if windows
    		// now be an ACTUAL real man and get the memory from plain & straight c++
    		var actualMem:Float = obtainMemory();
    		#else
    		// be a real man and calculate memory from hxcpp
    		var actualMem:Float = Gc.memInfo64(ClientPrefs.data.memoryType); // update: this sucks
    		#end
    		
    		memoryMegas = Math.abs(FlxMath.roundDecimal(actualMem / 1000000, 1));
		
		if (ClientPrefs.data.showMEM){
			if (memoryMegas > 1000){
			    memoryMegas = Math.ceil( Math.abs( actualMem ) / 10000000 / 1.024)/100;
			    memType = ' GB';
			}    
			
			text += "\nMEM: " + memoryMegas + memType;            
		}
            
            if (ClientPrefs.data.showMS) text += '\n' + "Delay: " + Math.floor(1 / DisplayFPS * 10000 + 0.5) / 10 + " MS";
            
            text += "\nNF V1.1.0";
                     
			text += "\n";
	
	}
}
