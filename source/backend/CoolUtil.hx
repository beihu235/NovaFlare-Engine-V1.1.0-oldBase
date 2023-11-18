package backend;

import flixel.util.FlxSave;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import backend.SUtil;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

class CoolUtil
{
	inline public static function quantize(f:Float, snap:Float){
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		trace(snap);
		return (m / snap);
	}

	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	inline public static function coolTextFile(path:String, ?android:Bool = true):Array<String>
	{
		var daList:String = null;
		#if (sys && MODS_ALLOWED)
		var formatted:Array<String> = path.split(':'); //prevent "shared:", "preload:" and other library names on file path
		if (android)
			path = SUtil.getPath() + formatted[formatted.length-1];
		else
			path = formatted[formatted.length-1];

		if(FileSystem.exists(path)) daList = File.getContent(path);
		#else
		if(Assets.exists(path)) daList = Assets.getText(path);
		#end
		return daList != null ? listFromString(daList) : [];
	}

	inline public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if(color.startsWith('0x')) color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null) colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	inline public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if(decimals < 1)
			return Math.floor(value);

		var tempMult:Float = 1;
		for (i in 0...decimals)
			tempMult *= 10;

		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}
	
	inline public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth) {
			for(row in 0...sprite.frameHeight) {
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if(colorOfThisPixel != 0) {
					if(countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0; //after the loop this will store the max color
		countByColor[FlxColor.BLACK] = 0;
		countByColor[FlxColor.BLACK] = 0;
		for(key in countByColor.keys()) {
			if(countByColor[key] >= maxCount) {
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		countByColor = [];
		return maxKey;
	}
	
	inline public static function getComboColor(sprite:flixel.FlxSprite):Int {
    var pixels = sprite.pixels;
    var color:FlxColor = FlxColor.fromRGB(pixels.getColor(0), pixels.getColor(1), pixels.getColor(2));
    var hsv:FlxColor = rgbToHsv(color.red, color.green, color.blue);

    // 计算新的hue
    var hue:Float = Math.atan2(hsv.b, hsv.g) / Math.PI * 180 + 180;
    if (hue < 0) hue += 360;

    return FlxColor.floatToInt(hue);
    }
    
    static public function rgbToHsv(red:Float, green:Float, blue:Float):FlxColor {
    var r:Float = red / 255;
    var g:Float = green / 255;
    var b:Float = blue / 255;

    var max:Float = Math.max(r, g, b);
    var min:Float = Math.min(r, g, b);
    var diff:Float = max - min;

    var hue:Float;
    if (max == min) {
        hue = 0;
    } else if (max == r) {
        hue = 60 * (((g - b) / diff) + 6);
    } else if (max == g) {
        hue = 60 * (((b - r) / diff) + 2);
    } else if (max == b) {
        hue = 60 * (((r - g) / diff) + 4);
    }

    if (hue < 0) hue += 360;

    var saturation:Float = max == 0 ? 0 : (1 - min / max);
    var value:Float = max;

    return hsvToRgb(hue, saturation, value);
}
static public function hsvToRgb(hue:Float, saturation:Float, value:Float):FlxColor {
    var c:Float = value * saturation;
    var x:Float = c * (1 - Math.abs((hue / 60) % 2 - 1));
    var m:Float = value - c;

    if (hue < 60)
 {        return FlxColor.fromRGB(c, x, 0);
    } else if (hue < 120) {
        return FlxColor.fromRGB(x, c, 0);
    } else if (hue < 180) {
        return FlxColor.fromRGB(0, c, x);
    } else if (hue < 240) {
        return FlxColor.fromRGB(0, x, c);
    } else if (hue < 300) {
        return FlxColor.fromRGB(x, 0, c);
    } else {
        return FlxColor.fromRGB(c, 0, x);
    }
}

	
	
	/*
	inline public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth) {
			for(row in 0...sprite.frameHeight) {
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if(colorOfThisPixel != 0) {
					if(countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0; //after the loop this will store the max color
		var hasOtherColors = false;
		//countByColor[FlxColor.BLACK] = 0;
		for(key in countByColor.keys()) {
			if (countByColor[key] > maxCount && key != FlxColor.WHITE && key != FlxColor.BLACK) {
				maxCount = countByColor[key];
				maxKey = key;
				hasOtherColors = true;
			}
		}
		
		if (countByColor[FlxColor.WHITE] > maxCount && !hasOtherColors){
		    maxCount = countByColor[FlxColor.WHITE];
		    maxKey = FlxColor.WHITE;
		}
		
		countByColor = [];
		return maxKey;
	}
    */
	inline public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max) dumbArray.push(i);

		return dumbArray;
	}

	inline public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	/** Quick Function to Fix Save Files for Flixel 5
		if you are making a mod, you are gonna wanna change "ShadowMario" to something else
		so Base Psych saves won't conflict with yours
		@BeastlyGabi
	**/
	inline public static function getSavePath(folder:String = 'ShadowMario'):String {
		@:privateAccess
		return #if (flixel < "5.0.0") folder #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}
}
