package objects;

class FlxBackdropEX extends FlxBackdrop
{
	public var ColorArray:Array<Int> = [
		0xFF9400D3,
		0xFF4B0082,
		0xFF0000FF,
		0xFF00FF00,
		0xFFFFFF00,
		0xFFFF7F00,
		0xFFFF0000	                                
	    ];
	
	var SoundTime = 0;
	var BeatTime = 60 / bpm;

	public var bpm = TitleState.bpm;
	
	public var currentColor:Int = 1;    
	public var currentColorAgain:Int = 0;    
	
	var canBeat = false;
	
	public function new(image:String, RepeatAxes:String, moveX:Float = 0, moveY:Float = 0,?random:Bool = true,?BPM:Int = TitleState.bpm) {			
		graphic = image;
		repeatAxes = RepeatAxes;
		if (random)
		    velocity.set(FlxG.random.bool(50) ? moveX : -moveX, FlxG.random.bool(50) ? moveY : -moveY);
		else
    		velocity.set(moveX, moveY);
    	bpm = BPM;	
    	super();		
	}

	override function update(elapsed:Float)
	{
    	SoundTime = FlxG.sound.music.time / 1000;
    	BeatTime = 60 / bpm;
	
    	if ( Math.floor(SoundTime/BeatTime + 0.5) % 4  == 2) canBeat = true; 
	
    	if ( Math.floor(SoundTime/BeatTime) % 4  == 0 && canBeat) l{
        
            canBeat = false;           
            currentColor++;   
                     
            if (currentColor > 6) currentColor = 1;
            currentColorAgain = currentColor - 1;
            if (currentColorAgain <= 0) currentColorAgain = 6;
          
           // FlxTween.color(bgMove, 0.6, ColorArray[currentColorAgain], ColorArray[currentColor], {ease: FlxEase.cubeOut});
        }        
    }
}