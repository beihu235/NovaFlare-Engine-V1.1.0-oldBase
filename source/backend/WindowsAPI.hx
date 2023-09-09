package backend;

class CppAPI
{
	#if cpp
  #if windows
	public static function obtainRAM():Int
	{
    #if windows
		return WindowsData.obtainRAM();
    #end
	}

	public static function darkMode()
	{
    #if windows
		WindowsData.setWindowColorMode(DARK);
    #end
	}

	public static function lightMode()
	{
    #if windows
		WindowsData.setWindowColorMode(LIGHT);
    #end
	}

	public static function setWindowOppacity(a:Float)
	{
    #if windows
		WindowsData.setWindowAlpha(a);
    #end
	}

	public static function _setWindowLayered()
	{
    #if windows
		WindowsData._setWindowLayered();
    #end
	}
	#end
  #end  
}
