package objects;

import openfl.display.Bitmap;
import openfl.display.BitmapData;

class Watermark extends Bitmap
{
    public function new(x:Float = 10, y:Float = 10, Alpha:Float = 0.5){

        super();

		this.x = x;
		this.y = y;
        this.alpha = Alpha;
        
        var image:String = Paths.modFolders('images/menuExtend/watermark.png');
        
        bitmapData = BitmapData.fromFile(image);
    }

} 

