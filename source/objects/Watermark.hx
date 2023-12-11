package objects;

import openfl.display.Sprite;

class Watermark extends Sprite
{
    public function new(x:Float = 10, y:Float = 10, Alpha:Float = 0.5){

        super();

		this.x = x;
		this.y = y;
        this.alpha = Alpha;
        loadBitmapDataFromTexture(Paths.image('menuExtend/Watermark'));
    }

} 