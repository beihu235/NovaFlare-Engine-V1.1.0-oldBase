package options;

import sys.FileSystem;
import sys.io.File;
import flixel.FlxG;

using StringTools;

class OptionsHelpers
{
    public static var languageArray = ["Engine", "简体中文", "繁體中文"];
	/*public static var noteskinArray = ["Default", "Chip", "Future", "Grafex"];
    public static var IconsBopArray = ['Grafex',  'Modern', 'Classic'];
    public static var TimeBarArray = ['Time Left', 'Time Elapsed', 'Disabled'];
    public static var ColorBlindArray = ['None', 'Deuteranopia', 'Protanopia', 'Tritanopia'];
    public static var AccuracyTypeArray = ['Grafex', 'Kade', 'Mania', 'Andromeda', 'Forever', 'Psych'];
    
	public static function getNoteskinByID(id:Int)
	{
		return noteskinArray[id];
	}

    static public function ChangeNoteSkin(id:Int)
    {
        ClientPrefs.noteSkin = getNoteskinByID(id);
    }

    public static function getIconBopByID(id:Int)
	{
	    return IconsBopArray[id];
	}

    static public function ChangeIconBop(id:Int)
    {
       // ClientPrefs.healthIconBop = getIconBopByID(id);
    }

    public static function getTimeBarByID(id:Int)
	{
	    return TimeBarArray[id];
	}

    static public function ChangeTimeBar(id:Int)
    {
        ClientPrefs.timeBarType = getTimeBarByID(id);
    }

    public static function getColorBlindByID(id:Int)
    {
        return ColorBlindArray[id];
    }

    static public function ChangeColorBlind(id:Int)
    {
        ClientPrefs.ColorBlindType = getColorBlindByID(id);
    }

    public static function getAccTypeID(id:Int)
    {
        return AccuracyTypeArray[id];
    }

    static public function ChangeAccType(id:Int)
    {
        ClientPrefs.ratingSystem = getAccTypeID(id);
    }*/
}

class OptionsName
{
    public static function setTTF():String{
        switch (ClientPrefs.data.language)
	    {
			case 0: //english
			    return "vcr";
			case 1: //chinese
			    return "vcr-CH";
			case 2: //chinese
			    return "vcr-CH";    
		}					
		return "vcr";
    }
    
    //--------------TTF SETTING------------------------//
    
    public static function funcDisable():String{
	    switch (ClientPrefs.data.language)
	    {
			case 0: //english
			return 'Disabled';
			case 1: //chinese
			return '禁用';
			case 2: //chinese
			return '禁用';
		}			
		return 'Disabled';
	}
	
	public static function funcEnable():String{
	    switch (ClientPrefs.data.language)
	    {
			case 0: //english
			    return 'Enabled';
			case 1: //chinese
			    return '启用';
			case 2: //chinese
			    return '啟用';    
		}			
		return 'Enabled';
	}
	
	public static function funcMS():String{
	    switch (ClientPrefs.data.language)
	    {
			case 0: //english
			    return 'MS';
			case 1: //chinese
			    return '毫秒';
			case 2: //chinese
			    return '毫秒';    
		}			
		return 'MS';
	}
	
	public static function funcGrid():String{
	    switch (ClientPrefs.data.language)
	    {
			case 0: //english
			    return 'Grid';
			case 1: //chinese
			    return '格';
			case 2: //chinese
			    return '格';    
		}			
		return 'Grid';
	}
	
	//----------OPTION SETTING------------------------//

    public static function setGameplay():String{
        switch (ClientPrefs.data.language)
	    {
			case 0: //english
			    return "Gameplay";
			case 1: //chinese
			    return "游玩设置";
			case 2: //chinese
			    return "遊玩設置";    
		}					
		return "Gameplay";
    }
    
    public static function setAppearance():String{
        switch (ClientPrefs.data.language)
	    {
			case 0: //english
			    return "Appearance";
			case 1: //chinese
			    return "界面设置";
			case 2: //chinese
			    return "介面設置";    
		}					
		return "Appearance";
    }
    
    public static function setMisc():String{
        switch (ClientPrefs.data.language)
	    {
			case 0: //english
			    return "Misc";
			case 1: //chinese
			    return "杂项";
			case 2: //chinese
			    return "雜項";    
		}					
		return "Misc";
    }
    
    public static function setOpponentMode():String{
        switch (ClientPrefs.data.language)
	    {
			case 0: //english
			    return "OpponentMode";
			case 1: //chinese
			    return "对手设置";
			case 2: //chinese
			    return "對手設置";    
		}					
		return "OpponentMode";
    }
    
    public static function setMenuExtend():String{
        switch (ClientPrefs.data.language)
	    {
			case 0: //english
			    return "MenuExtend";
			case 1: //chinese
			    return "主菜单扩展";
			case 2: //chinese
			    return "主菜單擴展";    
		}					
		return "MenuExtend";
    }
    
    public static function setControls():String{
        switch (ClientPrefs.data.language)
	    {
			case 0: //english
			    return "Controls";
			case 1: //chinese
			    return "摁键设置";
			case 2: //chinese
			    return "摁鍵設置";    
		}					
		return "Controls";
    }

}