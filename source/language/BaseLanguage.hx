package language;

class BaseLanguage {
    public function new() {
    
    }

    public function sharedMethod() {
        trace("This is the shared method from BaseClass");
    }
}    

class LanguageFactory {
    
    public function new() {
        var language = LanguageFactory.getInstance(ClientPrefs.data.language);
        return language; // 调用 Class 的 var
    }
    
    function getInstance(className:Int):BaseLanguage {
        switch (className) {
            case 0:
                return new EN();
            case 1:
                return new ZH();
            case 2:
                return new ZH-TW();    
            default:
                return new EN(); // or throw an error if the class name is invalid
        }
    }
} 


