package options;

import sys.FileSystem;
import sys.io.File;

import options.Option;

class OptionsHelpers
{
    public static var languageArray = ["English", "简体中文", "繁體中文"];
	public static var colorblindFilterArray = ['No color filter', 'Protanopia filter', 'Protanomaly filter', 'Deuteranopia filter','Deuteranomaly filter','Tritanopia filter','Tritanomaly filter','Achromatopsia filter','Achromatomaly filter'];

    static public function SetNoteSkin()
    {
        var noteSkins:Array<String> = [];
		if(Mods.mergeAllTextsNamed('images/noteSkins/list.txt', 'shared').length > 0)
			noteSkins = Mods.mergeAllTextsNamed('images/noteSkins/list.txt', 'shared');
		else
			noteSkins = CoolUtil.coolTextFile(Paths.getPreloadPath('shared/images/noteSkins/list.txt'));
			
		if(noteSkins.length > 0)
		{
		    noteSkins.insert(0, ClientPrefs.defaultData.noteSkin);
		    
			if(!noteSkins.contains(ClientPrefs.data.noteSkin)){
				ClientPrefs.data.noteSkin = ClientPrefs.defaultData.noteSkin; //Reset to default if saved noteskin couldnt be found
				NoteskinOption.chooseNum = 0;
            }else{
                for (i in 0...noteSkins.length - 1){
                    if (ClientPrefs.data.noteSkin == noteSkins[i])
                        NoteskinOption.chooseNum = i;
                }
            }
		}else{
		    ClientPrefs.data.noteSkin = ClientPrefs.defaultData.noteSkin;
		    NoteskinOption.chooseNum = 0;
		}
    }
    
    static public function ChangeNoteSkin()
    {
        var noteSkins:Array<String> = [];
		if(Mods.mergeAllTextsNamed('images/noteSkins/list.txt', 'shared').length > 0)
			noteSkins = Mods.mergeAllTextsNamed('images/noteSkins/list.txt', 'shared');
		else
			noteSkins = CoolUtil.coolTextFile(Paths.getPreloadPath('shared/images/noteSkins/list.txt'));
			
		if(noteSkins.length > 0)
		{
		    noteSkins.insert(0, ClientPrefs.defaultData.noteSkin);
		
		    if (NoteskinOption.chooseNum < 0) NoteskinOption.chooseNum = noteSkins.length - 1;
		    if (NoteskinOption.chooseNum > noteSkins.length - 1) NoteskinOption.chooseNum = 0;
		    
			if(!noteSkins.contains(ClientPrefs.data.noteSkin)){
				ClientPrefs.data.noteSkin = ClientPrefs.defaultData.noteSkin; //Reset to default if saved noteskin couldnt be found
				NoteskinOption.chooseNum = 0;
            }else{
                ClientPrefs.data.noteSkin = noteSkins[NoteskinOption.chooseNum];
            }
		}else{
		    ClientPrefs.data.noteSkin = ClientPrefs.defaultData.noteSkin;
		    NoteskinOption.chooseNum = 0;
		}
    }
    /*
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
			    return "视图";
			case 2: //chinese
			    return "視圖";    
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
			    return "Opponent Mode";
			case 1: //chinese
			    return "对手设置";
			case 2: //chinese
			    return "對手設置";    
		}					
		return "Opponent Mode";
    }
    
    public static function setMenuExtend():String{
        switch (ClientPrefs.data.language)
	    {
			case 0: //english
			    return "Menu Extend";
			case 1: //chinese
			    return "主菜单扩展";
			case 2: //chinese
			    return "主菜單擴展";    
		}					
		return "Menu Extend";
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
    
    //----------OPTION CAP------------------------//
    
    public static function setDownscrollOption():String{
        switch (ClientPrefs.data.language)
	    {
			case 0: //english
			    return "Toggle making the notes scroll down rather than up.";
			case 1: //chinese
			    return "让note从上往下接触判定线";
			case 2: //chinese
			    return "讓note從上往下接觸判定線";    
		}				
		return "Toggle making the notes scroll down rather than up.";
    }
    
    public static function displayDownscrollOption():String{
        switch (ClientPrefs.data.language)
	    {
			case 0: //english
			    return "Downscroll";
			case 1: //chinese
			    return "下落式";
			case 2: //chinese
			    return "下落式";    
		}					
		return "Downscroll";
    }
    
    //----------OPTION OptionCata------------------------//
    
    
    
}